//
//  Launch.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 16.07.23.
//

import Foundation


struct Launch: Decodable {
    let missionName: String?
    let launchDateUnix: Int?
    let launchSuccess: Bool?
}
