//
//  QuickSettleView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-09-25.
//

import SwiftUI

struct CompactorView: View {
    var h: Binding<House>
    @Binding var compactMembers: [Member]
    @Binding var showSheet: Bool
    @State var showCompactAlert = false
    func upCount() -> Int {
        return Int(ceil(Float(compactMembers.count)/2))
    }
    @State var paymentList = [Payment]()
    @State var state: compactState = .preCalculate
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    HeaderText(text: "Compactor", clear: .constant(false))
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
                            ForEach(compactMembers.sorted(by: { a, b in
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
                                
                                Text("Your group doesn't have any payments to compact")
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
                                
                                ActivityRequestCell(payment: .constant(p), showMemoEver: false, hId: h.wrappedValue.id, mems: h.members.wrappedValue)
                                
                            }
                            .padding(.horizontal, 10)
                            
                            
                        }
                    }
                }
                Spacer()
                Button {
                    if state == .preCalculate {
                        paymentList = compactPayments(compactMembers)
                        withAnimation {
                            state = .prePost
                        }
                    } else if state == .prePost {
                        showCompactAlert = true
                    }
                    
                } label: {
                    HStack{
                        Spacer()
                        Text(state == .preCalculate ? "Calculate" : paymentList.count > 0 ? "Compact" : "Close")
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
                .alert(isPresented: $showCompactAlert) {
                    Alert(title: Text("Confirm Compact"), message: Text("Compacting will delete all payments and requests and replace them with the smallest possible amount of requests."), primaryButton: Alert.Button.default(Text("Confirm"), action: {
                        
                        Fetch().deleteAllPayments(h: h.wrappedValue)
                        for p in paymentList {
                            Fetch().sendPayment(p: p, h: h.wrappedValue)
                        }
                        showSheet = false
                    }), secondaryButton: Alert.Button.destructive(Text("Cancel")))
                }
                
            }
        }
    }
}

struct CompactorView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView(house: .constant(House.placeholder), payType: .constant(0), tabSelection: .constant(0), pchoice: .constant([.empty]), rchoice: .constant([.empty]))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

enum compactState {
    case preCalculate
    case prePost
}
