//
//  HomeViewModel.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct DestinationTableViewCellData {
    
    var isDestinationSelected: Bool {
        return destination != nil
    }
    
    var destination: Destination?
    
    var planetLabel: String {
        return destination?.planet.name ?? pString(.selectPlanet)
    }
    
    var vehicleLabel: String {
        return destination?.vehicle.name ?? ""
    }
    
    init() {
    }
    
    mutating func updateDestination(destination: Destination) -> Void {
        self.destination = destination
    }
}

/// HomeViewModel
class HomeViewModel: BaseViewModel {
    typealias Dependencies = HasAPI
    
    /// Dependencies
    let dependencies: Dependencies
    
    /// Selected Row of UITableView
    let selectedIndexPath: BehaviorRelay<IndexPath?> = BehaviorRelay<IndexPath?>(value: nil)
    
    /// Planets
    let planets: BehaviorRelay<[Planet]> = BehaviorRelay<[Planet]>(value: [])
    
    /// Vehicles
    let vehicles: BehaviorRelay<[Vehicle]> = BehaviorRelay<[Vehicle]>(value: [])
    
    /// Available Planets
    var availablePlanets: [Planet] = []
    
    /// Available Vehicles
    var availableVehicles: [Vehicle] = []
    
    /// Selected Destinations
    var destinations: [Destination] = []
    
    /// TableView Cell Data
    var destinationTableViewCellData: [DestinationTableViewCellData]
    
    let resetTaps = PublishSubject<Void>()
    let nextTaps = PublishSubject<Void>()
    
    let refreshTableView = PublishSubject<Bool>()
    
    var isNextButtonEnabled = BehaviorRelay<Bool>(value: false)
    
    /// Initalize with dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        destinationTableViewCellData = Array(repeating: DestinationTableViewCellData(), count: 4)
        
        super.init()
        
        planets.subscribe(onNext: { [weak self] (value) in
            guard let `self` = self else { return }
            self.availablePlanets = value
        }).disposed(by: disposeBag)
        
        vehicles.subscribe(onNext: { [weak self] (value) in
            guard let `self` = self else { return }
            self.availableVehicles = value
        }).disposed(by: disposeBag)
        
        selectedIndexPath.subscribe(onNext: { [weak self] (indexPath) in
            guard let `self` = self, let indexPath = indexPath,
                self.destinationTableViewCellData[indexPath.row].isDestinationSelected else { return }
            self.alert.onNext((pString(.alreadySelected), .error))
        }).disposed(by: disposeBag)
        
        resetTaps.subscribe(onNext: { [weak self] () in
            guard let `self` = self else { return }
            self.destinations.removeAll()
            self.availablePlanets = self.planets.value
            self.availableVehicles = self.vehicles.value
            self.destinationTableViewCellData = Array(repeating: DestinationTableViewCellData(), count: 4)
            self.isNextButtonEnabled.accept(self.destinationTableViewCellData.reduce(0) { (result, de) -> Int in return result + (de.isDestinationSelected ? 1 : 0) } == self.destinationTableViewCellData.count)
            self.refreshTableView.onNext(true)
        }).disposed(by: disposeBag)
        
        getPlanets()
        
        getVehicles()
    }
    
    /// Update Available Planets and Vehicles
    func saveDestination(_ destination: Destination) {
        
        destinations.append(destination)
        
        availablePlanets.removeAll(where: { $0.name == destination.planet.name })
        
        if destination.vehicle.total == 1 {
            availableVehicles.removeAll(where: { $0.name == destination.vehicle.name })
        } else {
            let vehicle = destination.vehicle
            let updatedVehicle = Vehicle(name: vehicle.name, total: vehicle.total - 1, distance: vehicle.distance, speed: vehicle.speed)
            guard let index = availableVehicles.firstIndex(of: vehicle) else { return }
            availableVehicles[index] = updatedVehicle
        }
        
        if let indexPath = selectedIndexPath.value {
            destinationTableViewCellData[indexPath.row].updateDestination(destination: destination)
            isNextButtonEnabled.accept(destinationTableViewCellData.reduce(0) { (result, de) -> Int in return result + (de.isDestinationSelected ? 1 : 0) } == destinationTableViewCellData.count)
            refreshTableView.onNext(true)
        }
    }
}

/// Networking
extension HomeViewModel {
    
    /// Get Planets
    func getPlanets() {
        dependencies.api
            .planets()
            .trackActivity(isLoading)
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] (result) in
                guard let `self` = self else { return }
                switch result {
                case .success(let response):
                    plog(response)
                    self.planets.accept(response)
                case .failure:
                    self.alert.onNext((pString(.genericError), .error))
                }
            }).disposed(by: disposeBag)
    }
    
    /// Get Vehicles
    func getVehicles() {
        dependencies.api
            .vehicles()
            .trackActivity(isLoading)
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] (result) in
                guard let `self` = self else { return }
                switch result {
                case .success(let response):
                    plog(response)
                    self.vehicles.accept(response)
                case .failure:
                    self.alert.onNext((pString(.genericError), .error))
                }
            }).disposed(by: disposeBag)
    }
}
