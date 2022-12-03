//
//  SignUpProcessingViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 02.12.2022.
//

import UIKit

final class SignUpProcessingViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var service: SignUpServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        service?.signUp { [weak self] result in
            self?.handleSignUpResult(result)
        }
    }
    
    private func handleSignUpResult(_ result: Result<Void, Error>) {
        activityIndicator.stopAnimating()
        if case .failure(_) = result {
            showSignUpErrorAlert()
            return
        }
        performSegue(withIdentifier: "signUpCompleted", sender: nil)
    }
    
    private func showSignUpErrorAlert() {
        let alert = AlertBuilder()
            .message("Помилка реєстрації")
            .action(title: "ОК") { [weak self] _ in
                self?.dismiss(animated: true)
                self?.navigationController?.popViewController(animated: true)
            }
            .make()
        present(alert, animated: true)
    }
}
