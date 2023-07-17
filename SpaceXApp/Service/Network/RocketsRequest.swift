//
//  RocketsRequest.swift
//  SpaceXApp
//
//  Created by Антон Тропин on 16.07.23.
//

import Foundation

struct RocketsRequest: APIRequest {
    var parameters: [String : String] { [:] }
    var method: RequestType { .GET }
    var path: String { "rockets" }
}
