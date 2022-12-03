//
//  SignInViewModelProtocol.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 03.12.2022.
//

import FirebaseAuth

protocol SignInServiceProtocol {
    func addListener(completion: @escaping (Auth, User?) -> Void)
    func removeListener()
    func signIn(
        email: String,
        password: String,
        completion: @escaping (AuthDataResult?, Error?) -> Void
    )
}
