//
//  ParametersCollectionViewCell.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 30.07.23.
//

import UIKit

final class HorizontalCollectionViewCell: UICollectionViewCell, ConfigurableCell {

    private var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [valueLabel, descriptionLabel])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
extension HorizontalCollectionViewCell {
    func configure(with item: RocketItem) {
        guard case .info(let value, let description, _) = item else { return}
        valueLabel.text = value
        descriptionLabel.text = description
    }
}

// MARK: - Private Methods
private extension HorizontalCollectionViewCell {
    func setupUI() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 28
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
}
