//
//  MemberPicker.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct MemberPicker: View {
    @Binding var show: Bool
    @Binding var house: House
    @Binding var choice: [Member]
    var multiple: Bool = false
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                HeaderText(text: "Choose \(multiple ? "members" : "a member")", clear: .constant(false))
                ForEach (house.members.filter({ (m) -> Bool in
                    return m.id != UserDefaults.standard.string(forKey: "myId")
                })) { member in
                    imgButton(show: $show, member: .constant(member), choice: $choice, multiple: multiple)
                }
                Spacer()
                Button(action: {show = false}, label: {
                    HStack {
                        Spacer()
                        Text("Done")
                            .foregroundColor(choice.isEmpty ? .clear : .white)
                        Spacer()
                    }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(choice.isEmpty ? .clear : Color.blue)
                        )
                        .padding()
                })
                .allowsHitTesting(!choice.isEmpty)
            }
        }
    }
}

struct PickerButton: View {
    var text: String
    @Binding var choice: [Member]
    var body: some View {
        if choice.isEmpty {
            Text(text)
                .foregroundColor(.primary)
        } else {
            VStack (alignment: .leading) {
                ForEach(choice) { m in
                    HStack {
                        b64toimg(b64: m.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(radius: 4)
                        Text(m.name)
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
}



struct imgButton: View {
    @Binding var show: Bool
    @Binding var member: Member
    @State var selected: Bool = false
    @Binding var choice: [Member]
    var multiple: Bool
    var body: some View {
        HStack {
            b64toimg(b64: member.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(selected ? Color.blue : Color.clear)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "checkmark")
                                .foregroundColor(selected ? Color.white : Color.clear)
                        )
                )
                .onChange(of: choice.first?.name, perform: { _ in
                    selected = choice.contains(where: { (m) -> Bool in
                        return m.name == member.name
                    })
                })
            Spacer()
            VStack(alignment: .trailing) {
                Text(member.name)
                    .bold()
            }
        }
        .foregroundColor(.primary)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    Color("Material")
                )
        )
        .padding(.horizontal)
        .padding(.top, 10)
        .onTapGesture {
            withAnimation(Animation.easeOut.speed(3)) {
                if selected {
                    selected = false
                    choice.removeAll { (m) -> Bool in
                        m.name == member.name
                    }
                } else {
                    selected = true
                    choice.append(member)
                    if !multiple {
                        choice = [member]
                    }
                }
            }
        }
        .onAppear(){
            selected = choice.contains(where: { (m) -> Bool in
                return m.name == member.name
            })
        }
        
    }
}

//struct MemberPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.black.edgesIgnoringSafeArea(.all)
//            PaymentView(house: .constant(.placeholder), tabSelection: .constant(0))
//        }
//    }
//}
