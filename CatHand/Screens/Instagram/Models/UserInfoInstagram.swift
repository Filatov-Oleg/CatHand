//
//  UserInfoInstagram.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 28.11.2023.
//

import Foundation

public struct UserInfoInstagram: Codable {
    var imageData: Data
    var name: String
    var nickName: String
    let aboutMe: String
    let link: String
    let countOfPosts: Int
    let countOfFollowers: String
    let countOfFollowings: String
}
