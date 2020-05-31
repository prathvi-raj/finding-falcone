//
//  AppDependency.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import UIKit

protocol HasWindow {
    var window: UIWindow { get }
}

protocol HasAPI {
    var api: FalconeAPIs { get }
}

class AppDependency: HasWindow, HasAPI {
    
    let window: UIWindow
    let api: FalconeAPIs
    
    init(window: UIWindow) {
        self.window = window
        self.api = FalconeAPIs()
    }
}
