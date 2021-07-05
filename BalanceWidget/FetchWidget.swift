//
//  FetchWidget.swift
//  BalanceWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class FetchWidget: ObservableObject {
    private var db = Firestore.firestore()
    
    func updateMembers(members: Binding<[Member]>, myId: String, houseId: String){
        
    }

}
