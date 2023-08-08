//
//  ParametersCollectionViewCell.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 30.07.23.
//

import UIKit

final class HorizontalCollectionViewCell: UICollectionViewCell {

    private var valueLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.valueLabelFont
        label.textColor = Appearance.valueTextColor
        label.textAlignment = .center
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.descriptionLabelFont
        label.textColor = Appearance.descriptionTextColor
        label.textAlignment = .center
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [valueLabel, descriptionLabel])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Appearance.stackSpacing
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
    func configure(withValue value: String?, andDescription description: String?) {
        valueLabel.text = value
        descriptionLabel.text = description
    }
}

// MARK: - Private Methods
private extension HorizontalCollectionViewCell {
    func setupUI() {
        contentView.backgroundColor = Appearance.contentViewColor
        contentView.layer.cornerRadius = Appearance.contentViewCornerRadius
        addSubview(stackView)
        [valueLabel, descriptionLabel, stackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Appearance.stackCenterY),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Appearance.stackLeading),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Appearance.stackTrailing),
        ])
    }
}

// MARK: - Appearance Structure
private extension HorizontalCollectionViewCell {
    struct Appearance {
        static let valueLabelFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
        static let valueTextColor: UIColor = .label
        static let descriptionLabelFont: UIFont = .systemFont(ofSize: 12, weight: .light)
        static let descriptionTextColor: UIColor = .secondaryLabel
        static let stackSpacing: CGFloat = 3
        static let stackCenterY: CGFloat = 2
        static let stackLeading: CGFloat = 8
        static let stackTrailing: CGFloat = -8
        static let contentViewCornerRadius: CGFloat = 28
        static let contentViewColor: UIColor = .systemGray6
    }
}
