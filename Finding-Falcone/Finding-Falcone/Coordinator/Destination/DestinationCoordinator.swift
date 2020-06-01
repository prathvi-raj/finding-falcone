//
//  DestinationCoordinator.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift

enum DestinationCoordinatorResult {
    
    case selected(destination: Destination)
    case cancel
}

class DestinationCoordinator: Coordinator<DestinationCoordinatorResult> {
    typealias Dependencies = HasAPI & HasWindow
    
    private let navigationController: UINavigationController
    private let dependencies: Dependencies
    
    /// Selected Destinations
    private let destinations: [Destination]
    
    /// Available Planets
    private let availablePlanets: [Planet]
    
    /// Available Vehicles
    private let availableVehicles: [Vehicle]
    
    init(planets: [Planet], vehicles: [Vehicle], destinations: [Destination], navigationController: UINavigationController, dependencies: Dependencies) {
        
        self.navigationController = navigationController
        self.dependencies = dependencies
        
        self.availablePlanets = planets
        self.availableVehicles = vehicles
        self.destinations = destinations
    }
    
    override func start() -> Observable<DestinationCoordinatorResult> {
        return Observable<DestinationCoordinatorResult>.create { [weak self] (subscriber) -> Disposable in
            if let `self` = self {
                
                let viewModel = DestinationViewModel(planets: self.availablePlanets, vehicles: self.availableVehicles, destinations: self.destinations, dependencies: self.dependencies)
                let destinationNavigationController = UIStoryboard.main.get(DestinationNavigationController.self)
                
                let viewController = destinationNavigationController.viewControllers.first as! DestinationViewController
                viewController.viewModel = viewModel
                
                viewModel.cancelTaps.subscribe(onNext: { () in
                    plog("Cancel taps")
                    subscriber.onNext(.cancel)
                    subscriber.onCompleted()
                    viewController.dismiss(animated: true, completion: nil)
                }).disposed(by: self.disposeBag)
                
                viewModel.doneTaps.subscribe(onNext: { () in
                    if let destination = viewModel.destination {
                        subscriber.onNext(.selected(destination: destination))
                        subscriber.onCompleted()
                        viewController.dismiss(animated: true, completion: nil)
                    }
                }).disposed(by: self.disposeBag)
                
                self.navigationController.topViewController?.present(destinationNavigationController, animated: true, completion: nil)
            }
            return Disposables.create()
        }
    }
    
    deinit {
        plog(DestinationCoordinator.self)
    }
}
