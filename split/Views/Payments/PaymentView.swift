//
//  PaymentView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct PaymentView: View {
    @Environment(\.scenePhase) var scenePhase
    @Binding var house: House
    @State var typeSelection = 0
    @Binding var tabSelection: Int
    @Binding var pchoice: [Member]
    @Binding var rchoice: [Member]
    var body: some View {
        ScrollView {
            HeaderText(text: typeSelection == 1 ? "Request" : "Payment")
            Picker(selection: $typeSelection, label: Text("Picker"), content: {
                Text("Payment").tag(0)
                Text("Request").tag(1)
            })
            .pickerStyle(SegmentedPickerStyle())
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        Color("DarkMaterial")
                    )
            )
            .padding()
            .onTapGesture {
                if UIApplication.shared.isKeyboardPresented {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                if typeSelection == 0 {
                    typeSelection = 1
                } else {
                    typeSelection = 0
                }
            }
            
            if typeSelection == 0 {
                PaymentPaymentView(house: $house, choice: $pchoice, tabSelection: $tabSelection)
            } else {
                RequestPaymentView(house: $house, choice: $rchoice, tabSelection: $tabSelection)
            }
            Rectangle()
                .fill(Color.black)
                .frame(minHeight:120)
        }.onTapGesture {
            if UIApplication.shared.isKeyboardPresented {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        .onChange(of: scenePhase){ newPhase in
            if newPhase == .active {
                guard let name = shortcutItemToProcess?.localizedTitle as? String else {
                    print("else")
                    return
                }
                switch name {
                case "Send payment":
                    typeSelection = 0
                case "Send request":
                    typeSelection = 1
                default:
                    tabSelection = 0
                }
            }
        }
        
    }
}


struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            PaymentView(house: .constant(.placeholder), tabSelection: .constant(0), pchoice: .constant([.empty]), rchoice: .constant([.empty]))
        }
    }
}

extension UIApplication {
    /// Checks if view hierarchy of application contains `UIRemoteKeyboardWindow` if it does, keyboard is presented
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"),
           self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}
