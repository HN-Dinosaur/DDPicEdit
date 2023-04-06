//
//  Extention+UIView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit

extension UIView {

    func recursiveAddSubView(views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
    func recursiveAddLayoutGuide(guides: [UILayoutGuide]) {
        guides.forEach { self.addLayoutGuide($0) }
    }

}
