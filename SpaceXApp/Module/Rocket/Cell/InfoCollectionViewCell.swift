//
//  InfoCollectionViewCell.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 02.08.23.
//

import UIKit

final class InfoCollectionViewCell: UICollectionViewCell {

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.descriptionLabelFont
        label.textColor = .secondaryLabel
        return label
    }()
    private var valueLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.valueLabelFont
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [descriptionLabel, valueLabel])
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.spacing = Appearance.stackSpacing
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
    func configure(value: String, description: String) {
        valueLabel.text = value
        descriptionLabel.text = description
    }
}

// MARK: - Private Methods
private extension InfoCollectionViewCell {
    func setupUI() {
        addSubview(stackView)
        [valueLabel, descriptionLabel, stackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

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
        static let descriptionLabelFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
        static let stackSpacing: CGFloat = 16
        static let stackTop: CGFloat = 12
        static let stackBottom: CGFloat = -12
        static let stackLeading: CGFloat = 32
        static let stackTrailing: CGFloat = -32
    }
}
