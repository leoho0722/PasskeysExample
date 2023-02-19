//
//  GenerateAuthenticationOptions.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2022/9/26.
//

import Foundation

struct GenerateAuthenticationOptionsRequest: Codable {
    
}

struct GenerateAuthenticationOptionsResponse: Decodable {

    let challenge: String
    
    var allowCredentials: [AllowCredentials]
    
    let userVerification: String
    
    let timeout: Int
    
    let rpId: String
    
    struct AllowCredentials: Decodable {
        
        var type: String
        
        var id: String
        
        var transports: [String]
    }
}
