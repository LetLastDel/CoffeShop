//
//  AdmonOrderView.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 23.07.2023.
//

import SwiftUI

struct AdminOrderView: View {
    @StateObject var viewModel = AdminOrdersViewModel()
    @EnvironmentObject var contentVM: ContentViewModel

    @State var push = false
    var body: some View {
        VStack{
            List{
                ForEach(viewModel.orders) { order in
                    OrderCell(order: order, admin: true)
                        .environmentObject(contentVM)
                }
            }.listStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AdmonOrderView_Previews: PreviewProvider {
    static var previews: some View {
        AdminOrderView()
    }
}
