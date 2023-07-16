//
//  LaunchRequest.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 16.07.23.
//

import Foundation

struct LaunchRequest: APIRequest {
    var parameters: [String : String] = [:]
    let method = RequestType.GET
    let path = "launches"

    init(rocketID: String) {
        parameters["rocket_id"] = rocketID
    }
}
