//
//  Extension+UICollectionView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/12.
//

import UIKit

extension UICollectionView {
    
    func registerCellClasses(classes: [AnyClass]) {
        for cellMetaType in classes {
            self.register(cellMetaType, forCellWithReuseIdentifier: NSStringFromClass(cellMetaType))
        }
    }
    
    func dequeueCell<CellClass: UICollectionViewCell>(indexPath: IndexPath) -> CellClass {
        return self.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CellClass.self), for: indexPath) as! CellClass
    }
    
}

