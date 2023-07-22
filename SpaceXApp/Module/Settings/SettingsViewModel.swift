//
//  SettingsViewModel.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 21.07.23.
//

import Foundation
import RxSwift

protocol SettingsViewModelProtocol {
    var settings: BehaviorSubject<[Setting]> { get }
    func getSettings() -> [Setting]?
    func updateSettings(at index: Int, withSelectedIndex selectedIndex: Int)
}

final class SettingsViewModel: SettingsViewModelProtocol {

    private let storageService: StorageService
    private let disposeBag: DisposeBag = DisposeBag()
    lazy var settings: BehaviorSubject<[Setting]> = {
        BehaviorSubject<[Setting]>(value: storageService.fetchSettings())
    }()

    init(storageService: StorageService = .shared) {
        self.storageService = storageService
        bindSettings()
    }

}

// MARK: - Private Methods
private extension SettingsViewModel {
    func bindSettings() {
        settings.subscribe { newValue in
            self.storageService.setSettings(settings: newValue)
        }.disposed(by: disposeBag)
    }
}

// MARK: - SettingsViewModelProtocol
extension SettingsViewModel {
    func getSettings() -> [Setting]? {
        do {
            return try settings.value()
        } catch {
            print("Error getting settings: \(error)")
            return nil
        }
    }

    func updateSettings(at index: Int, withSelectedIndex selectedIndex: Int) {
        guard var curSettings = getSettings(), curSettings.indices.contains(index) else {
            print("Invalid index")
            return
        }
        curSettings[index].selectedIndex = selectedIndex
        settings.onNext(curSettings)
    }
}
