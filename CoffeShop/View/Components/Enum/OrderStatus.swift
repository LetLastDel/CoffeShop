//
//  OrderStatus.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 21.07.2023.
//

import Foundation

enum OrderStatus: String, CaseIterable{
    case created = "Создан"
    case canceled = "Отменен"
    case recieved = "Принят"
    case preparing = "Готовится"
    case ready = "Готов!"
    case widraw = "Выдан"
    
}

extension OrderStatus: Identifiable {
    var id: String { self.rawValue }

}
