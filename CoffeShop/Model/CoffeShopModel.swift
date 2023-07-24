//
//  CoffeShopModel.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 18.07.2023.
//

import Foundation
import FirebaseFirestore

struct CoffeShopModel: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var adress: String
}

extension CoffeShopModel {
    init?(qdSnap: QueryDocumentSnapshot) {
        let data = qdSnap.data()
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let adress = data["adress"] as? String else { return nil }
        
        self.id = id
        self.name = name
        self.adress = adress
    }
}

    extension CoffeShopModel {
        var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["name"] = name
        repres["adress"] = adress
        return repres
    }
}
