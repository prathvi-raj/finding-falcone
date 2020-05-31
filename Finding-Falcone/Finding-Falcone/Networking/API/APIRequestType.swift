//
//  APIRequestType.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

protocol APIRequestType {
    func request<T: Decodable, E: Decodable>(_ dataRequest: Observable<DataRequest>, jsonDecoder: JSONDecoder) -> Observable<APIResult<T,E>>
}

extension APIRequestType {
    
    func request<T: Decodable, E: Decodable>(_ dataRequest: Observable<DataRequest>, jsonDecoder: JSONDecoder = JSONDecoder()) -> Observable<APIResult<T,E>> {
        return Observable<APIResult<T, E>>.create({ (observer) -> Disposable in
            dataRequest.observeOn(MainScheduler.instance).subscribe({ (event) in
                switch event {
                case .next(let e):
//                    plog(e.debugDescription)
                    e.responseJSON(completionHandler: { (dataResponse) in
                        guard let statusCode = dataResponse.response?.statusCode else {
                            observer.onNext(APIResult.failure(error: APICallError.init(status: .failed)))
                            observer.onCompleted()
                            return
                        }
                        
                        plog(dataResponse.response)
                        
                        if let data = dataResponse.data {
                            plog(String(data: data, encoding: .utf8) ?? pString(.genericError))
                        }
                        
                        switch statusCode {
                            
                        case 200..<300:
                            
                            guard let data  = dataResponse.data else {
                                observer.onNext(APIResult.failure(error: APICallError.init(status: .serializationFailed)))
                                observer.onCompleted()
                                return
                            }
                            
                            do {
                                let model = try jsonDecoder.decode(T.self, from: data)
                                observer.onNext(APIResult.success(value: model))
                            }catch let error {
                                plog(error.localizedDescription)
                                observer.onNext(APIResult.failure(error: APICallError.init(status: .serializationFailed)))
                            }
                            
                        case 400..<500:
                            
                            guard let data  = dataResponse.data else {
                                observer.onError(APICallStatus.failed)
                                observer.onCompleted()
                                return
                            }
                            
                            print(String(data: data, encoding: .utf8) ?? pString(.genericError))
                            
                            do {
                                let model = try jsonDecoder.decode(E.self, from: data)
                                if model is FalconeError {
                                    observer.onNext(APIResult.failure(error: APICallError.init(status: .unknown)))
                                }else {
                                    observer.onNext(APIResult.failure(error: APICallError.init(status: .failed)))
                                }
                            }catch let error {
                                plog(error.localizedDescription)
                                observer.onError(APICallStatus.failed)
                            }
                            
                            observer.onError(APICallStatus.forbidden)
                        case 500:
                            observer.onNext(APIResult.failure(error: APICallError.init(status: .internalServerError)))
                        default:
                            observer.onNext(APIResult.failure(error: APICallError.init(status: .failed)))
                        }
                        observer.onCompleted()
                    })
                case .error(let error):
                    plog(error.localizedDescription)
                    observer.onError(APICallStatus.failed)
                    observer.onCompleted()
                case .completed:
                    break
                }
            })
        })
    }
}
