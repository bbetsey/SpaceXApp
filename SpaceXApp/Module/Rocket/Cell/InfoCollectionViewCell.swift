//
//  InfoCollectionViewCell.swift
//  SpaceXApp
//
//  Created by Антон Тропин on 02.08.23.
//

import UIKit

final class InfoCollectionViewCell: UICollectionViewCell, ConfigurableCell {

    func configure(with item: RocketItem) {
        guard case .info(let value, let description, let uuid) = item else { return }
    }
}
