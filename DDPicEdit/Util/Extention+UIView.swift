//
//  Extention+UIView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit

extension UIView {

    func recursiveAddSubView(views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }

}
