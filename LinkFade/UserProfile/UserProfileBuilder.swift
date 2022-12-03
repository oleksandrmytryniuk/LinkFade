//
//  UserProfileBuilder.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 29.11.2022.
//

import Foundation

final class UserProfileBuilder {
    private let firstName: String
    private let lastName: String
    private var birthday: Date?
    private var gender = UserGender.undefined
    private var userId: String?
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    @discardableResult func birthday(_ birthday: Date) -> Self {
        self.birthday = birthday
        return self
    }
    
    @discardableResult func gender(_ gender: UserGender) -> Self {
        self.gender = gender
        return self
    }
    
    @discardableResult func userId(_ userId: String) -> Self {
        self.userId = userId
        return self
    }
    
    func make() -> UserProfile? {
        guard let birthday, let userId else {
            return nil
        }
        return .init(
            firstName: firstName,
            lastName: lastName,
            birthday: birthday,
            gender: gender,
            userId: userId
        )
    }
}
