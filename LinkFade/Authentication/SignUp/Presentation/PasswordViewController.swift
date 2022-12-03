//
//  PasswordViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 01.12.2022.
//

import UIKit

final class PasswordViewController: SignUpFlowViewController {
    @IBOutlet private weak var passwordTextField: UITextField!
    
    var userProfileBuilder: UserProfileBuilder?
    var signUpCredentials: SignUpCredentials?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? SignUpViewController {
            target.userProfileBuilder = userProfileBuilder
            target.signUpCredentials = signUpCredentials?.password(passwordTextField.text)
        }
    }
}
