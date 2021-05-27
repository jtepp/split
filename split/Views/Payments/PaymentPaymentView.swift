//
//  PaymentPaymentView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct PaymentPaymentView: View {
    @Binding var house: House
    @State var showPicker = false
    @State var choice: [Member] = [Member]()
    var body: some View {
        HStack {
            Text("To:")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            Spacer()
            Button(action: {
                showPicker = true
            }, label: {
                Text("Tap to Select")
                    .padding(10)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                Color.white.opacity(0.5)
                            )
                    )
            })
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showPicker, content: {
            MemberPicker(show: $showPicker, house: $house, choice: $choice, multiple: false)
        })
    }
}

struct PaymentPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            PaymentView(house: .constant(.placeholder))
        }
    }
}
