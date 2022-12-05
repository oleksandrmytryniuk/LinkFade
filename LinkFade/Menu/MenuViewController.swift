//
//  MenuViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 05.12.2022.
//

import UIKit

final class MenuViewController: UIViewController {
    @IBOutlet private weak var profilePhotoImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    var viewModel: MenuViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.binding = { [weak self] userData in
            userData.loadProfileImage { image in
                self?.profilePhotoImageView.image = image
            }
            self?.userNameLabel.text = userData.userName
            self?.emailLabel.text = userData.email
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.addListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.removeListener()
    }
    
    @IBAction private func signOut() {
        viewModel?.signOut { [weak self] result in
            if case .failure(_) = result {
                self?.showAuthorizationErrorAlert()
                return
            }
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func showAuthorizationErrorAlert() {
        let alert = AlertBuilder()
            .message("Помилка авторизації")
            .action(title: "ОК") { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .make()
        present(alert, animated: true)
    }
}
