//
//  RocketModel.swift
//  SpaceXApp
//
//  Created by Антон Тропин on 31.07.23.
//

import UIKit

enum RocketSectionType: Int, CaseIterable {
    case header
    case horizontal
    case info
    case button
}

enum RocketItem: Hashable {
    case header(title: String, image: UIImage?)
    case horizontal(value: String, description: String)
    case info(value: String, description: String)
    case button
}

struct RocketSection: Hashable {
    let title: String?
    let type: RocketSectionType
    let items: [RocketItem]
}
