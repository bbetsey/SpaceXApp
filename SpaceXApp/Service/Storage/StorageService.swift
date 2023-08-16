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

    func getSetting(type: SettingType) -> Setting? {
        guard let setting = userDefaults.data(forKey: type.name) else {
            return nil
        }
        do {
            return try decoder.decode(Setting.self, from: setting)
        } catch {
            print("Error decoding settings: \(error)")
            return nil
        }
    }
}
