//
//  UserPreferences.swift
//  CmoreKeyDemo
//
//  Created by Leo Ho on 2022/6/24.
//

import Foundation

class UserPreferences {
    
    static let shared = UserPreferences()
    
    private let userPreferences: UserDefaults
    
    private init() {
        userPreferences = UserDefaults.standard
    }
    
    enum UserPreference: String {
        case relyPartyId
        case relyPartyName
        case userId
        case userDisplayName
        case userName
        case challenge
        case credentialId
    }
    
    var relyPartyId: String {
        get { return userPreferences.string(forKey: UserPreference.relyPartyId.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.relyPartyId.rawValue) }
    }
    
    var relyPartyName: String {
        get { return userPreferences.string(forKey: UserPreference.relyPartyName.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.relyPartyName.rawValue) }
    }
    
    var userId: String {
        get { return userPreferences.string(forKey: UserPreference.userId.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.userId.rawValue) }
    }
    
    var userDisplayName: String {
        get { return userPreferences.string(forKey: UserPreference.userDisplayName.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.userDisplayName.rawValue) }
    }
    
    var userName: String {
        get { return userPreferences.string(forKey: UserPreference.userName.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.userName.rawValue) }
    }
    
    var challenge: String {
        get { return userPreferences.string(forKey: UserPreference.challenge.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.challenge.rawValue) }
    }
    
    var credentialId: String {
        get { return userPreferences.string(forKey: UserPreference.credentialId.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.credentialId.rawValue) }
    }
}
