//
//  FullNameViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 29.11.2022.
//

import UIKit

final class FullNameViewController: SignUpFlowViewController {
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text else {
            return
        }
        if let target = segue.destination as? BirthdayViewController {
            target.userProfileBuilder = .init(firstName: firstName, lastName: lastName)
        }
    }
}
