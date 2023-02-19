//
//  VerifyAuthenticationResponse.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2022/9/26.
//

import Foundation

struct VerifyAuthenticationRequest: Codable {
    
    var id: String
    
    var rawId: String
    
    var response: Response
    
    var type: String
    
    var clientExtensionResults: ClientExtensionResults
    
    struct Response: Codable {
        
        var authenticatorData: Data
        
        var clientDataJSON: Data
        
        var signature: Data
        
        var userHandle: Data
    }
    
    struct ClientExtensionResults: Codable {
        
    }
    
    struct AllowCredentials: Codable {
        
        var type: String
        
        var id: String
        
        var transports: [String]
    }
}

struct VerifyAuthenticationResponse: Decodable {
    
    let username: String?
    
    let msg: String?
    
    let status: String?
    
    let signCount: Int?
    
    let verified: Bool
    
    enum CodingKeys: String, CodingKey {
        case username
        case msg
        case status
        case signCount = "user_credential.sign_count"
        case verified
    }
}
