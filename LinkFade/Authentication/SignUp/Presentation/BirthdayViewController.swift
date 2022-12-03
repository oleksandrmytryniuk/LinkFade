//
//  BirthdayViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 29.11.2022.
//

import UIKit

final class BirthdayViewController: SignUpFlowViewController {
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    var userProfileBuilder: UserProfileBuilder?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? GenderViewController {
            target.userProfileBuilder = userProfileBuilder?.birthday(datePicker.date)
        }
    }
}
