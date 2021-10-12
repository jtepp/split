//
//  QuickSettleView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-09-25.
//

import SwiftUI

struct QuickSettleView: View {
    var h: Binding<House>
    @Binding var settleMembers: [Member]
    @Binding var showSheet: Bool
    func upCount() -> Int {
        return Int(ceil(Float(settleMembers.count)/2))
    }
    @State var paymentList = [Payment]()
    @State var state: settleState = .preCalculate
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    HeaderText(text: "Quick Settle", clear: .constant(false))
                    Spacer()
                    Button {
                        showSheet = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(Font.body.bold())
                            .padding(4)
                            .background(
                                Circle()
                                    .fill(
                                        Color.white                                        )
                            )
                    }
                    .padding(.trailing, 10)
                }
                ScrollView {
                    if state == .preCalculate {
                        LazyVGrid(columns: [GridItem(spacing: 8), GridItem()], content: {
                            ForEach(settleMembers.sorted(by: { a, b in
                                memberBalanceFloat(m: a) > memberBalanceFloat(m: b)
                            })) {member in
                                MemberCellBalance(m: .constant(member))
                            }
                            
//                            .padding(.bottom, 5)
                        })
                        .padding()
                    } else if state == .prePost {
                        VStack {
                            if paymentList.count == 0 {
                                
                                Text("Your group is already even")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(
                                                Color("DarkMaterial")
                                            )
                                    )
                                    .onTapGesture {
                                        showSheet = false
                                    }
                                    .padding()
                                
                            }
                            ForEach(paymentList) { p in
                                
                                ActivityPaymentCell(payment: .constant(p), showMemoEver: false)
                                
                            }
                            .padding(.horizontal, 10)
                            
                            
                        }
                    }
                }
                Spacer()
                Button {
                    if state == .preCalculate {
                        paymentList = settlePayments(settleMembers)
                        withAnimation {
                            state = .prePost
                        }
                    } else if state == .prePost {
                        for p in paymentList {
                            Fetch().sendPayment(p: p, h: h.wrappedValue)
                        }
                        showSheet = false
                    }
                    
                } label: {
                    HStack{
                        Spacer()
                        Text(state == .preCalculate ? "Calculate" : paymentList.count > 0 ? "Post" : "Close")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(state == .preCalculate ? Color.blue : paymentList.count > 0 ? Color.green : Color.gray)
                )
                .padding(.bottom, 90)
            }
        }
    }
}

struct QuickSettleView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView(house: .constant(House.placeholder), payType: .constant(0), tabSelection: .constant(0), pchoice: .constant([.empty]), rchoice: .constant([.empty]))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

enum settleState {
    case preCalculate
    case prePost
}
