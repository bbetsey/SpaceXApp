//
//  RocketsViewModel.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 29.07.23.
//

import Foundation
import RxSwift
import RxCocoa

protocol RocketsViewModelProtocol {
    var rockets: Driver<[RocketViewController]> { get }
}

final class RocketsViewModel: RocketsViewModelProtocol {

    private let networkService: NetworkService

    lazy var rockets: Driver<[RocketViewController]> = {
        networkService.fetchData(dataType: [Rocket].self, apiRequest: RocketsRequest())
            .asDriver(onErrorJustReturn: [])
            .map { [weak self] rockets in
                rockets.compactMap { self?.getRocketViewController(from: $0) }
            }
    }()

    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
}

//MARK: - Private Methods
private extension RocketsViewModel {
    func getRocketViewController(from rocket: Rocket) -> RocketViewController {
        let rocketViewModel = RocketViewModel(rocket: rocket)
        return RocketViewController(viewModel: rocketViewModel)
    }
}
