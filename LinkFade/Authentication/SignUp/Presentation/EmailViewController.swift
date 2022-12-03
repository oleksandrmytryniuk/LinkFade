//
//  EmailViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 30.11.2022.
//

import UIKit

final class EmailViewController: SignUpFlowViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    
    var userProfileBuilder: UserProfileBuilder?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? PasswordViewController {
            target.userProfileBuilder = userProfileBuilder
            target.signUpCredentials = SignUpCredentials(email: emailTextField.text)
        }
    }
}
