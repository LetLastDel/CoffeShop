//
//  CafesCell.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 18.07.2023.
//

import SwiftUI

struct CafesCell: View {
    var cafe: CoffeShopModel
    @State var coffeShopsImage: UIImage?

    var body: some View {
        ZStack(alignment: .topLeading){
            if let photo = coffeShopsImage {
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250, height: 200)
                    .cornerRadius(20)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
            }
            VStack(alignment: .leading){
                Text(cafe.name)
                    .foregroundColor(.white)
                    .font(.callout).bold()
                    .padding()
                Spacer()
                Text(cafe.adress)
                    .foregroundColor(.white)
                    .font(.caption).bold()
                    .padding()
            }
            .background(Color.black.blur(radius: 50).opacity(0.2))
        }
        .onAppear {
            FireStoreStorage.shared.getImage(productID: cafe.id, reference: FireStoreStorage.shared.caffesRef) { result in
                    switch result {
                    case .success(let data):
                        coffeShopsImage = UIImage(data: data)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
}

//struct CafesCell_Previews: PreviewProvider {
//    static var previews: some View {
//        CafesCell()
//    }
//}
