//
//  PaymentPaymentView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct PaymentPaymentView: View {
    @ObservedObject var amountObj: AmountObject
    @Binding var house: House
    @State var showPicker = false
    @Binding var choice: [Member]
    @State var memoText = String()
    @Binding var tabSelection: Int
    var namespace: Namespace.ID
    @Binding var showOverlay: Bool
    @Binding var amountText: String
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
                                    Color("Material")
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
            if !showOverlay {
                AmountField(namespace: namespace, amountObj: amountObj, amountText: $amountText, showOverlay: $showOverlay)
                    .padding()
            } else {
                Rectangle().fill(Color.clear).frame(height:90)
            }
            InputField(name: "Memo", text: $memoText)
                .padding()
            Spacer()
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                Fetch().sendPayment(p: Payment(to: choice.first!.name, from: house.members.first(where: { (m) -> Bool in
                    return m.id == UserDefaults.standard.string(forKey: "myId")
                })?.name ?? "unknown sender", amount: Float(amountText)!, time: Int(NSDate().timeIntervalSince1970), memo: memoText, isRequest: false), h: house)
                
                //clear
                choice = [Member]()
                amountText = ""
                amountObj.clear()
                memoText = ""
                tabSelection = 0
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }, label: {
                HStack {
                    Spacer()
                    Text("Post")
                        .foregroundColor(choice.isEmpty || amountText.isEmpty || !amountText.isNumeric  || validateFloatString(str: $amountText) ? .clear : .white)
                    Spacer()
                }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(choice.isEmpty || amountText.isEmpty || !amountText.isNumeric || validateFloatString(str: $amountText) ? .clear : Color.blue)
                    )
                    .padding()
            })
            .allowsHitTesting(!(choice.isEmpty || amountText.isEmpty || !amountText.isNumeric || validateFloatString(str: $amountText)))
        }
    }
}


struct InputField: View {
    var name: String
    @Binding var text: String
    var small: Bool = false
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
        }.scaleEffect(small ? 0.8 : 1)
    }
}

struct NSInputField: View {
    var name: String
    @Binding var text: String
    var small: Bool = false
    var namespace: Namespace.ID
    var body: some View {
        HStack {
            Text("\(name):")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .matchedGeometryEffect(id: "\(name)", in: namespace)
            Spacer()
            TextField(name, text: $text)
                .opacity(0.5)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(name.lowercased() == "amount" ? .decimalPad : .default)
                
            Spacer()
        }.scaleEffect(small ? 0.8 : 1)
    }
}


//struct PaymentPaymentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.black.edgesIgnoringSafeArea(.all)
//            PaymentView(house: .constant(.placeholder), tabSelection: .constant(0))
//        }
//    }
//}

func validateFloatString(str: Binding<String>) -> Bool {
    return Float(String(format: "%.2f", Float(str.wrappedValue) ?? 0.00))! == 0.00
}
