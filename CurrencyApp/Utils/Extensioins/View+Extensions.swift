//
//  View+Extensions.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation
import UIKit

extension UIViewController {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableView {
    func registerForCell(identifier: String) {
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeueCell<T:UITableViewCell>(identifier: String, indexPath: IndexPath)->T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return UITableViewCell() as! T
        }
        return cell
    }
}
