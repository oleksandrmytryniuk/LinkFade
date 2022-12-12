//
//  ImageLoader.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 12.12.2022.
//

import UIKit

struct ImageLoader {
    private let imageURL: URL?
    
    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let imageURL, let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            }
        }
    }
}
