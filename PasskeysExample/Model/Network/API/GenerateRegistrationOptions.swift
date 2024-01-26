//
//  GenerateRegistrationOptions.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2022/9/14.
//

import Foundation

struct GenerateRegistrationOptionsRequest: Codable {
    
    var username: String
}

struct GenerateRegistrationOptionsResponse: Decodable {
    
    var rp: RelyingParty
    
    var user: User
    
    let challenge: String
    
    var pubKeyCredParams: [PublicKeyCredentialParameters]
    
    let attestation: String
    
    let timeout: Int
    
    var excludeCredentials: [ExcludeCredentials]
    
    var authenticatorSelection: AuthenticatorSelection
    
    struct RelyingParty: Decodable {
        
        var name: String
        
        var id: String
    }
    
    struct User: Decodable {
        
        var id: String
        
        var name: String
        
        var displayName: String
    }
    
    struct PublicKeyCredentialParameters: Decodable {
        
        var type: String
        
        var alg: Int
    }
    
    struct ExcludeCredentials: Decodable {
        
        var id: String?
        
        var transports: [String]?
        
        var type: String?
    }
    
    struct AuthenticatorSelection: Decodable {
        
        var requireResidentKey: Bool
        
        var userVerification: String
    }
}
