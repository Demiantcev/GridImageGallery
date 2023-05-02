//
//  Theme.swift
//  GridGallery
//
//  Created by Кирилл Демьянцев on 02.05.2023.
//

import UIKit

enum Theme: Int {
    case device
    case light
    case dark
    
    func getUserInterStyle() -> UIUserInterfaceStyle {
        switch self {
        case .device:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
