//
//  AmountCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import SwiftUI

struct AmountCell: View {
    @ObservedObject var amountObj: AmountObject
    var v: IdentifiableFloat
    var body: some View {
        HStack {
            Button {
                if amountObj.receiptToShow == "" {
                    amountObj.values.insert(v, at: amountObj.values.firstIndex(where: { i in
                        i.id == v.id
                    })!)
                } else {
                    amountObj.bulkReceipts[amountObj.receiptToShow]!.insert(v, at: amountObj.bulkReceipts[amountObj.receiptToShow]!.firstIndex(where: { i in
                        i.id == v.id
                    })!)
                }
            } label: {
                Image(systemName: "plus.circle")
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(v.value, specifier: "%.2f")")
                .font(.system(size: 18))
                .bold()
            Button {
                if amountObj.receiptToShow == "" {
                    amountObj.values.removeAll { i in
                        i.id == v.id
                    }
                } else {
                    amountObj.bulkReceipts[amountObj.receiptToShow]!.removeAll { i in
                        i.id == v.id
                    }
                }
                
            } label: {
                Image(systemName: "trash.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct AmountCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            AmountOverlay(amountObj: AmountObject(Namespace().wrappedValue).placeholder(), amountText: .constant("0.00"))
        }
        
        
    }
}
