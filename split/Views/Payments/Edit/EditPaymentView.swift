//
//  EditPaymentView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-12-19.
//

import SwiftUI

struct EditPaymentView: View {
    @Binding var house: House
    var member: Member
    var payment: Payment
    @Binding var mems: [Member]
    @State var showPicker = false
    @State var pickerFrom = true
    @State var choiceFrom = [Member]()
    @State var choiceTo = [Member]()
    @Binding var amountText: String
    var body: some View {
        VStack {
            HStack {
                Text("From:")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    if member.admin {
                        pickerFrom = true
                        showPicker = true
                    }
                }, label: {
                    PickerButton(text: "Loading Member...", choice: $choiceFrom, whiteText: true)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    member.admin ?
                                    Color("Material") : Color.black
                                )
                        )
                })
                Spacer()
            }
            .padding()
            
            
            HStack {
                Text("To:")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    if member.admin || member.name == payment.from {
                        pickerFrom = false
                        showPicker = true
                    }
                }, label: {
                    PickerButton(text: "Loading Member...", choice: $choiceTo, whiteText: true)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    member.admin || member.name == payment.from ?
                                    Color("Material") : Color.black
                                )
                        )
                })
                Spacer()
            }
            .padding()
            
            InputField(name: "Amount", text: $amountText)
                .padding()
            
            
        }
        .onAppear(perform: {
            let memF = mems.first { m in
                m.name == payment.from
            }
            
            if memF != nil {
                choiceFrom = [memF!]
            }
            
            let memT = mems.first { m in
                m.name == payment.to
            }
            
            if memT != nil {
                choiceTo = [memT!]
            }
            
            amountText = String(format: "%.2f", payment.amount)
        })
        .sheet(isPresented: $showPicker, content: {
            if !pickerFrom {
                MemberPicker(show: $showPicker, house: $house, choice: $choiceFrom, multiple: false)
            } else {
                MemberPicker(show: $showPicker, house: $house, choice: $choiceTo, multiple: false)
            }
        })
    }
}

struct EditPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityEditView(house: .constant(.placeholder), member: .empty, payment: .placeholder, mems: .constant([Member]()), showEdit: .constant(true))
        }
    }
}
