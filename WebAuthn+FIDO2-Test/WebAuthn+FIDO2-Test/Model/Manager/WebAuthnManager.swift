//
//  WebAuthnManager.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/16.
//

import Foundation
import WebAuthnKit

class WebAuthnManager: NSObject {
    
    func createWebAuthnClient(origin: String, authenticator: Authenticator) -> WebAuthnClient {
        var webAuthnClient = WebAuthnClient(origin: origin,
                                            authenticator: authenticator)
        return webAuthnClient
    }
    
    func createPublicKeyCredentialOptions(rpEntity: PublicKeyCredentialRpEntity,
                                          userEntity: (id: String, name: String, displayName: String),
                                          challenge: String,
                                          timeout: UInt64,
                                          excludeCredentials: [PublicKeyCredentialDescriptor] = [],
                                          authenticatorSelection: AuthenticatorSelectionCriteria,
                                          attestation: AttestationConveyancePreference) -> PublicKeyCredentialCreationOptions {
        var options = PublicKeyCredentialCreationOptions()
        
        options.challenge = Bytes.fromHex(challenge)
        
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
    
    
}
