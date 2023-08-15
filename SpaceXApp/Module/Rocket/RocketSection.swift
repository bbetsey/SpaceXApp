//
//  RocketModel.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 31.07.23.
//

import UIKit

enum RocketSectionType: Hashable {
    case header
    case horizontal
    case info(title: String?)
    case button
}

enum RocketItem: Hashable {
    case header(title: String, imageURL: URL?)
    case info(value: String, description: String, uuid: UUID = UUID())
    case button
}

struct RocketSection: Hashable {
    let type: RocketSectionType
    let items: [RocketItem]
}
