//
//  BulkCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-11.
//

import SwiftUI

struct BulkCell: View {
    @ObservedObject var amountObj: AmountObject
    var m: Member
    @State var txt = ""
    @State var lastChange = "-1"
    var body: some View {
        HStack {
            b64toimg(b64: m.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .background(Color.white)
                .shadow(radius: 4)
            Text(m.name)
                .foregroundColor(.white)
            Spacer()
            TextField("0.00", text: $txt)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .opacity(0.5)
                .foregroundColor(.primary)
                .frame(maxWidth: 82)
                .onReceive(amountObj.bulkReceipts[m.id].publisher) { _ in
                    let red = amountObj.bulkReceipts[m.id]!.reduce(0, { a, b in
                        a + b.value
                    })
                    
                    if String(format: "%.2f", red) != lastChange {
                        txt = String(format: "%.2f", red)
                        lastChange = String(format: "%.2f", red)
                    }
                }
            Button {
                amountObj.receiptToShow = m.id
                amountObj.showOverlay = true
                amountObj.canCloseOverlay = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    amountObj.canCloseOverlay = true
                }
                lastChange = "-1"
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
            .onAppear {
                if amountObj.bulkValues[m.id] ?? 0 != 0 {
                    txt = String(format: "%.2f", amountObj.bulkValues[m.id]!)
                } else {
                    txt = ""
                }
            }
            .onChange(of: txt, perform: { _ in
                if Float(txt) ?? -1 != -1 {
                    amountObj.bulkValues[m.id] = Float(txt)!
                }
                fixBulkGhosts(amountObj)
            })
            .onChange(of: amountObj.bulkPeople, perform: { _ in
                fixBulkGhosts(amountObj)
            })
        }
        
    }
}

struct BulkCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            PaymentView(house: .constant(.placeholder), payType: .constant(0), tabSelection: .constant(0), pchoice: .constant([.empty]), rchoice: .constant([.empty]))
        }
    }
}

func fixBulkGhosts(_ amountObj: AmountObject) {
    for k in amountObj.bulkValues.keys {
        if !amountObj.bulkPeople.contains(where: { m in
            m.id == k
        }) {
            amountObj.bulkValues.removeValue(forKey: k)
        }
    }
}
