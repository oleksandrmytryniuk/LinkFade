//
//  FriendRequest.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 06.12.2022.
//

struct FriendRequest {
    let sender: String
    let receiver: String
    
    var data: [String: Any] {
        [
            "sender": sender,
            "receiver": receiver
        ]
    }
    
    init(sender: String, receiver: String) {
        self.sender = sender
        self.receiver = receiver
    }
    
    init?(data: [String: Any]) {
        guard
            let sender = data["sender"] as? String,
            let receiver = data["receiver"] as? String
        else {
            return nil
        }
        self.sender = sender
        self.receiver = receiver
    }
}
