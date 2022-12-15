//
//  FriendsViewModelProtocol.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 15.12.2022.
//

import Foundation

protocol FriendsViewModelProtocol {
    var reloadAction: (() -> Void)? { get set }
    var numberOfSections: Int { get }
    func addListener()
    func removeListener()
    func selectedSegmentIndexDidChange(value: Int)
    func numberOfRowsInSection(_ section: Int) -> Int
    func titleForHeaderInSection(_ section: Int) -> String?
    func configureInviteFriendCell(_ cell: InviteFriendCell, forRowAt indexPath: IndexPath)
}
