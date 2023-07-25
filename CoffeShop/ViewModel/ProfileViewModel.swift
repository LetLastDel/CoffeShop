//
//  ProfileViewModel.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import Foundation


class ProfileViewModel: ObservableObject {
    var user: ProfileModel?
    @Published var check = false
    @Published var favorite: [ProductModel] = []
    @Published var orders: [OrderModel] = []
    var sorted: [OrderModel]  {
        orders.sorted { OrderModel, OrderModel in
            OrderModel.date > OrderModel.date
        }
    }    
    @Published var newName = ""
    @Published var newPhone = ""
    @Published var newAdress = ""

    
        var respres: [String: Any] {
            let dict = [
                "name": newName.isEmpty ? user?.name as Any : newName,
                "phone": newPhone.isEmpty ? user?.phone as Any : Int(newPhone) as Any,
                "adress": newAdress.isEmpty ? user?.adress as Any : newAdress,
                "email": user?.email ?? "",
                "admin": user?.admin as Any,
                "id" : user?.id as Any
            ] as [String : Any]
            return dict
        }
    func getFavorite() async throws{
        let fav = try await FireStoreService.shared.getFavorite(userID: user?.id ?? "")
        DispatchQueue.main.async {
            self.favorite = fav
        }
    }
    func getOrders() async throws{
        guard let user = user else { return }
        let order = try await FireStoreService.shared.getOrders(by: user.id)
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
        func changeUser() {
            Task{
                try await FireStoreService.shared.setProfile(profile: user!, dict: respres)
                DispatchQueue.main.async {
                    self.check.toggle()
                }
            }
        }
    }

