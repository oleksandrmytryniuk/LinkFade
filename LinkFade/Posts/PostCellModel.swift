//
//  PostCellData.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 13.12.2022.
//

import Foundation

struct PostCellModel {
    let userPhotoURL: URL?
    let userName: String
    let publishingDate: Date
    let text: String
    let imageURL: URL?
    let deleteButtonIsHidden: Bool
}
