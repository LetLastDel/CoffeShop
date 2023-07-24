//
//  TextExt.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 18.07.2023.
//

import SwiftUI

struct TextExt: View {
    @State var change: Bool
    var text: String
    @Binding var newText: String
    var action: () -> Void

    var body: some View {
        if change{
            TextField(text, text: $newText)
                .frame(maxWidth: 300, maxHeight: 20)
                .padding(.horizontal, 8)
                .background(.white)
                .cornerRadius(10)
                .shadow(color: .black, radius: 1, x: 0, y: 0)
                .overlay(alignment: .trailing) {
                    Button {
                        withAnimation(.easeInOut){
                            change.toggle()
                            action()
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.black)
                    }
                }
        } else {
            HStack{
                Text(text)
                    .frame(maxWidth: 300, maxHeight: 20)
                    .padding(.horizontal, 8)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 1, x: 0, y: 0)
                    .overlay(alignment: .trailing) {
                        Button {
                            withAnimation(.easeInOut){
                                change.toggle()
                            }
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.black)
                        }
                    }
            }
        }
    }
}

//struct TextExt_Previews: PreviewProvider {
//    static var previews: some View {
//        TextExt()
//    }
//}
