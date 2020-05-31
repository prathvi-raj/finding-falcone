//
//  FalconeAPIs.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class FalconeAPIs: APIRequestType {
    
    func planets() -> Observable<APIResult<[Planet], FalconeError>> {
        return request(APIManager.shared.requestObservable(api: FalconeRouter.planets))
    }
    
    func vehicles() -> Observable<APIResult<[Vehicle], FalconeError>> {
        return request(APIManager.shared.requestObservable(api: FalconeRouter.vehicles))
    }
    
    func token() -> Observable<APIResult<Token, FalconeError>> {
        return request(APIManager.shared.requestObservable(api: FalconeRouter.token))
    }
    
    func findFalcone(token: Token, destinations: [Destination]) -> Observable<APIResult<Result, FalconeError>> {
        return request(APIManager.shared.requestObservable(api: FalconeRouter.findFalcone(token: token, destinations: destinations)))
    }
}
