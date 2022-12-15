//
//  BaseTabBarController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 05.12.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogo()
        configureHome()
        configureFriends()
        configureMenu()
    }
    
    private func configureLogo() {
        let logo = UILabel()
        logo.text = "LinkFade"
        logo.font = .systemFont(ofSize: 28, weight: .bold)
        logo.textColor = .systemBlue
        navigationItem.leftBarButtonItem = .init(customView: logo)
    }
    
    private func configureHome() {
        let viewController = viewControllers?.first { $0 is PostsViewController }
        (viewController as? PostsViewController)?.viewModel = PostsViewModel()
    }
    
    private func configureFriends() {
        let viewController = viewControllers?.first { $0 is FriendsViewController }
        (viewController as? FriendsViewController)?.viewModel = FriendsViewModel()
    }
    
    private func configureMenu() {
        let viewController = viewControllers?.first { $0 is MenuViewController }
        (viewController as? MenuViewController)?.viewModel = MenuViewModel()
    }
}
