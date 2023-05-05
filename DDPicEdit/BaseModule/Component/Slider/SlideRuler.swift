//
//  SlideRuler.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/1.
//

import UIKit

fileprivate let scaleBarNumber = 41
fileprivate let majorScaleBarNumber = 5
fileprivate let scaleWidth: CGFloat = 1
fileprivate let pointerWidth: CGFloat = 1
fileprivate let dotWidth: CGFloat = 6

protocol SlideRulerDelegate {
    func didGetOffsetRatio(from slideRuler: SlideRuler, offsetRatio: CGFloat)
}

public class SlideRuler: DDPicBaseView {
    
    var sliderOffsetRatio: CGFloat = 0.5
    var delegate: SlideRulerDelegate?
    var reset = false
    var offsetValue: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(slider)
        makeRuler()
        makeCentralDot()
        makePointer()
        
        setUIFrames()
    }
    
    public func setUIFrames() {
        slider.frame = bounds
        // 设置居中
        offsetValue = sliderOffsetRatio * slider.frame.width
        slider.delegate = nil
        slider.contentSize = CGSize(width: frame.width * 2, height: frame.height)
        slider.contentOffset = CGPoint(x: offsetValue, y: 0)
        slider.delegate = self
        // 当前位置那根线
        pointer.frame = CGRect(x: (frame.width / 2 - pointerWidth / 2), y: bounds.origin.y, width: pointerWidth, height: frame.height)
        // 0点
        centralDot.frame = CGRect(x: frame.width - dotWidth / 2, y: frame.height * 0.2, width: dotWidth, height: dotWidth)
        centralDot.path = UIBezierPath(ovalIn: centralDot.bounds).cgPath
        // 普通bar
        scaleBarLayer.frame = CGRect(x: frame.width / 2, y: 0.6 * frame.height, width: frame.width, height: 0.4 * frame.height)
        scaleBarLayer.instanceTransform = CATransform3DMakeTranslation((frame.width - scaleWidth) / CGFloat((scaleBarNumber - 1)) , 0, 0)

        scaleBarLayer.sublayers?.forEach { [weak self] in
            guard let self = self else { return }
            $0.frame = CGRect(x: 0, y: 0, width: 1, height: self.scaleBarLayer.frame.height)
        }
        // 高亮bar
        majorScaleBarLayer.frame = scaleBarLayer.frame
        majorScaleBarLayer.instanceTransform = CATransform3DMakeTranslation((frame.width - scaleWidth) / CGFloat((majorScaleBarNumber - 1)) , 0, 0)
        
        majorScaleBarLayer.sublayers?.forEach {
            $0.frame = CGRect(x: 0, y: 0, width: 1, height: majorScaleBarLayer.frame.height)
        }
    }
    
    private func makePointer() {
        pointer.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(pointer)
    }
    
    private func makeCentralDot() {
        centralDot.fillColor = UIColor.white.cgColor
        slider.layer.addSublayer(centralDot)
    }
    
    private func makeRuler() {
        scaleBarLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let scaleBar = makeBarScaleMark(byColor: UIColor.gray.cgColor)
        scaleBarLayer.addSublayer(scaleBar)
        
        slider.layer.addSublayer(scaleBarLayer)
        
        majorScaleBarLayer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let majorScaleBar = makeBarScaleMark(byColor: UIColor.white.cgColor)
        majorScaleBarLayer.addSublayer(majorScaleBar)
        
        slider.layer.addSublayer(majorScaleBarLayer)
    }
    
    private func makeBarScaleMark(byColor color: CGColor) -> CALayer {
        let bar = CALayer()
        bar.backgroundColor = color
        return bar
    }
    
    func handleTempReset() {
        let offset = CGPoint(x: offsetValue, y: 0)
        slider.delegate = nil
        slider.setContentOffset(offset, animated: false)
        slider.delegate = self
        
        centralDot.isHidden = true
        let color = UIColor.gray.cgColor
        scaleBarLayer.sublayers?.forEach { $0.backgroundColor = color}
        majorScaleBarLayer.sublayers?.forEach { $0.backgroundColor = color}
    }
    
    func handleRemoveTempResetWith(progress: Float) {
        centralDot.fillColor = UIColor.white.cgColor
        
        scaleBarLayer.sublayers?.forEach { $0.backgroundColor = UIColor.gray.cgColor}
        majorScaleBarLayer.sublayers?.forEach { $0.backgroundColor = UIColor.white.cgColor}

        slider.delegate = nil
        let offsetX = CGFloat(progress) * offsetValue + offsetValue
        let offset = CGPoint(x: offsetX, y: 0)
        slider.setContentOffset(offset, animated: false)
        slider.delegate = self
        
        checkCentralDotHiddenStatus()
    }
    
    func checkCentralDotHiddenStatus() {
        centralDot.isHidden = (slider.contentOffset.x == frame.width / 2)
    }
    
    let pointer = CALayer()
    let centralDot = CAShapeLayer()
    lazy var slider: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    let scaleBarLayer: CAReplicatorLayer = {
        var r = CAReplicatorLayer()
        r.instanceCount = scaleBarNumber
        return r
    }()
    let majorScaleBarLayer: CAReplicatorLayer = {
        var r = CAReplicatorLayer()
        r.instanceCount = majorScaleBarNumber
        return r
    }()
}

extension SlideRuler: UIScrollViewDelegate {
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        checkCentralDotHiddenStatus()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        centralDot.isHidden = false
        
        let speed = scrollView.panGestureRecognizer.velocity(in: scrollView.superview)
        
        // 归0
        let limit = frame.width / CGFloat((scaleBarNumber - 1) * 2)
        if abs(slider.contentOffset.x - frame.width / 2) < limit && abs(speed.x) < 10.0 {
            if !reset {
                reset = true
                let offset = CGPoint(x: frame.width / 2, y: 0)
                scrollView.setContentOffset(offset, animated: false)
            }
        } else {
            reset = false
        }
        // 反馈正负
        var offsetRatio = (slider.contentOffset.x - offsetValue) / offsetValue
        
        if offsetRatio > 1 { offsetRatio = 1.0 }
        if offsetRatio < -1 { offsetRatio = -1.0 }
        
        delegate?.didGetOffsetRatio(from: self, offsetRatio: offsetRatio)
        
        if scrollView.frame.width > 0 {
            // 判断当前位置的比例
            sliderOffsetRatio = scrollView.contentOffset.x / scrollView.frame.width
        }
    }
}
