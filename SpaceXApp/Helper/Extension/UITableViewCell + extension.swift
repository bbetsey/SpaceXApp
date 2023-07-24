//
//  UITableViewCell + extension.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 24.07.23.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self.self)
    }
}
