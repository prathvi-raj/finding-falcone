//
//  BaseViewModel.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftMessages

enum CoordinatorError {
    case noInternetConnection
}

typealias CoordinationTask = (() -> Void)?

class BaseViewModel {
    
    /// Dispose Bag
    let disposeBag = DisposeBag()
    
    /// Error while coordinating
    let coordinatorError = PublishSubject<(CoordinationTask, CoordinatorError)>()
    
    /// Show Message
    let alert = PublishSubject<(String, Theme)>()
    
    /// Show Alert
    let alertDialog = PublishSubject<(String,String)>()
    
    /// Show UIActivityIndicatorView
    let isLoading: ActivityIndicator =  ActivityIndicator()
    
    /// Memory low case. Discard useless data
    let isMemoryLow: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
}
