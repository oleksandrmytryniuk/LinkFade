//
//  UserProfile.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 01.12.2022.
//

import Foundation
import FirebaseFirestore

struct UserProfile {
    let firstName: String
    let lastName: String
    let birthday: Date
    let gender: UserGender
    let userId: String
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var data: [String: Any] {
        [
            "firstName": firstName,
            "lastName": lastName,
            "birthday": birthday,
            "gender": UserGender.allCases.firstIndex(of: gender) ?? UserGender.allCases.count - 1,
            "userId": userId
        ]
    }
    
    init(firstName: String, lastName: String, birthday: Date, gender: UserGender, userId: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.gender = gender
        self.userId = userId
    }
    
    init?(data: [String: Any]) {
        guard
            let firstName = data["firstName"] as? String,
            let lastName = data["lastName"] as? String,
            let birthdayTimestamp = data["birthday"] as? Timestamp,
            let genderIndex = data["gender"] as? Int,
            let userId = data["userId"] as? String
        else {
            return nil
        }
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = Date(timeIntervalSince1970: Double(birthdayTimestamp.seconds))
        self.gender = UserGender.allCases[genderIndex]
        self.userId = userId
    }
}
