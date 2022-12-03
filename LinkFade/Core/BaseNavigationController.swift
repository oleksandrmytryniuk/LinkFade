//
//  BaseNavigationController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 03.12.2022.
//

import UIKit

final class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        (viewControllers.first as? SignInViewController)?.viewModel = SignInService()
    }
}
