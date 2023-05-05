//
//  IndicatorView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/1.
//

import UIKit

protocol IndicatorViewDelegate {
    func didActive(_ indicatorView: IndicatorView)
    func didTempReset(_ indicatorView: IndicatorView)
    func didRemoveTempReset(_ indicatorView: IndicatorView)
}

public class IndicatorView: DDPicBaseView {
    var limitNumber = 100
    var normalIconImage: CGImage?
    var dimmedIconImage: CGImage?
    var index = 0
    
    var active = false
    
    var progress: CGFloat = 0.0 {
        didSet {
            setProgress(progress)
        }
    }
    
    var status: IndicatorStatus = .initial {
        didSet {
            change(to: status)
        }
    }
    
    var delegate: IndicatorViewDelegate?
    
    private var circlePath: UIBezierPath!
    
    var progressColor = UIColor.white {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var minusProgressColor = UIColor.white {
        didSet {
            minusProgressLayer.strokeColor = minusProgressColor.cgColor
        }
    }
    
    var trackColor = UIColor.white {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        change(to: .initial)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleActivited(notification:)), name: .IndicatorActivated, object: nil)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.recursiveAddSubLayer(layers: [
            self.trackLayer,
            self.progressLayer,
            self.minusProgressLayer,
            self.iconLayer,
            self.progressNumberLayer
        ])
        circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        
        let iconLayerLength = frame.width / 2
        
        iconLayer.frame = CGRect(x: frame.width / 2 - iconLayerLength / 2  , y: frame.height / 2 - iconLayerLength / 2 , width: iconLayerLength, height: iconLayerLength)
        
        progressNumberLayer.frame = CGRect(x: layer.bounds.origin.x, y: ((layer.bounds.height - progressNumberLayer.fontSize) / 2), width: layer.bounds.width, height: layer.bounds.height)
        
        layer.cornerRadius = self.frame.size.width/2
        trackLayer.path = circlePath.cgPath
        progressLayer.path = circlePath.cgPath
        minusProgressLayer.path = circlePath.reversing().cgPath
    }
    
    func setData(limitNumber: Int = 30, normalIconImage: CGImage? = nil, dimmedIconImage: CGImage? = nil) {
        self.limitNumber = limitNumber
        self.normalIconImage = normalIconImage
        self.dimmedIconImage = dimmedIconImage
    }
    
    @objc func handleActivited(notification: Notification) {
        guard let object = notification.object as? IndicatorView else {
            return
        }
        
        // 如果不是点击的这个 && 当前这个view的progress为0 && status != tempReset
        if self !== object {
            active = false
            if getProgressValue() == 0 && status != .tempReset {
                status = .initial
            }
        }
    }
    
    @objc func handleTap() {
        if active {
            if status == .tempReset {
                status = .editing
                delegate?.didRemoveTempReset(self)
            } else {
                status = .tempReset
                delegate?.didTempReset(self)
            }
        } else {
            active = true
            delegate?.didActive(self)
            
            if status == .tempReset {
                delegate?.didTempReset(self)
            }
        }
        
        NotificationCenter.default.post(name: .IndicatorActivated, object: self)
    }
    
    private func getProgressLayer(color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        layer.lineWidth = 2.0
        layer.strokeEnd = 0.0
        return layer
    }
    
    private func setProgress(_ progress: CGFloat) {
        status = .editing
        
        if progress > 0 {
            progressLayer.isHidden = false
            minusProgressLayer.isHidden = true
            
            progressLayer.path = circlePath.cgPath
            progressColor = UIColor(displayP3Red: 247.0 / 255.0, green: 198.0 / 255.0, blue: 0, alpha: 1)
            trackColor = UIColor(displayP3Red: 55.0 / 255.0, green: 45.0 / 255.0, blue: 9.0 / 255.0, alpha: 1)
            progressLayer.strokeEnd = abs(CGFloat(progress))
            progressNumberLayer.foregroundColor = progressColor.cgColor
        } else {
            progressLayer.isHidden = true
            minusProgressLayer.isHidden = false
            
            minusProgressColor = UIColor(displayP3Red: 203.0 / 255.0, green: 203.0 / 255.0, blue: 203.0 / 255.0, alpha: 1)
            trackColor = UIColor(displayP3Red: 84.0 / 255.0, green: 84.0 / 255.0, blue: 84.0 / 255.0, alpha: 1)
            minusProgressLayer.strokeEnd = abs(CGFloat(progress))
            progressNumberLayer.foregroundColor = minusProgressColor.cgColor
        }
        progressNumberLayer.string = "\(getProgressValue())"
    }
    
    func getProgressValue() -> Int {
        Int(progress * CGFloat(limitNumber))
    }
    
    func change(to status: IndicatorStatus) {
        iconLayer.isHidden = false
        progressNumberLayer.isHidden = true
        trackLayer.strokeColor = trackColor.cgColor
        progressLayer.isHidden = true
        minusProgressLayer.isHidden = true
        
        switch status {
        case .initial:
            iconLayer.contents = normalIconImage
            trackLayer.strokeColor = UIColor.white.cgColor
        case .tempReset:
            iconLayer.contents = dimmedIconImage
            trackLayer.strokeColor = UIColor.gray.cgColor
        case .editing:
            iconLayer.isHidden = true
            progressNumberLayer.isHidden = false
            progressLayer.isHidden = false
            minusProgressLayer.isHidden = false
        }
    }
    
    fileprivate lazy var progressLayer = getProgressLayer(color: progressColor.cgColor)
    fileprivate lazy var minusProgressLayer = getProgressLayer(color: minusProgressColor.cgColor)
    fileprivate lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = self.trackColor.cgColor
        layer.lineWidth = 2.0
        layer.strokeEnd = 1.0
        return layer
    }()
    fileprivate lazy var progressNumberLayer: CATextLayer = {
        let textLayer = CATextLayer()
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.string = "0"
        textLayer.fontSize = 16
        textLayer.alignmentMode = .center
        return textLayer
    }()
    fileprivate var iconLayer: CALayer = {
        let layer = CALayer()
        layer.contentsGravity = .resizeAspect
        return layer
    }()
}

extension Notification.Name {
    static let IndicatorActivated
                = NSNotification.Name("ProgressIndicatorActivated")
}

enum IndicatorStatus {
    case initial
    case tempReset
    case editing
}
