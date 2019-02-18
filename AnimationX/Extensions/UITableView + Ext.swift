//
//  UITableView + Ext.swift
//  AnimationX
//
//  Created by User on 18/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func regiserCellByClass<T: UITableViewCell>(cellClass: T.Type) {
        let className = String(describing: cellClass)
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    func dequeueCellBy<T: UITableViewCell>(cellClass: T.Type, indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath)
        return cell as! T
    }
}
