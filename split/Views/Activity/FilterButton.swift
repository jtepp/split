//
//  FilterButton.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-12.
//

import SwiftUI

struct FilterButton: View {
    @Binding var incPay = true
    @Binding var incReq = true
    @Binding var incAn = true
    @Binding var incGM = true
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton()
    }
}
