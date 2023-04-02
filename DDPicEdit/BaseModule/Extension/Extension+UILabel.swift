//
//  Extension+UILabel.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/20.
//

import UIKit

extension UILabel {

    convenience init(text: String? = nil, color: UIColor, textFont: UIFont, numberOfLine: Int = 1) {
        self.init()
        self.text = text
        self.textColor = color
        self.font = textFont
        self.numberOfLines = numberOfLine
    }
    
}
