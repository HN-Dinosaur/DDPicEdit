//
//  CaptureFocusView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/2.
//

import UIKit
import Anchorage

final class CaptureFocusView: DDPicBaseView {
    private(set) var isFocusing: Bool = false
    private var isAuto: Bool = false
    // up = 0, down = 1
    public var value: CGFloat { return self.exposureView.currentValue }
    public var orientation: DeviceOrientation { return self.exposureView.orientation }
    
    private let options: CaptureOptionsInfo
    private var timer: Timer?
    private var exposureViewConstraint: [NSLayoutConstraint] = []
    private var rectViewConstraint: [NSLayoutConstraint] = []
    
    public init(frame: CGRect, options: CaptureOptionsInfo) {
        self.options = options
        super.init(frame: frame)
        setupView()
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    func focusing(at point: CGPoint, isAuto: Bool = false, isForce: Bool = false) {
        if !isForce && isAuto && isFocusing { return }
        self.isAuto = isAuto
        self.stopTimer()
        self.alpha = 0.5
        self.isFocusing = true
        self.exposureView.restore()
        self.rectView.isHidden = false
        self.exposureView.isHidden = isAuto
        
        let width: CGFloat = isAuto ? frame.width / 3 : 75
        let offsetX = point.x * bounds.width - width / 2
        let offsetY = point.y * bounds.height - width / 2
        
        self.rectViewConstraint.rebatch {
            self.rectView.sizeAnchors == CGSize(width: width, height: width)
            self.rectView.topAnchor == self.topAnchor + offsetY
            self.rectView.leftAnchor == self.leftAnchor + offsetX
        }
        self.rectView.setNeedsDisplay()
        self.exposureView.touchPoint = point
        self.updateExposureViewLocation()
        
        let rectViewScale: CGFloat = isAuto ? 1.1 : 1.6
        self.rectView.transform = CGAffineTransform(scaleX: rectViewScale, y: rectViewScale)
        self.exposureView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
            self.rectView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.exposureView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        self.startTimer()
    }
    
    private func setupView() {
        self.recursiveAddSubView(views: [self.rectView, self.exposureView])
        self.rectViewConstraint.rebatch {
            self.rectView.topAnchor == self.topAnchor
            self.rectView.leftAnchor == self.leftAnchor
            self.rectView.sizeAnchors == CGSize(width: 75, height: 75)
        }

//        self.exposureView.leftAnchor == self.rectView.rightAnchor + 5
        self.exposureView.centerYAnchor == self.rectView.centerYAnchor
        self.exposureView.sizeAnchors == CGSize(width: 27, height: 145)
    }
    
    public func setExposureViewValue(_ value: CGFloat) {
        guard !self.isAuto else { return }
        self.stopTimer()
        self.alpha = 1.0
        self.exposureView.setValue(value)
        self.startTimer()
    }
    
    func rotate(to orientation: DeviceOrientation, animated: Bool) {
        self.startTimer()
        self.alpha = 1.0
        self.exposureView.prepare(orientation: orientation, animated: animated) { [weak self] in
            guard let self = self else { return }
            self.updateExposureViewLocation()
            self.exposureView.rotate(animated: animated)
        }
    }
    
    private func updateExposureViewLocation() {
        switch self.exposureView.orientation {
        case .portrait:
            self.exposureViewConstraint.rebatch {
                if exposureView.touchPoint.x < 0.8 {
                    self.exposureView.leftAnchor == self.rectView.rightAnchor + 5
                } else {
                    self.exposureView.rightAnchor == self.rectView.leftAnchor - 5
                }
            }
        case .portraitUpsideDown:
            self.exposureViewConstraint.rebatch {
                if exposureView.touchPoint.x > 0.2 {
                    self.exposureView.rightAnchor == self.rectView.leftAnchor - 5
                } else {
                    self.exposureView.leftAnchor == self.rectView.rightAnchor + 5
                }
            }
        case .landscapeLeft:
            self.exposureViewConstraint.rebatch {
                if exposureView.touchPoint.y < 0.7 {
                    self.exposureView.topAnchor == self.rectView.bottomAnchor + 5
                } else {
                    self.exposureView.bottomAnchor == self.rectView.topAnchor - 5
                }
            }
        case .landscapeRight:
            self.exposureViewConstraint.rebatch {
                if exposureView.touchPoint.y > 0.25 {
                    self.exposureView.bottomAnchor == self.rectView.topAnchor - 5
                } else {
                    self.exposureView.topAnchor == self.rectView.bottomAnchor + 5
                }
            }
        }
    }
    
    public func startTimer(_ timeInterval: TimeInterval = 2) {
        self.stopTimer()
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerHideFocus(_:)), userInfo: nil, repeats: true)
    }
    
    public func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc
    private func timerHideFocus(_ timer: Timer) {
        guard self.timer != nil else { return }
        guard isFocusing else {
            stopTimer()
            return
        }
        let completionBlock = {
            self.isAuto = false
            self.isFocusing = false
            self.stopTimer()
        }
        if self.alpha == 1 {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = self.isAuto ? 0.0 : 0.4
            }) { _ in
                if self.isAuto {
                    completionBlock()
                } else {
                    self.startTimer(8)
                }
            }
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }) { _ in
                completionBlock()
            }
        }
    }
    
    private lazy var rectView: CaptureFocusRectView = {
        let view = CaptureFocusRectView(frame: .zero, options: options)
        view.isHidden = true
        return view
    }()
    
    private lazy var exposureView: CaptureExposureView = {
        let view = CaptureExposureView(frame: .zero, options: options)
        view.isHidden = true
        return view
    }()
}

