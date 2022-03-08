//
//  GeneralPaymentSymbol.swift
//  split
//
//  Created by Jacob Tepperman on 2022-03-07.
//

import SwiftUI

struct GeneralPaymentSymbol: View {
    var payment: Payment
    var body: some View {
        HStack {
            if payment.special != "" {
                Image(systemName: specialImgName(payment.special))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 14)
                    .foregroundColor(.white)
            }
        }.offset(x: -13, y: -12)
    }
}

func specialImgName(_ special: String) -> String{
    switch (special) {
    case "includeself": return "person.circle"
    case "quicksettle": return "arrowshape.bounce.right"
    case "compactor": return "arrow.3.trianglepath"
    default: return ""
    }
}
