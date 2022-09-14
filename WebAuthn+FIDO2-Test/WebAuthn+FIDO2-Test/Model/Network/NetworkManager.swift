//
//  NetworkManager.swift
//  WebAuthn+FIDO2-Test
//
//  Created by Leo Ho on 2022/9/14.
//

import Foundation

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()

    func requestData<E: Encodable, D: Decodable>(httpMethod: NetworkConstants.HTTPMethod,
                                                 path: NetworkConstants.APIPathConstants,
                                                 parameters: E) async throws -> D {
        let urlRequest = handleHTTPMethod(httpMethod, path, parameters)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            switch statusCode {
            case 400:
                throw NetworkConstants.RequestError.invalidRequest
            case 401:
                throw NetworkConstants.RequestError.authorizationError
            case 404:
                throw NetworkConstants.RequestError.notFound
            case 500:
                throw NetworkConstants.RequestError.internalError
            case 502:
                throw NetworkConstants.RequestError.serverError
            case 503:
                throw NetworkConstants.RequestError.serverUnavailable
            default:
                throw NetworkConstants.RequestError.unknownError
            }
        }
//        print(String(data: data, encoding: .utf8))
        let jsonDecoder = JSONDecoder()
        guard let results = try? jsonDecoder.decode(D.self, from: data) else {
            throw NetworkConstants.RequestError.jsonDecodeFailed
        }
        
        #if DEBUG
        self.printNeworkProgress(urlRequest, parameters, results)
        #endif
        
        return results
    }
    
    private func handleHTTPMethod<E: Encodable>(_ method: NetworkConstants.HTTPMethod,
                                                _ path: NetworkConstants.APIPathConstants,
                                                _ parameters: E) -> URLRequest {
        let baseURL = NetworkConstants.baseURL
        let url = URL(string: baseURL + path.rawValue)!
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        let httpType = NetworkConstants.ContentType.json.rawValue
        urlRequest.allHTTPHeaderFields = [NetworkConstants.HttpHeaderField.contentType.rawValue : httpType]
        urlRequest.httpMethod = method.rawValue
        
        let dict1 = try? parameters.asDictionary()
        
        switch method {
        case .get:
            let parameters = dict1 as? [String : String]
            urlRequest.url = requestWithURL(urlString: urlRequest.url?.absoluteString ?? "", parameters: parameters ?? [:])
        default:
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: dict1 ?? [:], options: .prettyPrinted)
        }
        return urlRequest
    }
    
    private func requestWithURL(urlString: String,
                                parameters: [String : String]?) -> URL? {
        guard var urlComponents = URLComponents(string: urlString) else { return nil }
        urlComponents.queryItems = []
        parameters?.forEach { (key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return urlComponents.url
    }
    
    private func printNeworkProgress<E: Encodable, D: Decodable>(_ urlRequest: URLRequest, _ parameters: E, _ results: D) {
        #if DEBUG
        print("=======================================")
        print("- URL: \(urlRequest.url?.absoluteString ?? "")")
        print("- Header: \(urlRequest.allHTTPHeaderFields ?? [:])")
        print("---------------Request-----------------")
        print(parameters)
        print("---------------Response----------------")
        print(results)
        print("=======================================")
        #endif
    }
    
}
