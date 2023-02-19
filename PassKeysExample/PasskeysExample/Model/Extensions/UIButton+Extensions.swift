//
//  UIButton+Extensions.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2023/2/19.
//

import UIKit

extension UIButton {
    
    func setButtonTitle(title: String, state: UIControl.State = .normal) {
        self.setTitle(title, for: state)
    }
}
