//
//  PositionCell.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 25.07.2023.
//

import SwiftUI

struct PositionCell: View {
    var position: PositionModel
    var body: some View {
        HStack{
            HStack(spacing: 4){
                Text(position.title)
                    .bold()
                Text(position.milk ?? "")
                Text(position.sirop ?? "")
                Text("\(position.count) шт")
            }
            HStack(spacing: 0){
                Text(String(format: "%.2f", (position.price)))
                Text("руб.")
            }
        }
        }
    }

//struct PositionCell_Previews: PreviewProvider {
//    static var previews: some View {
//        PositionCell(position: PositionModel(item: ProductModel(title: "Капучино", price: 124, description: "Вкусный", category: .coffe, season: false, new: false), title: "Капучино", count: 2, sirop: "Мятный", milk: "Ореховый", price: 234))
//    }
//}
