//
//  CoffeShopApp.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 16.07.2023.
//

import SwiftUI
import FirebaseCore


@main
struct CoffeShopApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .preferredColorScheme(.light)
            }
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
