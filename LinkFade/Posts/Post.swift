//
//  Post.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 12.12.2022.
//

import Foundation
import FirebaseFirestore

struct Post: Equatable {
    let text: String
    let imageURL: URL?
    let publishingDate: Date
    let userId: String
    let userPhotoURL: URL?
    let userName: String
    
    var data: [String: Any] {
        var parameters: [String: Any] = [
            "text": text,
            "publishingDate": publishingDate,
            "userId": userId,
            "userName": userName
        ]
        if let urlString = imageURL?.absoluteString {
            parameters["imageURL"] = urlString
        }
        if let urlString = userPhotoURL?.absoluteString {
            parameters["userPhotoURL"] = urlString
        }
        return parameters
    }
    
    init(
        text: String,
        imageURL: URL?,
        publishingDate: Date,
        userId: String,
        userPhotoURL: URL?,
        userName: String
    ) {
        self.text = text
        self.imageURL = imageURL
        self.publishingDate = publishingDate
        self.userId = userId
        self.userPhotoURL = userPhotoURL
        self.userName = userName
    }
    
    init?(data: [String: Any]) {
        guard
            let text = data["text"] as? String,
            let imageURLString = data["imageURL"] as? String,
            let timestamp = data["publishingDate"] as? Timestamp,
            let userId = data["userId"] as? String,
            let userName = data["userName"] as? String
        else {
            return nil
        }
        self.text = text
        self.imageURL = URL(string: imageURLString)
        self.publishingDate = Date(timeIntervalSince1970: Double(timestamp.seconds))
        self.userId = userId
        self.userName = userName
        if let userPhotoURLString = data["userPhotoURL"] as? String {
            self.userPhotoURL = URL(string: userPhotoURLString)
        } else {
            self.userPhotoURL = nil
        }
    }
}
