//
//  ResultViewModel.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// ResultViewModel
class ResultViewModel: BaseViewModel {
    typealias Dependencies = HasAPI
    
    /// Dependencies
    let dependencies: Dependencies
    
    /// Token
    let token: BehaviorRelay<Token?> = BehaviorRelay<Token?>(value: nil)
    
    /// Selected destinations
    private let destinations: [Destination]
    
    let closeTaps = PublishSubject<Void>()
    
    var resultResponse: Observable<Result> {
        return _resultResponse.asObservable().observeOn(MainScheduler.instance)
    }
    private let _resultResponse = ReplaySubject<Result>.create(bufferSize: 1)
    
    /// Initalize with dependencies
    init(destinations: [Destination], dependencies: Dependencies) {
        self.dependencies = dependencies
        self.destinations = destinations
        super.init()
        
        token.subscribe(onNext: { [weak self] (value) in
            guard let `self` = self, let value = value else { return }
            self.findFalcone(value: value)
        }).disposed(by: disposeBag)
        
        getToken()
    }
}

/// Networking
extension ResultViewModel {
    
    /// Get Token
    func getToken() {
        dependencies.api
            .token()
            .trackActivity(isLoading)
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { (result) in
                switch result {
                case .success(let response):
                    self.token.accept(response)
                case .failure:
                    self.alert.onNext((pString(.genericError), .error))
                }
            }).disposed(by: disposeBag)
    }
    
    /// Find falcone
    func findFalcone(value: Token) {
        dependencies.api
            .findFalcone(token: value, destinations: destinations)
            .trackActivity(isLoading)
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { (result) in
                switch result {
                case .success(let response):
                    self._resultResponse.onNext(response)
                case .failure:
                    self.alert.onNext((pString(.genericError), .error))
                }
            }).disposed(by: disposeBag)
    }
}
