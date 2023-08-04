//
//  HeaderSupplementaryView.swift
//  SpaceXApp
//
//  Created by Антон Тропин on 02.08.23.
//

import UIKit

final class HeaderSupplementaryView: UICollectionReusableView {

    static let reuseIdentifier = String(describing: HeaderSupplementaryView.self)

    private var sectionTitle: UILabel = {
        let label = UILabel()
        label.font = Appearance.titleFont
        label.textColor = Appearance.titleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension HeaderSupplementaryView {
    func setupUI() {
        addSubview(sectionTitle)
        NSLayoutConstraint.activate([
            sectionTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Appearance.titleLeading),
            sectionTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Appearance.titleTrailing),
        ])
    }
}

// MARK: - Public Methods
extension HeaderSupplementaryView {
    func configure(withTitle title: String?) {
        sectionTitle.text = title
    }
}

// MARK: - Appearance Structure
private extension HeaderSupplementaryView {
    struct Appearance {
        static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
        static let titleColor: UIColor = .label
        static let titleLeading: CGFloat = 32
        static let titleTrailing: CGFloat = -32
    }
}
