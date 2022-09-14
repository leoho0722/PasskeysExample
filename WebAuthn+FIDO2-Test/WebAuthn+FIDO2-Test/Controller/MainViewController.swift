//
//  MainViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/14.
//

import UIKit

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        registerAccount()
    }
    
    func registerAccount() {
        // MARK: Step1 POST Username
        postUsername()
        
        // MARK: Step2 GET Generate Registration Options
        generateRegistrationOptions()
        
        // MARK: Step3 POST Verify Registration Response
        verifyRegistrationResponse()
    }
    
    func verifyAccount() {
        // MARK: Step1 POST Username
        postUsername()
        
        // MARK: Step2 GET Generate Authentication Options
        generateAuthenticationOptions()
        
        // MARK: Step3 POST Verify Authentication Response
        verifyAuthenticationResponse()
    }
    
    private func postUsername() {
        let request = UsernameRequest(username: "leoho")
        
        Task {
            do {
                let results: UsernameResponse = try await NetworkManager.shared.requestData(httpMethod: .post, path: .username, parameters: request)
                print(results)
            } catch NetworkConstants.RequestError.invalidRequest {
                print("NetworkConstants.RequestError.invalidRequest")
            } catch NetworkConstants.RequestError.authorizationError {
                print("NetworkConstants.RequestError.authorizationError")
            } catch NetworkConstants.RequestError.notFound {
                print("NetworkConstants.RequestError.notFound")
            } catch NetworkConstants.RequestError.internalError {
                print("NetworkConstants.RequestError.internalError")
            } catch NetworkConstants.RequestError.serverError {
                print("NetworkConstants.RequestError.serverError")
            } catch NetworkConstants.RequestError.serverUnavailable {
                print("NetworkConstants.RequestError.serverUnavailable")
            } catch NetworkConstants.RequestError.unknownError {
                print("NetworkConstants.RequestError.unknownError")
            } catch NetworkConstants.RequestError.jsonDecodeFailed {
                print("NetworkConstants.RequestError.jsonDecodeFailed")
            }
        }
    }

    private func generateRegistrationOptions() {
        let request = GenerateRegistrationOptionsRequest()
        
        Task {
            do {
                let results: GenerateRegistrationOptionsResponse = try await NetworkManager.shared.requestData(httpMethod: .get, path: .generateRegistrationOptions, parameters: request)
                print(results)
            } catch NetworkConstants.RequestError.invalidRequest {
                print("NetworkConstants.RequestError.invalidRequest")
            } catch NetworkConstants.RequestError.authorizationError {
                print("NetworkConstants.RequestError.authorizationError")
            } catch NetworkConstants.RequestError.notFound {
                print("NetworkConstants.RequestError.notFound")
            } catch NetworkConstants.RequestError.internalError {
                print("NetworkConstants.RequestError.internalError")
            } catch NetworkConstants.RequestError.serverError {
                print("NetworkConstants.RequestError.serverError")
            } catch NetworkConstants.RequestError.serverUnavailable {
                print("NetworkConstants.RequestError.serverUnavailable")
            } catch NetworkConstants.RequestError.unknownError {
                print("NetworkConstants.RequestError.unknownError")
            } catch NetworkConstants.RequestError.jsonDecodeFailed {
                print("NetworkConstants.RequestError.jsonDecodeFailed")
            }
        }
    }
    
    private func verifyRegistrationResponse() {
        
    }
    
    private func generateAuthenticationOptions() {
        
    }
    
    private func verifyAuthenticationResponse() {
        
    }
    
}
