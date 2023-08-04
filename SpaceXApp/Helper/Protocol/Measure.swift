//
//  Measure.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 04.08.23.
//

import Foundation

protocol Measure {
    var kg: Float { get }
    var lb: Float { get }
    var meters: Float { get }
    var feet: Float { get }
}

extension Rocket.Mass: Measure {
    var meters: Float { 0 }
    var feet: Float { 0 }
}

extension Rocket.Size: Measure {
    var kg: Float { 0 }
    var lb: Float { 0 }
}

extension Rocket.PayloadWeight: Measure {
    var meters: Float { 0 }
    var feet: Float { 0 }
}
