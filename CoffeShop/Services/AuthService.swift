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
        let result = try await auth.signIn(withEmail: email, password: password)
        let profile = try await FireStoreService.shared.getProfile(by: result.user.uid)
        return profile
    }
    
    func singUp(email: String, password: String) async throws -> ProfileModel {
        let result = try await auth.createUser(withEmail: email, password: password)
        let user = result.user
        
        let profile = ProfileModel(id: user.uid,
                                  name: "Не указана",
                                  email: user.email!,
                                  phone: 0,
                                  adress: "Не указан",
                                  admin: false)
        do{
            try await FireStoreService.shared.createProfile(profile: profile)
            return profile
        } catch {
            throw error
        }
    }
    
    func singOut(){
        try! auth.signOut()
    }
}
