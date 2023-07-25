//
//  ButtonExt.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 18.07.2023.
//

import SwiftUI

struct ButtonExtWthTgl: View {
    var action: () -> Void
    var text: String
    var width: CGFloat = 100
    @State var pushed = false
    var body: some View {
        Button(text){
            action()
            pushed.toggle()
        }
        .frame(maxWidth: width, maxHeight: 20)
        .padding(.horizontal, 8)
        .background(pushed ? .black : .white)
        .foregroundColor(pushed ? .white : .black)
        .cornerRadius(10)
        .shadow(color: .black, radius: 1, x: 0, y: 0)
    }
}
struct ButtonExt: View {
    var action: () -> Void
    var text: String
    var width: CGFloat = 100
    var body: some View {
        Button(text){
            action()
        }
        .frame(maxWidth: width, maxHeight: 20)
        .padding(.horizontal, 8)
        .background(.white)
        .foregroundColor(.black)
        .cornerRadius(10)
        .shadow(color: .black, radius: 1, x: 0, y: 0)
    }
}

