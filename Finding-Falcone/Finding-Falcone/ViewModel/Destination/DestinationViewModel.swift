//
//  DestinationViewModel.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// DestinationViewModel
class DestinationViewModel: BaseViewModel {
    typealias Dependencies = HasAPI
    
    /// Dependencies
    let dependencies: Dependencies
    
    let selectedIndexPath: BehaviorRelay<IndexPath?> = BehaviorRelay<IndexPath?>(value: nil)
    
    /// Available Planets
    var availablePlanets: [Planet] = []
    
    /// Available Vehicles
    var availableVehicles: [Vehicle] = []
    
    /// Selected Planet
    private var selectedPlanet = BehaviorRelay<Planet?>(value: nil)
    
    /// Selected Vehicle
    private var selectedVehicle = BehaviorRelay<Vehicle?>(value: nil)
    
    let cancelTaps = PublishSubject<Void>()
    let doneTaps = PublishSubject<Void>()
    
    var destination: Destination? {
        guard let planet = selectedPlanet.value, let vehicle = selectedVehicle.value else {
            return nil
        }
        
        return Destination(planet: planet, vehicle: vehicle)
    }
    
    /// Initalize with dependencies
    init(planets: [Planet], vehicles: [Vehicle], dependencies: Dependencies) {
        self.dependencies = dependencies
        self.availableVehicles = vehicles
        self.availablePlanets = planets
        plog(planets)
        plog(vehicles)
        super.init()
    }
    
    func selectPlanet(index: Int) {
        guard !availablePlanets.isEmpty else { return }
        selectedPlanet.accept(availablePlanets[index])
    }

    func selectVehicle(index: Int) {
        if index >= availableVehicles.count {
            selectedVehicle.accept(nil)
        } else {
            selectedVehicle.accept(availableVehicles[index])
        }
    }
}
