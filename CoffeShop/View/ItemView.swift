//
//  ItemView.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 18.07.2023.
//

import SwiftUI

struct ItemView: View {
    @StateObject var viewModel = ItemViewModel()
    var item : MenuModel
    var profile: ProfileModel?
    @EnvironmentObject var vm: MainViewModel
    @EnvironmentObject var contentVM: ContentViewModel
    @State var price: Double = 0
    @State var change = false
    
    var body: some View {
        VStack{
            if let user = contentVM.currentUser {
                
                MenuCell(menu: item, width: 380, height: 300)
                    .overlay(alignment: .bottom) {
                        VStack(){
                            HStack{
                                Text(item.title)
                                Spacer()
                                Button {
                                    Task{
                                        await (profile != nil) ?  try FireStoreService.shared.removeFavorite(userID: profile!.id, menu: item)  : viewModel.addFavorite(item, to: contentVM.currentUser!)
                                    }
                                } label: {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.black)
                                }
                            }
                            HStack{
                                Text("\(item.price) руб")
                                Spacer()
                                HStack{
                                    Stepper("\(viewModel.itemCount)") {
                                        viewModel.incrementStep()
                                    } onDecrement: {
                                        viewModel.decrementStep()
                                    }
                                }.frame(maxWidth: 120)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .cornerRadius(10)
                Text("Описание")
                    .font(.largeTitle)
                Text(item.description)
                    .font(.footnote)
                if user.admin {
                    ButtonExt(action: {
                        change.toggle()
                    }, text: "Изменить")
                    .sheet(isPresented: $change) {
                        AdminAddView(menu: item, viewType: true)
                    }
                    ButtonExt(action: {
                        Task{
                            try await FireStoreService.shared.removeItemorShop(id: item.id, reference: FireStoreService.shared.menuRef)
                        }
                    }, text: "Удалить")
                    Spacer()
                } else {
                    if item.category == Categories.coffe{
                        VStack(spacing: 0){
                            Text("Выберите размер")
                                .font(.largeTitle)
                            HStack(spacing: 10){
                                Picker("", selection: $viewModel.selectedSize) {
                                    ForEach(viewModel.size.indices, id: \.self) { size in
                                        Text(viewModel.size[size])
                                    }.tag(viewModel.size.indices)
                                }.pickerStyle(.segmented)
                            }
                            Text("Молоко")
                                .font(.largeTitle)
                            Picker("", selection: $viewModel.selectedMilk) {
                                ForEach(viewModel.milk.indices, id: \.self) { milk in
                                    Text(viewModel.milk[milk])
                                }.tag(viewModel.milk.indices)
                            }.pickerStyle(.segmented)
                            Text("Сироп")
                                .font(.largeTitle)
                            Picker("", selection: $viewModel.selectedSirop) {
                                ForEach(viewModel.sirop.indices, id: \.self) { index in
                                    Text(viewModel.sirop[index])
                                }.tag(viewModel.sirop.indices)
                            }.pickerStyle(.segmented)
                        }.padding(.horizontal, 5)
                    }
                    HStack{
                        HStack{
                            Text("Итого:")
                            Text(String(format: "%.2f", (item.price * Double(viewModel.itemCount) * viewModel.getPrice(selectedSize: viewModel.selectedSize, milk: viewModel.selectedMilk))))
                            Text("руб.")
                        }.font(.title2)
                        Spacer()
                        Button("В корзину!") {
                            let price = (item.price * Double(viewModel.itemCount) * viewModel.getPrice(selectedSize: viewModel.selectedSize, milk: viewModel.selectedMilk))
                            let order = PositionModel(item: MenuModel(title: item.title, price: item.price, description: "", category: item.category, season: item.season, new: item.new), title: item.title, count: viewModel.itemCount, sirop: viewModel.sirop[viewModel.selectedSirop], milk: viewModel.milk[viewModel.selectedMilk], price: price, size: viewModel.size[viewModel.selectedSize])
                            CartViewModel.shared.addOrder(order: order)
                            print("Добавляю в корзину \(order)")
                        }
                        .frame(width: 100, height: 40)
                        .foregroundColor(.black)
                        .background(.orange)
                        .cornerRadius(10)
                    }   .padding()
                        .background(.white)
                }
            }
        }
                .frame(maxHeight: .infinity)
                .background(.white)
                .preferredColorScheme(.light)
        }
    }


