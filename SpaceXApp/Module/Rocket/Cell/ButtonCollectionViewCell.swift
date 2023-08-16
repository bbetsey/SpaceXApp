//
//  ButtonCollectionViewCell.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 02.08.23.
//

import UIKit

final class ButtonCollectionViewCell: UICollectionViewCell {

    private var launchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitleColor(.label, for: .normal)
        button.setTitle(Appearance.buttonTitle, for: .normal)
        button.titleLabel?.font = Appearance.buttonTitleFont
        button.layer.cornerRadius = Appearance.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
private extension ButtonCollectionViewCell {
    func setupUI() {
        addSubview(launchButton)

        NSLayoutConstraint.activate([
            launchButton.topAnchor.constraint(equalTo: topAnchor),
            launchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Appearance.buttonBottom),
            launchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Appearance.buttonLeading),
            launchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Appearance.buttonTrailing),
        ])
    }
}

// MARK: - Appearance Structure
private extension ButtonCollectionViewCell {
    enum Appearance {
        static let buttonTitle = "Посмотреть запуски"
        static let buttonTitleFont: UIFont = .systemFont(ofSize: 18, weight: .medium)
        static let buttonCornerRadius: CGFloat = 12
        static let buttonBottom: CGFloat = -32
        static let buttonLeading: CGFloat = 32
        static let buttonTrailing: CGFloat = -32
    }
}
