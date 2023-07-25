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
    @State var showAlert = false
    @State var alertMessage: String = ""
    
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
                    Text(isAuth ? "Авторизация" : "Регистрация")
                TextFieldExt(text: "Введите е-маил", bind: $viewModel.email, secure: false)
                TextFieldExt(text: "Введите пароль", bind: $viewModel.password, secure: true)
                    if !isAuth{
                        TextFieldExt(text: "Повторите пароль", bind: $viewModel.repeatPass, secure: true)
                    }
                    ButtonExt(action: {
                        Task{
                            do{
                                 isAuth ? try await viewModel.singIn() : try await viewModel.singUp()
                            } catch Errors.emptyLogin {
                                showAlert.toggle()
                                alertMessage = Errors.emptyLogin.rawValue
                            } catch Errors.shortPass {
                                showAlert.toggle()
                                alertMessage = Errors.shortPass.rawValue
                            } catch Errors.passNotConfirm {
                                showAlert.toggle()
                                alertMessage = Errors.passNotConfirm.rawValue
                            } catch Errors.singInError {
                                showAlert.toggle()
                                alertMessage = Errors.singInError.rawValue
                            } catch Errors.singUpError {
                                showAlert.toggle()
                                alertMessage = Errors.singUpError.rawValue
                            }
                        }
                    }, text: isAuth ? "Вход" : "Регистарция", width: .infinity)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Ошибка!"),
                              message: Text(alertMessage),
                              dismissButton: .default(Text("OK")))
                    }
                    Button(isAuth ? "Создать акаунт" : "Уже есть аккаунт"){
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
