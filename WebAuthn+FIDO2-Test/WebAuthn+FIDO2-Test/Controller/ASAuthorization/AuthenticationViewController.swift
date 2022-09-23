//
//  AuthenticationViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/16.
//

import UIKit
import AuthenticationServices

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
        
        authenticationManager.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func authenticationBtnClicked(_ sender: UIButton) {
        
    }
}

extension AuthenticationViewController: AuthenticationManagerDelegate {
    
    func signInWithPassKeys(with credentialAssertion: ASAuthorizationPlatformPublicKeyCredentialAssertion) {
        
        let signature = credentialAssertion.signature
        let clientDataJSON = credentialAssertion.rawClientDataJSON
        let userID = credentialAssertion.userID
        
        #if DEBUG
        print("==============================")
        print("Authentication-signature：", signature)
        print("Authentication-signature to String：", String(data: signature!, encoding: .utf8))
        print("Authentication-clientDataJSON：", clientDataJSON)
        print("Authentication-clientDataJSON to String：", String(data: clientDataJSON, encoding: .utf8))
        print("Authentication-userID：", userID)
        print("Authentication-userID to String：", String(data: userID!, encoding: .utf8))
        print("==============================")
        #endif
    }
    
    func signInWithPassword(userName: String, password: String) {
        #if DEBUG
        print("==============================")
        print("Authentication-userName：", userName)
        print("Authentication-password：", password)
        print("==============================")
        #endif
    }
}
