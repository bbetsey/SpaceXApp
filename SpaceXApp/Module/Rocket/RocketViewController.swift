//
//  RocketViewController.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 18.07.23.
//

import UIKit
import RxSwift

final class RocketViewController: UIViewController {

    typealias RocketDataSource = UICollectionViewDiffableDataSource<RocketSection, RocketItem>

    private let viewModel: RocketViewModelProtocol
    private let disposeBag = DisposeBag()
    private lazy var collectionView: UICollectionView = {
        let layout = makeCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGray4
        return indicator
    }()
    private lazy var dataSource: RocketDataSource = {
        let dataSource = makeDataSource()
        dataSource.supplementaryViewProvider = makeSupplementaryViewProvider()
        return dataSource
    }()

    init(viewModel: RocketViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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

// MARK: - Private Methods
private extension RocketViewController {

    func bindViewModel() {
        viewModel.sections
            .drive { [weak self] sections in
                self?.activityIndicator.stopAnimating()
                self?.applySnapshot(sections: sections)
            }
            .disposed(by: disposeBag)
    }

    func setupUI() {
        view.backgroundColor = .systemBackground
        [collectionView, activityIndicator].forEach(view.addSubview)
        [collectionView, activityIndicator].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        activityIndicator.startAnimating()

        collectionView.register(HorizontalCollectionViewCell.self,
                                forCellWithReuseIdentifier: HorizontalCollectionViewCell.reuseIdentifier)
        collectionView.register(HeaderCollectionViewCell.self,
                                forCellWithReuseIdentifier: HeaderCollectionViewCell.reuseIdentifier)
        collectionView.register(InfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: InfoCollectionViewCell.reuseIdentifier)
        collectionView.register(ButtonCollectionViewCell.self,
                                forCellWithReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier)
    }
}

// MARK: - CollectionViewCompositionalLayout
private extension RocketViewController {
    func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _  in
            guard let self else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch section.type {
            case .header:
                return self.makeHeaderViewLayout()
            case .horizontal:
                return self.makeHorizontalSection()
            case let .info(title):
                guard let _ = title else { return self.makeInfoSection(withHeader: false) }
                return self.makeInfoSection(withHeader: true)
            case .button:
                return self.makeButtonSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Appearance.interSectionSpacing
        layout.configuration = config
        return layout
    }

    func makeHeaderViewLayout() -> NSCollectionLayoutSection {
        let itemSize = Appearance.headerItemSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(view.frame.height / 2)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func makeHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = Appearance.horizontalItemSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = Appearance.horizontalItemInsets
        let groupSize = Appearance.horizontalGroupSize
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Appearance.horizontalSectionInsets
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

    func makeInfoSection(withHeader: Bool) -> NSCollectionLayoutSection {
        let itemSize = Appearance.infoItemSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = Appearance.infoGroupSize
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        if withHeader {
            let headerElement = Appearance.sectionHeaderElement
            section.boundarySupplementaryItems = [headerElement]
        }
        return section
    }

    func makeButtonSection() -> NSCollectionLayoutSection {
        let itemSize = Appearance.buttonItemSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = Appearance.buttonGroupSize
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

}

// MARK: - CollectionViewDataSource
private extension RocketViewController {
    func applySnapshot(sections: [RocketSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<RocketSection, RocketItem>()
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func makeDataSource() -> RocketDataSource {
        .init(collectionView: collectionView) { [weak self] collectionView, indexPath, rocketItem in
            guard let self else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch rocketItem {
            case let .header(title, imageURL):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HeaderCollectionViewCell.reuseIdentifier, for: indexPath
                ) as? HeaderCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(title: title, imageURL: imageURL) {
                    let settingsViewModel = SettingsViewModel()
                    let settingsViewController = SettingsTableViewController(settingsViewModel: settingsViewModel)
                    let navigationController = UINavigationController(rootViewController: settingsViewController)
                    self.present(navigationController, animated: true)
                }
                return cell
            case let .info(value, description, _):
                if section.type == .horizontal {
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: HorizontalCollectionViewCell.reuseIdentifier, for: indexPath
                    ) as? HorizontalCollectionViewCell else { return UICollectionViewCell() }
                    cell.configure(value: value, description: description)
                    return cell
                }
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: InfoCollectionViewCell.reuseIdentifier, for: indexPath
                ) as? InfoCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(value: value, description: description)
                return cell
            case .button:
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier, for: indexPath
                )
            }
        }
    }

    func makeSupplementaryViewProvider() -> RocketDataSource.SupplementaryViewProvider {
        { [weak self] collectionView, kind, indexPath in
            guard let self, kind == UICollectionView.elementKindSectionHeader else { return nil }
            let sectionIdentifiers = self.dataSource.snapshot().sectionIdentifiers
            let section = sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier,
                for: indexPath) as? HeaderSupplementaryView
            guard case let .info(title) = section.type, let title else { return nil }
            view?.configure(title: title)
            return view
        }
    }
}

// MARK: Appearance Structure
private extension RocketViewController {
    enum Appearance {
        static let interSectionSpacing: CGFloat = 32
        static let headerItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        static let horizontalItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        static let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(108),
            heightDimension: .absolute(96)
        )
        static let horizontalItemInsets = NSDirectionalEdgeInsets
            .init(top: 0, leading: 0, bottom: 0, trailing: 12)
        static let horizontalSectionInsets = NSDirectionalEdgeInsets
            .init(top: 0, leading: 32, bottom: 0, trailing: 0)
        static let infoItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        static let infoGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(46)
        )
        static let buttonItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        static let buttonGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(88)
        )
        static let sectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        static var sectionHeaderElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: Appearance.sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
    }
}
