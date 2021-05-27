//
//  PaymentView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct PaymentView: View {
    @Binding var house: House
    @State var typeSelection = 0
    @Binding var tabSelection: Int
    var body: some View {
        ScrollView {
            HeaderText(text: typeSelection == 1 ? "Request" : "Payment")
            Picker(selection: $typeSelection, label: Text("Picker"), content: {
                Text("Payment").tag(0)
                Text("Request").tag(1)
            })
            .pickerStyle(SegmentedPickerStyle())
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        Color.white.opacity(0.2)
                    )
            )
            .padding()
            
            if typeSelection == 0 {
                PaymentPaymentView(house: $house, tabSelection: $tabSelection)
            } else {
                RequestPaymentView(house: $house, tabSelection: $tabSelection)
            }
            
        }
    }
}


struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            PaymentView(house: .constant(.placeholder), tabSelection: .constant(0))
        }
    }
}
