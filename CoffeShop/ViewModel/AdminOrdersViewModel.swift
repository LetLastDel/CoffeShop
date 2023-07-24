//
//  AdminOrdersViewModel.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 23.07.2023.
//

import Foundation


class AdminOrdersViewModel: ObservableObject {
    
    @Published var orders: [OrderModel] = []


    init() {
        Task{
            try await getOrders()
        }
    }
    
    func getOrders() async throws{
        let order = try await FireStoreService.shared.getOrders(by: nil)
        DispatchQueue.main.async {
            self.orders = order
            Task{
                try await self.getOrderPosition()
            }
        }
    }
    func getOrderPosition() async throws{
        print("Запустилось получение позиций")
        for (index, ordr) in orders.enumerated() {
            let pos = try await FireStoreService.shared.getPositions(by: ordr.id)
            DispatchQueue.main.async {
                self.orders[index].positions = pos
            }
        }
    }
}
