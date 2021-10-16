//
//  AmountField.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import SwiftUI

struct AmountField: View {
    @Binding var house: House
    @ObservedObject var amountObj: AmountObject
    @Binding var amountText: String
    @State var showSheet = false
    var body: some View {
        VStack {
            if amountObj.showBulk {
                VStack {
                    ForEach(amountObj.bulkPeople) {m in
                        BulkCell(amountObj: amountObj, m: m)
                    }
                    HStack {
                        Spacer()
                        Button {
                            showSheet = true
                        } label: {
                            HStack {
                                Text("Add")
                                Image(systemName: "plus")
                                    .padding(2)
                                    .background(Circle().fill(Color.green))
                                
                            }
                            .foregroundColor(.white)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white.opacity(0.2))
                            )
                        }
                        .frame(width: 82)
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.2))
                )
                .padding(.bottom)
            }
            HStack {
                if !amountObj.showBulk {
                NSInputField(name: "Amount", text: $amountText, namespace: amountObj.namespace)
                } else {
                    Text("Amount:")
                        .matchedGeometryEffect(id: "Amountfield", in: amountObj.namespace, isSource: false)
                        .font(.title.bold())
                        .foregroundColor(.white)
                    GeometryReader { proxy in
                        HStack {
                            Text("\(amountObj.bulkValues.values.reduce(0) { a, b in a+b}, specifier: "%.2f")")
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .frame(width: proxy.size.width)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.5)))
                        .foregroundColor(.black)
                    }
                    
                }
                    
                Spacer()
                Button {
                    amountObj.showOverlay = true
                    amountObj.canCloseOverlay = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        amountObj.canCloseOverlay = true
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
                .frame(width: 28, height: 28)
                .opacity(amountObj.showBulk ? 0.5 : 1)
                .disabled(amountObj.showBulk)
//                .matchedGeometryEffect(id: "receiptbutton", in: amountObj.namespace)
                Button {
                    withAnimation {
                        amountObj.showBulk.toggle()
                    }
                    amountObj.clearBulk()
                    if amountObj.showBulk {
                        showSheet = true
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
                            RoundedRectangle(cornerRadius: 4)
                                .fill(amountObj.showBulk ? Color.white : Color.clear)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(amountObj.showBulk ? Color.clear : Color.white, lineWidth: 1)
                                )
                        )
                }
                .frame(width: 28, height: 28)
            }
            //        .onLongPressGesture {
            //            showOverlay = true
            //            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            //        }
            
        }
        .padding()
        .background(Color("DarkMaterial").cornerRadius(10)
                        .matchedGeometryEffect(id: "background", in: amountObj.namespace))
        .matchedGeometryEffect(id: "whole", in: amountObj.namespace, isSource: false)
        .sheet(isPresented: $showSheet, content: {
            BulkMemberPicker(show: $showSheet, house: $house, amountObj: amountObj, multiple: true)
        })
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
