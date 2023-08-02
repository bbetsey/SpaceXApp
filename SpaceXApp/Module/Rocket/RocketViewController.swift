//
//  RocketViewController.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 18.07.23.
//

import UIKit
import RxSwift

final class RocketViewController: UIViewController {

    private let viewModel: RocketViewModelProtocol
    private let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<RocketSection, RocketItem>!

    private lazy var collectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var sections: [RocketSection] = {
        viewModel.getSections()
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
        setupDataSource()
        applySnapshot()
    }
}

// MARK: - Private Methods
private extension RocketViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        let cellTypes = [
            HorizontalCollectionViewCell.self,
            HeaderCollectionViewCell.self,
            InfoCollectionViewCell.self,
            ButtonCollectionViewCell.self
        ]
        cellTypes.forEach { collectionView.register($0, forCellWithReuseIdentifier: $0.reuseIdentifier) }

        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier)
    }

    func bindViewModel() {}

    @objc func openSettings() {}

}

// MARK: - CollectionViewCompositionalLayout
private extension RocketViewController {
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let sectionKind = RocketSectionType.allCases[sectionIndex]
            switch sectionKind {
            case .header:
                return self?.createHeaderViewLayout()
            case .horizontal:
                return self?.createHorizontalSection()
            case .info:
                return self?.createInfoSection()
            case .button:
                return self?.createButtonSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        return layout
    }

    func createHeaderViewLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(view.frame.height / 2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return section
    }

    func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(108), heightDimension: .absolute(96))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 12, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(3.2), heightDimension: .absolute(96))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

    func createInfoSection() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(26))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerElement]
        return section
    }

    func createButtonSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(view.frame.height / 2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return section
    }

}

// MARK: - CollectionViewDataSource
private extension RocketViewController {
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<RocketSection, RocketItem>()
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func configure<T: ConfigurableCell>(cellType: T.Type, at indexPath: IndexPath, using rocketItem: RocketItem) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath)
        (cell as? T)?.configure(with: rocketItem)
        return cell
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<RocketSection, RocketItem>(collectionView: collectionView) {
            [weak self] collectionView, indexPath, rocketItem in

            let sectionKind = RocketSectionType.allCases[indexPath.section]

            switch sectionKind {
            case .header:
                return self?.configure(cellType: HeaderCollectionViewCell.self, at: indexPath, using: rocketItem)
            case .horizontal:
                return self?.configure(cellType: HorizontalCollectionViewCell.self, at: indexPath, using: rocketItem)
            case .info:
                return self?.configure(cellType: InfoCollectionViewCell.self, at: indexPath, using: rocketItem)
            case .button:
                return collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier, for: indexPath) as? ButtonCollectionViewCell ?? UICollectionViewCell()
            }
        }

        dataSource?.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            guard let title = section?.title else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier, for: indexPath) as? HeaderSupplementaryView
            view?.configure(withTitle: title)
            return view
        }
        collectionView.dataSource = dataSource
    }
}
