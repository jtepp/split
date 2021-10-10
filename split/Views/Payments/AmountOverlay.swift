//
//  AmountOverlay.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import SwiftUI

struct AmountOverlay: View {
    @ObservedObject var amountObj: AmountObject
    @Binding var show: Bool
    @Binding var namespace: Namespace
    @Binding var amountText: String
    @State var text = String()
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    HeaderText(text: "Amount", space: true, clear: .constant(false))
                    Spacer()
                    Button {
                        show = false
                        amountText = String(format: "%.2f", amountObj.total())
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
                VStack {
                    ForEach(amountObj.values, id: \.self) { v in
                        AmountCell(amountObj: amountObj, v: v)
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Material").opacity(amountObj.values.count > 0 ? 1 : 0))
                )
                .padding(.horizontal)
                
            }
            HStack {
                TextField("Add...", text: $text)
                    .opacity(0.5)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad
                    )
                Spacer()
                Button {
                    if Float(text) ?? -1 != -1 {
                        amountObj.values.append(Float(text)!)
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .foregroundColor(Color.white.opacity(0.5))
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.horizontal)
            Button(action: {
                show = false
                amountText = String(format: "%.2f", amountObj.total())
            }, label: {
                HStack {
                    Spacer()
                    Text("Done")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
                .padding()
            })
        }
        .background(Color("DarkMaterial").cornerRadius(10))
        .padding()
        .matchedGeometryEffect(id: "amount", in: namespace.wrappedValue)
        .padding(.bottom, 90)
    }
}

struct AmountOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            AmountOverlay(amountObj: AmountObject().placeholder(), show: .constant(true), namespace: .constant(Namespace()), amountText: .constant("0.00"))
        }
    }
}
