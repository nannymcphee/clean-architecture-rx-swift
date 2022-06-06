//
//  Preferences.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 19/05/2022.
//

import Foundation

let Preferences = UserDefaults.standard

class Defaults {
    fileprivate init() {}
}

class DefaultsKey<ValueType>: Defaults {
    let key: String
    let defaultValue: ValueType

    init(_ key: String, _ defaultValue: ValueType) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

extension UserDefaults {
    subscript(key: DefaultsKey<Bool>) -> Bool {
        get {
            if let value = value(forKey: key.key) as? Bool {
                return value
            } else {
                return key.defaultValue
            }
        }
        set { set(newValue, forKey: key.key) }
    }
    
    subscript(key: DefaultsKey<String>) -> String {
        get { return string(forKey: key.key) ?? key.defaultValue }
        set { set(newValue, forKey: key.key) }
    }
    
    subscript(key: DefaultsKey<Int>) -> Int {
        get {
            if let value = value(forKey: key.key) as? Int {
                return value
            } else {
                return key.defaultValue
            }
        }
        set { set(newValue, forKey: key.key) }
    }
}

extension Defaults {
    static let lastTabIndex = DefaultsKey<Int>("lastTabIndex", 0)
    static let lastVisitedMovieList = DefaultsKey<Int>("lastVisitedMovieList", 0)
    static let lastVisitedFavorites = DefaultsKey<Int>("lastVisitedFavorites", 0)
    static let didSaveDefaultMovies = DefaultsKey<Bool>("didSaveDefaultMovies", false)
}
