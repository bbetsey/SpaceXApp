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

    private lazy var pageControl: UIPageControl = {
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .systemGray
        pageControl.backgroundColor = .black
        pageControl.numberOfPages = views.count
        pageControl.currentPage = initialPage
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        return pageControl
    }()

    // MARK: - Private Properties
    private var views = [RocketViewController]()
    private let initialPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
}

// MARK: - Private Methods
extension RocketsPageViewController {

    private func setup() {
        dataSource = self
        delegate = self

        views = [viewOne, viewTwo, viewThree]
        setViewControllers([views[initialPage]], direction: .forward, animated: true)
    }

    private func layout() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 3)
        ])
    }

    @objc func pageControlTapped(_ sender: UIPageControl) {
        sender.tag < sender.currentPage
            ? setViewControllers([views[sender.currentPage]], direction: .forward, animated: true)
            : setViewControllers([views[sender.currentPage]], direction: .reverse, animated: true)

        pageControl.tag = sender.currentPage
    }
}

// MARK: - UIPageViewControllerDataSource
extension RocketsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let rocketVC = viewController as? RocketViewController else { return nil }
        guard let currentIndex = views.firstIndex(of: rocketVC) else { return nil }

        if currentIndex == 0 {
            return nil
        } else {
            return views[currentIndex - 1]
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let rocketVC = viewController as? RocketViewController else { return nil }
        guard let currentIndex = views.firstIndex(of: rocketVC) else { return nil }

        if currentIndex == views.count - 1 {
            return nil
        } else {
            return views[currentIndex + 1]
        }
    }
}

// MARK: - UIPageViewControllerDelegate
extension RocketsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard let viewControllers = pageViewController.viewControllers as? [RocketViewController] else { return }
        guard let currentIndex = views.firstIndex(of: viewControllers[0]) else { return }
        pageControl.currentPage = currentIndex
    }
}
