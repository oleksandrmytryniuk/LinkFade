//
//  PostCell.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 13.12.2022.
//

import UIKit

final class PostCell: UITableViewCell, Identifiable {
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var publishingDateLabel: UILabel!
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var deleteButton: UIButton!
    
    var model: PostCellModel? {
        didSet {
            loadUserProfilePhoto()
            userNameLabel.text = model?.userName
            publishingDateLabel.text = formattedDate(model?.publishingDate)
            mainLabel.text = model?.text
            loadPostImage()
            deleteButton.isHidden = model?.deleteButtonIsHidden ?? true
        }
    }
    var deleteAction: (() -> Void)?
    
    private func loadUserProfilePhoto() {
        ImageLoader(imageURL: model?.userPhotoURL).loadImage { [weak self] image in
            self?.photoImageView.image = image
        }
    }
    
    private func formattedDate(_ date: Date?) -> String? {
        guard let date else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func loadPostImage() {
        ImageLoader(imageURL: model?.imageURL).loadImage { [weak self] image in
            self?.mainImageView.image = image
        }
    }
    
    @IBAction private func deletePost() {
        deleteAction?()
    }
}
