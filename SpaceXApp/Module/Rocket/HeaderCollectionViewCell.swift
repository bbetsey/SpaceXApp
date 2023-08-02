//
//  HeaderCollectionViewCell.swift
//  SpaceXApp
//
//  Created by Антон Тропин on 01.08.23.
//

import UIKit

final class HeaderCollectionViewCell: UICollectionViewCell {

    private var rocketImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 32
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var headerTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 28, weight: .medium)
        title.textColor = .label
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    private var settingsButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let image = UIImage(systemName: "gearshape", withConfiguration: configuration)
        let button = UIButton()
        button.tintColor = .label
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerTitle, settingsButton])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
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
}

// MARK: - Private Methods
private extension HeaderCollectionViewCell {
    func setupUI() {
        [rocketImage, headerView].forEach(addSubview)
        headerView.addSubview(stackView)
        headerView.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            rocketImage.topAnchor.constraint(equalTo: topAnchor),
            rocketImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            rocketImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            rocketImage.heightAnchor.constraint(equalToConstant: contentView.frame.height - 70),
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 48),
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -32),
            stackView.heightAnchor.constraint(equalToConstant: 34)
        ])

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: rocketImage.bottomAnchor, constant: -30),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

// MARK: - Public Methods
extension HeaderCollectionViewCell {
    func configure(withTitle title: String, andImage image: UIImage?) {
        headerTitle.text = title
        rocketImage.image = image
    }
}
