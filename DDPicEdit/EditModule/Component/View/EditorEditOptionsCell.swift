//
//  EditorEditOptionsCell.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/6.
//

import UIKit
import Anchorage

public class EditorEditOptionsCell: DDPicBaseCollectionViewCell {
    
    public static let staticSize = CGSize(width: 50, height: 50)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.contentImageView)
        
        self.contentImageView.centerAnchors == self.contentView.centerAnchors
        self.contentImageView.sizeAnchors == CGSize(width: 25, height: 25)
    }
    
    public func updateData(_ image: UIImage?) {
        self.contentImageView.image = image
    }
    
    public lazy var contentImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
}
