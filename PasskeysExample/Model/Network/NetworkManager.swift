//
//  NetworkManager.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2022/9/14.
//

import Foundation

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()

    func requestData<E, D>(method: NetworkConstants.HTTPMethod,
                           path: NetworkConstants.APIPathConstants,
                           parameters: E) async throws -> D where E: Encodable, D: Decodable {
        let urlRequest = handleHTTPMethod(method, path, parameters)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = (response as? HTTPURLResponse),
              (200 ... 299).contains(httpResponse.statusCode) else {
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
        
        #if DEBUG
        print(String(describing: String(data: data, encoding: .utf8)))
        #endif

        do {
            let jsonDecoder = JSONDecoder()
            let results = try jsonDecoder.decode(D.self, from: data)
            
            #if DEBUG
            self.printNeworkProgress(urlRequest, parameters, results)
            #endif
            
            return results
        } catch {
            print("jsonDecodeFailed: \(error as! DecodingError)")
            throw NetworkConstants.RequestError.jsonDecodeFailed
        }

    }
    
    private func handleHTTPMethod<E>(_ method: NetworkConstants.HTTPMethod,
                                     _ path: NetworkConstants.APIPathConstants,
                                     _ parameters: E) -> URLRequest where E: Encodable {
        let baseURL = NetworkConstants.baseURL
        let url = URL(string: baseURL + path.rawValue)!
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        let httpType = NetworkConstants.ContentType.json.rawValue
        urlRequest.allHTTPHeaderFields = [
            NetworkConstants.HttpHeaderField.contentType.rawValue : httpType
        ]
        urlRequest.httpMethod = method.rawValue
        
        let dict1 = try? parameters.asDictionary()
        
        switch method {
        case .get:
            let parameters = dict1 as? [String : String]
            urlRequest.url = requestWithURL(urlString: urlRequest.url?.absoluteString ?? "",
                                            parameters: parameters ?? [:])
        default:
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: dict1 ?? [:],
                                                              options: .prettyPrinted)
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
    
    private func printNeworkProgress<E, D>(_ urlRequest: URLRequest,
                                           _ parameters: E,
                                           _ results: D) where E: Encodable, D: Decodable {
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
