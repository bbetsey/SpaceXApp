//
//  StorageService.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 19.07.23.
//

import Foundation

final class StorageService {

    static let shared = StorageService()
    private let userDefaults = UserDefaults.standard
    private let key = "settings"

    private init() {}

}

// MARK: - Public Methods
extension StorageService {
    func setSettings(settings: [Setting]) {
        do {
            let data = try JSONEncoder().encode(settings)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Error encoding settings: \(error)")
        }
    }

    func fetchSettings() -> [Setting] {
        guard let data = userDefaults.data(forKey: key) else { return defaultSettings() }
        do {
            return try JSONDecoder().decode([Setting].self, from: data)
        } catch {
            print("Error decoding settings: \(error)")
            return defaultSettings()
        }
    }
}

// MARK: - Private Methods
private extension StorageService {
    func defaultSettings() -> [Setting] {
        [
            Setting(type: .height, selectedIndex: 1),
            Setting(type: .diameter, selectedIndex: 1),
            Setting(type: .weight, selectedIndex: 0),
            Setting(type: .payloadWieght, selectedIndex: 1)
        ]
    }
}
