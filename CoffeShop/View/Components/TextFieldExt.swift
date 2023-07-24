//
//  TextFieldExt.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import SwiftUI

struct TextFieldExt: View {
    var text: String
    @Binding var bind: String
    @State var secure: Bool
    var body: some View {
        if !secure{
            TextField(text, text: $bind)
                .padding(.horizontal, 8)
                .background(.white)
                .cornerRadius(10)
                .shadow(color: .black, radius: 1, x: 0, y: 0)
        } else {
            SecureField(text, text: $bind)
                .padding(.horizontal, 8)
                .background(.white)
                .cornerRadius(10)
                .shadow(color: .black, radius: 1, x: 0, y: 0)
                .overlay(alignment: .trailing){
                    Button {
                        withAnimation(.easeInOut){
                            secure.toggle()}
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeInOut){
                                secure.toggle()}
                        }
                    } label: {
                        Image(systemName: "eye")
                            .foregroundColor(.black)
                    }
                }
        }
    }
}

//struct TextFieldExt_Previews: PreviewProvider {
//    static var previews: some View {
//        TextFieldExt()
//    }
//}
