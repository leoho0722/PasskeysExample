//
//  UIApplication+Extensions.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2023/2/19.
//

import UIKit

extension UIApplication {
    
    /// Top visible viewcontroller
    var topMostVisibleViewController: UIViewController? {
        guard let navigationController = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController as? UINavigationController else {
            return nil
        }
        return navigationController.visibleViewController
    }
}
