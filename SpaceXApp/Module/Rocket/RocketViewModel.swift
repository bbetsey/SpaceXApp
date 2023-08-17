//
//  RocketViewModel.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 28.07.23.
//

import Foundation
import RxCocoa
import RxSwift

protocol RocketViewModelProtocol {
    var sections: Driver<[RocketSection]> { get }
}

final class RocketViewModel: RocketViewModelProtocol {

    private let rocket: Rocket
    private let networkService: NetworkService
    private let storageService: StorageService
    private let sectionsSubject = BehaviorSubject<[RocketSection]>(value: [])
    private let disposeBag = DisposeBag()
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Appearance.dateFormat
        return formatter
    }()
    private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var sections: Driver<[RocketSection]> {
        sectionsSubject.asDriver(onErrorJustReturn: [])
    }

    init(
        rocket: Rocket,
        networkService: NetworkService = NetworkService(),
        storageService: StorageService = StorageService.shared
    ) {
        self.rocket = rocket
        self.networkService = networkService
        self.storageService = storageService
        setupSections()
        bindSettings()
    }
}

// MARK: - Private Methods
private extension RocketViewModel {

    func bindSettings() {
        storageService.settingsChanged.map { [weak self] in
            self?.makeSections() ?? []
        }
        .bind(to: sectionsSubject)
        .disposed(by: disposeBag)
    }

    func makeSections() -> [RocketSection] {
        [
            makeHeaderSection(),
            RocketSection(type: .horizontal, items: getHorizontalItems()),
            makeGeneralInfoSection(),
            makeInfoSection(forStage: rocket.firstStage, title: Appearance.firstStageTitle),
            makeInfoSection(forStage: rocket.secondStage, title: Appearance.secondStageTitle),
            RocketSection(type: .button, items: [.button])
        ]
    }

    func setupSections() {
        sectionsSubject.onNext(makeSections())
    }

    func makeHeaderSection() -> RocketSection {
        RocketSection(
            type: .header,
            items: [
                .header(title: rocket.rocketName, imageURL: rocket.flickrImages[0])
            ]
        )
    }

    func makeGeneralInfoSection() -> RocketSection {
        RocketSection(
            type: .info(title: nil),
            items: [
                .info(value: dateFormatter.string(from: rocket.firstFlight), description: Appearance.generalTitle1),
                .info(value: rocket.country, description: Appearance.generalTitle2),
                .info(value: formatCost(rocket.costPerLaunch), description: Appearance.generalTitle3)
            ]
        )
    }

    func makeInfoSection(forStage stage: Rocket.Stage, title: String) -> RocketSection {
        RocketSection(
            type: .info(title: title),
            items: [
                .info(value: "\(stage.engines)", description: Appearance.stageTitle1),
                .info(value: "\(stage.fuelAmountTons) \(Appearance.fuelUnit)", description: Appearance.stageTitle2),
                .info(value: "\(stage.burnTimeSec ?? 0) \(Appearance.timeUnit)", description: Appearance.stageTitle3)
            ]
        )
    }

    func getHorizontalItems() -> [RocketItem] {
        let heightSetting = storageService.getSetting(type: .height) ?? Setting(type: .height, selectedIndex: 0)
        let diameterSetting = storageService.getSetting(type: .diameter) ?? Setting(type: .diameter, selectedIndex: 0)
        let weightSetting = storageService.getSetting(type: .weight) ?? Setting(type: .weight, selectedIndex: 0)
        let payloadSetting = storageService.getSetting(type: .payloadWeight) ?? Setting(type: .payloadWeight,
                                                                                          selectedIndex: 0)

        let hightValue = heightSetting.selectedUnit == .meter ? rocket.height.meters : rocket.height.feet
        let diameterValue = diameterSetting.selectedUnit == .meter ? rocket.diameter.meters : rocket.diameter.feet
        let weightValue = weightSetting.selectedUnit == .pound ? rocket.mass.lb : rocket.mass.kg
        let payloadValue = payloadSetting.selectedUnit == .pound
            ? rocket.payloadWeights[0].lb
            : rocket.payloadWeights[0].kg

        return [
            getItem(setting: heightSetting, value: hightValue),
            getItem(setting: diameterSetting, value: diameterValue),
            getItem(setting: weightSetting, value: weightValue),
            getItem(setting: payloadSetting, value: payloadValue)
        ]
    }

    func getItem(setting: Setting, value: Double) -> RocketItem {
        let unit = setting.type.units[setting.selectedIndex]
        let value = numberFormatter.string(from: NSNumber(value: value))
        let description = "\(setting.type.name), \(unit.name)"
        return .info(value: value ?? "nil", description: description)
    }

    func formatCost(_ cost: Int) -> String {
        "$\(cost / Appearance.millionMultiplier) млн"
    }
}

// MARK: - Private Methods
private extension RocketViewModel {
    enum Appearance {
        static let dateFormat = "d MMMM, yyyy"
        static let millionMultiplier = 1000000
        static let firstStageTitle = "ПЕРВАЯ СТУПЕНЬ"
        static let secondStageTitle = "ВТОРАЯ СТУПЕНЬ"
        static let fuelUnit = "ton"
        static let timeUnit = "sec"
        static let generalTitle1 = "Первый запуск"
        static let generalTitle2 = "Страна"
        static let generalTitle3 = "Стоимость запуска"
        static let stageTitle1 = "Количество двигателей"
        static let stageTitle2 = "Количество топлива"
        static let stageTitle3 = "Время сгорания"
    }
}
