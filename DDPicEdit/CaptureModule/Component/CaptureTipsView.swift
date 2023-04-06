//
//  CaptureTipsView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/4.
//

import UIKit
import Anchorage

final class CaptureTipsView: DDPicBaseView {
    
    private let options: CaptureOptionsInfo
    
    init(frame: CGRect, options: CaptureOptionsInfo) {
        self.options = options
        super.init(frame: frame)
        self.addSubview(self.tipsLabel)
        self.tipsLabel.edgeAnchors == self.edgeAnchors
    }
    
    func showTips(hideAfter second: TimeInterval, animated: Bool) {
        guard isHidden else { return }
        self.alpha = 0
        self.isHidden = false
        let duration = animated ? 0.25 : 0
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        animator.addAnimations {
            self.alpha = 1
        }
        animator.addCompletion { [weak self ]_ in
            guard let self = self else { return }
            self.hideTips(afterDelay: second, animated: animated)
        }
        animator.startAnimation()
    }
    
    func hideTips(afterDelay second: TimeInterval, animated: Bool) {
        guard !isHidden else { return }
        let duration = animated ? 0.25 : 0
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        animator.addAnimations {
            self.alpha = 0
        }
        animator.addCompletion { _ in
            self.isHidden = true
        }
        animator.startAnimation(afterDelay: second)
    }
    
    private lazy var tipsLabel: UILabel = {
        let view = UILabel(text: options.theme[string: options.mediaOptions.localizedTipsKey], color: .white, textFont: UIFont.PingFang(size: 14))
        view.textAlignment = .center
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1
        return view
    }()
}
