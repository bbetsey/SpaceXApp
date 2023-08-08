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
    var rockets: Driver<[Rocket]> { get }
}

final class RocketsViewModel: RocketsViewModelProtocol {

    private let networkService: NetworkService

    lazy var rockets: Driver<[Rocket]> = {
        networkService.fetchRocket()
            .asDriver(onErrorJustReturn: [])
    }()

    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
}
