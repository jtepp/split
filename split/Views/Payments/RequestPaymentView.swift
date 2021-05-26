//
//  RequestPaymentView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct RequestPaymentView: View {
    @Binding var house: House
    var body: some View {
        Text("To:")
            .font(.title)
            .bold()
            .foregroundColor(.white)
    }
}
