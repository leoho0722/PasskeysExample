//
//  WebAuthnManager.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/16.
//

import UIKit
import WebAuthnKit

class WebAuthnManager: NSObject {
    
    func configure(vc: UIViewController, origin: String) -> WebAuthnClient {
        let userConsentUI = UserConsentUI(viewController: vc)
        userConsentUI.config.alwaysShowKeySelection = false
        userConsentUI.config.showRPInformation = false
        let authenticator = InternalAuthenticator(ui: userConsentUI)
        return WebAuthnClient(origin: origin, authenticator: authenticator)
    }
    
    func createPublicKeyCredentialOptions(rpEntity: (id: String, name: String),
                                          userEntity: (id: String, name: String, displayName: String),
                                          challenge: String,
                                          timeout: UInt64,
                                          excludeCredentials: [PublicKeyCredentialDescriptor] = [],
                                          authenticatorSelection: AuthenticatorSelectionCriteria,
                                          attestation: AttestationConveyancePreference) -> PublicKeyCredentialCreationOptions {
        var options = PublicKeyCredentialCreationOptions()
        
        options.challenge = Bytes.fromString(challenge)
        
        options.user.id = Bytes.fromString(userEntity.id)
        options.user.name = userEntity.name
        options.user.displayName = userEntity.displayName
        
        options.rp.id = rpEntity.id
        options.rp.name = rpEntity.name
        
        options.attestation = attestation
        
        options.addPubKeyCredParam(alg: .es256)
        
        options.authenticatorSelection = authenticatorSelection
        
        options.timeout = timeout
        
        options.excludeCredentials = excludeCredentials

        return options
    }
    
    func getPublicKeyCredentialOptions(rpId: String,
                                       challenge: String,
                                       credentialId: String,
                                       transports: [AuthenticatorTransport],
                                       userVerification: UserVerificationRequirement, timeout: UInt64) -> PublicKeyCredentialRequestOptions {
        var options = PublicKeyCredentialRequestOptions()
        
        options.challenge = Bytes.fromString(challenge)
        
        options.rpId = rpId
        
        options.addAllowCredential(credentialId: Bytes.fromString(credentialId), transports: transports)
        
        options.userVerification = userVerification
        
        options.timeout = timeout
        
        return options
    }
    
}
