//
//  AuthService.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService(); private init() { }
    
    let auth =  Auth.auth()
    var currentUser: User? { auth.currentUser }
    
    func singIn(email: String, password: String) async throws -> ProfileModel {
        do{
            let result = try await auth.signIn(withEmail: email, password: password)
            let profile = try await FireStoreService.shared.getProfile(by: result.user.uid)
            return profile
        } catch {
            throw Errors.singInError
            }
        }
  
    
    func singUp(email: String, password: String) async throws -> ProfileModel {
        let result = try await auth.createUser(withEmail: email, password: password)
        let user = result.user
        guard let userEmail = user.email else {
            throw Errors.singUpError
        }
        let profile = ProfileModel(id: user.uid,
                                  name: "Новый пользователь",
                                  email: userEmail,
                                  phone: nil,
                                  adress: nil,
                                  admin: false)
        do {
            try await FireStoreService.shared.createProfile(profile: profile)
        } catch {
            throw Errors.singUpError
        }
        return profile
    }

    func singOut(){
        try! auth.signOut()
    }
}
