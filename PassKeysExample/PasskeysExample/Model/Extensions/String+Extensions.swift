//
//  String+Extensions.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2023/2/19.
//

import Foundation

extension String {
    
    /// convert base64URL Encoded String to base64 Encoded String
    var base64URLEncodedToBase64: String {
        var encoded: String = Data(self.utf8).base64EncodedString()
        if encoded.count % 4 > 0 {
            encoded += String(repeating: "=", count: 4 - (encoded.count % 4))
        }
        return encoded
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func toDictionary() -> [String : Any] {
        var result = [String : Any]()
        guard !self.isEmpty else { return result }
        
        guard let dataSelf = self.data(using: .utf8) else {
            return result
        }
        
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf,
                                                       options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
        
    }
}
