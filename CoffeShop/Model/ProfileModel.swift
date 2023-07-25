//
//  ProfieModel.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import Foundation

struct ProfileModel: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var email: String
    var phone: Int?
    var adress: String?
    var admin: Bool
}

extension ProfileModel {
    
    var representation: [String: Any] {
        var dict = [String:Any]()
        dict["id"] = self.id
        dict["name"] = self.name
        dict["email"] = self.email
        dict["phone"] = self.phone
        dict["adress"] = self.adress
        dict["admin"] = self.admin
        return dict
    }
    
    init?(data: [String: Any]){
        guard let id: String = data["id"] as? String,
              let email: String = data["email"] as? String,
              let name: String = data["name"] as? String,
              let phone: Int = data["phone"] as? Int,
              let adress: String = data["adress"] as? String,
              let admin: Bool = data["admin"] as? Bool else { return nil }
        self.id = id
        self.email = email
        self.name = name
        self.phone = phone
        self.adress = adress
        self.admin = admin
    }
}
