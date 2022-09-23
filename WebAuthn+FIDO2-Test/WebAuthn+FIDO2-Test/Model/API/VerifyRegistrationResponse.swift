//
//  VerifyRegistrationResponse.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/14.
//

import Foundation

struct VerifyRegistrationRequest: Codable {
    
    var id: String
    
    var rawId: String
    
    var response: Response
    
    var type: String
    
    var clientExtensionResults: ClientExtensionResults
    
    var transports: [String]
    
    struct Response: Codable {
        
        var attestationObject: Data
        
        var clientDataJSON: Data
    }
    
    struct ClientExtensionResults: Codable {
        
    }
}

struct VerifyRegistrationResponse: Decodable {
    
    let username: String?
    
    let msg: String?
    
    let status: Int?
    
    let verified: Bool
}
