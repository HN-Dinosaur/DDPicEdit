//
//  EditorStickerCell.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/6.
//

import UIKit
import Anchorage

public class EditorStickerCell: DDPicBaseCollectionViewCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.contentImageView)
        self.contentImageView.edgeAnchors == self.edgeAnchors
    }
    
    public func setImage(_ image: UIImage?) {
        self.contentImageView.image = image
    }
    
    private lazy var contentImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
}
