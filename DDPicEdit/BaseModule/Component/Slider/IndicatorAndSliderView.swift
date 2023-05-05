//
//  IndicatorAndSliderView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/1.
//

import UIKit
import Anchorage

public protocol IndicatorAndSliderViewDelegate {
    
    func didGetOffsetRatio(_ slider: IndicatorAndSliderView, activeIndicatorIndex: Int, offsetRatio: Float)
    
}

public struct IndicatorModel {
    var limitNumber = 0
    var normalIconImage: CGImage?
    var dimmedIconImage: CGImage?
    var describeStr: String?
    
    public init(limitNumber: Int, normalIconImage: CGImage?, describeStr: String?) {
        self.limitNumber = limitNumber
        self.normalIconImage = normalIconImage
        if let normalIconImage = normalIconImage {
            if #available(iOS 13.0, *) {
                self.dimmedIconImage = UIImage(cgImage: normalIconImage).withTintColor(.gray).cgImage
            } else {
                // nothing to do
            }
        }
        self.describeStr = describeStr
    }
}

public class IndicatorAndSliderView: DDPicBaseView {

    public var delegate: IndicatorAndSliderViewDelegate?
    public var indicatorModels: [IndicatorModel] {
        set {
            self.indicatorContainer.indicatorModels = newValue
        }
        get {
            self.indicatorContainer.indicatorModels
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    func setupView() {
        self.recursiveAddSubView(views: [self.indicatorContainer, self.slideRuler])
        self.indicatorContainer.horizontalAnchors == self.horizontalAnchors
        self.indicatorContainer.topAnchor == self.topAnchor
        self.indicatorContainer.heightAnchor == 70
        
        self.slideRuler.horizontalAnchors == self.horizontalAnchors
        self.slideRuler.topAnchor == self.indicatorContainer.bottomAnchor + 10
        self.slideRuler.heightAnchor == 50
    }
    
    func setSlideRulerBy(progress: Float) {
        self.slideRuler.handleRemoveTempResetWith(progress: progress)
//        let activeIndex = self.indicatorContainer.activeIndicatorIndex
//        self.delegate?.didGetOffsetRatio(self, activeIndicatorIndex: activeIndex, offsetRatio: progress)
    }
    
    public lazy var indicatorContainer: IndicatorContainer = {
        let indicatorContainer = IndicatorContainer(frame: .zero)
        indicatorContainer.didActive = { [weak self] progress in
            self?.setSlideRulerBy(progress: progress)
        }
        indicatorContainer.didTempReset = { [weak self] in
            guard let self = self else { return }
            self.slideRuler.handleTempReset()
            let activeIndex = self.indicatorContainer.activeIndicatorIndex
            self.delegate?.didGetOffsetRatio(self, activeIndicatorIndex: activeIndex, offsetRatio: 0)
        }
        indicatorContainer.didRemoveTempReset = { [weak self] progress in
            self?.setSlideRulerBy(progress: progress)
        }
        return indicatorContainer
    }()
    public lazy var slideRuler: SlideRuler = {
        let slideRuler = SlideRuler(frame: CGRect(origin: .zero, size: CGSize(width: UIKitConstant.UIScreenWidth, height: 50)))
        slideRuler.delegate = self
        return slideRuler
    }()
}

extension IndicatorAndSliderView: SlideRulerDelegate {
    func didGetOffsetRatio(from slideRuler: SlideRuler, offsetRatio: CGFloat) {
        indicatorContainer.getActiveIndicator()?.progress = Float(offsetRatio)
        
        let activeIndex = indicatorContainer.activeIndicatorIndex
        delegate?.didGetOffsetRatio(self, activeIndicatorIndex: activeIndex, offsetRatio: Float(offsetRatio))
    }
}
