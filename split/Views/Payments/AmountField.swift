//
//  AmountField.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import SwiftUI

struct AmountField: View {
    @ObservedObject var amountObj: AmountObject
    @Binding var amountText: String
    var body: some View {
        HStack {
            InputField(name: "Amount", text: $amountText)
                .onChange(of: amountText) { _ in
                    if validateFloatString(str: $amountText) {
                        amountObj.values = [Float(amountText)!]
                    }
                }
            Spacer()
            Button {
                amountObj.show = true
            } label: {
                Image(systemName: "list.bullet")
                    .foregroundColor(.white)
                    .padding(.horizontal, 2)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white, lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(Color("DarkMaterial").cornerRadius(10))
    }
}


struct AmountField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            AmountField(amountObj: AmountObject(), amountText: .constant(""))
                .padding()
        }
    }
}
