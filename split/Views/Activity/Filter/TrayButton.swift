//
//  FilterButton.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-12.
//

import SwiftUI

struct TrayButton: View {
    @Binding var open: Bool
    @Binding var incPay: Bool
    @Binding var incReq: Bool
    @Binding var incAn: Bool
    @Binding var incGM: Bool
    var body: some View {
        
        HStack {
            Image("funnel")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.white)
                .frame(width: 18, height: 18, alignment: .center)
                .padding(14)
        }
        .background(
            Capsule()
                .fill(
                    Color.gray.opacity(0.2)
                )
        )
    }
}

struct TrayButton_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            HStack {
                HeaderText(text: "Activity", space: false)
                TrayButton(open: .constant(true), incPay: .constant(true), incReq: .constant(true), incAn: .constant(true), incGM: .constant(true))
                Spacer()
                Button(action: {
                }, label:{
                    Image(systemName: "questionmark")
                        .font(Font.body.bold())
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Circle()
                                .fill(
                                    Color.gray.opacity(0.2)
                                )
                        )
                })
                .padding()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

