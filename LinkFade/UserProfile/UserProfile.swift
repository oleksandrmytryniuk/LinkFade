//
//  UserProfile.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 01.12.2022.
//

import Foundation
import FirebaseFirestore

final class UserProfile {
    private var photoURLString: String?
    
    let firstName: String
    let lastName: String
    let birthday: Date
    let gender: UserGender
    let userId: String
    var graphNode: Int?
    var friends = [String]()
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var photoURL: URL? {
        if let photoURLString {
            return URL(string: photoURLString)
        }
        return nil
    }
    
    var data: [String: Any] {
        var parameters: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "birthday": birthday,
            "gender": UserGender.allCases.firstIndex(of: gender) ?? UserGender.allCases.count - 1,
            "userId": userId
        ]
        if let graphNode {
            parameters["graphNode"] = graphNode
        }
        return parameters
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
        self.graphNode = data["graphNode"] as? Int
        self.photoURLString = data["photoURL"] as? String
        self.friends = data["friends"] as? [String] ?? []
    }
}
