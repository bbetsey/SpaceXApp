//
//  SettingsTableViewController.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 20.07.23.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsTableViewController: UITableViewController {

    private let settingsViewModel: SettingsViewModelProtocol = SettingsViewModel()
    private let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

}

// MARK: - Private Methods
private extension SettingsTableViewController {
    func setupUI() {
        tableView.dataSource = nil
        tableView.delegate = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = "Настройки"

        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = CGFloat(Appearance.rowHeight)
        tableView.backgroundColor = .black
    }

    func bindViewModel() {
        settingsViewModel.settings
            .bind(
                to: tableView.rx.items(cellIdentifier: SettingsTableViewCell.reuseIdentifier, cellType: SettingsTableViewCell.self)
            ) { row, setting, cell in
                cell.configure(with: setting)
                cell.onSegmentChanged = { index in
                    self.settingsViewModel.updateSettings(at: row, withSelectedIndex: index)
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Appearance.headerHeight
    }
}

// MARK: - Appearance
private extension SettingsTableViewController {
    struct Appearance {
        static let headerHeight: CGFloat = 40
        static let rowHeight: CGFloat = 54
    }
}
