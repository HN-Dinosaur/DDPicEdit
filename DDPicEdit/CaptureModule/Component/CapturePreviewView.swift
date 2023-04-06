//
//  CapturePreviewView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/2.
//

import UIKit
import CoreMedia
import Anchorage

protocol CapturePreviewViewDelegate: AnyObject {
    func previewView(_ previewView: CapturePreviewView, didFocusAt point: CGPoint)
    func previewView(_ previewView: CapturePreviewView, didUpdateExposure level: CGFloat)
    func previewView(_ previewView: CapturePreviewView, didPinchWith scale: CGFloat)
}

final class CapturePreviewView: DDPicBaseView {
    
    private let options: CaptureOptionsInfo
    weak var delegate: CapturePreviewViewDelegate?
    public var isRunning: Bool = true
    
    public init(frame: CGRect, options: CaptureOptionsInfo, delegate: CapturePreviewViewDelegate?) {
        self.options = options
        self.delegate = delegate
        super.init(frame: frame)
        self.setupUI()
        self.setGesture()
    }
    
    private func setupUI() {
        let viewArray = [self.previewContentView, self.focusView, self.previewMaskView]
        self.previewContentView.addSubview(self.blurView)
        self.recursiveAddSubView(views: viewArray)
        viewArray.forEach { $0.edgeAnchors == self.edgeAnchors }
    }
    
    private func setGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapped(_:)))
        self.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.addGestureRecognizer(pan)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(_:)))
        self.addGestureRecognizer(pinch)
    }
    
    @objc private func onTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        let touchPoint = sender.location(in: self)
        guard touchPoint.x > 0, touchPoint.x < frame.width else { return }
        guard touchPoint.y > 0, touchPoint.y < frame.height else { return }
        let point = CGPoint(x: touchPoint.x / frame.width, y: touchPoint.y / frame.height)
        self.focusView.focusing(at: point)
        delegate?.previewView(self, didFocusAt: point)
    }
    
    @objc private func onPan(_ sender: UIPanGestureRecognizer) {
        guard focusView.isFocusing else { return }
        let point = sender.translation(in: self)
        sender.setTranslation(.zero, in: self)
        let difference: CGFloat
        switch focusView.orientation {
        case .portrait:
            difference = point.y / bounds.height
        case .portraitUpsideDown:
            difference = -point.y / bounds.height
        case .landscapeLeft:
            difference = -point.x / bounds.width
        case .landscapeRight:
            difference = point.x / bounds.width
        }
        self.focusView.setExposureViewValue(self.focusView.value + difference)
        self.delegate?.previewView(self, didUpdateExposure: self.focusView.value)
    }
    
    @objc private func onPinch(_ sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        sender.scale = 1.0
        self.delegate?.previewView(self, didPinchWith: scale)
    }
    
    func hideToolMask(animated: Bool) {
        let duration = animated ? 0.25 : 0
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        animator.addAnimations {
            self.previewMaskView.topMaskView.alpha = 0
            self.previewMaskView.bottomMaskView.alpha = 0
        }
        animator.startAnimation()
    }
    
    public func showToolMask(animated: Bool) {
        let duration = animated ? 0.25 : 0
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        animator.addAnimations {
            self.previewMaskView.topMaskView.alpha = 1.0
            self.previewMaskView.bottomMaskView.alpha = 1.0
        }
        animator.startAnimation()
    }
    
    public func transitionFlip(isIn: Bool, stopPreview: @escaping () -> Void, startPreview: @escaping () -> Void, completion: @escaping () -> Void) {
        let transform = previewContentView.transform
        // 先缩小，再模糊
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.previewContentView.transform = transform.scaledBy(x: 0.85, y: 0.85)
        }) { _ in
            self.blurView.alpha = 1
        }
        // 翻转
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            let options: UIView.AnimationOptions = isIn ? .transitionFlipFromLeft : .transitionFlipFromRight
            UIView.transition(with: self.previewContentView, duration: 0.25, options: options, animations: nil, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // 恢复transform
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.previewContentView.transform = transform
            }) { _ in
                DispatchQueue.global().async {
                    // 开始切换摄像头
                    stopPreview()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                        self.previewContentView.alpha = 0
                    }) { _ in
                        self.clear()
                        self.blurView.alpha = 0
                        // 停止切换摄像头
                        startPreview()
                        // 恢复镜头内容
                        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                            self.previewContentView.alpha = 1
                        }) { _ in
                            // 展示底部button
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    public func autoFocus(isForce: Bool = false) {
        let point = CGPoint(x: 0.5, y: 0.5)
        self.focusView.focusing(at: point, isAuto: true, isForce: isForce)
    }
    
    public func rotate(to orientation: DeviceOrientation, animated: Bool) {
        self.focusView.rotate(to: orientation, animated: animated)
    }

    private lazy var previewContentView = CapturePreviewContentView(frame: .zero)
    private lazy var focusView = CaptureFocusView(frame: .zero, options: options)
    private lazy var previewMaskView = CapturePreviewMaskView(frame: .zero, options: options)
    private lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: effect)
        view.alpha = 0
        return view
    }()
}

// MARK: - Preview Buffer
extension CapturePreviewView {
    func clear() {
        self.previewContentView.clear()
    }
    
    func draw(_ sampleBuffer: CMSampleBuffer) {
        guard isRunning else { return }
        self.previewContentView.draw(sampleBuffer: sampleBuffer)
    }
}
