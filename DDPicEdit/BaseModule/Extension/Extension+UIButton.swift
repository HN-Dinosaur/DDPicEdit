//
//  Extension+UIButton.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/4.
//

import UIKit

extension UIButton {
    
    convenience init(title: String? = nil, font: UIFont, edgeInset: UIEdgeInsets = .zero) {
        self.init()
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.contentEdgeInsets = edgeInset
    }
    
    convenience init(image: UIImage) {
        self.init()
        self.setImage(image, for: .normal)
    }
    
}
