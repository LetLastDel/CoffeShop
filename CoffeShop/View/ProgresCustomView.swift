//
//  ProgresCustomView.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 25.07.2023.
//

import SwiftUI

struct ProgresCustomView: View {
    @State var degrees = 0.0

    var body: some View {
        VStack {
            Image(systemName: "cup.and.saucer.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .rotationEffect(Angle(degrees: degrees))
        }
        .onAppear {
            startAnimation()
        }
    }
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(Animation.linear(duration: 1.0)) {
                degrees += 180
            }
        }
    }
}
struct ProgresCustomView_Previews: PreviewProvider {
    static var previews: some View {
        ProgresCustomView()
    }
}
