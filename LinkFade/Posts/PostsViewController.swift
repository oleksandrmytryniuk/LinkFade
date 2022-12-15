//
//  PostsViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 02.12.2022.
//

import UIKit

final class PostsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: PostsViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addPost)
        )
        viewModel?.addListener()
    }
    
    @objc private func addPost() {
        performSegue(withIdentifier: "addPost", sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.removeListener()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? NewPostViewController {
            target.service = NewPostService()
        }
    }
    
    @IBAction private func switchValueDidChange(_ sender: UISwitch) {
        viewModel?.showsUserOnly = sender.isOn
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.postsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = PostCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let postCell = cell as? PostCell else {
            fatalError("Unable to dequeue cell of the required type.")
        }
        viewModel?.configureCell(postCell, forRowAt: indexPath)
        return postCell
    }
}

// MARK: - PostsViewModelDelegate

extension PostsViewController: PostsViewModelDelegate {
    func viewModelDidLoadPosts(_ viewModel: PostsViewModelProtocol?) {
        tableView.reloadData()
    }
    
    func viewModel(_ viewModel: PostsViewModelProtocol?, didDeleteRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
