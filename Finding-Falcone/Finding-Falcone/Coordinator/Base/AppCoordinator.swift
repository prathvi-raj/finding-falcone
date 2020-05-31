//
//  AppCoordinator.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift

/// AppCoordinator: Starts the Application by initalizing the HomeViewController
final class AppCoordinator: Coordinator<Void> {
    
    /// Root navigation controller for window
    private let navigationController:UINavigationController
    
    /// Key window
    private let window: UIWindow
    
    /// Dependencies
    let dependencies: AppDependency
    
    init(window:UIWindow, navigationController:UINavigationController) {
        
        self.window = window
        self.navigationController = navigationController
        self.dependencies = AppDependency(window: self.window)
    }
    
    override func start() -> Observable<Void> {
        return showHome()
    }
    
    deinit {
        plog(AppCoordinator.self)
    }
}

extension AppCoordinator {
    
    /// Launch Home View Controller
    private func showHome() -> Observable<Void> {
        let coordinator = HomeCoordinator(navigationController: navigationController, dependencies: self.dependencies)
        return coordinate(to: coordinator)
    }
}
