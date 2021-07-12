//
//  FilterButtonItem.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-12.
//

import SwiftUI

struct TrayItem: View {
    @Binding var on: Bool
    var body: some View {
        
        Label(
            title: { Text("Messages")},
            icon: { Image(systemName: on ? "circlebadge.fill" : "circlebadge") }
        )
        .onTapGesture {
            on.toggle()
        }
    }
}

struct FilterButtonItem_Previews: PreviewProvider {
    static var previews: some View {
        TrayItem(on: .constant(true))
    }
}
