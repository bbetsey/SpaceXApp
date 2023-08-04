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
    func updateSettings()
}

final class RocketViewModel: RocketViewModelProtocol {

    private let rocket: Rocket
    private let networkService: NetworkService
    private let storageService: StorageService
    private let sectionsSubject: BehaviorSubject<[RocketSection]>
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

    private lazy var settings: [Setting] = {
        storageService.fetchSettings()
    }()

    var sections: Driver<[RocketSection]> {
        sectionsSubject.asDriver(onErrorJustReturn: [])
    }

    init(
        rocket: Rocket,
        networkService: NetworkService = NetworkService(),
        storageService: StorageService = StorageService()
    ) {
        self.rocket = rocket
        self.networkService = networkService
        self.storageService = storageService
        self.sectionsSubject = BehaviorSubject(value: [])
        setup()
    }

    func updateSettings() {
        settings = storageService.fetchSettings()
        setup()
    }

}

// MARK: - Private Methods
private extension RocketViewModel {

    func setup() {
        if let images = rocket.flickrImages, !images.isEmpty {
            networkService.fetchImage(from: images.last)
                .asDriver(onErrorJustReturn: nil)
                .drive { [weak self] image in
                    self?.setupSections(withImage: image)
                }
                .disposed(by: disposeBag)
        }
    }

    func setupSections(withImage image: UIImage?) {
        var rocketSections = [RocketSection]()
        rocketSections.append(RocketSection(title: nil, type: .header, items: [.header(title: self.rocket.rocketName, image: image)]))
        rocketSections.append(RocketSection(title: nil, type: .horizontal, items: getParameters()))
        rocketSections.append(RocketSection(title: nil, type: .info, items: getGeneralInfo()))
        addStages(to: &rocketSections)
        rocketSections.append(RocketSection(title: nil, type: .button, items: [.button]))
        sectionsSubject.onNext(rocketSections)
    }

    func addStages(to sections: inout [RocketSection]) {
        if let firstStage = rocket.firstStage {
            sections.append(
                RocketSection(title: Appearance.firstStageTitle, type: .info, items: getStage(stage: firstStage))
            )
        }
        if let secondStage = rocket.secondStage {
            sections.append(
                RocketSection(title: Appearance.secondStageTitle, type: .info, items: getStage(stage: secondStage))
            )
        }
    }

    func getParameters() -> [RocketItem] {
        var parameters = [RocketItem]()
        settings.forEach { setting in
            switch setting.type {
            case .height:
                parameters.append(getParameterItem(setting: setting, measureValue: rocket.height))
            case .diameter:
                parameters.append(getParameterItem(setting: setting, measureValue: rocket.diameter))
            case .weight:
                parameters.append(getParameterItem(setting: setting, measureValue: rocket.mass))
            case .payloadWieght:
                if let payloadWeight = rocket.payloadWeights.first {
                    parameters.append(getParameterItem(setting: setting, measureValue: payloadWeight))
                }
            }
        }
        return parameters
    }

    func getParameterItem<M: Measure>(setting: Setting, measureValue: M) -> RocketItem {
        let unit = setting.type.units[setting.selectedIndex]
        let value: String?
        switch unit {
        case .meter:
            value = numberFormatter.string(from: NSNumber(value: measureValue.meters))
        case .feet:
            value = numberFormatter.string(from: NSNumber(value: measureValue.feet))
        case .kilogram:
            value = numberFormatter.string(from: NSNumber(value: measureValue.kg))
        case .pound:
            value = numberFormatter.string(from: NSNumber(value: measureValue.lb))
        }
        let description = "\(setting.type.name), \(unit.name)"
        return .info(value: value, description: description)
    }

    func getGeneralInfo() -> [RocketItem] {
        [
            .info(value: dateFormatter.string(from: rocket.firstFlight), description: Appearance.generalTitle1),
            .info(value: rocket.country, description: Appearance.generalTitle2),
            .info(value: formatCost(rocket.costPerLaunch), description: Appearance.generalTitle3),
        ]
    }

    func getStage(stage: Rocket.Stage) -> [RocketItem] {
        [
            .info(value: "\(stage.engines)", description: Appearance.stageTitle1),
            .info(value: "\(stage.fuelAmountTons) \(Appearance.fuelUnit)", description: Appearance.stageTitle2),
            .info(value: "\(stage.burnTimeSec ?? 0) \(Appearance.timeUnit)", description: Appearance.stageTitle3),
        ]
    }

    private func formatCost(_ cost: Int) -> String {
        return "$\(cost / Appearance.millionMultiplier) млн"
    }

}

// MARK: - Private Methods
private extension RocketViewModel {
    struct Appearance {
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
