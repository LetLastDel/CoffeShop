//
//  CartView.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @EnvironmentObject var contentVM: ContentViewModel
    @State var showMenu = false
    @State var shod = false
    var gridItem: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
            if let profile = contentVM.currentUser {
                ScrollView{
                    VStack{
                        Text("Добро пожаловать, \(contentVM.currentUser?.name ?? "гость")")
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(viewModel.coffeShops, id: \.id) { cof in
                                    CafesCell(cafe: cof)
                                        .onTapGesture {
                                            if profile.admin{
                                                viewModel.selectedCafe = cof
                                            }
                                        }
                                }
                            }
                        }
                        .sheet(item: $viewModel.selectedCafe, content: { selectedCafe in
                            AdminAddView(cafe: selectedCafe, viewType: false)
                        })
                        .frame(maxHeight: 200)
                        HStack{
                            Text(showMenu ? "Меню" : "Новинки")
                            Spacer()
                            ButtonExtWthTgl(action: {
                                withAnimation(.easeIn(duration: 0.8)) {
                                    showMenu.toggle()
                                }
                            }, text: "Показать все", width: 130)
                        }
                        VStack{
                            if showMenu{
                                LazyVGrid(columns: gridItem, alignment: .center, spacing: 0) {
                                    ForEach(viewModel.menu, id: \.id) { menu in
                                        NavigationLink {
                                            ItemView(item: menu)
                                                .environmentObject(viewModel)
                                                .environmentObject(contentVM)
                                        } label: {
                                            MenuCell(menu: menu)
                                        }
                                    }.padding(.bottom, 8)
                                }
                            }
                            if !showMenu{
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(viewModel.sorted, id: \.id) { menu in
                                            NavigationLink {
                                                ItemView(item: menu)
                                                    .environmentObject(viewModel)
                                                    .environmentObject(contentVM)
                                            } label: {
                                                MenuCell(menu: menu)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, 2)
                        .background(.white)
                }
            }
        }
    }
