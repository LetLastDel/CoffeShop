//
//  Orders.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import Foundation
import FirebaseFirestore
struct PositionModel: Identifiable {
    
    var id: String = UUID().uuidString
    var item: MenuModel
    var title: String
    var count: Int
    var sirop: String?
    var milk: String?
    var price: Double
    var size: String?
}

extension PositionModel {
    var repsesentation: [String: Any] {
        var dict = [String: Any]()
        dict["id"] = self.id
        dict["title"] = item.title
        dict["count"] = self.count
        dict["sirop"] = self.sirop
        dict["milk"] = self.milk
        dict["price"] = self.price
        dict["size"] = self.size
        return dict
    }
}
extension PositionModel{
    init?(qdSnap: QueryDocumentSnapshot) {
        let data = qdSnap.data()
        guard let id = data["id"] as? String,
        let title = data["title"] as? String,
        let count = data["count"] as? Int,
        let sirop = data["sirop"] as? String,
        let milk = data["milk"] as? String,
        let price = data["price"] as? Double,
        let size = data["size"] as? String else { return nil }
        let item: MenuModel = MenuModel(title: title, price: price, description: "", category: .cake, season: false, new: false)

        self.id = id
        self.title = title
        self.count = count
        self.sirop = sirop
        self.milk = milk
        self.price = price
        self.size = size
        self.item = item
    }
}
