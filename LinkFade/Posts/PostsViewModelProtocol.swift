//
//  PostsViewModelProtocol.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 13.12.2022.
//

import Foundation

protocol PostsViewModelProtocol {
    var showsUserOnly: Bool { get set }
    var delegate: PostsViewModelDelegate? { get set }
    var postsCount: Int { get }
    func addListener()
    func removeListener()
    func configureCell(_ cell: PostCell, forRowAt indexPath: IndexPath)
}

protocol PostsViewModelDelegate: AnyObject {
    func viewModelDidLoadPosts(_ viewModel: PostsViewModelProtocol?)
    func viewModel(_ viewModel: PostsViewModelProtocol?, didDeleteRowAt indexPath: IndexPath)
}
