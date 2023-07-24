//
//  ContentView.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 16.07.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        if !viewModel.progress{
            ProgressView()
        }
       else if (viewModel.currentUser != nil) {
            TabBarView()
                .environmentObject(viewModel)
        } else {
            AuthView(viewModel: AuthViewModel(contentVM: viewModel))
                .environmentObject(viewModel)
                .preferredColorScheme(.light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
