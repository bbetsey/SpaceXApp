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
        label.font = .systemFont(ofSize: 16, weight: .semibold)
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

    func configure(withTitle title: String?) {
        sectionTitle.text = title
    }
}

// MARK: - Private Methods
private extension HeaderSupplementaryView {
    func setupUI() {
        addSubview(sectionTitle)

        NSLayoutConstraint.activate([
            sectionTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            sectionTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
    }
}
