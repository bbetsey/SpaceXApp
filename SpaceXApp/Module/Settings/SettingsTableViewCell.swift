//
//  TableViewCell.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 22.07.23.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "settingCell"

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: Appearance.labelFontSize, weight: .medium)
        label.textColor = .white
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var settingControl: UISegmentedControl = {
        let items = ["", ""]
        let control = UISegmentedControl(items: items)
        let font = UIFont.systemFont(ofSize: Appearance.controlFontSize, weight: .medium)
        control.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.black], for: .selected)
        control.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.lightGray], for: .normal)
        control.addTarget(self, action: #selector(didChangeSegment(_:)), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    var onSegmentChanged: ((Int) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Methods
private extension SettingsTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.isUserInteractionEnabled = false

        [label, settingControl].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Appearance.leading),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            settingControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Appearance.trailing),
            settingControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            settingControl.widthAnchor.constraint(equalToConstant: Appearance.controlWidth)
        ])
    }
}

// MARK: - Public Methods
extension SettingsTableViewCell {
    func configure(with setting: Setting) {
        label.text = setting.type.name
        settingControl.setTitle(setting.type.units[0].name, forSegmentAt: 0)
        settingControl.setTitle(setting.type.units[1].name, forSegmentAt: 1)
        settingControl.selectedSegmentIndex = setting.selectedIndex
    }

    @objc func didChangeSegment(_ sender: UISegmentedControl) {
        onSegmentChanged?(sender.selectedSegmentIndex)
    }
}

// MARK: - Appearance
private extension SettingsTableViewCell {
    struct Appearance {
        static let leading: CGFloat = 28
        static let trailing: CGFloat = -28
        static let controlWidth: CGFloat = 115
        static let controlFontSize: CGFloat = 15
        static let labelFontSize: CGFloat = 15
    }
}
