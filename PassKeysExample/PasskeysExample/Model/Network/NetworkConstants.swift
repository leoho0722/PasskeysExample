//
//  NetworkConstants.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2022/9/14.
//

import Foundation

struct NetworkConstants {
    
    static let baseURL = "https://zero-trust-test.nutc-imac.com"
    
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        case json = "application/json"
        case xml = "application/xml"
        case x_www_form_urlencoded = "application/x-www-form-urlencoded"
    }
    
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }

    enum RequestError: Error {
        case unknownError
        case connectionError
        case invalidResponse
        case jsonDecodeFailed
        case invalidRequest     // statusCode 400
        case authorizationError // statusCode 401
        case notFound           // statusCode 404
        case internalError      // statusCode 500
        case serverError        // statusCode 502
        case serverUnavailable  // statusCode 503
    }
    
    enum APIPathConstants: String {
        
        // MARK: Shared
        
        case username = "/username"
        
        // MARK: Registration

        case generateRegistrationOptions = "/generate-registration-options"
        
        case verifyRegistrationResponse = "/verify-registration-response"
        
        // MARK: Authentication
        
        case generateAuthenticationOptions = "/generate-authentication-options"
        
        case verifyAuthenticationResponse = "/verify-authentication-response"
    }
}
