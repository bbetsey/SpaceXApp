//
//  InfoCollectionViewCell.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 02.08.23.
//

import UIKit

final class InfoCollectionViewCell: UICollectionViewCell, ConfigurableCell {

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .right
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [descriptionLabel, valueLabel])
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: RocketItem) {
        guard case .info(let value, let description, _) = item else { return }
        descriptionLabel.text = description
        valueLabel.text = value
    }
}

// MARK: - Private Methods
private extension InfoCollectionViewCell {
    func setupUI() {
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
}
