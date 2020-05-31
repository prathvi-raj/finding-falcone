//
//  String+Localized.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation

let kNotificationLanguageChanged        = NSNotification.Name(rawValue:"kNotificationLanguageChanged")

public func SetLanguage(language:String) -> Bool {
    return Localizator.shared.setLanguage(language)
}

private class Localizator {
    
    // MARK: - Private properties
    private let userDefaults                            =   UserDefaults.standard
    private var availableLanguagesArray:[String]        =   Bundle.main.localizations
    private var localizedDictionary:NSDictionary!
    
    private let kSaveLanguageDefaultKey                 =   "kSaveLanguageDefaultKey"
    
    // MARK: - Public properties
    var currentLanguage:String?                         =   Bundle.main.localizations.first
    
    
    // MARK: - Public computed properties
    var saveInUserDefaults:Bool {
        get {
            return (userDefaults.object(forKey: kSaveLanguageDefaultKey) != nil)
        }
        set {
            if newValue {
                userDefaults.set(currentLanguage, forKey: kSaveLanguageDefaultKey)
            } else {
                userDefaults.removeObject(forKey: kSaveLanguageDefaultKey)
            }
            userDefaults.synchronize()
        }
    }
    
    
    // MARK: - Singleton method
    static let shared = Localizator()
    
    // MARK: - Init method
    private init() {
        
        guard let languageSaved = userDefaults.object(forKey: kSaveLanguageDefaultKey) as? String else {
            
            if let baseLanguage = self.availableLanguagesArray.first {
                
                if self.loadDictionaryForLanguage(baseLanguage) {
                    return
                }
                return
            }
            
            if self.loadDictionaryForLanguage("Base") {
                return
            }
            return
        }
        
        if self.loadDictionaryForLanguage(languageSaved) {
            return
        }
    }
    
    
    // MARK: - Private instance methods
    fileprivate func loadDictionaryForLanguage(_ newLanguage:String) -> Bool {
        // pxlog("Language: \(newLanguage)")
        
        if !availableLanguagesArray.contains(newLanguage) {
            return false
        }
        
        if let path = Bundle.main.url(forResource: "Localizable", withExtension: "plist", subdirectory: nil, localization: newLanguage)?.path {
            if FileManager.default.fileExists(atPath: path) {
                currentLanguage = newLanguage
                localizedDictionary = NSDictionary(contentsOfFile: path)
                return true
            }
        }
        
        
        
        return false
    }
    
    fileprivate func setLanguage(_ newLanguage:String) -> Bool {
        
        if (newLanguage == currentLanguage) || !availableLanguagesArray.contains(newLanguage) {
            return false
        }
        
        if loadDictionaryForLanguage(newLanguage) {
            NotificationCenter.default.post(name: kNotificationLanguageChanged, object: nil)
            if saveInUserDefaults {
                userDefaults.set(currentLanguage, forKey: kSaveLanguageDefaultKey)
                userDefaults.synchronize()
            }
            return true
        }
        
        return false
    }
    
    func localize(key: String) -> String {
        
        guard let localizedDictionary = localizedDictionary else {
            return String() // Fix this.
        }
        
        guard let localizedString =  (localizedDictionary.value(forKey: key) as? NSDictionary)?.value(forKey: "value") as? String else {
            
            return String() // Fix this.
        }
        
        return localizedString
    }
}

extension String {
    var localized: String {
        return Localizator.shared.localize(key: self)
    }
}
