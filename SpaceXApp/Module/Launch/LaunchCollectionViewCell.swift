//
//  LaunchCollectionViewCell.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 25.07.23.
//

import UIKit

final class LaunchCollectionViewCell: UICollectionViewCell {

    private var missionNameLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.missionLabelFont
        return label
    }()
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.dateLabelFont
        label.textColor = .systemGray
        return label
    }()
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [missionNameLabel, dateLabel])
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    private var rocketImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
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
extension LaunchCollectionViewCell {
    func configure(with launch: LaunchModel) {
        missionNameLabel.text = launch.missionName
        dateLabel.text = launch.launchDate
        rocketImageView.image = launch.rocketImage
    }
}

// MARK: - Private Methods
private extension LaunchCollectionViewCell {
    func setupUI() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = Appearance.cornerRadius
        [labelStackView, rocketImageView].forEach(addSubview)
        [missionNameLabel, dateLabel, labelStackView, rocketImageView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Appearance.stackLeading),
            labelStackView.trailingAnchor.constraint(equalTo: rocketImageView.leadingAnchor,
                                                     constant: Appearance.stackTraling),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelStackView.heightAnchor.constraint(equalToConstant: Appearance.stackHeight)
        ])

        NSLayoutConstraint.activate([
            rocketImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Appearance.rocketTrailing),
            rocketImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rocketImageView.heightAnchor.constraint(equalToConstant: Appearance.rocketSize),
            rocketImageView.widthAnchor.constraint(equalToConstant: Appearance.rocketSize)
        ])
    }
}

// MARK: - Appearance Structure
private extension LaunchCollectionViewCell {
    enum Appearance {
        static let missionLabelFont: UIFont = .systemFont(ofSize: 20, weight: .regular)
        static let dateLabelFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
        static let stackLeading: CGFloat = 24
        static let stackTraling: CGFloat = -16
        static let stackHeight: CGFloat = 52
        static let rocketTrailing: CGFloat = -24
        static let rocketSize: CGFloat = 30
        static let cornerRadius: CGFloat = 24
    }
}
