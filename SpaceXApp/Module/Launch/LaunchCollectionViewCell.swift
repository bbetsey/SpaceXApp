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
        label.font = .systemFont(ofSize: Appearance.missionNameLabelFontSize, weight: .regular)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Appearance.dateLabelFontSize, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var rocketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [missionNameLabel, dateLabel])
        stackView.distribution = .fill
        stackView.axis = .vertical
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
extension LaunchCollectionViewCell {
    func configure(with launch: Launch) {
        missionNameLabel.text = launch.missionName
        dateLabel.text = formatDate(fromUnixTime: launch.launchDateUnix)
        rocketImageView.image = launch.launchSuccess ?? true
            ? UIImage(named: "rocket")
            : UIImage(named: "rocket-reverse")
        statusImageView.image = launch.launchSuccess ?? true
            ? UIImage(named: "success")
            : UIImage(named: "cancel")
    }
}

// MARK: - Private Methods
private extension LaunchCollectionViewCell {
    func setupUI() {

        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 24
        [labelStackView, rocketImageView, circleImageView, statusImageView].forEach(addSubview)

        circleImageView.image = UIImage(systemName: "circle.fill")
        circleImageView.tintColor = .white

        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Appearance.stackLeading),
            labelStackView.trailingAnchor.constraint(equalTo: rocketImageView.leadingAnchor, constant: Appearance.stackTraling),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelStackView.heightAnchor.constraint(equalToConstant: Appearance.stackHeight)
        ])

        NSLayoutConstraint.activate([
            rocketImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Appearance.rocketTrailing),
            rocketImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rocketImageView.heightAnchor.constraint(equalToConstant: Appearance.rocketSize),
            rocketImageView.widthAnchor.constraint(equalToConstant: Appearance.rocketSize)
        ])

        NSLayoutConstraint.activate([
            circleImageView.trailingAnchor.constraint(equalTo: rocketImageView.trailingAnchor),
            circleImageView.bottomAnchor.constraint(equalTo: rocketImageView.bottomAnchor),
            circleImageView.widthAnchor.constraint(equalToConstant: Appearance.statusSize),
            circleImageView.heightAnchor.constraint(equalToConstant: Appearance.statusSize)
        ])

        NSLayoutConstraint.activate([
            statusImageView.trailingAnchor.constraint(equalTo: rocketImageView.trailingAnchor),
            statusImageView.bottomAnchor.constraint(equalTo: rocketImageView.bottomAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: Appearance.statusSize),
            statusImageView.heightAnchor.constraint(equalToConstant: Appearance.statusSize)
        ])
    }

    func formatDate(fromUnixTime unixTime: Int?) -> String {
        guard let unixTime = unixTime else { return "nil" }
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM, yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Appearance
private extension LaunchCollectionViewCell {
    struct Appearance {
        static let missionNameLabelFontSize: CGFloat = 20
        static let dateLabelFontSize: CGFloat = 16
        static let stackLeading: CGFloat = 24
        static let stackTraling: CGFloat = -16
        static let stackHeight: CGFloat = 52
        static let rocketTrailing: CGFloat = -24
        static let rocketSize: CGFloat = 30
        static let statusSize: CGFloat = 12
    }
}
