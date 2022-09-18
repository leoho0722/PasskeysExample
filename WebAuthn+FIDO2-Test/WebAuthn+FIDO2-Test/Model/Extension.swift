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


extension Encodable {
    
    func asDictionary() throws -> [String : Any] {
        let data = try JSONEncoder().encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}

extension Dictionary {
    
    func toJsonString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
    }
}
