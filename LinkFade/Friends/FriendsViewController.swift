//
//  FriendsViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 05.12.2022.
//

import UIKit

final class FriendsViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.rightBarButtonItem = makeRightBarItem()
    }
    
    private func makeRightBarItem() -> UIBarButtonItem {
        .init(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(navigateToFriendsSearch)
        )
    }
    
    @objc private func navigateToFriendsSearch() {
        performSegue(withIdentifier: "searchFriends", sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? FriendsSearchViewController {
            target.viewModel = FriendsSearchViewModel()
        }
    }
}
