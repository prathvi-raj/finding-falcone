//
//  FindFalconeRequest.swift
//  Finding-Falcone
//
//  Created by Prathvi on 01/06/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation

struct FindFalconeRequest: Codable {
    let token : String
    var planetNames: [String] = []
    var vehicleNames: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case planetNames = "planet_names"
        case vehicleNames = "vehicle_names"
    }
    
    init(token: Token, destinations: [Destination]) {
        self.token = token.token
        destinations.forEach { destination in
            planetNames.append(destination.planet.name)
            vehicleNames.append(destination.vehicle.name)
        }
    }
}
