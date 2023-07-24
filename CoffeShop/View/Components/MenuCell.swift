//
//  MenuCell.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 18.07.2023.
//

import SwiftUI

struct MenuCell: View {
    var menu: MenuModel
    @State var menuImage: UIImage?
    var width: CGFloat = 200
    var height: CGFloat = 200
    var body: some View {
        ZStack(alignment: .topLeading){
            if let photo = menuImage {
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: width, maxHeight: height)
                    .cornerRadius(20)
                    .clipped()
            } else {
                Image(systemName: "cup.and.saucer.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width)
            }
                Text(menu.title)
                    .foregroundColor(.black)
                    .font(.callout).bold()
                    .padding()
        }
        .onAppear {
            FireStoreStorage.shared.getImage(productID: menu.id, reference: FireStoreStorage.shared.productsRef) { result in
                    switch result {
                    case .success(let data):
                        menuImage = UIImage(data: data)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }    
        }
    }
}

