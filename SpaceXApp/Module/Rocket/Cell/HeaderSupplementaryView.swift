//
//  HeaderSupplementaryView.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 02.08.23.
//

import UIKit

final class HeaderSupplementaryView: UICollectionReusableView {

    private var sectionTitle: UILabel = {
        let label = UILabel()
        label.font = Appearance.titleFont
        label.textColor = .label
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

// MARK: - Public Methods
extension HeaderSupplementaryView {
    func configure(title: String) {
        sectionTitle.text = title
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

// MARK: - Appearance Structure
private extension HeaderSupplementaryView {
    struct Appearance {
        static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
        static let titleLeading: CGFloat = 32
        static let titleTrailing: CGFloat = -32
    }
}
