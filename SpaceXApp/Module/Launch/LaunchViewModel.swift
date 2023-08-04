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
    var rocketTitle: String { get }
}

final class LaunchViewModel: LaunchViewModelProtocol {
    
    private let networkService: NetworkService
    private let rocketID: String
    let rocketTitle: String

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, yyyy"
        return formatter
    }()

    lazy var launches: Driver<[LaunchModel]> = {
        networkService.fetchData(dataType: [Launch].self, apiRequest: LaunchRequest(rocketID: rocketID), dateFormatterType: .long)
            .asDriver(onErrorJustReturn: [])
            .map { [weak self] launches in
                launches.compactMap { self?.getLaunchModel(from: $0) }
            }
    }()
    
    init(rocketID: String, rocketTitle: String, networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
        self.rocketTitle = rocketTitle
        self.rocketID = rocketID
    }
}

// MARK: - Private Methods
private extension LaunchViewModel {
    func getLaunchModel(from launch: Launch) -> LaunchModel {
        let launchDate = dateFormatter.string(from: launch.launchDateUtc)
        let rocketImage: UIImage?

        if launch.launchSuccess == nil {
            rocketImage = UIImage(named: "unknown")
        } else if launch.launchSuccess == true {
            rocketImage = UIImage(named: "success")
        } else {
            rocketImage = UIImage(named: "cancel")
        }
        return LaunchModel(missionName: launch.missionName, launchDate: launchDate, rocketImage: rocketImage)
    }
}
