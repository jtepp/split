//
//  FloatingButton.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-11.
//

import SwiftUI

struct FloatingButton: View {
    @State var open = false
    var body: some View {
        Circle()
            .fill(Color("DarkMaterial"))
            .shadow(radius: 10)
            .frame(width: 70, height: 70)
            .overlay(
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: open ? 225 : 0))
                    .onTapGesture {
                        withAnimation(.easeOut) {
                            open.toggle()
                        }
                    }
            
            )
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton()
    }
}
