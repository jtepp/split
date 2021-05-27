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
    @State var memoText = String()
    @Binding var tabSelection: Int
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
            InputField(name: "Amount", text: $amountText)
            .padding()
            InputField(name: "Memo", text: $memoText)
                .padding()
            Spacer()
            Button(action: {
                Fetch().sendPayment(p: Payment(to: choice.first!.name, from: house.members.first(where: { (m) -> Bool in
                    return m.id == UserDefaults.standard.string(forKey: "myId")
                })?.name ?? "unknown sender", amount: Float(amountText)!, time: Int(NSDate().timeIntervalSince1970), memo: memoText, isRequest: false), h: house)
                
                //clear
                choice = [Member]()
                amountText = ""
                memoText = ""
                tabSelection = 0
            }, label: {
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
            .allowsHitTesting(!(choice.isEmpty || amountText.isEmpty || !amountText.isNumeric))
        }
    }
}


struct InputField: View {
    var name: String
    @Binding var text: String
    var body: some View {
        HStack {
            Text("\(name):")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            Spacer()
            TextField(name, text: $text)
                .opacity(0.5)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(name.lowercased() == "amount" ? .decimalPad : .default)
                
            Spacer()
        }
    }
}


struct PaymentPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            PaymentView(house: .constant(.placeholder), tabSelection: .constant(0))
        }
    }
}
