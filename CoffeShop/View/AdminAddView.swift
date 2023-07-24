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
    var menu: MenuModel?
    var cafe: CoffeShopModel?
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
                TextFieldExt(text: menu?.title ?? cafe?.name ?? "Название", bind: $viewModel.title, secure: false)
                TextFieldExt(text: menu?.description ?? cafe?.adress ?? "Описание", bind: $viewModel.description, secure: false)
                if viewType{
                    TextFieldExt(text: String(menu?.price ?? 0) ?? "Цена", bind: $viewModel.price, secure: false)
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
                    viewModel.product = MenuModel(id: menu?.id ??  viewModel.id,
                                            title: viewModel.title,
                                            price: (Double(viewModel.price) ?? 0.0),
                                            description: viewModel.description,
                                            category: viewModel.category,
                                            season: viewModel.season,
                                            new: viewModel.new)
                } else {
                    viewModel.coffeShop = CoffeShopModel(id: cafe?.id ?? viewModel.id, name: viewModel.title, adress: viewModel.description)
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
            Button("Удалить") {
                Task{
                    try await FireStoreService.shared.removeItemorShop(
                            id: caffeShop.id,
                            reference: FireStoreService.shared.coffeShopRef)
                    }
                }
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
