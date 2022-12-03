//
//  GenderCell.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 30.11.2022.
//

import UIKit

final class GenderCell: UITableViewCell, Identifiable {
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var selectionIcon: UIImageView!
    
    var title: String? {
        didSet {
            genderLabel.text = title
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionIcon.image = .init(systemName: selected ? "circle.inset.filled" : "circle")
    }
}
