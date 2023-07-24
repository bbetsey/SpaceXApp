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

    private var settingsViewModel: SettingsViewModelProtocol!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsViewModel = SettingsViewModel()
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
        tableView.delegate = self
        tableView.dataSource = nil
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = Appearance.title

        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.rowHeight = CGFloat(Appearance.rowHeight)
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
