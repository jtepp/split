//
//  FilterButtonItem.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-12.
//

import SwiftUI

struct TrayItem: View {
    @Binding var on: Bool
    var img: String = "arrow.right.circle"
    var body: some View {
        Button {
            on.toggle()
            
        }
            label: {
        HStack {
            Image(systemName: img)
                .foregroundColor(.white)
            VerticalToggle(on: $on)
                .frame(width: 10, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
            }
    }
}

struct FilterButtonItem_Previews: PreviewProvider {
    static var previews: some View {
        TBC()
    }
}
