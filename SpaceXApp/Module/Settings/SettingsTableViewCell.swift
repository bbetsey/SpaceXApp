//
//  TableViewCell.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 22.07.23.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell {

    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Appearance.labelFontSize, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var settingControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["", ""])
        let font = UIFont.systemFont(ofSize: Appearance.controlFontSize, weight: .medium)
        control.selectedSegmentTintColor = .white
        control.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.black], for: .selected)
        control.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.lightGray], for: .normal)
        control.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
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

        [label, settingControl].forEach(addSubview)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: Appearance.labelHeight),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Appearance.labelLeading),
            label.trailingAnchor.constraint(equalTo: settingControl.leadingAnchor, constant: Appearance.labelTrailing)
        ])
        NSLayoutConstraint.activate([
            settingControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            settingControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Appearance.controlTrailing),
            settingControl.widthAnchor.constraint(equalToConstant: Appearance.controlWidth),
            settingControl.heightAnchor.constraint(equalToConstant: Appearance.controlHeight)
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
        static let labelLeading: CGFloat = 28
        static let labelTrailing: CGFloat = -16
        static let labelHeight: CGFloat = 35
        static let labelFontSize: CGFloat = 15
        static let controlTrailing: CGFloat = -28
        static let controlHeight: CGFloat = 35
        static let controlWidth: CGFloat = 115
        static let controlFontSize: CGFloat = 15
    }
}
