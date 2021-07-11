//
//  SwiftUIView.swift
//  Element
//
//  Created by Jacob Tepperman on 2021-07-10.
//

import SwiftUI

struct CustomRoundedRect: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}


