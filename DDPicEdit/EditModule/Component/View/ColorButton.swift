//
//  ColorButton.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/11.
//

import UIKit
import Anchorage

final class ColorButton: DDPicBaseUIControl {

    private let size: CGFloat
    private let color: UIColor
    private let borderWidth: CGFloat
    private let borderColor: UIColor
    
    init(tag: Int, size: CGFloat, color: UIColor, borderWidth: CGFloat = 2, borderColor: UIColor = .white) {
        self.size = size
        self.color = color
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        super.init(frame: .zero)
        self.tag = tag
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorView.layer.borderWidth = isSelected ? self.borderWidth * 1.5 : self.borderWidth
        self.colorView.layer.borderColor = self.borderColor.cgColor
        self.colorView.layer.cornerRadius = self.colorView.bounds.width / 2
    }
    
    private func setupView() {
        self.addSubview(colorView)
        self.colorView.centerAnchors == self.centerAnchors
        self.colorView.sizeAnchors == CGSize(width: self.size, height: self.size)
    }
    
    private(set) lazy var colorView: UIButton = {
        let view = UIButton(type: .custom)
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        view.backgroundColor = self.color
        return view
    }()
}
