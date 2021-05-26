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
    var body: some View {
        ScrollView {
            HeaderText(text: "Create")
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
        }
    }
}


struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            PaymentView(house: .constant(.placeholder))
        }
    }
}
