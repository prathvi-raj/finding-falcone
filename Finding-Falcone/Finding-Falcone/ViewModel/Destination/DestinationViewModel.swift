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
    
    /// Destinations
    let destinations: [Destination]
    
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
    
    var timeTakenText: Observable<String?> {
        Observable.combineLatest(selectedPlanet, selectedVehicle)
            .map { [weak self] (planet, vehicle) in
                guard let self = self, let planet = planet, let vehicle = vehicle else { return nil }
                let time = (planet.distance / vehicle.speed) + self.totalTimeTake
                return "Time : \(time)"
            }
    }
    
    /// Total time taken for all the destinations
    var totalTimeTake: Int {
        return destinations.reduce(0, { (accumulation, enumeration) -> Int in
            return accumulation + enumeration.timeTaken
        })
    }
    
    /// Selected destination
    var destination: Destination? {
        guard let planet = selectedPlanet.value, let vehicle = selectedVehicle.value else {
            return nil
        }
        
        return Destination(planet: planet, vehicle: vehicle)
    }
    
    /// Initalize with dependencies
    init(planets: [Planet], vehicles: [Vehicle], destinations: [Destination], dependencies: Dependencies) {
        self.dependencies = dependencies
        self.availableVehicles = vehicles
        self.availablePlanets = planets
        self.destinations = destinations
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
