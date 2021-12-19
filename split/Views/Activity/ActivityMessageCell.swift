//
//  ActivityMessageCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-11.
//

import SwiftUI

struct ActivityMessageCell: View {
    @Binding var allPayments: [Payment]
    @Binding var payment: Payment
    @Binding var member: Member
    @State var img = ""
    @Binding var GMmsg: String
    @Binding var showMessagePopover: Bool
    var body: some View {
        
//        Menu {
//
//            if payment.by != member.id {
//                Button {
//                    GMmsg = "@"+payment.from+" "
//                    showMessagePopover = true
//                } label: {
//                    Text("Reply")
//                    Image(systemName: "arrowshape.turn.up.left")
//                }
//
//            }
//
//            if member.admin || payment.by == member.id {
//            Button {
//                var house = House.empty
//                house.id = member.home
//                Fetch().deletePayment(p: payment, h: house)
//            } label: {
//                Text("Delete")
//                    .foregroundColor(.red)
//                Image(systemName: "trash")
//                    .foregroundColor(.red)
//            }
//            }
//
//        }
//            label: {
            HStack {
                
                if payment.by != (UserDefaults.standard.string(forKey: "myId") ?? "") {
                    VStack {
                        Spacer()
                        if !nextMessageIsSameSender(allPayments, id: payment.id!, from: payment.from) {
                            VStack {
                                b64toimg(b64: img)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .shadow(radius: 4)
                                    .background(Color.white)
                                    .onAppear {
                                        Fetch().imgFromId(id: payment.by, img: $img)
                                    }
                                Text(payment.from)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                    .padding(.vertical, -4)
                                    .minimumScaleFactor(0.4)
                                    .multilineTextAlignment(.center)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: 40, height: 60)
                        } else {
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 40, height: 60)
                        }
                    }
                    .padding(.trailing)
                }
                
                VStack {
                    HStack {
                        //                        if payment.by == (UserDefaults.standard.string(forKey: "myId") ?? "") {
                        //                            Spacer(minLength: 0)
                        //                        }
                        Text(payment.memo)
                            .padding(.horizontal,10)
                            .padding(.bottom, 10)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(payment.by == (UserDefaults.standard.string(forKey: "myId") ?? "") ? .white : .black)
                        //                        if payment.by != (UserDefaults.standard.string(forKey: "myId") ?? "") {
                        Spacer(minLength: 0)
                        //                        }
                    }
                    .lineLimit(10)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 2)
                .padding(.top, 6)
                .padding(.bottom, 10)
                .background(
                    CustomRoundedRect(corners: nextMessageIsSameSender(allPayments, id: payment.id!, from: payment.from) ? [.allCorners] : [.topLeft, .topRight, (payment.by == (UserDefaults.standard.string(forKey: "myId") ?? "") ? .bottomLeft : .bottomRight)],radius: 10)
                        .fill(
                            Color(payment.by == (UserDefaults.standard.string(forKey: "myId") ?? "") ? "MessageBlue" : "MessageWhite")
                        )
                )
                .overlay(
                    VStack {
                        Spacer()
                        TimeBar(unix: payment.time, white: payment.by == (UserDefaults.standard.string(forKey: "myId") ?? ""))
                            .padding(.horizontal,4)
                    }
                )
                if payment.by == (UserDefaults.standard.string(forKey: "myId") ?? "") {
                    VStack {
                        VStack {
                            Spacer()
                            if !nextMessageIsSameSender(allPayments, id: payment.id!, from: payment.from) {
                                VStack {
                                    b64toimg(b64: img)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .shadow(radius: 4)
                                        .background(Color.white)
                                        .onAppear {
                                            Fetch().imgFromId(id: payment.by, img: $img)
                                        }
                                    Text(payment.from)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                        .padding(.vertical, -4)
                                        .minimumScaleFactor(0.4)
                                        .multilineTextAlignment(.center)
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(width: 40, height: 60)
                            } else {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 40, height: 60)
                            }
                        }
                        .padding(.leading)
                    }
                }
            }
            .contextMenu(menuItems: {
                
                if payment.by != member.id {
                    Button {
                        GMmsg = "@"+payment.from+" "
                        showMessagePopover = true
                    } label: {
                        Text("Reply")
                        Image(systemName: "arrowshape.turn.up.left")
                    }
                    
                }
                
                if member.admin || payment.by == member.id {
                Button {
                    var house = House.empty
                    house.id = member.home
                    Fetch().deletePayment(p: payment, h: house)
                } label: {
                    Text("Delete")
                        .foregroundColor(.red)
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                }
                
            })
            .padding(.bottom, nextMessageIsSameSender(allPayments, id: payment.id!, from: payment.from) ? -20 : -8)
            .padding(.top, -10)

//        }
    }
}

struct ActivityMessageCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityMessageCell(allPayments: .constant([.placeholderm]), payment: .constant(.placeholder), member: .constant(.placeholder), GMmsg: .constant(""), showMessagePopover: .constant(true))
                .frame(height: 00)
        }
    }
}


func nextMessageIsSameSender(_ payments: [Payment], id: String, from: String) -> Bool {
    let i = payments.firstIndex { p in
        return p.id == id
    } ?? 0
    
    if (payments.count - 1) > i {
        let pn = payments[i+1]
        if pn.type == .groupmessage {
            if pn.from == from {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    } else {
        return false
    }
}
