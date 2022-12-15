//
//  FriendsViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 05.12.2022.
//

import UIKit

final class FriendsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: FriendsViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.reloadAction = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(navigateToFriendsSearch)
        )
        viewModel?.addListener()
    }
    
    @objc private func navigateToFriendsSearch() {
//        performSegue(withIdentifier: "searchFriends", sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.removeListener()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? FriendsSearchViewController {
            target.viewModel = FriendsSearchViewModel()
        }
    }
    
    @IBAction private func segmentedControlValueDidChange(_ sender: UISegmentedControl) {
        viewModel?.selectedSegmentIndexDidChange(value: sender.selectedSegmentIndex)
    }
}

// MARK: - UITableViewDataSource

extension FriendsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSections ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return .init()
        }
        let identifier = InviteFriendCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let inviteFriendCell = cell as? InviteFriendCell else {
            fatalError("Unable to dequeue cell of the required type.")
        }
        viewModel?.configureInviteFriendCell(inviteFriendCell, forRowAt: indexPath)
        return inviteFriendCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel?.titleForHeaderInSection(section)
    }
}
