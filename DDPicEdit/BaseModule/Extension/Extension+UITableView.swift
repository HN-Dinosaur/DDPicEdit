//
//  Extension+UITableView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/20.
//

import UIKit

extension UITableView {

    func registerCellClasses(classes: [AnyClass]) {
        for cellMetaType in classes {
            self.register(cellMetaType, forCellReuseIdentifier: NSStringFromClass(cellMetaType))
        }
    }

    func dequeueCell<CellClass: UITableViewCell>(indexPath: IndexPath) -> CellClass {
        return self.dequeueReusableCell(withIdentifier: NSStringFromClass(CellClass.self), for: indexPath) as! CellClass
    }

}
