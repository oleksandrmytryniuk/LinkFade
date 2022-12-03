//
//  SignUpServiceProtocol.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 03.12.2022.
//

protocol SignUpServiceProtocol {
    typealias Completion = (Result<Void, Error>) -> Void
    
    func signUp(completion: @escaping Completion)
}
