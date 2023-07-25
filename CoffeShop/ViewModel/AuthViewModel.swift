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
    
    func singIn() async throws {
        guard !email.isEmpty else { throw Errors.emptyLogin };
        guard password.count >= 8 else { throw Errors.shortPass }
            do{
                let user = try await AuthService.shared.singIn(email: email, password: password)
                DispatchQueue.main.async {
                    self.contentVM.currentUser = user
                }
            } catch {
                throw Errors.singInError
            }
        }
    func singUp() async throws {
        guard !email.isEmpty else { throw Errors.emptyLogin };
        guard password.count >= 8 else { throw Errors.shortPass }
        guard password == repeatPass else { throw Errors.passNotConfirm }
            do{
                let user = try await AuthService.shared.singUp(email: self.email, password: self.password)
                DispatchQueue.main.async {
                    self.contentVM.currentUser = user
                }
            } catch {
                throw Errors.singUpError
            }
        }
    }
