//
//  APIConstants.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation


struct APIConstants {
    
    /// The API's base URL
    static var baseURL: URL {
        return URL(string: "https://findfalcone.herokuapp.com/")!
    }
    
    /// The parameters (Queries) that we're gonna use
    enum Parameters: String {
        case url = "url"
    }
    
    /// The header fields
    enum HttpHeaderField: String {
        case authorization = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    /// The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
}

