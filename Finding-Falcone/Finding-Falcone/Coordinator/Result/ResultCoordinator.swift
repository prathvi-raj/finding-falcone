//
//  ResultCoordinator.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift

enum ResultCoordinatorResult {
    case close
}

class ResultCoordinator: Coordinator<ResultCoordinatorResult> {
    typealias Dependencies = HasAPI & HasWindow
    
    private let navigationController: UINavigationController
    private let dependencies: Dependencies
    
    /// Selected destinations
    private let destinations: [Destination]
    
    init(destinations: [Destination], navigationController: UINavigationController, dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.destinations = destinations
    }
    
    override func start() -> Observable<ResultCoordinatorResult> {
        return Observable<ResultCoordinatorResult>.create { [weak self] (subscriber) -> Disposable in
            if let `self` = self {
                let viewModel = ResultViewModel(destinations: self.destinations, dependencies: self.dependencies)
                let resultNavigationController = UIStoryboard.main.get(ResultNavigationController.self)
                let viewController = resultNavigationController.viewControllers.first as! ResultViewController
                viewController.viewModel = viewModel
                
                viewModel.closeTaps.subscribe(onNext: { [weak self] () in
                    if let `self` = self {
                        subscriber.onNext(.close)
                        self.navigationController.popViewController(animated: true)
                    }
                }).disposed(by: self.disposeBag)
                
                self.navigationController.pushViewController(viewController, animated: true)
            }
            return Disposables.create()
        }
    }
    
    deinit {
        plog(ResultCoordinator.self)
    }
}
