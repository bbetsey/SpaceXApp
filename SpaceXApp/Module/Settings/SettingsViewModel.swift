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

    private let storageService: StorageService
    private let disposeBag: DisposeBag = DisposeBag()
    private let settinsgSubject: BehaviorSubject<[Setting]>

    var settings: Driver<[Setting]> {
        settinsgSubject.asDriver(onErrorJustReturn: [])
    }

    init(storageService: StorageService = StorageService()) {
        self.storageService = storageService
        settinsgSubject = BehaviorSubject<[Setting]>(value: storageService.fetchSettings())
        bindSettings()
    }

    func updateSettings(at setting: Setting, withSelectedIndex selectedIndex: Int) {
        var currentSettings = getSettings()
        for (index, currentSetting) in currentSettings.enumerated() {
            if currentSetting.type == setting.type {
                currentSettings[index].selectedIndex = selectedIndex
                settinsgSubject.onNext(currentSettings)
                break
            }
        }
    }
}

// MARK: - Private Methods
private extension SettingsViewModel {
    func bindSettings() {
        settings.drive(onNext: self.storageService.setSettings).disposed(by: disposeBag)
    }

    func getSettings() -> [Setting] {
        do {
            return try settinsgSubject.value()
        } catch {
            print("Error getting settings: \(error)")
            return []
        }
    }
}
