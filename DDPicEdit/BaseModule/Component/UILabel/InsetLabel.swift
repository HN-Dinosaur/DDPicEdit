//
//  InsetLabel.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/21.
//

import UIKit

class InsetLabel: DDPicBaseLabel {
    var internalInset: UIEdgeInsets = .zero
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width + internalInset.horizontal, height: super.intrinsicContentSize.height + internalInset.vertical)
    }
    
    init(inset: UIEdgeInsets) {
        super.init(frame: .zero)
        self.internalInset = inset
    }
}
