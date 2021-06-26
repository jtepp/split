//
//  AlternateIconRow.swift
//  split
//
//  Created by Jacob Tepperman on 2021-06-26.
//

import SwiftUI

struct AlternateIconRow: View {
    @Binding var choice: String
    var names: [String]
    var body: some View {
        HStack{
            ForEach(names, id: \.self) { name in
                AlternateIconButton(choice: $choice, name: name)
            }
        }
        .padding(.bottom)
    }
}

struct AlternateIconRow_Previews: PreviewProvider {
    static var previews: some View {
        AlternateIconRow(choice: .constant("Default-inverse"), names: ["Default", "Default-inverse"])
    }
}
