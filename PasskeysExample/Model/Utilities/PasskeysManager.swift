//
//  PasskeysManager.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2022/9/14.
//

import AuthenticationServices
import Foundation
import os

class PasskeysManager: NSObject {
    
    let domain = "zero-trust-test.nutc-imac.com"
    
    var authenticationAnchor: ASPresentationAnchor?
        
    weak var delegate: PasskeysManagerDelegate?
    
    // MARK: PassKeys signUp
    
    func signUpWith(userName: String,
                    challenge: String,
                    anchor: ASPresentationAnchor) {
        
        self.authenticationAnchor = anchor
        
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: domain)

        // Fetch the challenge from the server. The challenge needs to be unique for each request.
        // The userID is the identifier for the user's account.
        let challenge = Data(challenge.utf8)
        let userID = Data(UUID().uuidString.utf8)

        let registrationRequest = publicKeyCredentialProvider.createCredentialRegistrationRequest(challenge: challenge,
                                                                                                  name: userName,
                                                                                                  userID: userID)

        // Use only ASAuthorizationPlatformPublicKeyCredentialRegistrationRequests or
        // ASAuthorizationSecurityKeyPublicKeyCredentialRegistrationRequests here.
        let authController = ASAuthorizationController(authorizationRequests: [registrationRequest])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
    
    // MARK: PassKeys signIn
    
    func signInWith(challenge: String,
                    anchor: ASPresentationAnchor,
                    preferImmediatelyAvailableCredentials: Bool) {
        
        self.authenticationAnchor = anchor
        
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: domain)

        // Fetch the challenge from the server. The challenge needs to be unique for each request.
        let challenge = challenge.data(using: .utf8)!

        let assertionRequest = publicKeyCredentialProvider.createCredentialAssertionRequest(challenge: challenge)

        // Also allow the user to use a saved password, if they have one.
        let passwordCredentialProvider = ASAuthorizationPasswordProvider()
        let passwordRequest = passwordCredentialProvider.createRequest()

        // Pass in any mix of supported sign-in request types.
        let authController = ASAuthorizationController(authorizationRequests: [assertionRequest, passwordRequest])
        authController.delegate = self
        authController.presentationContextProvider = self

        if preferImmediatelyAvailableCredentials {
            // If credentials are available, presents a modal sign-in sheet.
            // If there are no locally saved credentials, no UI appears and
            // the system passes ASAuthorizationError.Code.canceled to call
            // `PasskeysManager.authorizationController(controller:didCompleteWithError:)`.
            authController.performRequests(options: .preferImmediatelyAvailableCredentials)
        } else {
            // If credentials are available, presents a modal sign-in sheet.
            // If there are no locally saved credentials, the system presents a QR code to allow signing in with a
            // passkey from a nearby device.
            authController.performRequests()
        }
    }
    
    // MARK: PassKeys signIn with AutoFill
    
    func beginAutoFillAssistedPasskeySignIn(challenge: String,
                                            anchor: ASPresentationAnchor) {
        
        self.authenticationAnchor = anchor

        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: domain)

        // Fetch the challenge from the server. The challenge needs to be unique for each request.
        let challenge = Data(challenge.utf8)
        let assertionRequest = publicKeyCredentialProvider.createCredentialAssertionRequest(challenge: challenge)

        // AutoFill-assisted requests only support ASAuthorizationPlatformPublicKeyCredentialAssertionRequest.
        let authController = ASAuthorizationController(authorizationRequests: [assertionRequest])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performAutoFillAssistedRequests()
    }
}

extension PasskeysManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        let logger = Logger()
        switch authorization.credential {
        case let credentialRegistration as ASAuthorizationPlatformPublicKeyCredentialRegistration:
            logger.log("A new passkey was registered: \(credentialRegistration)")
            // Verify the attestationObject and clientDataJSON with your service.
            // The attestationObject contains the user's new public key to store and use for subsequent sign-ins.
            
            delegate?.signUpWithPassKeys?(with: credentialRegistration)
            // After the server verifies the registration and creates the user account, sign in the user with the new account.
        case let credentialAssertion as ASAuthorizationPlatformPublicKeyCredentialAssertion:
            logger.log("A passkey was used to sign in: \(credentialAssertion)")
            // Verify the below signature and clientDataJSON with your service for the given userID.
            
            delegate?.signInWithPassKeys?(with: credentialAssertion)
            // After the server verifies the assertion, sign in the user.
        case let passwordCredential as ASPasswordCredential:
            logger.log("A password was provided: \(passwordCredential)")
            // Verify the userName and password with your service.
            
             let userName = passwordCredential.user
             let password = passwordCredential.password

            delegate?.signInWithPassword?(userName: userName, password: password)
            // After the server verifies the userName and password, sign in the user.
        default:
            fatalError("Received unknown authorization type.")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        let logger = Logger()
        guard let authorizationError = error as? ASAuthorizationError else {
            logger.error("Unexpected authorization error: \(error.localizedDescription)")
            return
        }

        if authorizationError.code == .canceled {
            // Either the system doesn't find any credentials and the request ends silently, or the user cancels the request.
            // This is a good time to show a traditional login form, or ask the user to create an account.
            logger.log("Request canceled.")
        } else {
            // Another ASAuthorization error.
            // Note: The userInfo dictionary contains useful information.
            logger.error("Error: \((error as NSError).userInfo)")
        }
    }
}

extension PasskeysManager: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return authenticationAnchor!
    }
}

@objc protocol PasskeysManagerDelegate: NSObjectProtocol {
    
    @objc optional func signUpWithPassKeys(with credentialRegistration: ASAuthorizationPlatformPublicKeyCredentialRegistration)
    
    @objc optional func signInWithPassKeys(with credentialAssertion: ASAuthorizationPlatformPublicKeyCredentialAssertion)
    
    @objc optional func signInWithPassword(userName: String, password: String)
}
