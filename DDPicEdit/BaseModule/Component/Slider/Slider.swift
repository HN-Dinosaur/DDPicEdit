//
//  Slider.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/1.
//

import UIKit
import Anchorage

public protocol SliderDelegate {
    
    func didGetOffsetRatio(_ slider: Slider, activeIndicatorIndex: Int, offsetRatio: Float)
    
}

public struct ProcessIndicatorModel {
    var limitNumber = 0
    var normalIconImage: CGImage?
    var dimmedIconImage: CGImage?
    
    public init(limitNumber: Int, normalIconImage: CGImage?, dimmedIconImage: CGImage?) {
        self.limitNumber = limitNumber
        self.normalIconImage = normalIconImage
        self.dimmedIconImage = dimmedIconImage
    }
}

public class Slider: DDPicBaseView {

    public var delegate: SliderDelegate?
    var indicatorContainer: ProcessIndicatorContainer!
    var slideRuler: SlideRuler!
    
    public static func createSlider(processIndicatorModels: [ProcessIndicatorModel],
                             activeIndex: Int) -> Slider {
        let slider = Slider(frame: .zero)
        processIndicatorModels.forEach {
            slider.addIndicatorWith(limitNumber: $0.limitNumber, normalIconImage: $0.normalIconImage, dimmedIconImage: $0.dimmedIconImage)
        }
        slider.setActiveIndicatorIndex(activeIndex)
        return slider
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createIndicatorContainer()
        self.createSlideRuler()
        self.setupView()
    }
    
    func createIndicatorContainer() {
        self.indicatorContainer = ProcessIndicatorContainer(frame: .zero)
        
        self.indicatorContainer.didActive = { [weak self] progress in
            self?.setSlideRulerBy(progress: progress)
        }
        
        self.indicatorContainer.didTempReset = { [weak self] in
//            guard let self = self else { return }
            self?.slideRuler.handleTempReset()
//            let activeIndex = self.indicatorContainer.activeIndicatorIndex
//            self.delegate?.didGetOffsetRatio(self, activeIndicatorIndex: activeIndex, offsetRatio: 0)
        }
        
        self.indicatorContainer.didRemoveTempReset = { [weak self] progress in
            self?.setSlideRulerBy(progress: progress)
        }
    }
    
    func createSlideRuler() {
        self.slideRuler = SlideRuler(frame: .zero)
        self.slideRuler.delegate = self
    }
    
    func setupView() {
        self.recursiveAddSubView(views: [self.indicatorContainer, self.slideRuler])
        self.indicatorContainer.horizontalAnchors == self.horizontalAnchors
        self.indicatorContainer.topAnchor == self.topAnchor
        self.indicatorContainer.heightAnchor == 50
        
        self.slideRuler.horizontalAnchors == self.horizontalAnchors
        self.slideRuler.topAnchor == self.indicatorContainer.bottomAnchor + 10
        self.slideRuler.heightAnchor == 50
    }
    
    func addIndicatorWith(limitNumber: Int, normalIconImage: CGImage?, dimmedIconImage: CGImage?) {
        self.indicatorContainer.addIndicatorWith(limitNumber: limitNumber, normalIconImage: normalIconImage, dimmedIconImage: dimmedIconImage)
    }
    
    func setActiveIndicatorIndex(_ index: Int = 0) {
        self.indicatorContainer.setActiveIndicatorIndex(index)
    }
    
    func setSlideRulerBy(progress: Float) {
        self.slideRuler.handleRemoveTempResetWith(progress: progress)
//        let activeIndex = self.indicatorContainer.activeIndicatorIndex
//        self.delegate?.didGetOffsetRatio(self, activeIndicatorIndex: activeIndex, offsetRatio: progress)
    }
}

extension Slider: SlideRulerDelegate {
    func didGetOffsetRatio(from slideRuler: SlideRuler, offsetRatio: CGFloat) {
        indicatorContainer.getActiveIndicator()?.progress = Float(offsetRatio)
        
        let activeIndex = indicatorContainer.activeIndicatorIndex
        delegate?.didGetOffsetRatio(self, activeIndicatorIndex: activeIndex, offsetRatio: Float(offsetRatio))
    }
}
