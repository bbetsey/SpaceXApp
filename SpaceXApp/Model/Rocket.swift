//
//  Rocket.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 16.07.23.
//

import Foundation

struct Rocket: Decodable {
    let id: Int?
    let height: Size
    let diameter: Size
    let mass: Mass
    let payloadWeights: [PayloadWeight]
    let firstFlight: Date
    let country: String
    let costPerLaunch: Int
    let firstStage: Stage
    let secondStage: Stage
    let flickrImages: [String]
    let rocketName: String
}

extension Rocket {
    struct Stage: Decodable {
        let engines: Int
        let fuelAmountTons: Double
        let burnTimeSec: Int?
    }

    struct Size: Decodable {
        let meters: Double
        let feet: Double
    }

    struct Mass: Decodable {
        let kg: Double
        let lb: Double
    }

    struct PayloadWeight: Decodable {
        let id: String
        let name: String
        let kg: Double
        let lb: Double
    }
}
