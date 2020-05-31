//
//  APIRequestCall.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

fileprivate func requestPrivate<T: Decodable>(_ dataRequest: Observable<DataRequest>, jsonDecoder: JSONDecoder = JSONDecoder()) -> Observable<T> {
    return Observable<T>.create({ (observer) -> Disposable in
        dataRequest.observeOn(MainScheduler.instance).subscribe({ (event) in
            plog(event)
            switch event {
            case .next(let e):
//                print(e.debugDescription)
                e.responseJSON(completionHandler: { (dataResponse) in
                    guard let statusCode = dataResponse.response?.statusCode else {
                        observer.onError(APICallStatus.failed)
                        observer.onCompleted()
                        return
                    }
                    
                    switch statusCode {
                        
                    case 200..<300:
                        
                        guard let data  = dataResponse.data else {
                            observer.onError(APICallStatus.failed)
                            observer.onCompleted()
                            return
                        }
                        
                        print(String(data: data, encoding: .utf8) ?? pString(.genericError))
                        
                        do {
                            let model = try jsonDecoder.decode(T.self, from: data)
                            observer.onNext(model)
                        }catch let error {
                            plog(error.localizedDescription)
                            observer.onError(APICallStatus.failed)
                        }
                    case 403:
                        observer.onError(APICallStatus.forbidden)
                    case 404:
                        observer.onError(APICallStatus.notFound)
                    case 409:
                        observer.onError(APICallStatus.conflict)
                    case 500:
                        observer.onError(APICallStatus.internalServerError)
                    default:
                        observer.onError(APICallStatus.failed)
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
