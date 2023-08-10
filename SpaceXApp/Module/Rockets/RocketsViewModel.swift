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
    private let rocketSubject = BehaviorSubject<[Rocket]>(value: [])
    private let disposeBag = DisposeBag()

    var rockets: Driver<[Rocket]> { rocketSubject.asDriver(onErrorJustReturn: []) }

    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
        getRockets()
    }
}

// MARK: - Private Methods
private extension RocketsViewModel {
    func getRockets() {
        networkService.fetchRocket()
            .subscribe { [weak self] rockets in
                self?.rocketSubject.onNext(rockets)
            }
            .disposed(by: disposeBag)
    }
}
