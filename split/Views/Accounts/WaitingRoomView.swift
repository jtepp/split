//
//  WaitingRoomView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-27.
//

import SwiftUI

struct WaitingRoomView: View {
    @Binding var show: Bool
    var body: some View {
        VStack{
            Spacer()
            Button(action: {}, label: {
                HStack {
                    Spacer()
                    Text("Join a House")
                        .foregroundColor(.white)
                    Spacer()
                }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                    )
                    .padding()
            })
            .padding()
            
            Button(action: {}, label: {
                HStack {
                    Spacer()
                    Text("Create a House")
                        .foregroundColor(.white)
                    Spacer()
                }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                    )
                    .padding()
            })
            .padding()
            
            Spacer()
        }
    }
}
