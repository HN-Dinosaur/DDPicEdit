//
//  Extention+UIView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit
import MBProgressHUD

extension UIView {
    
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }

    func recursiveAddSubView(views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
    func recursiveAddSubLayer(layers: [CALayer]) {
        layers.forEach { self.layer.addSublayer($0) }
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
    
    func showHudWaiting() {
        MBProgressHUD.showAdded(to: self, animated: true)
    }
    
    func hideHudWaiting() {
        MBProgressHUD.hideAllHUDs(for: self, animated: true)
    }
    
    func screenshot(_ imageSize: CGSize = .zero) -> UIImage {
        let size = CGSize(width: self.bounds.size.width.roundTo(places: 5), height: self.bounds.size.height.roundTo(places: 5))
        let renderer: UIGraphicsImageRenderer
        if imageSize == .zero {
            renderer = UIGraphicsImageRenderer(size: size)
        } else {
            let format = UIGraphicsImageRendererFormat()
            format.scale = imageSize.width / size.width
            renderer = UIGraphicsImageRenderer(size: size, format: format)
        }
        return renderer.image { [weak self] context in
            self?.layer.render(in: context.cgContext)
        }
    }

}
