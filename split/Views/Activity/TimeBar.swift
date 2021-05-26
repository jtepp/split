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
            Spacer()
            Text(unixtodate(unix: unix))
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

