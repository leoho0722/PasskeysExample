//
//  WebAuthnKitRegisterViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/18.
//

import UIKit
import WebAuthnKit
import PromiseKit

class WebAuthnKitRegisterViewController: BaseViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    /// WebAuthnKit
    let webAuthnManager = WebAuthnManager()
    var webAuthnClient: WebAuthnClient?
    var publicKeyCredentialCreationOptions = PublicKeyCredentialCreationOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WebAuthnKit-Register"
        
        setupNavigationBarStyle(backgroundColor: .systemCyan)
        registerButton.setButtonTitle(title: "Register")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func configureWebAuthn() {
        let userConsentUI = UserConsentUI(viewController: self)
        let authenticator = InternalAuthenticator(ui: userConsentUI)
        self.webAuthnClient = webAuthnManager.createWebAuthnClient(origin: "https://zero-trust-test.nutc-imac.com/", authenticator: authenticator)
    }
    
    @IBAction func registerBtnClicked(_ sender: UIButton) {
        
    }
}

private extension WebAuthnKitRegisterViewController {
    
    // MARK: Step1 POST Username
    
    func postUsername() {
        guard let username = usernameTextField.text else { return }
        let request = UsernameRequest(username: username)
        
        Task {
            do {
                let results: UsernameResponse = try await NetworkManager.shared.requestData(httpMethod: .post, path: .username, parameters: request)
                
                generateRegistrationOptions()
                
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
    
    // MARK: Step2 GET Generate Registration Options
    
    func generateRegistrationOptions() {
        let request = GenerateRegistrationOptionsRequest()
        
        Task {
            do {
                let results: GenerateRegistrationOptionsResponse = try await NetworkManager.shared.requestData(httpMethod: .get, path: .generateRegistrationOptions, parameters: request)
                
                verifyRegistrationResponse(rpEntity: (results.rp.id, results.rp.name),
                                           userEntity: (results.user.id, results.user.displayName, results.user.name),
                                           challenge: results.challenge,
                                           timeout: UInt64(results.timeout),
                                           authenticatorSelection: (results.authenticatorSelection.requireResidentKey, results.authenticatorSelection.userVerification),
                                           attestation: results.attestation)
                
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
    
    // MARK: Step3 POST Verify Registration Response
    
    func verifyRegistrationResponse(rpEntity: (id: String, name: String),
                                    userEntity: (id: String, displayName: String, name: String),
                                    challenge: String,
                                    timeout: UInt64,
                                    authenticatorSelection: (requireResidentKey: Bool, userVerification: String),
                                    attestation: String) {
        let rp = PublicKeyCredentialRpEntity(id: rpEntity.id, name: rpEntity.name)
        
        var authenticatorSelectionCriteria = AuthenticatorSelectionCriteria()
        switch authenticatorSelection.userVerification {
        case "required":
            authenticatorSelectionCriteria = AuthenticatorSelectionCriteria(requireResidentKey: authenticatorSelection.requireResidentKey,
                                                                            userVerification: .required)
        case "preferred":
            authenticatorSelectionCriteria = AuthenticatorSelectionCriteria(requireResidentKey: authenticatorSelection.requireResidentKey,
                                                                            userVerification: .preferred)
        case "discouraged":
            authenticatorSelectionCriteria = AuthenticatorSelectionCriteria(requireResidentKey: authenticatorSelection.requireResidentKey,
                                                                            userVerification: .discouraged)
        default:
            authenticatorSelectionCriteria = AuthenticatorSelectionCriteria(requireResidentKey: authenticatorSelection.requireResidentKey,
                                                                            userVerification: .preferred)
        }
        
        var attestationConveyancePreference: AttestationConveyancePreference = .none
        switch attestation {
        case "none":
            attestationConveyancePreference = .none
        case "direct":
            attestationConveyancePreference = .direct
        case "indirect":
            attestationConveyancePreference = .indirect
        default:
            attestationConveyancePreference = .none
        }
        
        self.publicKeyCredentialCreationOptions = webAuthnManager.createPublicKeyCredentialOptions(rpEntity: rp,
                                                                                                   userEntity: userEntity,
                                                                                                   challenge: challenge,
                                                                                                   timeout: timeout,
                                                                                                   authenticatorSelection: authenticatorSelectionCriteria,
                                                                                                   attestation: attestationConveyancePreference)
        firstly {
            (self.webAuthnClient?.create(self.publicKeyCredentialCreationOptions))!
        }.done { credential in
            print(credential)
            
            let clientDataJSON: [String : String] = [
                "type" : "webauthn.create",
                "challenge" : challenge,
                "origin" : "https://" + rpEntity.id + "/"
            ]
            
            let clientData: Data = try! JSONSerialization.data(withJSONObject: clientDataJSON, options: .prettyPrinted)
            let clientDataToString = String(data: clientData, encoding: .utf8) as! String
            let clientDataToBase64 = try Data(clientDataToString.utf8).base64EncodedString()
            
            let request = VerifyRegistrationRequest(id: userEntity.id,
                                                    rawId: userEntity.id,
                                                    response: VerifyRegistrationRequest.Response(attestationObject: credential.response.attestationObject.toHexString(),
                                                                                                 clientDataJSON: clientDataToBase64),
                                                    type: credential.type.rawValue,
                                                    clientExtensionResults: VerifyRegistrationRequest.ClientExtensionResults(),
                                                    transports: [AuthenticatorTransport.internal_.rawValue])
            print(request)
            
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
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
}