private final class CaptureFocusRectView: DDPicBaseView {
    
    
    private let options: CaptureOptionsInfo
    
    init(frame: CGRect, options: CaptureOptionsInfo) {
        self.options = options
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.addSublayer(self.rectLayer)
    }
    
    override func draw(_ rect: CGRect) {
        let subLineWidth: CGFloat = 5
        let linePath = UIBezierPath(rect: self.bounds)
        linePath.move(to: CGPoint(x: 0, y: self.bounds.height / 2))
        linePath.addLine(to: CGPoint(x: subLineWidth, y: self.bounds.height / 2))
        linePath.move(to: CGPoint(x: self.bounds.width / 2, y: 0))
        linePath.addLine(to: CGPoint(x: self.bounds.width / 2, y: subLineWidth))
        linePath.move(to: CGPoint(x: self.bounds.width, y: self.bounds.height / 2))
        linePath.addLine(to: CGPoint(x: self.bounds.width - subLineWidth, y: self.bounds.height / 2))
        linePath.move(to: CGPoint(x: self.bounds.width / 2, y: self.bounds.height))
        linePath.addLine(to: CGPoint(x: self.bounds.width / 2, y: self.bounds.height - subLineWidth))
        self.rectLayer.path = linePath.cgPath
    }
    
    private lazy var rectLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.strokeColor = options.theme[color: .focus].cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
}

private final class CaptureExposureView: DDPicBaseView {
    
    fileprivate var touchPoint: CGPoint = .zero
    private let options: CaptureOptionsInfo
    fileprivate var orientation: DeviceOrientation = .portrait
    fileprivate(set) var currentValue: CGFloat = 0.5
    private var imageViewConstraints: [NSLayoutConstraint] = []
    private var topLineConstraints: [NSLayoutConstraint] = []
    private var bottomLineConstrints: [NSLayoutConstraint] = []
    
    init(frame: CGRect, options: CaptureOptionsInfo) {
        self.options = options
        super.init(frame: frame)
        self.recursiveAddSubView(views: [self.topLine, self.bottomLine, self.imageView])
        self.topLine.widthAnchor == 1
        self.bottomLine.widthAnchor == 1
        self.prepareNormalConstraint()
    }
    
    public func prepare(orientation: DeviceOrientation, animated: Bool, completion: @escaping Block) {
        self.orientation = orientation
        let duration = animated ? 0.15 : 0
        let timeingParameters = UICubicTimingParameters(animationCurve: .easeOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timeingParameters)
        animator.addAnimations {
            self.alpha = 0
        }
        animator.addCompletion { [weak self] _ in
            guard let self = self else { return }
            self.imageViewConstraints.rebatch { }
            self.topLineConstraints.rebatch { }
            self.bottomLineConstrints.rebatch { }
            completion()
        }
        animator.startAnimation()
    }
    
