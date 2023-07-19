//
//  RocketsViewController.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 11.07.23.
//

import UIKit
import RxSwift

final class RocketsPageViewController: UIPageViewController {

    //MARK: - Subviews
    private var viewOne: RocketViewController = {
        let vc = RocketViewController()
        vc.view.backgroundColor = .cyan
        return vc
    }()

    private var viewTwo: RocketViewController = {
        let vc = RocketViewController()
        vc.view.backgroundColor = .green
        return vc
    }()

    private var viewThree: RocketViewController = {
        let vc = RocketViewController()
        vc.view?.backgroundColor = .blue
        return vc
    }()

    // MARK: - Private Properties
    private var views = [RocketViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Private Methods
private extension RocketsPageViewController {
    private func setup() {
        dataSource = self
        views = [viewOne, viewTwo, viewThree]
        setViewControllers([views[0]], direction: .forward, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource
extension RocketsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let rocketVC = viewController as? RocketViewController,
                let currentIndex = views.firstIndex(of: rocketVC)
        else { return nil }

        if currentIndex == 0 {
            return nil
        } else {
            return views[currentIndex - 1]
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let rocketVC = viewController as? RocketViewController,
              let currentIndex = views.firstIndex(of: rocketVC)
        else { return nil }

        if currentIndex == views.count - 1 {
            return nil
        } else {
            return views[currentIndex + 1]
        }
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        views.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
}
