//
//  SignUpViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 01.12.2022.
//

import UIKit

final class SignUpViewController: SignUpFlowViewController {
    var userProfileBuilder: UserProfileBuilder?
    var signUpCredentials: SignUpCredentials?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? SignUpProcessingViewController {
            target.service = SignUpService(
                profileBuilder: userProfileBuilder,
                credentials: signUpCredentials
            )
        }
    }
}
