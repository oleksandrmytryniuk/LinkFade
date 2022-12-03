//
//  GenderViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 30.11.2022.
//

import UIKit

final class GenderViewController: SignUpFlowViewController {
    private var selectedGender = UserGender.undefined
    
    var userProfileBuilder: UserProfileBuilder?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? EmailViewController {
            target.userProfileBuilder = userProfileBuilder?.gender(selectedGender)
        }
    }
}

// MARK: - UITableViewDataSource

extension GenderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserGender.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = GenderCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let genderCell = cell as? GenderCell else {
            fatalError("Unable to dequeue cell of the required type.")
        }
        genderCell.title = UserGender.allCases[indexPath.item].rawValue
        return genderCell
    }
}

// MARK: - UITableViewDelegate

extension GenderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGender = UserGender.allCases[indexPath.item]
    }
}
