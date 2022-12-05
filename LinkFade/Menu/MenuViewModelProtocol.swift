//
//  MenuViewModelProtocol.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 05.12.2022.
//

protocol MenuViewModelProtocol {
    var binding: ((UserData) -> Void)? { get set }
    func addListener()
    func removeListener()
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
}
