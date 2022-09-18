//
//  RegisterViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/16.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    /// PassKeys
    let authenticationManager = AuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ASAuthorization-Register"
        
        setupNavigationBarStyle(backgroundColor: .systemGreen)
        registerButton.setButtonTitle(title: "Register")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func registerBtnClicked(_ sender: UIButton) {
        guard let window = self.view.window else {
            fatalError("The view was not in the app's view hierarchy!")
        }
        guard let username = usernameTextField.text else { return }
        authenticationManager.signUpWith(userName: username, anchor: window)
    }
}
