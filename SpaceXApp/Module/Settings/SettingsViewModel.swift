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

    init(storageService: StorageService = StorageService.shared) {
        self.storageService = storageService
        let settings = [
            storageService.getSetting(type: .height) ?? Setting(type: .height, selectedIndex: 0),
            storageService.getSetting(type: .diameter) ?? Setting(type: .diameter, selectedIndex: 0),
            storageService.getSetting(type: .weight) ?? Setting(type: .weight, selectedIndex: 0),
            storageService.getSetting(type: .payloadWeight) ?? Setting(type: .payloadWeight, selectedIndex: 0)
        ]
        settingsSubject = BehaviorSubject<[Setting]>(value: settings)
    }

    func updateSettings(at setting: Setting, withSelectedIndex selectedIndex: Int) {
        var currentSetting = setting
        currentSetting.selectedIndex = selectedIndex
        storageService.setSetting(setting: currentSetting)
    }
}
