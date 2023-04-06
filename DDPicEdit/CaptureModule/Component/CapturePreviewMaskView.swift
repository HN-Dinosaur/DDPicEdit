//
//  CapturePreviewMaskView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/3.
//

import UIKit
import Anchorage

final class CapturePreviewMaskView: DDPicBaseView {
    
    private var maskColor = UIColor.black.withAlphaComponent(0.25)
    private let options: CaptureOptionsInfo
    
    init(frame: CGRect, options: CaptureOptionsInfo) {
        self.options = options
        super.init(frame: frame)
        self.topMaskView.backgroundColor = self.maskColor
        self.bottomMaskView.backgroundColor = self.maskColor
        self.setupView()
    }
    
    private func setupView() {
        self.addLayoutGuide(centerLayoutGuide)
        self.recursiveAddSubView(views: [self.topMaskView, self.bottomMaskView])
        
        self.topMaskView.topAnchor == self.topAnchor
        self.topMaskView.horizontalAnchors == self.horizontalAnchors
        
        self.centerLayoutGuide.topAnchor == self.topMaskView.bottomAnchor
        self.centerLayoutGuide.horizontalAnchors == self.horizontalAnchors
        self.centerLayoutGuide.widthAnchor == centerLayoutGuide.heightAnchor * options.photoAspectRatio.value
        self.setMaskColorAlpha(1.0)
        // 后续有增加media改进计划， 现在只支持拍照
        // switch options.mediaOptions
        
        self.bottomMaskView.topAnchor == self.centerLayoutGuide.bottomAnchor
        self.bottomMaskView.horizontalAnchors == self.horizontalAnchors
        self.bottomMaskView.bottomAnchor == self.bottomAnchor
        self.bottomMaskView.heightAnchor == self.topMaskView.heightAnchor
    }
    
    public func setMaskColor(_ color: UIColor) {
        maskColor = color
        topMaskView.backgroundColor = color
        bottomMaskView.backgroundColor = color
    }
    
    public func setMaskColorAlpha(_ alpha: CGFloat) {
        let color = maskColor.withAlphaComponent(alpha)
        setMaskColor(color)
    }
    
    private(set) lazy var topMaskView = UIView(frame: .zero)
    
    private lazy var centerLayoutGuide = UILayoutGuide()
    
    private(set) lazy var bottomMaskView = UIView(frame: .zero)
}
