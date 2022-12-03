//
//  Identifiable.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 30.11.2022.
//

import Foundation

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String { String(describing: Self.self) }
}
