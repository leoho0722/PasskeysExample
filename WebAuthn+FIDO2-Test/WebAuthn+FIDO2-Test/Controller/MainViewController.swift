//
//  MainViewController.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/14.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var authenticationButton: UIButton!
    @IBOutlet weak var usePassKeysSwitch: UISwitch!
    
    let loginManager = LoginManager()
    let authenticationManager = AuthenticationManager()
    
    var username: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginManager.authToken = UUID().uuidString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func registerBtnClicked(_ sender: UIButton) {
        
        guard let usernameTF = usernameTextField.text else { return }
        username = usernameTF
        
        if usePassKeysSwitch.isOn {
//            guard let window = self.view.window else {
//                fatalError("The view was not in the app's view hierarchy!")
//            }
//            authenticationManager.signUpWith(userName: username, anchor: window)
            registerAccount()
        } else {
            loginManager.signUpWithFIDO2(username: username) { registerResults in
                switch registerResults {
                case .success(let success):
                    print("Register Success：", success.success)
                    print("Register Success：", success.jwt)
                case .failure(let failure):
                    print("Register Failure：", failure)
                }
            }
        }
    }
    
    @IBAction func authenticationBtnClicked(_ sender: UIButton) {
        
        if usePassKeysSwitch.isOn {
            guard let window = self.view.window else {
                fatalError("The view was not in the app's view hierarchy!")
            }
            authenticationManager.signInWith(anchor: window, preferImmediatelyAvailableCredentials: true)
        } else {
            loginManager.authenticateWithFIDO2(username: username) { authenticateResults in
                switch authenticateResults {
                case .success(let success):
                    print("Authenticate Success：", success.success)
                    print("Authenticate Success：", success.jwt)
                case .failure(let failure):
                    print("Authenticate Failure：", failure)
                }
            }
        }
    }
}

extension MainViewController {
    
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
        let request = UsernameRequest(username: username)
        
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
