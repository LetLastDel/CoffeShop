//
//  ItemViewModel.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 18.07.2023.
//

import Foundation
import UIKit

class ItemViewModel: ObservableObject {
    @Published var itemCount = 1
    @Published var size = ["330", "400", "450"]
    @Published var selectedSize = 0
    @Published var milk = ["Коровье", "Миндальное", "Кокосовое"]
    @Published var selectedMilk = 0
    @Published var sirop = ["Ваниль", "Шоколад", "Карамель", "Малиновый"]
    @Published var selectedSirop = 0
    @Published var image = UIImage(named: "photo")
    
    func getPrice(selectedSize: Int, milk: Int) -> Double {
        var sizeCoef = 1.0
        var milkCoef = 0.0
        switch selectedSize{
        case 0: sizeCoef = 1
        case 1: sizeCoef = 1.25
        case 2: sizeCoef = 1.5
        default: sizeCoef = 1
        }
        switch selectedMilk{
        case 0: milkCoef = 0.0
        case 1: milkCoef = 0.3
        case 2: milkCoef = 0.2
        default: milkCoef = 0
        }
        let coef = sizeCoef + milkCoef
        return coef
    }
    func incrementStep() {
        itemCount += 1
    }
    func decrementStep() {
        if itemCount > 1{
            itemCount -= 1}
    }
    func addFavorite(_ manu: MenuModel, to user: ProfileModel) async{
        Task{
            try await FireStoreService.shared.addFavorite(manu, to: user)
        }
    }
    func showImages(url: String){
        Task{
            do{
                let photo = try await NetworkService.shared.downloadImage(url: url)
                DispatchQueue.main.async {
                    self.image = photo
                }
            } catch {
                throw error
            }
        }
        
    }
}
