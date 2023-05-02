//
//  MTUserDefaults.swift
//  GridGallery
//
//  Created by Кирилл Демьянцев on 02.05.2023.
//

import Foundation

struct MTUserDefaults {
    
    static var shared = MTUserDefaults()
    
    var theme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .device
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
