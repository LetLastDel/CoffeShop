//
//  MainViewModel.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 18.07.2023.
//

import Foundation
import UIKit

class MainViewModel: ObservableObject {
    
    @Published var coffeShops: [CoffeShopModel] = []
    @Published var menu: [MenuModel] = []
    @Published var selectedCafe: CoffeShopModel?
    var sorted: [MenuModel] {
        menu.filter { MenuModel in
            MenuModel.new
        }
    }

    init() {
        Task{
            let menu = try await FireStoreService.shared.getMenu()
            DispatchQueue.main.async {
                self.menu = menu
            }
        }
        Task{
            let cshop = try await FireStoreService.shared.getShop()
            DispatchQueue.main.async {
                self.coffeShops = cshop
            }
        }
    }
}
