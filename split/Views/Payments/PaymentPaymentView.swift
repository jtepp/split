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
    @State var amountText = String()
    var body: some View {
        VStack {
            HStack {
                Text("To:")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    showPicker = true
                }, label: {
                    PickerButton(text: "Tap to Select", choice: $choice)
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
//            Spacer()
            HStack {
                Text("Amount:")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                TextField("Amount", text: $amountText)
                    .opacity(0.5)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    
                Spacer()
            }
            .padding()
            //memo
            Spacer()
            Button(action: {}, label: {
                HStack {
                    Spacer()
                    Text("Post")
                        .foregroundColor(choice.isEmpty || amountText.isEmpty || !amountText.isNumeric ? .clear : .white)
                    Spacer()
                }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(choice.isEmpty || amountText.isEmpty || !amountText.isNumeric ? .clear : Color.blue)
                    )
                    .padding()
            })
        }
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
