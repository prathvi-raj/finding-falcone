//
//  APIManager.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class APIManager {
    
    static let shared: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    let session: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        
        session = Alamofire.Session(configuration: configuration)
    }
    
    func requestObservable(api: APIRouterType) -> Observable<DataRequest> {
        return session.rx.request(urlRequest: api)
    }
}
