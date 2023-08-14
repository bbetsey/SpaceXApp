//
//  StorageService.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 19.07.23.
//

import RxSwift
import RxCocoa

final class StorageService {

    static let shared = StorageService()

    private let key = "settings"
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let userDefaults: UserDefaults

    let settingsChanged = PublishRelay<Void>()

    private init() {
        userDefaults = .standard
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
            settingsChanged.accept(())
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
        let data = [
            SettingType.height.name,
            SettingType.diameter.name,
            SettingType.weight.name,
            SettingType.payloadWeight.name
        ].compactMap { userDefaults.data(forKey: $0) }
        do {
            return try data.compactMap { try decoder.decode(Setting.self, from: $0) }
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
            getDefaultSetting(type: .payloadWeight),
        ]
        defaultSettings.forEach(setSetting)
        return defaultSettings
    }

    func getDefaultSetting(type: SettingType) -> Setting {
        Setting(type: type, selectedIndex: 1)
    }
}
