//
//  SettingsTableViewController.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 20.07.23.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsTableViewController: UITableViewController {

    private let settingsViewModel: SettingsViewModelProtocol
    private let disposeBag = DisposeBag()

    init(settingsViewModel: SettingsViewModelProtocol = SettingsViewModel()) {
        self.settingsViewModel = settingsViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Appearance.headerHeight
    }
}

// MARK: - Private Methods
private extension SettingsTableViewController {
    func setupUI() {
        tableView.dataSource = nil
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)

        navigationController?.navigationBar.prefersLargeTitles = false
        title = Appearance.title

        tableView.separatorStyle = .none
        tableView.rowHeight = Appearance.rowHeight
    }

    func bindViewModel() {
        settingsViewModel.settings
            .drive(
                tableView.rx.items(cellIdentifier: SettingsTableViewCell.reuseIdentifier, cellType: SettingsTableViewCell.self)
            ) { row, setting, cell in
                cell.configure(with: setting)
                cell.onSegmentChanged = { [weak self] index in
                    self?.settingsViewModel.updateSettings(at: setting, withSelectedIndex: index)
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - Appearance
private extension SettingsTableViewController {
    struct Appearance {
        static let headerHeight: CGFloat = 40
        static let rowHeight: CGFloat = 54
        static let title = "Настройки"
    }
}
