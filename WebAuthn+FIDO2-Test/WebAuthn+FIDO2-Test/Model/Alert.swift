//
//  Alert.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/26.
//

import UIKit

class Alert {
    
    static func showAlertWith(title: String?,
                              message: String?,
                              confirmTitle: String,
                              vc: UIViewController,
                              confirm: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { action in
                confirm?()
            }
            alertController.addAction(confirmAction)
            vc.present(alertController, animated: true)
        }
    }
}
