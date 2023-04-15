//
//  DDPicBaseCollectionViewCell.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/12.
//

import UIKit

public class DDPicBaseCollectionViewCell: UICollectionViewCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable, message: "Unsupported init(coder:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
