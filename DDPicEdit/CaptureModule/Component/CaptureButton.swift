//
//  CaptureButton.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/4.
//

import UIKit
import Anchorage

protocol CaptureButtonDelegate: AnyObject {

    func captureButtonDidTapped(_ button: CaptureButton)
    func captureButtonDidBeganLongPress(_ button: CaptureButton)
    func captureButtonDidEndedLongPress(_ button: CaptureButton)

}

final class CaptureButton: DDPicBaseUIControl {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 88, height: 88)
    }

    weak var delegate: CaptureButtonDelegate?
    private let options: CaptureOptionsInfo
    
    init(frame: CGRect, options: CaptureOptionsInfo) {
        self.options = options
        super.init(frame: frame)
        setupView()
        setupGestureRecognizer()
    }
    
    private func setupView() {
        self.recursiveAddSubView(views: [self.circleView, self.buttonView])
        self.circleView.edgeAnchors == self.edgeAnchors
        
        self.buttonView.centerAnchors == self.centerAnchors
        self.buttonView.sizeAnchors == CGSize(width: 56, height: 56)
    }
    
    private func setupGestureRecognizer() {
        if options.mediaOptions.contains(.photo) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapped(_:)))
            addGestureRecognizer(tapGesture)
        }
    }
    
    @objc
    private func onTapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.captureButtonDidTapped(self)
    }
    
    private lazy var circleView = CaptureCircleView(frame: .zero)
    private lazy var buttonView = CaptureRecordView(frame: .zero)
}


