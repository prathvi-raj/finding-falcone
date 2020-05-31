//
//  APIRouterType.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRouterType: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}
