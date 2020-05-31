//
//  Destination.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation

struct Destination: Equatable {
    let planet: Planet
    let vehicle: Vehicle
    
    var timeTaken: Int {
        planet.distance / vehicle.speed
    }
}
