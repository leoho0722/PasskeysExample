//
//  Alert.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2022/9/26.
//

import UIKit

@MainActor class Alert {
    
    class func showAlertWith(title: String?,
                             message: String?,
                             vc: UIViewController,
                             confirmTitle: String,
                             confirm: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
                confirm?()
            }
            alertController.addAction(confirmAction)
            vc.present(alertController, animated: true)
        }
    }
}
