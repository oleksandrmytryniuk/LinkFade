//
//  SignUpCredentials.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 01.12.2022.
//

final class SignUpCredentials {
    let email: String?
    private(set) var password: String?
    
    init(email: String?) {
        self.email = email
    }
    
    @discardableResult func password(_ password: String?) -> Self {
        self.password = password
        return self
    }
}
