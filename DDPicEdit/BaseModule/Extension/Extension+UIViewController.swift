//
//  Extension+UIViewController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/7.
//

import UIKit

extension UIViewController {
    
    static var currentVisibleVc: UIViewController? {
        func findVC(rawVc: UIViewController) -> UIViewController {
            switch rawVc {
            case let vc where rawVc.presentedViewController != nil:
                return findVC(rawVc: vc)
            case let naviVc as UINavigationController:
                guard let vc = naviVc.visibleViewController else { return rawVc }
                return findVC(rawVc: vc)
            case let tabVc as UITabBarController:
                guard let vc = tabVc.selectedViewController else { return rawVc }
                return findVC(rawVc: vc)
            default:
                return rawVc
            }
        }
        
        guard let rootVc = ScreenHelper.keyWindow?.rootViewController else { return nil }
        
        return findVC(rawVc: rootVc)
    }
    
}

