//
//  Favorite.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import Foundation
import FirebaseFirestore

struct MenuModel: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var price: Double
    var description: String
    var category: Categories
    var season: Bool
    var new: Bool
}

extension MenuModel {
    init?(qdSnap: QueryDocumentSnapshot) {
        let data = qdSnap.data()
        guard let id = data["id"] as? String,
              let title = data["title"] as? String,
              let price = data["price"] as? Double,
              let description = data["description"] as? String,
              let category = data["category"] as? String,
              let season = data["season"] as? Bool,
              let new = data["new"] as? Bool else { return nil }
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.category = Categories.fromStringValue(category)!
        self.season = season
        self.new = new
    }
}

extension MenuModel {
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["title"] = title
        repres["price"] = price
        repres["description"] = description
        repres["category"] = category.rawValue
        repres["season"] = season
        repres["new"] = new
        return repres
    }
}

