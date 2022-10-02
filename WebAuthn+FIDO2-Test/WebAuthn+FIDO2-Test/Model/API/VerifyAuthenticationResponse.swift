//
//  VerifyAuthenticationResponse.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/26.
//

import Foundation

struct VerifyAuthenticationRequest: Codable {
    
    var challenge: String
    
    var allowCredentials: [AllowCredentials]
    
    var userVerification: String
    
    var timeout: Int
    
    var rpId: String
    
    struct AllowCredentials: Codable {
        
        var type: String
        
        var id: String
        
        var transports: [String]
    }
}

struct VerifyAuthenticationResponse: Decodable {
    
    let username: String?
    
    let msg: String?
    
    let status: Int?
    
    let verified: Bool
}
