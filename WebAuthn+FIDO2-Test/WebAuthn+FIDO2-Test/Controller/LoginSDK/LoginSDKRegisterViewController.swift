//
//  LoginSDKRegisterViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/18.
//

import UIKit

class LoginSDKRegisterViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    /// LoginSDK
    let loginManager = LoginManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "LoginSDK-Register"
        
        setupNavigationBarStyle(backgroundColor: .systemBlue)
        registerButton.setButtonTitle(title: "Register")
        
        loginManager.authToken = UUID().uuidString
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func registerBtnClicked(_ sender: UIButton) {
        guard let username = usernameTextField.text else { return }
        loginManager.signUpWithFIDO2(username: username) { registerResults in
            switch registerResults {
            case .success(let success):
                print("Register Success：", success.success)
                print("Register Success：", success.jwt)
            case .failure(let failure):
                print("Register Failure：", failure)
            }
        }
    }

}
