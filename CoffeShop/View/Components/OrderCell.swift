//
//  OrderCell.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 21.07.2023.
//

import SwiftUI

struct OrderCell: View {
    var order: OrderModel
    @State var user: ProfileModel?
    @State var tap: Bool = false
    @State var admin: Bool = false
    @State var status: String = ""

    var body: some View {
        VStack{
            HStack{
                Text("\(order.date.formatted(date: .long, time: .shortened))")
                Spacer()
                if !admin{
                    Text(order.status)
                } else {
                Picker("", selection: $status) {
                        ForEach(OrderStatus.allCases, id: \.id) { status in
                            Text(status.rawValue).tag(status.rawValue)
                        }
                }.pickerStyle(.menu)
                }
            }
            if admin{
                HStack{
                    if user != nil{
                        Text((user?.name)!)
                        Text("\(user?.phone ?? 0)")
                    }
                    Spacer()
                    VStack{
                        Text(user?.adress ?? "Адрес не указан")
                    }
                }
            }
            if tap{
                    VStack{
                        ForEach(order.positions, id: \.id) { position in
                            VStack(alignment: .trailing){
                                HStack{
                                    Text(position.item.title)
                                        .bold()
                                    Spacer()
                                    Text("\(position.count) шт")
                                        .frame(maxWidth: 100)
                                    HStack{
                                        Text(String(format: "%.2f", (position.item.price)))
                                        Text("руб")
                                    }.frame(maxWidth: 100)
                                    
                                }
                            }
                        }
                    }
            }
            HStack{
                Spacer()
                Text("Итого:")
                Text(String(format: "%.2f", (order.ttlPrice)))
                Text("руб")
            }.padding(.horizontal, 7)
        }.onAppear{
            Task{
                self.user = try await FireStoreService.shared.getProfile(by: order.userID)
            }
            self.status = order.status
        }
        .onChange(of: status, perform: { stat in
            print("Запустилось")
            Task{
                try await FireStoreService.shared.changeOrderStatus(order: order, status: stat)
            }
        })
        .onTapGesture {
            withAnimation {
            tap.toggle()
            }
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, maxHeight: tap ? .infinity : 120)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: .black, radius: 1, x: 0, y: 0)
    }
}

struct OrderCell_Previews: PreviewProvider {
    static var previews: some View {
        AdminOrderView()

    }
}
