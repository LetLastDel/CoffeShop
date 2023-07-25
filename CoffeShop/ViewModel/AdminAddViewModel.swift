//
//  AdminAddViewModel.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 24.07.2023.
//

import SwiftUI
import PhotosUI

@MainActor
class AdminAddViewModel: ObservableObject {
    @Published var selectedImage: UIImage = UIImage(systemName: "plus.rectangle")!
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    var id: String = UUID().uuidString
    @Published var title: String = ""
    @Published var price: String = ""
    @Published var description: String = ""
    @Published var category: Categories = .cake
    @Published var season: Bool = false
    @Published var new: Bool = false
    @Published var imgUrl = ""
    @Published var imageData: Data?
    @Published var product: ProductModel?
    @Published var coffeShop: ShopModel?
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task{
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    imageData = data
                    selectedImage = uiImage
                    return
                }
            }
        }
    }

}
