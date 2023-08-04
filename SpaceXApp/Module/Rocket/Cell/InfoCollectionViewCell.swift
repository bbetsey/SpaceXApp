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
        label.font = Appearance.descriptionLabelFont
        label.textColor = Appearance.descriptionTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var valueLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.valueLabelFont
        label.textColor = Appearance.valueTextColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [descriptionLabel, valueLabel])
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.spacing = Appearance.stackSpacing
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
}

// MARK: - Public Methods
extension InfoCollectionViewCell {
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
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Appearance.stackTop),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Appearance.stackLeading),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Appearance.stackTrailing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Appearance.stackBottom),
        ])
    }
}

// MARK: - Appearance Structure
private extension InfoCollectionViewCell {
    struct Appearance {
        static let valueLabelFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
        static let valueTextColor: UIColor = .label
        static let descriptionLabelFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
        static let descriptionTextColor: UIColor = .secondaryLabel
        static let stackSpacing: CGFloat = 16
        static let stackTop: CGFloat = 12
        static let stackBottom: CGFloat = -12
        static let stackLeading: CGFloat = 32
        static let stackTrailing: CGFloat = -32
    }
}
