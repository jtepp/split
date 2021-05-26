//
//  TimeBar.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct TimeBar: View {
    var unix: Int
    var body: some View {
        HStack {
            Text(unixtotime(unix: unix))
                .font(.callout)
                .bold()
            Spacer()
            Text(unixtodate(unix: unix))
                .font(.callout)
                .bold()
        }
        .foregroundColor(Color.black.opacity(0.4))
    }
}

struct TimeBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityPaymentCell(payment: .constant(.placeholder))
        }
            
    }
}



func unixtodate(unix: Int) -> String {
    let date = Date(timeIntervalSince1970: Double(unix))
    let df = DateFormatter()
    df.dateFormat = "M/dd/yyyy"
    return df.string(from: date)
}

func unixtotime(unix: Int) -> String {
    let date = Date(timeIntervalSince1970: Double(unix))
    let df = DateFormatter()
    df.dateFormat = "hh:mm a"
    return df.string(from: date)
}

