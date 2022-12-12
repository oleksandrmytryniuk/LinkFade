//
//  FriendsSearchViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 06.12.2022.
//

import UIKit

final class FriendsSearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: FriendsSearchViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.reloadAction = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.addListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.removeListener()
    }
}

// MARK: - UISearchBarDelegate

extension FriendsSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchBarTextDidChange(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource

extension FriendsSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.searchResultsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = InviteFriendCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let searchResultCell = cell as? InviteFriendCell else {
            fatalError("Unable to dequeue cell of the required type.")
        }
        viewModel?.configureCell(searchResultCell, forRowAt: indexPath)
        return searchResultCell
    }
}
