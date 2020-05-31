//
//  Vehicle.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation

struct Vehicle: Codable, Equatable, Hashable {
    let name: String
    let total: Int
    let distance: Int
    let speed: Int

    var displayName: String {
        "\(name) (\(total))"
    }
    
    enum CodingKeys: String, CodingKey {
        case name, speed
        case total = "total_no"
        case distance = "max_distance"
    }
}
