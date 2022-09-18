//
//  MainViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/14.
//

import UIKit

class MainViewController: BaseViewController {

    /// LoginSDK
    @IBOutlet weak var loginSDKRegisterButton: UIButton!
    @IBOutlet weak var loginSDKAuthenticationButton: UIButton!
    
    /// WebAuthnKit
    @IBOutlet weak var webAuthnKitRegisterButton: UIButton!
    @IBOutlet weak var webAuthnKitAuthenticationButton: UIButton!
    
    /// ASAuthorization
    @IBOutlet weak var asRegisterButton: UIButton!
    @IBOutlet weak var asAuthenticationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginSDKRegisterButton.setButtonTitle(title: "LoginSDK-Register")
        loginSDKAuthenticationButton.setButtonTitle(title: "LoginSDK-Authentication")
        
        webAuthnKitRegisterButton.setButtonTitle(title: "WebAuthnKit-Register")
        webAuthnKitAuthenticationButton.setButtonTitle(title: "WebAuthnKit-Authentication")
        
        asRegisterButton.setButtonTitle(title: "ASAuthorization-Register")
        asAuthenticationButton.setButtonTitle(title: "ASAuthorization-Authentication")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarStyle(backgroundColor: .systemMint)
    }

    @IBAction func loginSDKRegisterBtnClicked(_ sender: UIButton) {
        let nextVC = LoginSDKRegisterViewController()
        pushViewController(nextVC)
    }
    
    @IBAction func loginSDKAuthenticationBtnClicked(_ sender: UIButton) {
        let nextVC = LoginSDKAuthenticationViewController()
        pushViewController(nextVC)
    }
    
    @IBAction func webAuthnKitRegisterBtnClicked(_ sender: UIButton) {
        let nextVC = WebAuthnKitRegisterViewController()
        pushViewController(nextVC)
    }
    
    @IBAction func webAuthnKitAuthenticationBtnClicked(_ sender: UIButton) {
        let nextVC = WebAuthnKitAuthenticationViewController()
        pushViewController(nextVC)
    }
    
    @IBAction func asRegisterBtnClicked(_ sender: UIButton) {
        let nextVC = RegisterViewController()
        pushViewController(nextVC)
    }
    
    @IBAction func asAuthenticationBtnClicked(_ sender: UIButton) {
        let nextVC = AuthenticationViewController()
        pushViewController(nextVC)
    }
}
