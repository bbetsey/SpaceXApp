//
//  RocketViewModel.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 28.07.23.
//

import Foundation
import RxCocoa

protocol RocketViewModelProtocol {
    var rocket: Rocket { get }
    var rocketImage: Driver<UIImage?> { get }
    func getSections() -> [RocketSection]
}

final class RocketViewModel: RocketViewModelProtocol {

    private let networkService: NetworkService
    let rocket: Rocket

    lazy var rocketImage: Driver<UIImage?> = {
        networkService.fetchImage(from: rocket.flickrImages?[1])
            .asDriver(onErrorJustReturn: nil)
    }()

    init(rocket: Rocket, networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
        self.rocket = rocket
    }

}

// MARK: - Private Methods
private extension RocketViewModel {
    func getValue(by setting: Setting) -> Float? {
        switch setting.type {
        case .height:
            return setting.type.units[setting.selectedIndex] == .meter ? rocket.height?.meters : rocket.height?.feet
        case .diameter:
            return setting.type.units[setting.selectedIndex] == .meter ? rocket.diameter?.meters : rocket.diameter?.feet
        case .weight:
            return setting.type.units[setting.selectedIndex] == .kilogram ? rocket.mass?.kg : rocket.mass?.lb
        case .payloadWieght:
            return setting.type.units[setting.selectedIndex] == .kilogram ? rocket.payloadWeights?[0].kg : rocket.payloadWeights?[0].lb
        }
    }
}

// MARK: - Public Methods
extension RocketViewModel {
    func getSections() -> [RocketSection] {
        [
            RocketSection(
                title: nil,
                type: .header,
                items: [
                    .header(title: "Falcon 9", image: UIImage(named: "rocket"))
                ]
            ),
            RocketSection(
                title: nil,
                type: .horizontal,
                items: [
                    .info(value: "221", description: "Высота"),
                    .info(value: "237", description: "Длина"),
                    .info(value: "249", description: "Ширина"),
                    .info(value: "245", description: "Масса")
                ]
            )
        ]
    }
}
