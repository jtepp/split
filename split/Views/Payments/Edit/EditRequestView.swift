//
//  EditRequestView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-12-19.
//

import SwiftUI

struct EditRequestView: View {
    @Binding var house: House
    var member: Member
    var payment: Payment
    @Binding var mems: [Member]
    @State var showPicker = false
    @Binding var editType: EditPickerType
    @Binding var choiceFrom: [Member]
    @Binding var choiceTo: [Member]
    @State var choiceALL = [Member]()
    @Binding var amountText: String
    @Binding var memoText: String

    var body: some View {
        VStack {
            HStack {
                Text("To:")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    if member.admin {
                        editType = .to
                        choiceALL = choiceTo
                        showPicker = true
                    }
                }, label: {
                    PickerButton(text: "Loading Member...", choice: $choiceTo, whiteText: !member.admin)
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
            .padding(.horizontal)
            
            
            HStack {
                Text("From:")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    if member.admin || member.name == payment.to {
                        editType = .from
                        choiceALL = choiceFrom
                        showPicker = true
                    }
                }, label: {
                    PickerButton(text: "Loading Member...", choice: $choiceFrom, whiteText: !(member.admin || member.name == payment.to))
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    member.admin || member.name == payment.to ?
                                    Color("Material") : Color.black
                                )
                        )
                })
                Spacer()
            }
            .padding(.horizontal)
            
            InputField(name: "Amount", text: $amountText)
                .padding(.horizontal)
            InputField(name: "Memo", text: $memoText)
                .padding(.horizontal)
            
            EditLogView(payment: payment)
                .padding(10)
            
            
        }
        .onAppear(perform: {
            let memRF = mems.filter { m in
                payment.reqfrom.contains { n in
                    n == m.name
                }
            }
            
            if !memRF.isEmpty {
                choiceFrom = memRF
            }
            
            let memT = mems.first { m in
                m.name == payment.to
            }
            
            if memT != nil {
                choiceTo = [memT!]
            }
            
            amountText = String(format: "%.2f", payment.amount)
            memoText = payment.memo
        })
        .sheet(isPresented: $showPicker, onDismiss: {
            if editType == .from {
                choiceFrom = choiceALL
            } else if editType == .to {
                choiceTo = choiceALL
            }
        }, content: {
            MemberPicker(show: $showPicker, house: $house, choice: $choiceALL, multiple: editType == .from)
        })
    }
}

struct EditRequestView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityEditView(house: .constant(.placeholder), member: .empty, payment: .placeholderr, mems: .constant([Member]()), showEdit: .constant(true))
        }
    }
}
