//
//  EditorCropOptionCell.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/12.
//

import UIKit
import Anchorage

final class EditorCropOptionCell: DDPicBaseCollectionViewCell {
    
    private var option: EditorCropOption = .free
    private var selectColor: UIColor = .green
    private var contentLabelConstraint: [NSLayoutConstraint] = []
    private var shapeLayer: CAShapeLayer?
    override var isSelected: Bool {
        didSet {
            self.contentLabel.textColor = self.isSelected ? self.selectColor : .white
            self.setupLayer()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.contentLabel)
        self.contentLabelConstraint.rebatch {
            self.contentLabel.edgeAnchors == self.contentView.edgeAnchors
        }
    }
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel(color: .white, textFont: UIFont.PingFang(size: 8))
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
}

// MARK: - Public
extension EditorCropOptionCell {
    
    func set(_ options: EditorPhotoOptionsInfo, option: EditorCropOption, selectColor: UIColor) {
        self.option = option
        self.selectColor = selectColor
        
        self.setupLayer()
        switch option {
        case .free:
            contentLabel.text = options.theme[string: .editorFree]
        case .custom(let w, let h):
            contentLabel.text = "\(w):\(h)"
        }
    }
}

// MARK: - Private
extension EditorCropOptionCell {
    
    private func setupLayer() {
        self.shapeLayer?.removeFromSuperlayer()
        self.shapeLayer = nil
        
        let size: CGFloat = 25
        let labelWidth: CGFloat
        let path = UIBezierPath()
        switch option {
        case .free:
            labelWidth = size
            let line: CGFloat = 8
            let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            path.move(to: CGPoint(x: center.x - size / 2, y: center.y - size / 2 + line))
            path.addLine(to: CGPoint(x: center.x - size / 2, y: center.y - size / 2))
            path.addLine(to: CGPoint(x: center.x - size / 2 + line, y: center.y - size / 2))
            path.move(to: CGPoint(x: center.x + size / 2 - line, y: center.y - size / 2))
            path.addLine(to: CGPoint(x: center.x + size / 2, y: center.y - size / 2))
            path.addLine(to: CGPoint(x: center.x + size / 2, y: center.y - size / 2 + line))
            path.move(to: CGPoint(x: center.x + size / 2, y: center.y + size / 2 - line))
            path.addLine(to: CGPoint(x: center.x + size / 2, y: center.y + size / 2))
            path.addLine(to: CGPoint(x: center.x + size / 2 - line, y: center.y + size / 2))
            path.move(to: CGPoint(x: center.x - size / 2 + line, y: center.y + size / 2))
            path.addLine(to: CGPoint(x: center.x - size / 2, y: center.y + size / 2))
            path.addLine(to: CGPoint(x: center.x - size / 2, y: center.y + size / 2 - line))
        case .custom(let w, let h):
            let width: CGFloat
            let height: CGFloat
            if w >= h {
                width = size
                height = size * CGFloat(h) / CGFloat(w)
            } else {
                height = size
                width = size * CGFloat(w) / CGFloat(h)
            }
            labelWidth = width
            let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            path.move(to: CGPoint(x: center.x - width / 2, y: center.y - height/2))
            path.addLine(to: CGPoint(x: center.x + width / 2, y: center.y - height / 2))
            path.addLine(to: CGPoint(x: center.x + width / 2, y: center.y + height / 2))
            path.addLine(to: CGPoint(x: center.x - width / 2, y: center.y + height / 2))
            path.addLine(to: CGPoint(x: center.x - width / 2, y: center.y - height / 2))
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.cornerRadius = 2
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = isSelected ? selectColor.cgColor : UIColor.white.cgColor
        layer.addSublayer(shapeLayer)
        self.shapeLayer = shapeLayer
        
        self.contentLabelConstraint.rebatch {
            self.contentLabel.horizontalAnchors == self.contentView.horizontalAnchors
            self.contentLabel.centerXAnchor == self.contentView.centerXAnchor
            self.contentLabel.widthAnchor == labelWidth - 2
        }
    }
}
