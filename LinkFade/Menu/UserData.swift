//
//  UserData.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 05.12.2022.
//

import UIKit

struct UserData {
    private let photoURL: URL?
    
    let userName: String?
    let email: String?
    
    init(photoURL: URL?, userName: String?, email: String?) {
        self.photoURL = photoURL
        self.userName = userName
        self.email = email
    }
    
    func loadProfileImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let photoURL, let data = try? Data(contentsOf: photoURL) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            }
        }
    }
}
