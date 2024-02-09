//
//  InstagramSettingsView.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 27.11.2023.
//

import SwiftUI



struct InstagramSettingsView: View {
    
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
                TextField("Количество подписок", text: $countOfFollowings)
                    .keyboardType(.numberPad)
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

private extension InstagramSettingsView {
    
    func isEmptyFields() -> Bool {
        return self.name.isEmpty ||
               self.nickName.isEmpty ||
               self.countOfFollowers.isEmpty
    }
}
