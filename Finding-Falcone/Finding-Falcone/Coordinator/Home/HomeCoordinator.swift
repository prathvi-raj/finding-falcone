//
//  HomeCoordinator.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift

class HomeCoordinator: Coordinator<Void> {
    typealias Dependencies = HasAPI & HasWindow
    
    private let navigationController: UINavigationController
    private let dependencies: Dependencies
    
    init(navigationController: UINavigationController, dependencies: Dependencies) {
        
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    override func start() -> Observable<Void> {
        
        let viewModel = HomeViewModel(dependencies: self.dependencies)
        let homeNavigationController = UIStoryboard.main.get(HomeNavigationController.self)
        let viewController = homeNavigationController.viewControllers.first as! HomeViewController
        viewController.viewModel = viewModel
        navigationController.viewControllers = [viewController]
        
        viewModel.selectedIndexPath.subscribe(onNext: { [weak self] (indexPath) in
            guard let `self` = self, let indexPath = indexPath, !viewModel.destinationTableViewCellData[indexPath.row].isDestinationSelected else { return }
            plog(indexPath)
            self.showDestination(planets: viewModel.availablePlanets, vehicles: viewModel.availableVehicles, destinations: viewModel.destinations)
                .subscribe(onNext: { (result) in
                    switch result {
                    case .selected(let destination):
                        viewModel.saveDestination(destination)
                    case .cancel:
                        break
                    }
                }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        viewModel.nextTaps.subscribe(onNext: { [weak self] () in
            guard let `self` = self else { return }
            self.showResult(destinations: viewModel.destinations).subscribe(onNext: { (result) in
                switch result {
                case .close:
                    viewModel.resetTaps.onNext(())
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        self.dependencies.window.rootViewController = navigationController
        
        return Observable.never()
    }
    
    deinit {
        plog(HomeCoordinator.self)
    }
}

extension HomeCoordinator {
    
    /// Launch Destination View Controller
    private func showDestination(planets: [Planet], vehicles: [Vehicle], destinations: [Destination]) -> Observable<DestinationCoordinatorResult> {
        let coordinator = DestinationCoordinator(planets: planets, vehicles: vehicles, destinations: destinations, navigationController: navigationController, dependencies: dependencies)
        return coordinate(to: coordinator)
    }
    
    private func showResult(destinations: [Destination]) -> Observable<ResultCoordinatorResult> {
        let coordinator = ResultCoordinator(destinations: destinations, navigationController: navigationController, dependencies: dependencies)
        return coordinate(to: coordinator)
    }
}
