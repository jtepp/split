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
            GeneralPaymentCell(payment: $payment)
            ScrollView {
                HStack {
                    Text("Payment")
                        .font(Font.caption.smallCaps().weight(Font.Weight.black))
                    Spacer()
                }
                HStack {
                    Text(payment.memo)
                    Spacer()
                }
            }
            .padding(.bottom, showMemo ? 20 : 0)
            .animation(.easeIn)
            .frame(maxHeight: showMemo ? 10000 : 0)
            .frame(minHeight: showMemo ? 80 : 0)
            .foregroundColor(showMemo ? .black : .clear)
        }
        .foregroundColor(.black)
        .padding()
        .padding(.bottom, 10)
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
                    //                        .padding(.top, -10)
                    Spacer()
                }
                .overlay(
                    TimeBar(unix: payment.time)
                        .padding(.horizontal, 4)
                        .offset(y: payment.memo == "" ? 8 : 12)
                )
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
            ScrollView {
                ForEach(Range(0...10)) { _ in
                    ActivityPaymentCell(payment: .constant(.placeholder))
                }
            }
        }
        
    }
}
