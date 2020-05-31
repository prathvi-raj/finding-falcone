//
//  GetString.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation

/**
 Returns the localized string for StringConstantKeys. If the string is not there in the Localizable.plist file. It will crash in Debug mode and will return empty string in Release environment.
 */
public func pString(_ object:StringKeys) -> String {
    return object.rawValue.localized
}
