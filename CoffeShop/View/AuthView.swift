//
//  AuthView.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 16.07.2023.
//

import SwiftUI

struct AuthView: View {
    @StateObject var viewModel: AuthViewModel
    @State var isAuth = true
    @EnvironmentObject var contentVM: ContentViewModel
    
    var body: some View {
        VStack{
                VStack{
                    Text("Coffe Shop")
                        .font(.title).bold()
                    Image(systemName: "cup.and.saucer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 100)
                }
                VStack(spacing: 20){
                    Text(isAuth ? "Authorization" : "Registrarion")
                TextFieldExt(text: "Insert email", bind: $viewModel.email, secure: false)
                TextFieldExt(text: "Insert password", bind: $viewModel.password, secure: true)
                    if !isAuth{
                        TextFieldExt(text: "Confirm password", bind: $viewModel.repeatPass, secure: true)
                    }
                    Button(isAuth ? "Enter" : "Create account") {
                        isAuth ? viewModel.singIn() : viewModel.singUp()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: .black, radius: 1, x: 0, y: 0)
                    Button(isAuth ? "Create account" : "I have an account"){
                        withAnimation {
                            isAuth.toggle()
                        }
                    }.foregroundColor(.black)
            }
            .frame(width: 360)
            .padding(.vertical, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
