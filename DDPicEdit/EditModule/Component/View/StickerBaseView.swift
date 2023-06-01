//
//  StickerBaseView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/6.
//

import UIKit
import Anchorage

public class StickerBaseView: DDPicBaseView {
    
    var isGestureEnded: Bool {
        for gesture in gestureRecognizers ?? [] {
            if gesture.state == .changed {
                return false
            }
        }
        return true
    }
    
    let data: StickerData

    init(data: StickerData) {
        self.data = data
        super.init(frame: data.frame)
        self.recursiveAddSubView(views: [self.rectView, self.imageView])
        self.rectView.edgeAnchors == self.edgeAnchors - UIEdgeInsets(edge: 10)
        self.imageView.edgeAnchors == self.edgeAnchors
        self.imageView.image = data.image
    }

    func calculateTransform() -> CGAffineTransform {
        return CGAffineTransform.identity
            .translatedBy(x: data.point.x, y: data.point.y)
            .scaledBy(x: data.scale, y: data.scale)
            .rotated(by: data.rotation)
    }
    
    /// 激活
    private(set) var isActive: Bool = false
    private var timer: Timer?
    private var checkCount: Int = 0
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let extensionRect = self.imageView.frame.inset(by: UIEdgeInsets(edge: -50))
        if extensionRect.contains(point) && self.isUserInteractionEnabled {
            return self
        }
        return super.hitTest(point, with: event)
    }
    
    public func setActive(_ isActive: Bool) {
        self.isActive = isActive
        rectView.isHidden = !isActive
        if isActive && timer == nil {
            checkCount = 0
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkActive(_:)), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func checkActive(_ timer: Timer) {
        if self.timer == nil || !self.isActive {
            timer.invalidate()
            self.timer = nil
            return
        }
        checkCount = !isGestureEnded ? 0 : checkCount + 1
        if checkCount >= 4 {
            setActive(false)
            timer.invalidate()
            self.timer = nil
        }
    }
    
    public lazy var rectView: UIView = {
        let view = UIView(frame: .zero)
        view.isHidden = true
        view.layer.cornerRadius = 1
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    public lazy var imageView = UIImageView(frame: .zero)
}
