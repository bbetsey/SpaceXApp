//
//  LaunchRequest.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 16.07.23.
//

import Foundation

struct LaunchRequest: APIRequest {
    let parameters: [String : String]
    var method: RequestType { .GET }
    var path: String { "launches" }

    init(rocketID: String) {
        parameters = ["rocket_id": rocketID]
    }
}
