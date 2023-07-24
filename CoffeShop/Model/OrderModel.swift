//
//  OrderModel.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 21.07.2023.
//

import Foundation
import FirebaseFirestore

struct OrderModel: Identifiable {
    
    var id = UUID().uuidString
    let userID: String
    var positions = [PositionModel]()
    var date: Date
    var status: String
    var ttlPrice: Double {
        var sum = 0.0
        
        for pos in positions{
            sum += pos.price
        }
        return sum
    }
}
extension OrderModel {
    var representation: [String: Any] {
        var dict = [String: Any]()
        dict["id"] = self.id
        dict["userID"] = self.userID
        dict["date"] = self.date
        dict["status"] = self.status
        return dict
    }
}
extension OrderModel{
    init?(qdSnap: QueryDocumentSnapshot) {
        let data = qdSnap.data()
        guard let id = data["id"] as? String,
        let userID = data["userID"] as? String,
        let date = data["date"] as? Timestamp,
        let status = data["status"] as? String else { return nil }

        self.id = id
        self.userID = userID
        self.date = date.dateValue()
        self.status = status

    }
}
