//
//  LoginViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 26.11.2022.
//

import UIKit
import FirebaseAuth

final class SignInViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    var service: SignInServiceProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        service?.addListener { [weak self] auth, user in
            if user != nil {
                self?.performSegue(withIdentifier: "signInCompleted", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
        service?.removeListener()
    }
    
    @IBAction private func signIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        service?.signIn(email: email, password: password) { [weak self] result, error in
            if error != nil {
                self?.showSignInErrorAlert()
            }
        }
    }
    
    private func showSignInErrorAlert() {
        let alert = AlertBuilder()
            .message("Помилка автентифікації")
            .action(title: "ОК") { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .make()
        present(alert, animated: true)
    }
}
