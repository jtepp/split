//
//  FloatingButton.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-11.
//

import SwiftUI

struct FloatingMenuButton: View {
    @Binding var open: Bool
    var actions:[Action]
    var body: some View {
        ZStack {
            VStack{
                ForEach(actions){a in
                    
                    HStack {
                        Button{
                            a.action()
                            open = false
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
            .offset(x:-80, y: -CGFloat(20*actions.count + 4) - 60)
//            .opacity(open ? 1 : 0)
            .scaleEffect(open ? 1 : 0)
            .animation(.easeInOut.speed(1.2))
            
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
                            withAnimation(.easeInOut) {
                                open.toggle()
                            }
                        }
                    
                )
        }
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMenuButton(open: .constant(false), actions: Action.placeholders)
    }
}

struct Action: Identifiable {
    let id = UUID()
    var image: String
    var label: String
    var action: () -> Void
    static let placeholders = [Action(image: "plus.bubble", label: "New message") {},
                               Action(image: "arrow.right.circle", label: "New payment") {},
                               Action(image: "arrow.left.circle", label: "New Request") {}]
}
