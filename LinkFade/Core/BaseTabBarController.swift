//
//  BaseTabBarController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 05.12.2022.
//

import UIKit

final class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenu()
    }
    
    private func configureMenu() {
        let viewController = viewControllers?.first { $0 is MenuViewController }
        (viewController as? MenuViewController)?.viewModel = MenuViewModel()
    }
}
