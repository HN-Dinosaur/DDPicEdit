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
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    convenience init(image: UIImage) {
        self.init()
        self.setImage(image, for: .normal)
    }
    
}
