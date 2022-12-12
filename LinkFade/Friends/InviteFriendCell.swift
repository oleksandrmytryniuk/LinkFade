//
//  SearchResultCell.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 07.12.2022.
//

import UIKit

final class InviteFriendCell: UITableViewCell, Identifiable {
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var inviteButton: UIButton!
    private var inviteButtonAction: (() -> Void)?
    
    func configure(photoURL: URL?, userName: String?, inviteButtonAction: (() -> Void)? = nil) {
        ImageLoader(imageURL: photoURL).loadImage { [weak self] image in
            self?.profileImageView.image = image
        }
        nameLabel.text = userName
        self.inviteButtonAction = inviteButtonAction
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inviteButton.addTarget(self, action: #selector(handleInviteAction), for: .touchUpInside)
    }
    
    @objc private func handleInviteAction() {
        inviteButtonAction?()
    }
}
