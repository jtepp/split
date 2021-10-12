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
    var namespace: Namespace.ID
    @Binding var amountText: String
    @State var text = String()
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    NSHeaderText(text: "Amount", space: true, clear: .constant(false), namespace: namespace)
                    Spacer()
                    Button {
                        show = false
                        amountText = amountObj.total() == 0 ? "" : String(format: "%.2f", amountObj.total())
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
                    .matchedGeometryEffect(id: "button", in: namespace)
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
                    .keyboardType(.decimalPad)
                    .matchedGeometryEffect(id: "Amountbox", in: namespace)
                Spacer()
                Button {
                    if Float(text) ?? 0 != 0 {
                        amountObj.values.append(Float(text)!)
                        text = ""
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
                amountText = amountObj.total() == 0 ? "" : String(format: "%.2f", amountObj.total())
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
        .background(Color("DarkMaterial").cornerRadius(10)
                        .matchedGeometryEffect(id: "background", in: namespace))
        .padding()
        .padding(.bottom, 90)
        .matchedGeometryEffect(id: "whole", in: namespace)
    }
}

struct AmountOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            AmountOverlay(amountObj: AmountObject().placeholder(), show: .constant(true), namespace: Namespace().wrappedValue, amountText: .constant("0.00"))
        }
    }
}
