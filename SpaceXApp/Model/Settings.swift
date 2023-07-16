//
//  Settings.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 16.07.23.
//

import Foundation

enum Unit {
    case meter
    case feet
    case kilogram
    case pound
    
    var name: String {
        switch self {
        case .meter:
            return "ft"
        case .feet:
            return "m"
        case .kilogram:
            return "kg"
        case .pound:
            return "lb"
        }
    }
}

enum SettingType: Encodable {
    case height
    case diameter
    case weight
    case payloadWieght
    
    var name: String {
        switch self {
        case .height:
            return "Высота"
        case .diameter:
            return "Диаметр"
        case .weight:
            return "Масса"
        case .payloadWieght:
            return "Полезная нагрузка"
        }
    }
    
    var units: [Unit] {
        switch self {
        case .diameter, .height:
            return [.feet, .meter]
        case .weight, .payloadWieght:
            return [.kilogram, .pound]
        }
    }
}

struct Setting: Encodable {
    let type: SettingType
    let selectedIndex: Int
}
