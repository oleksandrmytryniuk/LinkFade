//
//  SignInViewModel.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 03.12.2022.
//

import FirebaseAuth

final class SignInService: SignInServiceProtocol {
    private var listener: AuthStateDidChangeListenerHandle?
    
    func addListener(completion: @escaping (Auth, User?) -> Void) {
        listener = Auth.auth().addStateDidChangeListener { auth, user in
            completion(auth, user)
        }
    }
    
    func removeListener() {
        if let listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    func signIn(
        email: String,
        password: String,
        completion: @escaping (AuthDataResult?, Error?) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}
