//
//  SignUpFlowViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 28.11.2022.
//

import UIKit

class SignUpFlowViewController: UIViewController {
    @IBAction private func popToLoginViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}
