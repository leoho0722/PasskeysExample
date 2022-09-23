//
//  RegisterViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/16.
//

import UIKit
import AuthenticationServices
import WebAuthnKit
import LoginSDK

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    /// PassKeys
    let authenticationManager = AuthenticationManager()
    
    var challengeFromAPI: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ASAuthorization-Register"
        
        setupNavigationBarStyle(backgroundColor: .systemGreen)
        registerButton.setButtonTitle(title: "Register")
        
        authenticationManager.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func registerBtnClicked(_ sender: UIButton) {
        
        let request = GenerateRegistrationOptionsRequest()
        
        Task {
            do {
                let results: GenerateRegistrationOptionsResponse = try await NetworkManager.shared.requestData(httpMethod: .get, path: .generateRegistrationOptions, parameters: request)

                challengeFromAPI = results.challenge
                
                #if DEBUG
                print(results.challenge)
                print(challengeFromAPI)
                print(results.challenge.base64URLEncodedToBase64)
                print(results.challenge.base64URLEncodedToBase64.base64Decoded()!)
                #endif
                
                guard let window = self.view.window else {
                    fatalError("The view was not in the app's view hierarchy!")
                }
                guard let username = usernameTextField.text else { return }
                authenticationManager.signUpWith(userName: username, challenge: results.challenge, anchor: window)
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
}

extension RegisterViewController: AuthenticationManagerDelegate {
    
    func signUpWithPassKeys(with credentialRegistratio: ASAuthorizationPlatformPublicKeyCredentialRegistration) {
        
        let attestationObject = credentialRegistratio.rawAttestationObject
        let clientDataJSON = credentialRegistratio.rawClientDataJSON
        let credentialID = credentialRegistratio.credentialID

        #if DEBUG
        print("==============================")
        print("Register-attestationObject：", attestationObject)
        print("Register-clientDataJSON：", clientDataJSON.base64EncodedString())
        print("Register-clientDataJSON：", clientDataJSON.base64EncodedString().base64Decoded()!)
        print("Register-credentialID：", credentialID)
        print("==============================")
        #endif
        
        var temp = clientDataJSON.base64EncodedString().base64Decoded()!.toDictionary()
        print(temp)
        
        temp["challenge"] = challengeFromAPI
        print(temp)
        guard let clientData = temp.toJsonData() else { return }
        
        let request = VerifyRegistrationRequest(id: credentialID.base64urlEncodedString(),
                                                rawId: credentialID.base64urlEncodedString(),
                                                response: VerifyRegistrationRequest.Response(attestationObject: attestationObject!,
                                                                                             clientDataJSON: clientData),
                                                type: "public-key",
                                                clientExtensionResults: VerifyRegistrationRequest.ClientExtensionResults(),
                                                transports: ["internal"])
        
        Task {
            do {
                let results: VerifyRegistrationResponse = try await NetworkManager.shared.requestData(httpMethod: .post, path: .verifyRegistrationResponse, parameters: request)
                print(results)
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
}

