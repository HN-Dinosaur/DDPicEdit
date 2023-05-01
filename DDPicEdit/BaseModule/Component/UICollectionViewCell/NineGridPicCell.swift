//
//  NineGridPicCell.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/30.
//

import UIKit
import Anchorage

public class NineGridPicCell: DDPicBaseCollectionViewCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.imageView)
        self.imageView.edgeAnchors == self.contentView.edgeAnchors
    }
    
    public func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
}
