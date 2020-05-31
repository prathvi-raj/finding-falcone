//
//  Encodable+Dictionary.swift
//  Finding-Falcone
//
//  Created by Prathvi on 01/06/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
