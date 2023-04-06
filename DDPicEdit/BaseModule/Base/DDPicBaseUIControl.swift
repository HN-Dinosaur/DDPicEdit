//
//  DDPicBaseUIControl.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/4.
//

import UIKit

class DDPicBaseUIControl: UIControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable, message: "Unsupported init(coder:)")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
