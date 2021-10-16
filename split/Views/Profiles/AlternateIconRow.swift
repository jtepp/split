//
//  AlternateIconRow.swift
//  split
//
//  Created by Jacob Tepperman on 2021-06-26.
//

import SwiftUI

struct AlternateIconRow: View {
    var title: String
    var names: [String]
    @Binding var choice: String
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(Font.title2.weight(.semibold))
            ScrollView(.horizontal){
                HStack {
                ForEach(names, id: \.self) { name in
                    AlternateIconButton(choice: $choice, name: name)
                }
                }
                .padding(.vertical, 8)
            }
            .padding(.bottom)
        }
    }
}

struct AlternateIconRow_Previews: PreviewProvider {
    static var previews: some View {
        AlternateIconRow(title: "Default", names: ["Default", "Default-inverse"], choice: .constant("Default-inverse"))
    }
}
