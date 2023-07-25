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
    
    
    static var allCases: [OrderStatus] {
        return [.created, .canceled, .recieved, .preparing, .ready, .widraw]
    }
    static func fromStringValue(_ stringValue: String) -> OrderStatus? {
        return allCases.first { $0.rawValue == stringValue }
        
    }
}
extension OrderStatus: Identifiable {
    var id: String { self.rawValue }

}
