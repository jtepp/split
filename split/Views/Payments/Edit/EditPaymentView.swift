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
    @State var choice = [Member]()
    var body: some View {
        HStack {
        Text("From:")
            .font(.title)
            .bold()
            .foregroundColor(.white)
        Spacer()
        Button(action: {
            if member.admin {
                showPicker = true
            }
        }, label: {
            PickerButton(text: "Loading Member...", choice: $choice, whiteText: true)
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
    .onAppear(perform: {
        let mem = mems.first { m in
            m.name == payment.from
        }
        
        if mem != nil {
            choice = [mem!]
        }
    })
    .sheet(isPresented: $showPicker, content: {
        MemberPicker(show: $showPicker, house: $house, choice: $choice, multiple: false)
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
