//
//  RocketsViewController.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 11.07.23.
//

import UIKit
import RxSwift

final class RocketsPageViewController: UIPageViewController {

    // MARK: - Private Properties
    private var views = [RocketViewController]()
    private let disposeBag = DisposeBag()
    private let viewModel: RocketsViewModelProtocol

    init(viewModel: RocketsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
    }
}

// MARK: - Private Methods
private extension RocketsPageViewController {
    func setup() {
        dataSource = self
    }

    func bindViewModel() {
        viewModel.rockets
            .drive { [weak self] rockets in
                guard let self = self, rockets.count > 0 else { return }
                self.views = rockets.compactMap { rocket in
                    let rocketViewModel = RocketViewModel(rocket: rocket)
                    return RocketViewController(viewModel: rocketViewModel)
                }
                self.setViewControllers([self.views[0]], direction: .forward, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UIPageViewControllerDataSource
extension RocketsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let rocketVC = viewController as? RocketViewController,
              let currentIndex = views.firstIndex(of: rocketVC) else { return nil }

        return currentIndex == 0 ? nil : views[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let rocketVC = viewController as? RocketViewController,
              let currentIndex = views.firstIndex(of: rocketVC) else { return nil }

        return (currentIndex == views.count - 1) ? nil : views[currentIndex + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        views.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
}
