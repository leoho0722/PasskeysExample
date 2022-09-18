//
//  WebAuthnKitAuthenticationViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/18.
//

import UIKit
import WebAuthnKit

class WebAuthnKitAuthenticationViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var authenticationButton: UIButton!
    
    /// WebAuthnKit
    let webAuthnManager = WebAuthnManager()
    var webAuthnClient: WebAuthnClient?
    var publicKeyCredentialCreationOptions = PublicKeyCredentialCreationOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WebAuthnKit-Authentication"
        
        setupNavigationBarStyle(backgroundColor: .systemCyan)
        authenticationButton.setButtonTitle(title: "Authentication")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func configureWebAuthn() {
        let userConsentUI = UserConsentUI(viewController: self)
        let authenticator = InternalAuthenticator(ui: userConsentUI)
        self.webAuthnClient = webAuthnManager.createWebAuthnClient(origin: "https://zero-trust-test.nutc-imac.com/", authenticator: authenticator)
    }
    
    @IBAction func authenticationBtnClicked(_ sender: UIButton) {
        
    }
}

private extension WebAuthnKitAuthenticationViewController {
    
    // MARK: Step1 POST Username
    
    func postUsername() {
        guard let username = usernameTextField.text else { return }
        let request = UsernameRequest(username: username)
        
        Task {
            do {
                let results: UsernameResponse = try await NetworkManager.shared.requestData(httpMethod: .post, path: .username, parameters: request)
                
                generateAuthenticationOptions()
                
            } catch NetworkConstants.RequestError.invalidRequest {
                print("NetworkConstants.RequestError.invalidRequest")
            } catch NetworkConstants.RequestError.authorizationError {
                print("NetworkConstants.RequestError.authorizationError")
            } catch NetworkConstants.RequestError.notFound {
                print("NetworkConstants.RequestError.notFound")
            } catch NetworkConstants.RequestError.internalError {
                print("NetworkConstants.RequestError.internalError")
            } catch NetworkConstants.RequestError.serverError {
                print("NetworkConstants.RequestError.serverError")
            } catch NetworkConstants.RequestError.serverUnavailable {
                print("NetworkConstants.RequestError.serverUnavailable")
            } catch NetworkConstants.RequestError.unknownError {
                print("NetworkConstants.RequestError.unknownError")
            } catch NetworkConstants.RequestError.jsonDecodeFailed {
                print("NetworkConstants.RequestError.jsonDecodeFailed")
            }
        }
    }
    
    // MARK: Step2 GET Generate Authentication Options
    
    func generateAuthenticationOptions() {
        
    }
    
    // MARK: Step3 POST Verify Authentication Response
    
    func verifyAuthenticationResponse() {
        
    }
}
