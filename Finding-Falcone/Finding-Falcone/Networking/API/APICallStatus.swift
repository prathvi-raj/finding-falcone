//
//  APICallStatus.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation

enum APICallStatus: Error {
    
    case success
    case failed
    case forbidden
    case notFound
    case conflict
    case internalServerError
    case serializationFailed
    case offline
    case timeout
    case unknown
}

extension APICallStatus: LocalizedError {
    
    var localizedDescription: String {
        
        switch self {
        case .success:
            return String()
        case .failed:
            return pString(.genericError)
        case .forbidden:
            return pString(.genericError)
        case .notFound:
            return pString(.genericError)
        case .conflict:
            return pString(.genericError)
        case .internalServerError:
            return pString(.genericError)
        case .serializationFailed:
            return pString(.genericError)
        case .offline:
            return pString(.internetConnectionOffline)
        case .timeout:
            return pString(.internetConnectionSlow)
        case .unknown:
            return pString(.genericError)
        }
    }
}
