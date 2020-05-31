//
//  APICallError.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation

class APICallError {
    
    var critical: Bool = false
    var code: String = String()
    var reason:String = String()
    var message: String = String()
    var callStatus: APICallStatus = .unknown
    
    init() {
        
    }
    
    init(critical:Bool, code: String, reason:String, message:String, callStatus: APICallStatus = .unknown) {
        self.critical = critical
        self.code = code
        self.reason = reason
        self.message = message
        self.callStatus = callStatus
    }
    
    convenience init(status:APICallStatus) {
        switch status {
        case .success:
            self.init()
        case .failed:
            self.init(critical: false, code: "1111", reason: "Not 200.", message: pString(.genericError))
        case .forbidden:
            self.init(critical: false, code: "2222", reason: "HTTP status code 403", message: pString(.genericError))
        case .serializationFailed:
            self.init(critical: false, code: "3333", reason: "Could not parse the json", message: pString(.genericError))
        case .offline:
            self.init(critical: false, code: "10101", reason: "User offline", message: pString(.internetConnectionOffline), callStatus: .offline)
        case .timeout:
            self.init(critical: false, code: "5555", reason: "Slow internet connection", message: pString(.internetConnectionSlow))
        default:
            self.init(critical: false, code: "1111", reason: "Not 200.", message: pString(.genericError))
        }
    }
    
}
