//
//  AuthenticationViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/16.
//

import UIKit

class AuthenticationViewController: BaseViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var authenticationButton: UIButton!
    
    /// PassKeys
    let authenticationManager = AuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ASAuthorization-Authentication"
        
        setupNavigationBarStyle(backgroundColor: .systemGreen)
        authenticationButton.setButtonTitle(title: "Authentication")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func authenticationBtnClicked(_ sender: UIButton) {
        
    }
}
