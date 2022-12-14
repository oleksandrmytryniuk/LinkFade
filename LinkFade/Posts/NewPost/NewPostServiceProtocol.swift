//
//  NewPostServiceProtocol.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 14.12.2022.
//

import Foundation

protocol NewPostServiceProtocol {
    func addListener()
    func removeListener()
    func savePost(text: String, imageData: Data, completion: @escaping (Error?) -> Void)
}
