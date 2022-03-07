//
//  EditLogView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-12-19.
//

import SwiftUI

struct EditLogView: View {
    var payment: Payment
    var body: some View {
        VStack {
            HStack {
                Text("Edits:")
                    .bold()
                Spacer()
            }
            Rectangle()
                .fill(Color("Material"))
                .frame(height: 2)
                .padding(.top, -4)
            ForEach(Array(payment.editLog.keys), id: \.self) { key in
                if key.isNumeric {
                    EditLogCell(time: key, edit: payment.editLog[key]!)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    Color("DarkMaterial")
                )
        )
    }
}


struct EditLogCell: View {
    var time: String
    var edit: String
    var body: some View {
        HStack {
            
            VStack {
                Text("\(unixtodate(unix: Int(Float(time) ?? 0)))")
                    .font(.caption2)
                    .foregroundColor(.primary)
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                Color("Material")
                            )
                )
                Spacer(minLength: 0)
            }
            Text(edit)
                .font(.subheadline)
            Spacer(minLength: 0)
        }
        .foregroundColor(.white)
    }
}


struct EditLogView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
                   Color.black.edgesIgnoringSafeArea(.all)
                   ActivityEditView(house: .constant(.placeholder), member: .empty, payment: .placeholder, mems: .constant([Member]()), showEdit: .constant(true))
               }
    }
}
