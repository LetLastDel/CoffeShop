//
//  AdminAddView.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 24.07.2023.
//

import SwiftUI
import PhotosUI

struct AdminAddView: View {
    @State var tgl = false
    var menu: ProductModel?
    var cafe: ShopModel?
    @StateObject var viewModel = AdminAddViewModel()
    @State var viewType: Bool

    var body: some View {
        VStack{
            Picker("", selection: $viewType) {
                Text("Меню").tag(true)
                Text("Кафе").tag(false)
            }.pickerStyle(.segmented)
            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                Image(uiImage: viewModel.selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 190)
                        .foregroundColor(.black)
                        .cornerRadius(20)
                }
            VStack(spacing: 10){
                Text("Название")
                TextFieldExt(text: menu?.title ?? cafe?.name ?? "", bind: $viewModel.title, secure: false)
                Text("Описание")
                TextFieldExt(text: menu?.description ?? cafe?.adress ?? "", bind: $viewModel.description, secure: false)
                if viewType{
                    Text("Цена")
                    if let price = menu?.price{
                        TextFieldExt(text: String(price), bind: $viewModel.price, secure: false)
                    }
                    Picker("", selection: $viewModel.category) {
                        ForEach(Categories.allCases, id: \.id) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }.pickerStyle(.segmented)
                    Toggle("Сезонное", isOn: $viewModel.season)
                    Toggle("Новинка!", isOn: $viewModel.new)
                }
            }
            ButtonExt(action: {
                if viewType {
                    if let price = Double(viewModel.price){
                        viewModel.product = ProductModel(id: menu?.id ??  viewModel.id,
                                                      title: viewModel.title,
                                                      price: price,
                                                      description: viewModel.description,
                                                      category: viewModel.category,
                                                      season: viewModel.season,
                                                      new: viewModel.new)
                    }
                } else {
                    viewModel.coffeShop = ShopModel(id: cafe?.id ?? viewModel.id, name: viewModel.title, adress: viewModel.description)
                }
                Task{
                    guard let imageData = viewModel.selectedImage.jpegData(compressionQuality: 0.3) else { return }
                    viewType ?
                    try await FireStoreService.shared.addProduct(product: viewModel.product!,photo: imageData) :
                    try await FireStoreService.shared.addCafes(coffeShop: viewModel.coffeShop!, photo: imageData)
                }
            }, text: "Сохранить")
            .bold()
            if let caffeShop = cafe{
                ButtonExt(action: {
                    Task{
                        try await FireStoreService.shared.removeItemorShop(
                                id: caffeShop.id,
                                reference: FireStoreService.shared.coffeShopRef)
                        }
                }, text: "Удалить")
            }
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }
}

//struct AdminAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdminAddView()
//    }
//}
