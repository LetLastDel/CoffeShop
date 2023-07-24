//
//  AuthViewModel.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import Foundation
 
class AuthViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatPass: String = ""
    
    var contentVM: ContentViewModel
    
    init(contentVM: ContentViewModel){
        self.contentVM = contentVM
    }
    
    func singIn() {
        guard !email.isEmpty else { print("Логин пустой"); return };
        guard password.count > 4 else { print("Пароль короткий"); return }
        Task{
            let user = try await AuthService.shared.singIn(email: email, password: password)
            DispatchQueue.main.async {
                self.contentVM.currentUser = user
            }
        }
    }
    func singUp() {
        print("reg")
        guard !email.isEmpty else { print("Логин пустой"); return };
        guard password.count > 8 else { print("Пароль короткий"); return }
        guard password == repeatPass else { print("Пароли не совпали"); return }
        Task{
            let user = try await AuthService.shared.singUp(email: self.email, password: self.password)
            DispatchQueue.main.async {
                self.contentVM.currentUser = user
            }
        }
    }
}
