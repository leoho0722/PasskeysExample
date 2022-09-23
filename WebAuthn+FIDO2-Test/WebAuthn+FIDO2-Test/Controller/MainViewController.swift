//
//  MainViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/14.
//

import UIKit

class MainViewController: BaseViewController {
    
    /// ASAuthorization
    @IBOutlet weak var asRegisterButton: UIButton!
    @IBOutlet weak var asAuthenticationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        asRegisterButton.setButtonTitle(title: "ASAuthorization-Register")
        asAuthenticationButton.setButtonTitle(title: "ASAuthorization-Authentication")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarStyle(backgroundColor: .systemMint)
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
