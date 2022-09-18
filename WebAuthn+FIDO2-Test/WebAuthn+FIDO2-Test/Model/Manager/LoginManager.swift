//
//  AuthenticationManager.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/14.
//

import Foundation
import LoginSDK

class LoginManager: NSObject {
    
    static let shared = LoginManager()
    
    // MARK: - LoginSDK Register、Authenticate
    
    var authToken: String? = nil
    
    enum RegisterError: Error {
        case signUpFailed(String)
    }
    
    enum AuthenticateError: Error {
        case authenticateFailed(String)
    }
    
    func signUpWithFIDO2(username: String, completion: @escaping (Result<RegisterResponse, RegisterError>) -> Void) {
        
        var options: RegistrationOptions? = nil
        
        guard authToken != nil else { return }
        options = RegistrationOptions.buildAuth(token: authToken)
        
        LoginApi.client.registerWithFido2(username: username, options: options) { response in
            if response.success {
                completion(.success(response))
            } else {
                completion(.failure(.signUpFailed(response.errorMessage)))
            }
        }
    }
    
    func authenticateWithFIDO2(username: String, completion: @escaping (Result<AuthenticateResponse, AuthenticateError>) -> Void) {
        
        var options: AuthenticationOptions? = nil
        
        guard authToken != nil else { return }
        options = AuthenticationOptions.buildAuth(token: authToken)
        
        LoginApi.client.authenticateWithFido2(username: username, options: options) { response in
            if response.success {
                completion(.success(response))
            } else {
                completion(.failure(.authenticateFailed(response.errorMessage)))
            }
        }
    }
}
