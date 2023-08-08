//
//  StorageService.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 19.07.23.
//

import Foundation

final class StorageService {
    private let key = "settings"
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }
}

// MARK: - Public Methods
extension StorageService {

    func setSetting(setting: Setting) {
        do {
            let data = try encoder.encode(setting)
            userDefaults.set(data, forKey: setting.type.name)
        } catch {
            print("Error encoding settings: \(error)")
        }
    }

    func fetchSetting(type: SettingType) -> Setting {
        guard let setting = userDefaults.data(forKey: type.name) else {
            return getDefaultSetting(type: type)
        }
        do {
            return try decoder.decode(Setting.self, from: setting)
        } catch {
            print("Error decoding settings: \(error)")
            return getDefaultSetting(type: type)
        }

    }

    func fetchSettings() -> [Setting] {
        guard let height = userDefaults.data(forKey: SettingType.height.name),
              let diameter = userDefaults.data(forKey: SettingType.diameter.name),
              let weight = userDefaults.data(forKey: SettingType.weight.name),
              let payloadWeight = userDefaults.data(forKey: SettingType.payloadWieght.name) else {
            return setDefaultSettings()
        }
        do {
            return [
                try decoder.decode(Setting.self, from: height),
                try decoder.decode(Setting.self, from: diameter),
                try decoder.decode(Setting.self, from: weight),
                try decoder.decode(Setting.self, from: payloadWeight),
            ]
        } catch {
            print("Error decoding settings: \(error)")
            return setDefaultSettings()
        }
    }
}

// MARK: - Private Methods
private extension StorageService {
    func setDefaultSettings() -> [Setting] {
        let defaultSettings = [
            getDefaultSetting(type: .height),
            getDefaultSetting(type: .diameter),
            getDefaultSetting(type: .weight),
            getDefaultSetting(type: .payloadWieght),
        ]
        defaultSettings.forEach(setSetting)
        return defaultSettings
    }

    func getDefaultSetting(type: SettingType) -> Setting {
        Setting(type: type, selectedIndex: 1)
    }
}
