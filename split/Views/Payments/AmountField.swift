//
//  AmountField.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import SwiftUI

struct AmountField: View {
    @ObservedObject var amountObj: AmountObject
    @Binding var amountText: String
    var body: some View {
        HStack {
            NSInputField(name: "Amount", text: $amountText, namespace: amountObj.namespace)
            Spacer()
            Button {
                amountObj.showOverlay = true
            } label: {
                Image(systemName: "list.bullet")
                    .foregroundColor(.white)
                    .padding(.horizontal, 2)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white, lineWidth: 1)
                    )
            }
            .matchedGeometryEffect(id: "receiptbutton", in: amountObj.namespace)
            .frame(width: 28, height: 28)
            .opacity(amountObj.showBulk ? 0.5 : 1)
            .disabled(amountObj.showBulk)
            Button {
                withAnimation {
                    amountObj.showBulk.toggle()
                }
            } label: {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 19)
                    .foregroundColor(amountObj.showBulk ? Color("DarkMaterial") : .white)
                    .padding(.horizontal, 3)
                    .padding(.vertical, 8.5)
                    .background(
                        bulkButtonBackground(amountObj: amountObj)
                    )
            }
            .matchedGeometryEffect(id: "bulkbutton", in: amountObj.namespace)
            .frame(width: 28, height: 28)
        }
        .padding()
        .background(Color("DarkMaterial").cornerRadius(10)
                        .matchedGeometryEffect(id: "background", in: amountObj.namespace))
        .matchedGeometryEffect(id: "whole", in: amountObj.namespace)
        //        .onLongPressGesture {
        //            showOverlay = true
        //            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        //        }
        
    }
}

struct bulkButtonBackground: View {
    @ObservedObject var amountObj: AmountObject
    var body: some View {
        if !amountObj.showBulk {
           RoundedRectangle(cornerRadius: 4)
                .stroke(Color.white, lineWidth: 1)
        } else {
           RoundedRectangle(cornerRadius: 4)
                .fill(Color.white)
        }
    }
}



struct AmountField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            PaymentView(house: .constant(.placeholder), payType: .constant(0), tabSelection: .constant(0), pchoice: .constant([.empty]), rchoice: .constant([.empty]))
        }
    }
}
