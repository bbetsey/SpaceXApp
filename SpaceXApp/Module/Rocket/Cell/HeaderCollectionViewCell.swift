//
//  HeaderCollectionViewCell.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 01.08.23.
//

import UIKit
import Kingfisher

final class HeaderCollectionViewCell: UICollectionViewCell {

    private var rocketImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = Appearance.headerCornerRadius
        return view
    }()
    private var headerTitle: UILabel = {
        let title = UILabel()
        title.font = Appearance.headerTitleFont
        title.textColor = .label
        return title
    }()
    private var settingsButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: Appearance.settingImagePointSize, weight: .medium)
        let image = UIImage(systemName: Appearance.settingImageName, withConfiguration: configuration)
        let button = UIButton()
        button.tintColor = .secondaryLabel
        button.setImage(image, for: .normal)
        return button
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerTitle, settingsButton])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
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
extension HeaderCollectionViewCell {
    func configure(withTitle title: String?, andImageURL imageURL: String?) {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else { return }
        headerTitle.text = title
        rocketImage.kf.setImage(with: url)
    }
}

// MARK: - Private Methods
private extension HeaderCollectionViewCell {
    func setupUI() {
        [rocketImage, headerView].forEach(addSubview)
        headerView.addSubview(stackView)
        headerView.backgroundColor = .systemBackground
        [rocketImage, headerView, headerTitle, settingsButton, stackView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            rocketImage.topAnchor.constraint(equalTo: topAnchor),
            rocketImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            rocketImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            rocketImage.heightAnchor.constraint(equalToConstant: contentView.frame.height - Appearance.imageMargin),
        ])

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Appearance.stackLeading),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: Appearance.stackTrailing),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: Appearance.stackHeight)
        ])

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: rocketImage.bottomAnchor, constant: Appearance.headerViewTop),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

// MARK: - Appearance Structure
private extension HeaderCollectionViewCell {
    struct Appearance {
        static let imageMargin: CGFloat = 40
        static let headerViewTop: CGFloat = -30
        static let headerCornerRadius: CGFloat = 32
        static let headerTitleFont: UIFont = .systemFont(ofSize: 24, weight: .medium)
        static let settingImagePointSize: CGFloat = 24
        static let settingImageName = "gearshape"
        static let stackSpacing: CGFloat = 16
        static let stackLeading: CGFloat = 32
        static let stackTrailing: CGFloat = -32
        static let stackHeight: CGFloat = 34
    }

}
