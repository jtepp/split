//
//  BalanceTileView.swift
//  spllitWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-05.
//

import SwiftUI
import WidgetKit

struct BalanceTileView: View {
    var member: codableMember
    var body: some View {
        Link(destination: URL(string: "widgetlink")!){
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("DarkMaterial"))
                .aspectRatio(1.0, contentMode: .fit)
                .overlay(
                    VStack {
                        b64toimg(b64: member.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color("Material"))
                            )
                            .padding(.top, 6)
                            .padding(.bottom, -6)
                        Text(member.name)
                            .font(.system(size: 8).weight(.bold))
                            .foregroundColor(.white)
                        balWidCalc(member:member)
                            .font(.system(size: 8).weight(.bold))
                            .padding(.horizontal, 10)
                        //                        .minimumScaleFactor(0.3)
                    }
                )
            
        }
        }
    }
    
    struct BalanceTileView_Previews: PreviewProvider {
        static var previews: some View {
            BalanceWidgetView(members: [.placeholder,.placeholder,.placeholder2,.placeholder2], rows: 2, cols: 2)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
    
    func balWidCalc(member: codableMember) -> AnyView {
        let myName = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myName") ?? "0"
        let num = (member.iOwe[myName] ?? 0) - (member.owesMe[myName] ?? 0)
        let str = String(format: "$%.2f", abs(num))
        var col: Color = Color("Material")
        var img = ""
        if num > 0 {
            col = .green
            img = "arrowtriangle.up.fill"
        } else if num < 0 {
            col = .red
            img = "arrowtriangle.down.fill"
        }
        return AnyView(HStack {
            Text(str)
                .lineLimit(1)
        }
        .foregroundColor(col)
        .overlay(
            HStack {
                Image(systemName: img)
                    .prep()
                    .foregroundColor(col)
                Spacer()
            }
            
        )
        )
    }
