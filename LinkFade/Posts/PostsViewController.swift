//
//  PostsViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 02.12.2022.
//

import UIKit

final class PostsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addPost))
    }
    
    @objc private func addPost() {
        print("test")
    }
}
