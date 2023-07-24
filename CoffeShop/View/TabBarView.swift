//
//  TapBarView.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    var body: some View {
        TabView{
            if let user = contentVM.currentUser{
                MainView()
                    .environmentObject(contentVM)
                    .tabItem{
                        Image(systemName: "house.fill")
                    }
                if user.admin {
                    AdminOrderView()
                        .environmentObject(contentVM)
                        .tabItem {
                            Image(systemName: "lanyardcard")
                        }
                    AdminAddView(viewType: true)
                        .environmentObject(contentVM)
                        .tabItem {
                            Image(systemName: "gear")
                            
                        }
                } else {
                    CartView(viewModel: CartViewModel.shared)
                        .environmentObject(contentVM)
                        .tabItem{
                            Image(systemName: "cart")
                        }
                }
                ProfileView()
                    .environmentObject(contentVM)
                    .tabItem {
                        Image(systemName: "person")
                    }
            }
        }
    }
}
