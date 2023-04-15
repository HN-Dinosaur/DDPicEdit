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
    
    func getController() -> UIViewController? {
        var view: UIView? = self.superview
        while view != nil {
            if let controller = view?.next as? UIViewController {
                return controller
            }
            view = view?.superview
        }
        return nil
    }
    
    func setLayoutMarginWithoutInsetFromSafeArea(insets: UIEdgeInsets) {
        self.layoutMargins = insets
        self.insetsLayoutMarginsFromSafeArea = false
    }

}