    private func prepareNormalConstraint() {
        self.imageViewConstraints.rebatch {
            self.centerAnchors == self.centerAnchors
            self.imageView.sizeAnchors == CGSize(width: self.bounds.width, height: self.bounds.width)
        }
        self.topLineConstraints.rebatch {
            self.topLine.topAnchor == self.topAnchor - 5
            self.topLine.bottomAnchor == self.imageView.topAnchor - 3
            self.topLine.centerXAnchor == self.centerXAnchor
        }

        self.bottomLineConstrints.rebatch {
            self.bottomLine.topAnchor == self.imageView.bottomAnchor + 3
            self.bottomLine.bottomAnchor == self.bottomAnchor + 5
            self.bottomLine.centerXAnchor == self.centerXAnchor
        }
    }
    
    func rotate(animated: Bool) {
        switch orientation {
        case .portrait, .portraitUpsideDown:
            self.prepareNormalConstraint()
        case .landscapeLeft, .landscapeRight:
            self.imageViewConstraints.rebatch {
                self.centerAnchors == self.centerAnchors
                self.imageView.sizeAnchors == CGSize(width: self.bounds.height, height: self.bounds.height)
            }
            
            self.topLineConstraints.rebatch {
                self.topLine.leftAnchor == self.leftAnchor - 5
                self.topLine.rightAnchor == self.imageView.leftAnchor - 3
                self.topLine.centerYAnchor == self.centerYAnchor
            }
            self.bottomLineConstrints.rebatch {
                self.bottomLine.leftAnchor == self.imageView.rightAnchor + 3
                self.bottomLine.rightAnchor == self.rightAnchor + 5
                self.bottomLine.centerYAnchor == self.centerYAnchor
            }
        }
        
        layoutIfNeeded()
        self.setValue(self.currentValue)
        
        let duration = animated ? 0.15 : 0
        let timingParameters = UICubicTimingParameters(animationCurve: .easeIn)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        animator.addAnimations {
            self.alpha = 1
        }
        animator.startAnimation(afterDelay: 0.1)
    }
    
    func setValue(_ value: CGFloat) {
        guard value >= 0 && value <= 1 else { return }
        self.currentValue = value
        self.topLine.isHidden = value == 0.5
        self.bottomLine.isHidden = value == 0.5
        switch orientation {
        case .portrait:
            // 仅剩进度条的高度
            let height = bounds.height - imageView.bounds.height
            let offset = -(height * 0.5 - height * value)
            self.imageViewConstraints.rebatch {
                self.imageView.centerXAnchor == self.centerXAnchor
                self.imageView.centerYAnchor == self.centerYAnchor + offset
            }
        case .portraitUpsideDown:
            let height = bounds.height - imageView.bounds.height
            let offset = height * 0.5 - height * value
            self.imageViewConstraints.rebatch {
                self.imageView.centerXAnchor == self.centerXAnchor
                self.imageView.centerYAnchor == self.centerYAnchor + offset
            }
        case .landscapeLeft:
            let width = bounds.width - imageView.bounds.width
            let offset = width * 0.5 - width * value
            self.imageViewConstraints.rebatch {
                self.imageView.centerXAnchor == self.centerXAnchor + offset
                self.imageView.centerYAnchor == self.centerYAnchor
            }
        case .landscapeRight:
            let width = bounds.width - imageView.bounds.width
            let offset = -(width * 0.5 - width * value)
            self.imageViewConstraints.rebatch {
                self.imageView.centerXAnchor == self.centerXAnchor + offset
                self.imageView.centerYAnchor == self.centerYAnchor
            }
        }
    }
    
    public func restore() {
        self.currentValue = 0.5
        self.topLine.isHidden = true
        self.bottomLine.isHidden = true
        self.imageViewConstraints.rebatch {
            self.imageView.centerAnchors == self.centerAnchors
        }
    }
    
    private lazy var imageView: UIImageView = {
        let image = options.theme[icon: .captureSunlight]?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.tintColor = options.theme[color: .focus]
        return view
    }()
    
    private lazy var topLine: UIView = {
        let view = UIView(frame: .zero)
        view.isHidden = true
        view.backgroundColor = options.theme[color: .focus]
        return view
    }()
    
    private lazy var bottomLine: UIView = {
        let view = UIView(frame: .zero)
        view.isHidden = true
        view.backgroundColor = options.theme[color: .focus]
        return view
    }()
}
