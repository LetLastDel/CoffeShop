//
//  CartViewModel.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 19.07.2023.
//

import Foundation

class CartViewModel: ObservableObject {
    
    static let shared = CartViewModel(); private init() { }
    
     @Published var position = [PositionModel]()
     var total: Double {
        var ttl = 0.0
        for ord in position{
            ttl += ord.price
        }
        return Double(ttl)
    }
    func addOrder(order: PositionModel) {
        print("Сработало добавление")
        self.position.append(order)
        print(position)
    }
    
    
}
