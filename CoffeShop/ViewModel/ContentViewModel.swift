//
//  ContentViewModel.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import Foundation
import FirebaseAuth
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var currentUser: ProfileModel?
    @Published var progress: Bool = true

    init(){
        Task {
            do {
                if let userID = AuthService.shared.currentUser?.uid {
                    let user = try await FireStoreService.shared.getProfile(by: userID)
                    DispatchQueue.main.async {
                        self.currentUser = user
                        self.progress = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.progress = false
                    }
                }
            } catch {
                DispatchQueue.main.async { [self] in
                    self.progress = false
                }
            }
        }
    }
}


