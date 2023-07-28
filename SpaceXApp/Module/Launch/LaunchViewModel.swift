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
        return networkService.get(dataType: [Launch].self, apiRequest: LaunchRequest(rocketID: rocketID))
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
extension LaunchViewModel {
    private func getLaunchModel(from launch: Launch) -> LaunchModel {
        let launchDate = formatDate(fromUnixTime: launch.launchDateUnix)
        let rocketImage = launch.launchSuccess == nil
            ? UIImage(named: "unknown")
            : UIImage(named: launch.launchSuccess == true ? "success" : "cancel")
        return LaunchModel(missionName: launch.missionName, launchDate: launchDate, rocketImage: rocketImage)
    }

    private func formatDate(fromUnixTime unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        return dateFormatter.string(from: date)
    }
}
