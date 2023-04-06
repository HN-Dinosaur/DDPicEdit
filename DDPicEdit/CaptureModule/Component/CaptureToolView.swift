//
//  CaptureToolView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/4.
//

import UIKit
import Anchorage

final class CaptureToolView: DDPicBaseView {
    
    private let options: CaptureOptionsInfo
    
    init(frame: CGRect, options: CaptureOptionsInfo) {
        self.options = options
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        let layoutGuide1 = UILayoutGuide()
        let layoutGuide2 = UILayoutGuide()
        self.recursiveAddLayoutGuide(guides: [layoutGuide1, layoutGuide2])
        self.recursiveAddSubView(views: [self.captureButton, self.cancelButton, self.switchButton])
        
        layoutGuide1.leftAnchor == self.leftAnchor
        layoutGuide1.verticalAnchors == self.verticalAnchors
        
        self.captureButton.centerAnchors == self.centerAnchors
        
        layoutGuide2.leftAnchor == self.captureButton.rightAnchor
        layoutGuide2.rightAnchor == self.rightAnchor
        layoutGuide2.verticalAnchors == self.verticalAnchors
        // 使得layoutGuide1的宽度也被计算出来
        layoutGuide2.widthAnchor == layoutGuide1.widthAnchor
        
        self.cancelButton.centerYAnchor == layoutGuide1.centerYAnchor
        self.cancelButton.leftAnchor == layoutGuide1.leftAnchor + 16
        
        self.switchButton.centerYAnchor == layoutGuide2.centerYAnchor
        self.switchButton.rightAnchor == layoutGuide2.rightAnchor - 16
        self.switchButton.sizeAnchors == CGSize(width: 48, height: 48)
    }
    
    private(set) lazy var captureButton = CaptureButton(frame: .zero, options: options)
    private(set) lazy var cancelButton = UIButton(title: options.theme[string: .cancel], font: UIFont.PingFang(size: 18), edgeInset: UIEdgeInsets(edge: 8))
    private(set) lazy var switchButton = UIButton(image: options.theme[icon: .cameraSwitch]!)
}

// MARK: - Animation
extension CaptureToolView {
    
    func rotate(to orientation: DeviceOrientation, animated: Bool) {
        let duration = animated ? 0.25 : 0
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        animator.addAnimations {
            self.cancelButton.transform = orientation.transformMirrored
            self.switchButton.transform = orientation.transformMirrored
        }
        animator.startAnimation()
    }
    
    func showButtons(animated: Bool) {
        let duration = animated ? 0.25 : 0
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        animator.addAnimations {
            self.cancelButton.alpha = 1.0
            self.switchButton.alpha = 1.0
        }
        animator.addCompletion { _ in
            self.cancelButton.isEnabled = true
            self.switchButton.isEnabled = true
        }
        animator.startAnimation()
    }
    
    func hideButtons(animated: Bool) {
        let duration = animated ? 0.25 : 0
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        
        animator.addAnimations {
            self.cancelButton.alpha = 0.0
            self.switchButton.alpha = 0.0
        }
        animator.addCompletion { _ in
            self.cancelButton.isEnabled = false
            self.switchButton.isEnabled = false
        }
        animator.startAnimation()
    }
}
