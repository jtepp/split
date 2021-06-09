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
    @State var includeSelf = false
    @State var explainIncludeSelf = false
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
                Toggle(isOn: $includeSelf, label: {
                    Button(action: {
                        explainIncludeSelf = true
                    }, label: {
                        Text("i")
                            .font(.system(size: 10, design: .monospaced))
                            .padding(4)
                            .background(
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.white)
                            )
                    })
                    Text("Label")
                })
                    .foregroundColor(.white)
            }
            .padding()
            InputField(name: "Memo", text: $memoText)
                .padding()
            Spacer()
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
        .alert(isPresented: $explainIncludeSelf, content: {
            Alert.init(title: Text(""), message: Text(""), dismissButton: Alert.Button.cancel(Text("Ok")))
        })
    }
}

struct RequestPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            PaymentView(house: .constant(.placeholder), tabSelection: .constant(0))
        }
    }
}
