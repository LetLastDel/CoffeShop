//
//  Profile.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @StateObject var viewModel = ProfileViewModel()
    @State var showEditView = false
    @State var showAlert = false
    
    var body: some View {
        VStack{
            VStack(alignment: .trailing){
                HStack(alignment: .top){
                    HStack{
                        Image("cat")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 120)
                            .cornerRadius(60)
                            .shadow(color: .black, radius: 1, x: 0, y: 0)

                        Spacer()
                        VStack{
                            TextExt(change: false, text: contentVM.currentUser?.name ?? "Не указан", newText: $viewModel.newName, action: viewModel.changeUser)
                            Text(contentVM.currentUser?.email ?? "Empty")
                                .frame(maxWidth: 300, maxHeight: 20)
                                .padding(.horizontal, 8)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(color: .black, radius: 1, x: 0, y: 0)
                            TextExt(change: false, text: contentVM.currentUser?.adress ?? "Не указан", newText: $viewModel.newAdress, action: viewModel.changeUser)
                            TextExt(change: false, text: contentVM.currentUser?.phone?.description ?? "Не указан", newText: $viewModel.newPhone, action: viewModel.changeUser)
                        }
                    }.padding()
                }
                VStack{
                    Text("Избранное:")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 1) {
                            ForEach(viewModel.favorite, id: \.id) { menu in
                                NavigationLink {
                                    ItemView(item: menu, profile: contentVM.currentUser)
                                         .environmentObject(viewModel)
                                         .environmentObject(contentVM)
                                } label: {
                                    MenuCell(menu: menu, width: 100)
                                }
                            }
                        } .frame(maxHeight: viewModel.favorite.isEmpty ? 0 : 100)
                    }
                }
                VStack{
                    Text("История заказов:")
                    List{
                        ForEach(viewModel.orders.sorted(by: { $0.date > $1.date })) { order in
                            OrderCell(order: order)
                        }
                    }.listStyle(.plain)
                }
            }
            ButtonExt(action: { showAlert.toggle() }, text: "Выйти")
                .confirmationDialog("", isPresented: $showAlert) {
                    Button("Подвтердить"){
                        AuthService.shared.singOut()
                        contentVM.currentUser = nil
                    }
                } message: {
                    Text("Вы уверены что хотите выйти?")
                }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewModel.user = contentVM.currentUser
                Task{ try await viewModel.getFavorite() }
                Task{ try await viewModel.getOrders() }
            }
        .onChange(of: viewModel.check, perform: { newValue in
            Task{
                contentVM.currentUser = try await FireStoreService.shared.getProfile(by: contentVM.currentUser!.id)
            }
        })
    }
}

