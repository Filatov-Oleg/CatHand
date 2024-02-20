//
//  InstagramSettingsScreen.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 27.11.2023.
//

import SwiftUI
//
//HStack(alignment: .top) {
//    Text("Имя")
//    VStack {
//        TextField("", text: $name)
//            .textFieldStyle(.plain)
//            .foregroundStyle(Color.blackOrWhite)
//        Rectangle().frame(height: 1)
//            .foregroundStyle(Color.blackOrWhite.opacity(0.25))
//    }
//    .padding(.leading, 16)
//}
//.padding(.horizontal)

struct InstagramSettingsScreen: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var instagramViewModel: InstagramViewModel
    
    @State var name: String = ""
    @State var nickName: String = ""
    @State var aboutMe: String = ""
    @State var link: String = ""
    @State var countOfFollowers = ""
    @State var countOfFollowings = ""
    
    var countOfPosts = Array(0...100)
    @State private var selectedCount = 10
    
    var onSave: (UserInfoInstagram) -> Void
    
    
    var body: some View {
        VStack {
            HStack() {
                Text("Заполните профиль")
                    .font(.headline)
                Spacer()
                Button {
                    let userInfo = UserInfoInstagram(imageData: Data(),
                                                     name: name,
                                                     nickName: nickName,
                                                     aboutMe: aboutMe,
                                                     link: link,
                                                     countOfPosts: selectedCount,
                                                     countOfFollowers: countOfFollowers,
                                                     countOfFollowings: countOfFollowings)
                    
                    onSave(userInfo)
                    UserDefaultsService().needShowInstagramSettings = true
                    dismiss()
                } label: {
                    Text("Сохранить")
                }
                .disabled(isEmptyFields())
                

            }
            .padding([.vertical, .horizontal])
            Form {
                TextField("Имя", text: $name)
                TextField("Имя пользователя", text: $nickName)
                TextField("Количество подписчиков", text: $countOfFollowers)
                    .keyboardType(.numberPad)
                    .onChange(of: countOfFollowers) { newValue in
                        if newValue.count > 5 {
                            self.countOfFollowers = String(newValue.prefix(5))
                        }
                    }
                TextField("Количество подписок", text: $countOfFollowings)
                    .keyboardType(.numberPad)
                    .onChange(of: countOfFollowings) { newValue in
                        if newValue.count > 5 {
                            self.countOfFollowings = String(newValue.prefix(5))
                        }
                    }
                Section("О себе") {
                    TextEditor(text: $aboutMe)
                }
                TextField("Ссылка", text: $link)
            }
        }
        .onAppear {
            name = instagramViewModel.userInfo?.name ?? ""
            nickName = instagramViewModel.userInfo?.nickName ?? ""
            countOfFollowers = instagramViewModel.userInfo?.countOfFollowers ?? ""
            aboutMe = instagramViewModel.userInfo?.aboutMe ?? ""
            link = instagramViewModel.userInfo?.link ?? ""
            selectedCount = instagramViewModel.userInfo?.countOfPosts ?? 0
            countOfFollowers = instagramViewModel.userInfo?.countOfFollowers ?? ""
            countOfFollowings = instagramViewModel.userInfo?.countOfFollowings ?? ""
        }
    }
}

private extension InstagramSettingsScreen {
    
    func isEmptyFields() -> Bool {
        return self.name.isEmpty ||
               self.nickName.isEmpty ||
               self.countOfFollowers.isEmpty
    }
}
