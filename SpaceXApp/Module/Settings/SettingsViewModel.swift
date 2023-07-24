//
//  SettingsViewModel.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 21.07.23.
//

import Foundation
import RxSwift
import RxCocoa

protocol SettingsViewModelProtocol {
    var settings: Driver<[Setting]> { get }
    func updateSettings(at setting: Setting, withSelectedIndex selectedIndex: Int)
}

final class SettingsViewModel: SettingsViewModelProtocol {

    private let disposeBag = DisposeBag()
    private let storageService: StorageService
    private let settingsSubject: BehaviorSubject<[Setting]>

    var settings: Driver<[Setting]> {
        settingsSubject.asDriver(onErrorJustReturn: [])
    }

    init(storageService: StorageService = StorageService()) {
        self.storageService = storageService
        settingsSubject = BehaviorSubject<[Setting]>(value: storageService.fetchSettings())
    }

    func updateSettings(at setting: Setting, withSelectedIndex selectedIndex: Int) {
        var currentSettings = storageService.fetchSettings()
        for (index, currentSetting) in currentSettings.enumerated() {
            if currentSetting.type == setting.type {
                currentSettings[index].selectedIndex = selectedIndex
                storageService.setSettings(settings: currentSettings)
                break
            }
        }
    }
}
