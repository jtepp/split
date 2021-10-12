//
//  AmountCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import SwiftUI

struct AmountCell: View {
    @ObservedObject var amountObj: AmountObject
    var v: Float
    var body: some View {
        HStack {
            Button {
                amountObj.values.insert(v, at: amountObj.values.firstIndex(of: v)!)
            } label: {
                Image(systemName: "plus.circle")
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(v, specifier: "%.2f")")
                .font(.system(size: 18))
                .bold()
            Button {
                amountObj.values.remove(at: amountObj.values.firstIndex(of: v)!)
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
            AmountOverlay(amountObj: AmountObject().placeholder(), show: .constant(true), namespace: Namespace().wrappedValue, amountText: .constant("0.00"))
        }
        
        
    }
}
