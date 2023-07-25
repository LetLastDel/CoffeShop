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
    @State var showAlert = false
    @State var alertMessage = ""
    var body: some View {
        VStack{
            Text("Корзина")
                .font(.title).bold()
            List {
                ForEach(0 ..< viewModel.position.count, id: \.self) { index in
                    PositionCell(position: viewModel.position[index])
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                viewModel.position.remove(at: index)
                            } label: {
                                Image(systemName: "trash")
                            }
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
                    ButtonExt(action: {
                        guard !viewModel.position.isEmpty else {
                            showAlert.toggle()
                            alertMessage = Errors.emptyChart.rawValue
                            return
                        }
                        Task{
                            guard let user = contentVM.currentUser else { return }
                            guard !(user.adress == nil || user.phone == nil) else {
                                showAlert.toggle()
                                alertMessage = Errors.adressError.rawValue
                                return
                            }
                            var order = OrderModel(userID: user.id,
                                                   date: Date(),
                                                   status: OrderStatus.created.rawValue)
                            order.positions = viewModel.position
                            try await FireStoreService.shared.addOrder(order: order)
                            viewModel.position.removeAll()
                        }
                    }, text: "Подтвердить", width: 200)
                }.padding(.horizontal, 5)
            }
        } .alert(isPresented: $showAlert) {
            Alert(title: Text("Ошибка!"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(viewModel: CartViewModel.shared)
    }
}
