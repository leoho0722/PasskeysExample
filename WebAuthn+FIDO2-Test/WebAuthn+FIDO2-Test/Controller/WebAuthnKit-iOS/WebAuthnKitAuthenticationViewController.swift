//
//  WebAuthnKitAuthenticationViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/18.
//

import UIKit
import WebAuthnKit
import PromiseKit

class WebAuthnKitAuthenticationViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var authenticationButton: UIButton!
    
    /// WebAuthnKit
    let webAuthnManager = WebAuthnManager()
    var webAuthnClient: WebAuthnClient?
    var publicKeyCredentialRequestOptions = PublicKeyCredentialRequestOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WebAuthnKit-Authentication"
        
        setupNavigationBarStyle(backgroundColor: .systemCyan)
        authenticationButton.setButtonTitle(title: "Authentication")
        
        webAuthnClient = webAuthnManager.configure(vc: self, origin: "https://zero-trust-test.nutc-imac.com")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func authenticationBtnClicked(_ sender: UIButton) {
        
        let rpId = UserPreferences.shared.relyPartyId
        
        let challenge = UserPreferences.shared.challenge
        
        let credentialId = UserPreferences.shared.credentialId
        
        let transports: [AuthenticatorTransport] = [.internal_]
        
        let userVerification: UserVerificationRequirement = .required
        
        let timeout: UInt64 = 120
        
        publicKeyCredentialRequestOptions = webAuthnManager.getPublicKeyCredentialOptions(rpId: rpId,
                                                                                          challenge: challenge,
                                                                                          credentialId: credentialId,
                                                                                          transports: transports,
                                                                                          userVerification: userVerification,
                                                                                          timeout: timeout)
        print(publicKeyCredentialRequestOptions)
        
        print("rpId", UserPreferences.shared.relyPartyId)
        print("credentialId", UserPreferences.shared.credentialId)
        print("challenge", UserPreferences.shared.challenge)
        
        firstly {
            self.webAuthnClient!.get(self.publicKeyCredentialRequestOptions)
        }.done { assertion in
            #if DEBUG
            print("==========================================")
            print("credentialId: " + assertion.id)
            print("rawId: " + Base64.encodeBase64URL(assertion.rawId))
            print("authenticatorData: " + Base64.encodeBase64URL(assertion.response.authenticatorData))
            print("signature: " + Base64.encodeBase64URL(assertion.response.signature))
            print("userHandle: " + Base64.encodeBase64URL(assertion.response.userHandle!))
            print("clientDataJSON: " + Base64.encodeBase64URL(assertion.response.clientDataJSON.data(using: .utf8)!))
            print("==========================================")
            #endif
        }.catch { error in
            print(error as? WAKError)
        }
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
