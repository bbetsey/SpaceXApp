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
        button.setTitle("Посмотреть запуски", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 12
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
            launchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            launchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            launchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
    }
}
