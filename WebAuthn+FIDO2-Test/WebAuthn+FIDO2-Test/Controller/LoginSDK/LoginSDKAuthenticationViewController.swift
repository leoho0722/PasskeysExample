//
//  LoginSDKAuthenticationViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/18.
//

import UIKit

class LoginSDKAuthenticationViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var authenticationButton: UIButton!
    
    /// LoginSDK
    let loginManager = LoginManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "LoginSDK-Authentication"
        setupNavigationBarStyle(backgroundColor: .systemBlue)
        authenticationButton.setButtonTitle(title: "Authentication")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func authenticationBtnClicked(_ sender: UIButton) {
        guard let username = usernameTextField.text else { return }
        loginManager.authenticateWithFIDO2(username: username) { authenticateResults in
            switch authenticateResults {
            case .success(let success):
                print("Authenticate Success：", success.success)
                print("Authenticate Success：", success.jwt)
            case .failure(let failure):
                print("Authenticate Failure：", failure)
            }
        }
    }

}
