//
//  AmountField.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import SwiftUI

struct AmountField: View {
    var namespace: Namespace.ID
    @ObservedObject var amountObj: AmountObject
    @Binding var amountText: String
    var body: some View {
        HStack {
            NSInputField(name: "Amount", text: $amountText, namespace: namespace)
            Spacer()
            Button {
                withAnimation {
                    amountObj.showOverlay = true
                }
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
            .matchedGeometryEffect(id: "button", in: namespace)
        }
        .padding()
        .background(Color("DarkMaterial").cornerRadius(10)
                        .matchedGeometryEffect(id: "background", in: namespace))
        .matchedGeometryEffect(id: "whole", in: namespace)
//        .onLongPressGesture {
//            showOverlay = true
//            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//        }
        
    }
}


