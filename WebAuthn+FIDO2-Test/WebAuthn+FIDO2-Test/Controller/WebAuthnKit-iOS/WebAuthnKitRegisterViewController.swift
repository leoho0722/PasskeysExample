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
        
        webAuthnClient = webAuthnManager.configure(vc: self, origin: "https://zero-trust-test.nutc-imac.com")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func registerBtnClicked(_ sender: UIButton) {
        
        guard let username = usernameTextField.text else { return }
        
        let rp = ("zero-trust-test.nutc-imac.com", "ubuntu")
        
        let user = ("MDEyMzQ1", username, username)
        
        let challenge = "clK6HxNTcNZ3mSnT9a-oyDwCX0SB1xJg6linavsBvUuTDGSqjr-6DiqTaUJMVQhlJ7OPivli8vHuCKLLAHuYRA"
        
        let timeout: UInt64 = 60000
        
        let authSelectionCriteria = AuthenticatorSelectionCriteria(requireResidentKey: true, userVerification: .preferred)
        
        let attestationConveyancePreference: AttestationConveyancePreference = .direct
        
        publicKeyCredentialCreationOptions = webAuthnManager.createPublicKeyCredentialOptions(rpEntity: rp,
                                                                                              userEntity: user,
                                                                                              challenge: challenge,
                                                                                              timeout: timeout,
                                                                                              authenticatorSelection: authSelectionCriteria,
                                                                                              attestation: attestationConveyancePreference)
        
        print(publicKeyCredentialCreationOptions)
        
        UserPreferences.shared.relyPartyId = rp.0
        UserPreferences.shared.relyPartyName = rp.1
        UserPreferences.shared.userId = user.0
        UserPreferences.shared.userDisplayName = user.1
        UserPreferences.shared.userName = user.2
        UserPreferences.shared.challenge = challenge
        
        print("relyPartyId", UserPreferences.shared.relyPartyId)
        print("relyPartyName", UserPreferences.shared.relyPartyName)
        print("userId", UserPreferences.shared.userId)
        print("userDisplayName", UserPreferences.shared.userDisplayName)
        print("userName", UserPreferences.shared.userName)
        print("challenge", UserPreferences.shared.challenge)
        
        firstly {
            self.webAuthnClient!.create(self.publicKeyCredentialCreationOptions)
        }.done { credential in
            #if DEBUG
            print("==========================================")
            print("Credential.id：", credential.id)
            print("Credential.rawId：", Base64.encodeBase64URL(credential.rawId))
            print("Credential.response.clientDataJSON：", Base64.encodeBase64URL(credential.response.clientDataJSON.data(using: .utf8)!))
            print("Credential.response.attestationObject：", Base64.encodeBase64URL(credential.response.attestationObject))
            print("Credential.type：", credential.type)
            print("==========================================")
            #endif
            
            UserPreferences.shared.credentialId = credential.id
        }.catch { error in
            print(error as? WAKError)
        }
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
                                           authenticatorSelection: (results.authenticatorSelection.requireResidentKey,
                                                                    results.authenticatorSelection.userVerification),
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
        var authSelectionCriteria = AuthenticatorSelectionCriteria()
        switch authenticatorSelection.userVerification {
        case "required":
            authSelectionCriteria = AuthenticatorSelectionCriteria(requireResidentKey: authenticatorSelection.requireResidentKey, userVerification: .required)
        case "preferred":
            authSelectionCriteria = AuthenticatorSelectionCriteria(requireResidentKey: authenticatorSelection.requireResidentKey, userVerification: .preferred)
        case "discouraged":
            authSelectionCriteria = AuthenticatorSelectionCriteria(requireResidentKey: authenticatorSelection.requireResidentKey, userVerification: .discouraged)
        default:
            authSelectionCriteria = AuthenticatorSelectionCriteria(requireResidentKey: authenticatorSelection.requireResidentKey, userVerification: .preferred)
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
        
        self.publicKeyCredentialCreationOptions = webAuthnManager.createPublicKeyCredentialOptions(rpEntity: rpEntity,
                                                                                                   userEntity: userEntity,
                                                                                                   challenge: challenge,
                                                                                                   timeout: timeout,
                                                                                                   authenticatorSelection: authSelectionCriteria,
                                                                                                   attestation: attestationConveyancePreference)
        firstly {
            (self.webAuthnClient?.create(self.publicKeyCredentialCreationOptions))!
        }.done { credential in
            
            #if DEBUG
            print(credential)
            #endif
            
            let id = credential.id
            let rawId = Base64.encodeBase64URL(credential.rawId)
            let attestationObject = Base64.encodeBase64URL(credential.response.attestationObject)
            let clientDataJSON = Base64.encodeBase64URL(credential.response.clientDataJSON.data(using: .utf8)!)
            
            let request = VerifyRegistrationRequest(id: id,
                                                    rawId: rawId,
                                                    response: VerifyRegistrationRequest.Response(attestationObject: attestationObject, clientDataJSON: clientDataJSON),
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
