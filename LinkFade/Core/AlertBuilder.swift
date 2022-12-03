//
//  AlertBuilder.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 03.12.2022.
//

import UIKit

final class AlertBuilder {
    private var title: String?
    private var message: String?
    private var style = UIAlertController.Style.alert
    private var actions = [UIAlertAction]()
    
    @discardableResult func title(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    @discardableResult func message(_ message: String) -> Self {
        self.message = message
        return self
    }
    
    @discardableResult func style(_ style: UIAlertController.Style) -> Self {
        self.style = style
        return self
    }
    
    @discardableResult func action(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: @escaping (UIAlertAction) -> Void
    ) -> Self {
        actions.append(.init(title: title, style: style, handler: handler))
        return self
    }
    
    func make() -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        return alert
    }
}
