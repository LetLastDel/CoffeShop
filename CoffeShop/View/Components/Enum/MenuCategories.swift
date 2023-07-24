//
//  MenuCategories.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 24.07.2023.
//

import Foundation

enum Categories: String, CaseIterable {
    
    case coffe = "Кофе"
    case cake = "Десерт"
    
    static var allCases: [Categories] {
        return [.coffe, .cake]
    }
    static func fromStringValue(_ stringValue: String) -> Categories? {
        return allCases.first { $0.rawValue == stringValue }
        
    }
}
extension Categories: Identifiable {
    var id: String { self.rawValue }
}
