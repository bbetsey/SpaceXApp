//
//  LaunchViewModel.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 25.07.23.
//

import RxSwift
import RxCocoa

protocol LaunchViewModelProtocol {
    var launches: Driver<[LaunchModel]> { get }
}

final class LaunchViewModel: LaunchViewModelProtocol {
    
    private let networkService: NetworkService
    let launches: Driver<[LaunchModel]>
    
    init(rocketID: String, networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
        launches = networkService.get(dataType: [Launch].self, apiRequest: LaunchRequest(rocketID: rocketID))
            .asDriver(onErrorJustReturn: [])
            .map({ launches in
                launches.compactMap { LaunchModel.getLaunchModel(from: $0) }
            })
    }
}
