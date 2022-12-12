//
//  FriendsSearchViewModelProtocol.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 07.12.2022.
//

import Foundation

protocol FriendsSearchViewModelProtocol {
    var reloadAction: (() -> Void)? { get set }
    var searchResultsCount: Int { get }
    func addListener()
    func removeListener()
    func searchBarTextDidChange(_ searchText: String)
    func configureCell(_ cell: InviteFriendCell, forRowAt indexPath: IndexPath)
}
