//
//  LaunchCollectionViewController.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 25.07.23.
//

import UIKit
import RxSwift
import RxCocoa

final class LaunchCollectionViewController: UICollectionViewController {

    private let launchViewModel: LaunchViewModelProtocol
    private let disposeBag = DisposeBag()
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Appearance.minimumInteritemSpacing
        layout.minimumLineSpacing = Appearance.minimumLineSpacing
        return layout
    }()
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    init(launchViewModel: LaunchViewModelProtocol) {
        self.launchViewModel = launchViewModel
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LaunchCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: view.frame.width - (Appearance.rowLeftMargin * 2), height: Appearance.rowHeight)
    }
}

// MARK: - Private Methods
private extension LaunchCollectionViewController {
    func setupUI() {
        collectionView.register(LaunchCollectionViewCell.self,
                                forCellWithReuseIdentifier: LaunchCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = nil
        collectionView.contentInset = Appearance.contentInset
        collectionView.alwaysBounceVertical = true
        navigationController?.navigationBar.prefersLargeTitles = false
        title = launchViewModel.rocketTitle

        collectionView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }

    func bindViewModel() {
        launchViewModel.launches
            .do(onNext: { [weak self] _ in
                self?.activityIndicator.stopAnimating()
            })
            .drive(
                collectionView.rx.items(cellIdentifier: LaunchCollectionViewCell.reuseIdentifier,
                                        cellType: LaunchCollectionViewCell.self)
            ) { _, launch, cell in
                cell.configure(with: launch)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Appearance Structure
private extension LaunchCollectionViewController {
    enum Appearance {
        static let minimumInteritemSpacing: CGFloat = 64
        static let minimumLineSpacing: CGFloat = 16
        static let rowHeight: CGFloat = 100
        static let rowLeftMargin: CGFloat = 32
        static let contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
}
