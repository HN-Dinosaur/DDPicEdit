//
//  MirrorCropView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/16.
//

import UIKit
import Anchorage

final class MirrorCropView: DDPicBaseView {
    
    var color: UIColor = .black {
        didSet {
            topView.backgroundColor = color
            leftView.backgroundColor = color
            rightView.backgroundColor = color
            bottomView.backgroundColor = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.recursiveAddSubView(views: [
            self.topView,
            self.leftView,
            self.rightView,
            self.bottomView
        ])
    }
    
    func setRect(_ rect: CGRect) {
        self.topViewConstraint.rebatch {
            self.topView.horizontalAnchors == self.horizontalAnchors
            self.topView.topAnchor == self.topAnchor
            self.topView.heightAnchor == rect.minY
        }
        self.leftViewConstraint.rebatch {
            self.leftView.topAnchor == self.topAnchor + rect.minY
            self.leftView.bottomAnchor == self.topAnchor + rect.maxY
            self.leftView.leftAnchor == self.leftAnchor
            self.leftView.widthAnchor == rect.minX
        }
        self.rightViewConstraint.rebatch {
            self.rightView.rightAnchor == self.rightAnchor
            self.rightView.leftAnchor == self.leftAnchor + rect.maxX
            self.rightView.topAnchor == self.topAnchor + rect.minY
            self.rightView.bottomAnchor == self.topAnchor + rect.maxY
        }
        self.bottomViewConstraint.rebatch {
            self.bottomView.bottomAnchor == self.bottomAnchor
            self.bottomView.horizontalAnchors == self.horizontalAnchors
            self.bottomView.topAnchor == self.topAnchor + rect.maxY
        }
    }
    
    private var topViewConstraint: [NSLayoutConstraint] = []
    private var leftViewConstraint: [NSLayoutConstraint] = []
    private var rightViewConstraint: [NSLayoutConstraint] = []
    private var bottomViewConstraint: [NSLayoutConstraint] = []
    
    private lazy var topView = UIView(backgroundColor: .black)
    private lazy var leftView = UIView(backgroundColor: .black)
    private lazy var rightView = UIView(backgroundColor: .black)
    private lazy var bottomView = UIView(backgroundColor: .black)
}
