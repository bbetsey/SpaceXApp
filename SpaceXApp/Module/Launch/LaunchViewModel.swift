//
//  LaunchViewModel.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 25.07.23.
//

import RxSwift
import RxCocoa

protocol LaunchViewModelProtocol {
    var launches: Driver<[Launch]> { get }
    func prepareLaunchForCell(launch: Launch) -> LaunchModel
}

struct LaunchModel {
    let missionName: String?
    let launchDate: String
    let rocketImage: UIImage?
    let statusImage: UIImage?
}

final class LaunchViewModel: LaunchViewModelProtocol {
    
    private let networkService: NetworkService
    let launches: Driver<[Launch]>

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM, yyyy"
        return formatter
    }()
    
    init(rocketID: String, networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
        launches = networkService.get(dataType: [Launch].self, apiRequest: LaunchRequest(rocketID: rocketID))
            .asDriver(onErrorJustReturn: [])
    }

    func prepareLaunchForCell(launch: Launch) -> LaunchModel {
        let rocketImage = launch.launchSuccess ?? true
            ? UIImage(named: "rocket")
            : UIImage(named: "rocket-reverse")
        let statusImage = launch.launchSuccess ?? true
            ? UIImage(named: "success")
            : UIImage(named: "cancel")
        return LaunchModel(
            missionName: launch.missionName,
            launchDate: formatDate(fromUnixTime: launch.launchDateUnix),
            rocketImage: rocketImage,
            statusImage: statusImage
        )
    }
}

// MARK: - Private Methods
private extension LaunchViewModel {
    func formatDate(fromUnixTime unixTime: Int?) -> String {
        guard let unixTime = unixTime else { return "nil" }
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        return dateFormatter.string(from: date)
    }
}
