//
//  RequestPaymentView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct RequestPaymentView: View {
    @Binding var house: House
    @State var showPicker = false
    @State var choice: [Member] = [Member]()
    @State var amountText = String()
    @State var memoText = String()
    @Binding var tabSelection: Int
    var body: some View {
        VStack {
            HStack {
                Text("From:")
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
                MemberPicker(show: $showPicker, house: $house, choice: $choice, multiple: true)
            })
//            Spacer()
            VStack {
                InputField(name: "Amount", text: $amountText)
                Text("Total amount will be split equally between members")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .opacity(0.5)
            }
            .padding()
            InputField(name: "Memo", text: $memoText)
                .padding()
            Spacer()
            Button(action: {
                Fetch().sendPayment(p: Payment(to: house.members.first(where: { (m) -> Bool in
                    return m.id == UserDefaults.standard.string(forKey: "myId")
                })?.name ?? "unknown recipient", reqfrom: choice.map({ (m) -> String in
                    return m.name
                }), amount: Float(amountText)!, time: Int(NSDate().timeIntervalSince1970), memo: memoText, isRequest: true), h: house)
                
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
