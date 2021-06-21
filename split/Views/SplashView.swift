//
//  SplashView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-28.
//

import SwiftUI

struct SplashView: View {
    @Binding var dontSplash: Bool
    @Binding var showSplash: Bool
    @State var showCore = false
    var body: some View {
        VStack {
            HeaderText(text: "What's New")
                .padding(.bottom)
            ScrollView {
                HStack {
                    Spacer()
                    VStack {
                    if showCore {
                        SplashDetailsView(title: "Invite your friends", text: "Long press your group name to copy an invitation on the members page", image: "person.3.fill", color: .blue)
                            .padding(.bottom)
                        SplashDetailsView(title: "Post payments or requests", text: "Post payments to one person or requests from multiple people", image: "dollarsign.square", color: .green)
                            .padding(.bottom)
                        SplashDetailsView(title: "Track who owes who", text: "Check a member's page to see who they owe and who owes them", image: "note.text", color: .yellow)
                            .padding(.bottom)
                    } else {
                        HStack {
                            Text("Show main features")
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(.white)
                        .padding()
                        
                    }
                }
                .animation(Animation.easeIn.speed(2))
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(
                            Color.white.opacity(0.2)
                        )
                )
                .padding(.horizontal)
                .padding(.bottom)
                .onTapGesture {
                    showCore.toggle()
            }
            
                SplashDetailsView(title: "New invite links", text: "Send your friends a link to join your group directly", image: "link.circle", color: .purple)
                    .padding(.bottom)
                SplashDetailsView(title: "Take a shortcut", text: "Long press on the spllit app to use the new quick actions", image: "arrowshape.turn.up.right.fill", color: .red)
                    .padding(.bottom)
            }
            Spacer()
            Text("Disclaimer: This app does not involve any actual money or payments, it is just a way to keep track of payments in your group")
                .font(.footnote)
                .foregroundColor(Color.white.opacity(0.5))
                .padding(.horizontal)
            Button(action: {
                dontSplash = true
                UserDefaults.standard.set(true, forKey: "dontSplash")
                showSplash = false
            }, label: {
                HStack {
                    Spacer()
                    Text("Continue")
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
        }
        .onAppear(){
            UserDefaults.standard.setValue(true, forKey: "1.4")
        }
    }
}

struct SplashDetailsView: View {
    let title: String
    let text: String
    let image: String
    var color: Color = .white
    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(color)
                .padding()
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(Font.headline.bold())
                        .foregroundColor(.white)
                    
                    Text(text)
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.5))
                }
                Spacer()
            }
            .frame(maxWidth: 250)
            
        }
        .lineLimit(2)
        .minimumScaleFactor(0.4)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(dontSplash: .constant(false), showSplash: .constant(false))
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
