//
//  ChartView.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 19.07.2023.
//

import SwiftUI

struct CartView: View {
    @StateObject var viewModel: CartViewModel
    @EnvironmentObject var contentVM: ContentViewModel
    
    var body: some View {
        VStack{
            Text("Корзина")
                .font(.title).bold()
            List {
                ForEach(viewModel.position) { item in
                    HStack{
                        Text(item.item.title)
                        Text(item.milk ?? "")
                        Text(item.sirop ?? "")
                        Text("\(item.count) шт")
                        Text(String(format: "%.2f", (item.price)))
                        Text("руб.")
                    }
                }
            }.listStyle(.plain)
            VStack{
                HStack{
                    Text("Итого:")
                    Text(String(format: "%.2f", (viewModel.total)))
                    Text("руб.")
                    Spacer()
                }.font(.title).bold()
                HStack{
                    Spacer()
                    Button("Подтвердить") {
                        Task{
                            print("жмяк")
                            guard let user = contentVM.currentUser else { return }
                            var order = OrderModel(userID: user.id,
                                                   date: Date(),
                                                   status: OrderStatus.created.rawValue)
                            order.positions = viewModel.position
                            print("Сами позиции \(viewModel.position)")
                            print("проверка")
                            print("Позиции в ордере \(order.positions)")
                            try await FireStoreService.shared.addOrder(order: order)
                            viewModel.position.removeAll()
                        }
                    }.frame(maxWidth: 150, maxHeight: 20)
                        .padding(.horizontal, 8)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 1, x: 0, y: 0)
                }.padding(.horizontal, 5)
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(viewModel: CartViewModel.shared)
    }
}
