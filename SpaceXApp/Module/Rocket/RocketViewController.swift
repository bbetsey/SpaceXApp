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
    private var dataSource: RocketDataSource!
    private var sections = [RocketSection]()

    private lazy var collectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGray4
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateSettings()
    }
}

// MARK: - Private Methods
private extension RocketViewController {

    func bindViewModel() {
        viewModel.sections
            .drive(onNext: { [weak self] sections in
                self?.sections = sections
                self?.activityIndicator.stopAnimating()
                self?.applySnapshot()
            })
            .disposed(by: disposeBag)
    }

    func setupUI() {
        view.backgroundColor = .systemBackground
        [collectionView, activityIndicator].forEach(view.addSubview)

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

        let cellTypes = [
            HorizontalCollectionViewCell.self,
            HeaderCollectionViewCell.self,
            InfoCollectionViewCell.self,
            ButtonCollectionViewCell.self
        ]
        cellTypes.forEach { collectionView.register($0, forCellWithReuseIdentifier: $0.reuseIdentifier) }
        collectionView.register(
            HeaderSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier
        )
    }
}

// MARK: - CollectionViewCompositionalLayout
private extension RocketViewController {
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }

            let sectionKind = self.sections[sectionIndex].type
            switch sectionKind {
            case .header:
                return self.createHeaderViewLayout()
            case .horizontal:
                return self.createHorizontalSection()
            case .info:
                guard self.sections[sectionIndex].title != nil else {
                    return self.createInfoSection(withHeader: false)
                }
                return self.createInfoSection(withHeader: true)
            case .button:
                return self.createButtonSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Appearance.interSectionSpacing
        layout.configuration = config
        return layout
    }

    func createHeaderViewLayout() -> NSCollectionLayoutSection {
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

    func createHorizontalSection() -> NSCollectionLayoutSection {
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

    func createInfoSection(withHeader: Bool) -> NSCollectionLayoutSection {
        let itemSize = Appearance.infoItemSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = Appearance.infoGroupSize
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        if withHeader {
            let headerSize = Appearance.sectionHeaderSize
            let headerElement = Appearance.sectionHeaderElement
            section.boundarySupplementaryItems = [headerElement]
        }
        return section
    }

    func createButtonSection() -> NSCollectionLayoutSection {
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
        dataSource = RocketDataSource(collectionView: collectionView) {
            [weak self] collectionView, indexPath, rocketItem in
            guard let self = self else { return UICollectionViewCell() }

            let sectionKind = self.sections[indexPath.section].type
            switch sectionKind {
            case .header:
                return self.configure(cellType: HeaderCollectionViewCell.self, at: indexPath, using: rocketItem)
            case .horizontal:
                return self.configure(cellType: HorizontalCollectionViewCell.self, at: indexPath, using: rocketItem)
            case .info:
                return self.configure(cellType: InfoCollectionViewCell.self, at: indexPath, using: rocketItem)
            case .button:
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? ButtonCollectionViewCell ?? {
                    print("Ошибка при создании ButtonCollectionViewCell")
                    return UICollectionViewCell()
                }()
            }
        }

        dataSource?.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier,
                for: indexPath) as? HeaderSupplementaryView
            view?.configure(withTitle: section?.title)
            return view
        }
        collectionView.dataSource = dataSource
    }
}

// MARK: Appearance Structure
private extension RocketViewController {
    struct Appearance {
        static let interSectionSpacing: CGFloat = 32

        // HEADER Section
        static let headerItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        // HORIZONTAL Section
        static let horizontalItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        static let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(108),
            heightDimension: .absolute(96)
        )
        static let horizontalItemInsets = NSDirectionalEdgeInsets
            .init(top: 0, leading: 12, bottom: 0, trailing: 0)
        static let horizontalSectionInsets = NSDirectionalEdgeInsets
            .init(top: 0, leading: 20, bottom: 0, trailing: 0)

        // INFO Section
        static let infoItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        static let infoGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(46)
        )

        // BUTTON Section
        static let buttonItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        static let buttonGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(88)
        )

        // SECTION HEADER
        static let sectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        static let sectionHeaderElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: Appearance.sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
    }
}
