//
//  Result.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation

struct Result: Codable, Equatable, Hashable {
    let status: String
    let planetName: String?

    var isSuccess: Bool {
        return status == "success"
    }
    
    var displayName: String? {
        return planetName != nil ? "Planet : \(planetName!)" : nil
    }
    
    
    
    enum CodingKeys: String, CodingKey {
        case status
        case planetName = "planet_name"
    }
}
