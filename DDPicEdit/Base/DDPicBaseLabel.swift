//
//  DDPicBaseLabel.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/21.
//

import UIKit

class DDPicBaseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable, message: "Unsupported init(coder:)")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
