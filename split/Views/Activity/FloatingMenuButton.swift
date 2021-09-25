//
//  FloatingButton.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-11.
//

import SwiftUI

struct FloatingMenuButton: View{
    @Binding var open: Bool
    var above: Bool
    var radius: CGFloat
    var rotate: Bool = false
    var actions:[Action]
    var image: String
    var scale: CGFloat = 1
    var body: some View {
        ZStack {
            VStack{
                ForEach(actions){a in
                    
                    HStack {
                        Button{
                            a.action()
                        }
                        label: {
                            Text(a.label)
                                .font(.body)
                            Spacer()
                            Image(systemName: a.image)
                                .font(.body.bold())
                        }
                        
                        .foregroundColor(.white)
                        .allowsHitTesting(open)
                    }
                    .frame(height: 20)
                    if a.id != actions[actions.count - 1].id {
                        Rectangle()
                            .frame(height:2)
                            .foregroundColor(Color("Material"))
                    }
                    
                    
                }
                
            }
            .frame(width: 200)
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color("DarkMaterial")))
            .shadow(radius: 10)
            .offset(x:-2 * radius - 10, y: (above ? -1 : 1) * (CGFloat(20*actions.count + 4) + 25 + radius))
            //            .opacity(open ? 1 : 0)
            .scaleEffect(open ? 1 : 0)
            .animation(.easeInOut.speed(1.2))
            
            Circle()
                .fill(Color("DarkMaterial"))
                .shadow(radius: 10)
                .frame(width: 2*radius, height: 2*radius)
                .overlay(
                    //                    Image(systemName: "plus")
                    //                        .resizable()
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale)
                        .padding()
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: (open && rotate) ? 135 : 0))
                    
                )
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        open.toggle()
                    }
                }
        }
        
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMenuButton(open: .constant(false), above: true, radius: 35, rotate: true, actions: Action.placeholders, image: "plus")
    }
}

struct Action: Identifiable {
    let id = UUID()
    var image: String
    var label: String
    var action: () -> Void
    static let placeholders = [Action(image: "plus.bubble", label: "New message") {},
                               Action(image: "arrow.right.circle", label: "New payment") {},
                               Action(image: "arrow.left.circle", label: "New request") {}]
}
