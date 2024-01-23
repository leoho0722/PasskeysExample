//
//  UserPreferences.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2022/6/24.
//

import Foundation

class UserPreferences {
    
    static let shared = UserPreferences()
    
    enum Keys: String {
        
        case relyPartyId
        
        case relyPartyName
        
        case userId
        
        case userDisplayName
        
        case userName
        
        case challenge
        
        case credentialId
    }
    
    var relyPartyId: String {
        get { return UserDefaults.standard.string(forKey: Keys.relyPartyId.rawValue) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.relyPartyId.rawValue) }
    }
    
    var relyPartyName: String {
        get { return UserDefaults.standard.string(forKey: Keys.relyPartyName.rawValue) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.relyPartyName.rawValue) }
    }
    
    var userId: String {
        get { return UserDefaults.standard.string(forKey: Keys.userId.rawValue) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.userId.rawValue) }
    }
    
    var userDisplayName: String {
        get { return UserDefaults.standard.string(forKey: Keys.userDisplayName.rawValue) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.userDisplayName.rawValue) }
    }
    
    var userName: String {
        get { return UserDefaults.standard.string(forKey: Keys.userName.rawValue) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.userName.rawValue) }
    }
    
    var challenge: String {
        get { return UserDefaults.standard.string(forKey: Keys.challenge.rawValue) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.challenge.rawValue) }
    }
    
    var credentialId: String {
        get { return UserDefaults.standard.string(forKey: Keys.credentialId.rawValue) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.credentialId.rawValue) }
    }
}
