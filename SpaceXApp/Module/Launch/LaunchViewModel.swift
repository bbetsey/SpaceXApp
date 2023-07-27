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
            .map { launches in
                launches.compactMap { LaunchViewModel.getLaunchModel(from: $0) }
            }
    }
}

// MARK: - Static Methods
extension LaunchViewModel {
    static func getLaunchModel(from launch: Launch) -> LaunchModel {
        let missionName = launch.missionName
        let launchDate = formatDate(fromUnixTime: launch.launchDateUnix)

        guard let launchStatus = launch.launchSuccess else {
            let rocketImage = UIImage(named: "unknown")
            return LaunchModel(missionName: missionName, launchDate: launchDate, rocketImage: rocketImage)
        }

        let rocketImage = UIImage(named: launchStatus ? "success" : "cancel")
        return LaunchModel(missionName: missionName, launchDate: launchDate, rocketImage: rocketImage)
    }

    static func formatDate(fromUnixTime unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM, yyyy"
        return formatter.string(from: date)
    }
}
