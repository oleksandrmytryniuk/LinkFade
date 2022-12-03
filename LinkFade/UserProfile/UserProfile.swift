//
//  UserProfile.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 01.12.2022.
//

import Foundation

struct UserProfile {
    let firstName: String
    let lastName: String
    let birthday: Date
    let gender: UserGender
    let userId: String
    
    var data: [String: Any] {
        [
            "firstName": firstName,
            "lastName": lastName,
            "birthday": birthday,
            "gender": UserGender.allCases.firstIndex(of: gender) ?? UserGender.allCases.count - 1,
            "userId": userId
        ]
    }
}
