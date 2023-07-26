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
    private let rocketTitle: String
    private let disposeBag = DisposeBag()

    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 64
        layout.minimumLineSpacing = 16
        return layout
    }()

    init(launchViewModel: LaunchViewModelProtocol, rocketTitle: String) {
        self.rocketTitle = rocketTitle
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - (Appearance.rowLeftMargin * 2), height: Appearance.rowHeight)
    }
}

// MARK: - Private Methods
private extension LaunchCollectionViewController {
    func setupUI() {
        collectionView!.register(LaunchCollectionViewCell.self, forCellWithReuseIdentifier: LaunchCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = nil
        collectionView.contentInset = Appearance.contentInset
        collectionView.alwaysBounceVertical = true
        navigationController?.navigationBar.prefersLargeTitles = false
        title = rocketTitle
    }

    func bindViewModel() {
        launchViewModel.launches
            .drive(
                collectionView.rx.items(
                    cellIdentifier: LaunchCollectionViewCell.reuseIdentifier,
                    cellType: LaunchCollectionViewCell.self
                )
            ) { row, launch, cell in
                cell.configure(with: launch)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Appearance
private extension LaunchCollectionViewController {
    struct Appearance {
        static let rowHeight: CGFloat = 100
        static let rowLeftMargin: CGFloat = 32
        static let contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
}
