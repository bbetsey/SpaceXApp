//
//  LaunchModel.swift
//  SpaceXApp
//
//  Created by Антон Тропин on 27.07.23.
//

import UIKit

struct LaunchModel {
    let missionName: String?
    let launchDate: String
    let rocketImage: UIImage?
}

extension LaunchModel {
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
