//
//  ActivityPaymentCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct ActivityPaymentCell: View {
    @Binding var payment: Payment
    @State var showMemo = false
    var body: some View {
        VStack {
            TimeBar(unix: payment.time)
                .padding(.bottom, 2)
            GeneralPaymentCell(payment: $payment)
            ScrollView {
                HStack {
                    Text(payment.memo)
                    Spacer()
                }
            }
            .padding(.bottom, showMemo ? 20 : 0)
            .animation(.easeIn)
            .frame(maxHeight: showMemo ? 10000 : 0)
            .foregroundColor(showMemo ? .black : .clear)
        }
        .foregroundColor(.black)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    Color.white.opacity(0.5)
                )
        )
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: payment.memo != "" ? "chevron.down" : "")
                        .rotationEffect(.degrees(showMemo ? 180 : 0))
                        .padding()
                        .foregroundColor(.black)
                    Spacer()
                }
            }
        )
        .onTapGesture {
            withAnimation {
                if payment.memo != "" {
                    showMemo.toggle()
                }
            }
        }
    }
}

struct ActivityPaymentCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityPaymentCell(payment: .constant(.placeholder))
        }
        
    }
}
