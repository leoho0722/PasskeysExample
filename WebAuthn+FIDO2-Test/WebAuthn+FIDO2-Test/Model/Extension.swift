//
//  Extension.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/14.
//

import UIKit

extension UIButton {
    
    func setButtonTitle(title: String, state: UIControl.State = .normal) {
        self.setTitle(title, for: state)
    }
}

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
        
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf, options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
        
    }
}

extension Encodable {
    
    func asDictionary() throws -> [String : Any] {
        let data = try JSONEncoder().encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}

extension Dictionary {
    
    func toJsonString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
    }
    
    func toJsonData() -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        return data
    }
}
