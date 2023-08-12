//
//  UICollectionReusableView+reuseIdentifier.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 08.08.23.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        String(describing: self.self)
    }
}
