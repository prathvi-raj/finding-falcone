//
//  FalconeRouter.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import Alamofire

enum FalconeRouter: APIRouterType {
    
    case planets
    case vehicles
    case token
    case findFalcone(token: Token, destinations: [Destination])
    
    func asURLRequest() throws -> URLRequest {
        
        let baseURL: String = {
            return APIConstants.baseURL.absoluteString
        }()
        
        let apiVersion: String? = {
            return nil
        }()
        
        let relativePath: String? = {
            switch self {
            case .planets:
                return "planets"
            case .vehicles:
                return "vehicles"
            case .token:
                return "token"
            case .findFalcone:
                return "find"
            }
        }()
        
        var method: HTTPMethod {
            switch self {
            case .planets, .vehicles:
                return .get
            case .token, .findFalcone:
                return .post
            }
        }
        
        let params: ([String: Any]?) = {
            var params: [String: Any] = [:]
            switch self {
            case .planets, .vehicles, .token:
                break
            case .findFalcone(let token, let destinations):
                if let dictionary = FindFalconeRequest(token: token, destinations: destinations).dictionary {
                    params = dictionary
                }
            }
            print(params)
            return params
        }()
        
        let headers: [String:String]? = {
            var headers: [String: String] = [:]
            switch self {
            case .planets, .vehicles:
                break
            case .token:
                headers = [APIConstants.HttpHeaderField.acceptType.rawValue: APIConstants.ContentType.json.rawValue]
            case .findFalcone:
                headers = [APIConstants.HttpHeaderField.acceptType.rawValue: APIConstants.ContentType.json.rawValue,
                           APIConstants.HttpHeaderField.contentType.rawValue: APIConstants.ContentType.json.rawValue
                ]
            }
            return headers
        }()
        
        let url:URL = {
            
            var completeUrl = URL(string: baseURL)!
            
            if let apiVersion = apiVersion {
                completeUrl = completeUrl.appendingPathComponent(apiVersion)
            }
            
            if let relativePath = relativePath {
                completeUrl = completeUrl.appendingPathComponent(relativePath)
            }
            
            return completeUrl
        }()
        
        let encoding:ParameterEncoding = {
            
            switch self {
            case .findFalcone, .token:
                return JSONEncoding.default
            default:
                return URLEncoding.default
                
            }
        }()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        return try encoding.encode(urlRequest, with: params)
    }
}
