//
//  splitApp.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-24.
//

import SwiftUI
import Firebase

@main
struct splitApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
       
        WindowGroup {
            Main()
                .preferredColorScheme(.dark)
        }
    }
}
