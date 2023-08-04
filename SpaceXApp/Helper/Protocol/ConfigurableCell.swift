//
//  ConfigurableCell.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 02.08.23.
//

import UIKit

protocol ConfigurableCell: UICollectionViewCell {
    func configure(with item: RocketItem)
}
