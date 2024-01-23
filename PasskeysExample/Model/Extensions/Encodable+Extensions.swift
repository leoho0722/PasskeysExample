//
//  Encodable+Extensions.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2023/2/19.
//

import Foundation

extension Encodable {
    
    func asDictionary() throws -> [String : Any] {
        let data = try JSONEncoder().encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                options: .fragmentsAllowed) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
