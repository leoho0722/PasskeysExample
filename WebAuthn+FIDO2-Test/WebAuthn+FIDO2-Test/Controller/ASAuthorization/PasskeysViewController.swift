//
//  PasskeysViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/26.
//

import UIKit
import AuthenticationServices
import WebAuthnKit
import LoginSDK

class PasskeysViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var opModeSegmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var opModeButton: UIButton!
    
    // MARK: - Variables
    
    var selectedIndex: Int = 0 // 判斷現在是 Registration 還是 Authentication
    
    /// PassKeys
    let passkeysManager = PasskeysManager()
    var challengeFromRegistration: String = ""
    var challengeFromAuthentication: String = ""
    var allowCredentials: [VerifyAuthenticationRequest.AllowCredentials] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        passkeysManager.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        
        /// NavigationBar
        self.title = "PassKeys Demo"
        setupNavigationBarStyle(backgroundColor: .purple)
        
        /// UISegmentControl
        setupSegmentControl()
        
        /// UITextField
        setupTextField()
        
        /// UIButton
        setupButton()
    }
    
    private func setupSegmentControl() {
        opModeSegmentControl.setTitle("Registration", forSegmentAt: 0)
        opModeSegmentControl.setTitle("Authentication", forSegmentAt: 1)
    }
    
    private func setupTextField() {
        usernameTextField.placeholder = "Username"
    }
    
    private func setupButton() {
        switch selectedIndex {
        case 0:
            opModeButton.setButtonTitle(title: "Registration")
        case 1:
            opModeButton.setButtonTitle(title: "Authentication")
        default:
            break
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func opModeSegmentControlChange(_ sender: UISegmentedControl) {
        selectedIndex = (sender.selectedSegmentIndex == 0) ? 0 : 1
        setupButton()
    }
    
    @IBAction func opModeBtnClicked(_ sender: UIButton) {
        switch selectedIndex {
        // MARK: - Registration
        case 0:
            let request = GenerateRegistrationOptionsRequest()
            
            Task {
                do {
                    let results: GenerateRegistrationOptionsResponse = try await NetworkManager.shared.requestData(httpMethod: .get,
                                                                                                                   path: .generateRegistrationOptions,
                                                                                                                   parameters: request)
                    
                    challengeFromRegistration = results.challenge
                    
                    #if DEBUG
                    print(results.challenge)
                    print(challengeFromRegistration)
                    print(results.challenge.base64URLEncodedToBase64)
                    print(results.challenge.base64URLEncodedToBase64.base64Decoded()!)
                    #endif
                    
                    guard let window = self.view.window else {
                        fatalError("The view was not in the app's view hierarchy!")
                    }
                    
                    guard let username = usernameTextField.text else { return }
                    
                    passkeysManager.signUpWith(userName: username,
                                               challenge: results.challenge,
                                               anchor: window)
                    
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
        // MARK: - Authentication
        case 1:
            let request = GenerateAuthenticationOptionsRequest()
            
            Task {
                do {
                    let results: GenerateAuthenticationOptionsResponse = try await NetworkManager.shared.requestData(httpMethod: .get,
                                                                                                                     path: .generateAuthenticationOptions,
                                                                                                                     parameters: request)
                    
                    challengeFromAuthentication = results.challenge
                    
                    for i in 0 ..< results.allowCredentials.count {
                        allowCredentials.append(VerifyAuthenticationRequest.AllowCredentials(type: results.allowCredentials[i].type,
                                                                                             id: results.allowCredentials[i].id,
                                                                                             transports: results.allowCredentials[i].transports))
                    }
                    
                    #if DEBUG
                    print(results.challenge)
                    print(challengeFromAuthentication)
                    print(results.challenge.base64URLEncodedToBase64)
                    print(results.challenge.base64URLEncodedToBase64.base64Decoded()!)
                    #endif
                    
                    guard let window = self.view.window else {
                        fatalError("The view was not in the app's view hierarchy!")
                    }
                    
                    passkeysManager.signInWith(challenge: results.challenge,
                                               anchor: window,
                                               preferImmediatelyAvailableCredentials: true)
                    
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
        default:
            break
        }
    }
}

// MARK: - PasskeysManagerDelegate

extension PasskeysViewController: PasskeysManagerDelegate {

    func signUpWithPassKeys(with credentialRegistration: ASAuthorizationPlatformPublicKeyCredentialRegistration) {
        
        let attestationObject = credentialRegistration.rawAttestationObject
        let clientDataJSON = credentialRegistration.rawClientDataJSON
        let credentialID = credentialRegistration.credentialID
        
        #if DEBUG
        print("==============================")
        print("Register-attestationObject：", attestationObject)
        print("Register-clientDataJSON：", clientDataJSON.base64EncodedString())
        print("Register-clientDataJSON：", clientDataJSON.base64EncodedString().base64Decoded()!)
        print("Register-credentialID：", credentialID)
        print("==============================")
        #endif
        
        var temp = clientDataJSON.base64EncodedString().base64Decoded()!.toDictionary()
        #if DEBUG
        print(temp)
        #endif
        
        temp["challenge"] = challengeFromRegistration
        #if DEBUG
        print(temp)
        #endif
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
                let results: VerifyRegistrationResponse = try await NetworkManager.shared.requestData(httpMethod: .post,
                                                                                                      path: .verifyRegistrationResponse,
                                                                                                      parameters: request)
                print(results)
                if results.verified {
                    Alert.showAlertWith(title: "Registration Results",
                                        message: "username：\(results.username)",
                                        confirmTitle: "Close",
                                        vc: self,
                                        confirm: nil)
                } else {
                    Alert.showAlertWith(title: "Registration Results",
                                        message: "msg：\(results.msg)\nstatus：\(results.status)",
                                        confirmTitle: "Close",
                                        vc: self,
                                        confirm: nil)
                }
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

    func signInWithPassKeys(with credentialAssertion: ASAuthorizationPlatformPublicKeyCredentialAssertion) {
        
        let signature = credentialAssertion.signature
        let clientDataJSON = credentialAssertion.rawClientDataJSON
        let userID = credentialAssertion.userID
        let authenticatorData = credentialAssertion.rawAuthenticatorData
        
        #if DEBUG
        print("==============================")
        print("Authentication-signature：", signature)
        print("Authentication-authenticatorData：", authenticatorData)
        print("Authentication-clientDataJSON：", clientDataJSON)
        print("Authentication-clientDataJSON：", clientDataJSON.base64EncodedString())
        print("Authentication-clientDataJSON：", clientDataJSON.base64EncodedString().base64Decoded()!)
        print("allowCredentials：", allowCredentials)
        print("==============================")
        #endif

        let request = VerifyAuthenticationRequest(id: allowCredentials.last!.id,
                                                  rawId: allowCredentials.last!.id,
                                                  response: VerifyAuthenticationRequest.Response(authenticatorData: authenticatorData!,
                                                                                                 clientDataJSON: clientDataJSON,
                                                                                                 signature: signature!,
                                                                                                 userHandle: userID!),
                                                  type: "public-key",
                                                  clientExtensionResults: VerifyAuthenticationRequest.ClientExtensionResults())
        
        Task {
            do {
                let results: VerifyAuthenticationResponse = try await NetworkManager.shared.requestData(httpMethod: .post,
                                                                                                        path: .verifyAuthenticationResponse,
                                                                                                        parameters: request)
                print(results)
                if results.verified {
                    Alert.showAlertWith(title: "Authentication Results",
                                        message: "Succeed！",
                                        confirmTitle: "Close",
                                        vc: self,
                                        confirm: nil)
                } else {
                    Alert.showAlertWith(title: "Authentication Results",
                                        message: "msg：\(results.msg)\nstatus：\(results.status)",
                                        confirmTitle: "Close",
                                        vc: self,
                                        confirm: nil)
                }
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
