//
//  ProcessIndicatorContainer.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/1.
//

import UIKit
import Anchorage

class ProcessIndicatorContainer: DDPicBaseView {

    var progressIndicatorViewList: [ProcessIndicatorView] = []
    
    var activeIndicatorIndex = 0
    let spacing: CGFloat = 20
    var pageWidth: CGFloat = 0
    var iconLength: CGFloat = 50
    
    var didActive: ((Float) -> Void) = { _ in }
    var didTempReset = {}
    var didRemoveTempReset: ((Float) -> Void) = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupView()
        self.reArrangeIndicators()
        self.setActiveIndicatorIndex(activeIndicatorIndex)
        
        // iF you want a customized page width, comment this one
        // backgroundSlideView.isPagingEnabled = true
        
    }
    
    func setupView() {
        pageWidth = iconLength + spacing
        
        self.addSubview(scrollView)
        self.scrollView.edgeAnchors == self.edgeAnchors
        self.progressIndicatorViewList.forEach {
            $0.sizeAnchors == CGSize(width: 50, height: 50)
        }
    }
    
    func reArrangeIndicators() {
        let slideContentSize = self.getSlideContentSize()
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width + slideContentSize.width - iconLength, height: scrollView.frame.height)
        // 设置每个子View的位置
        let startX = scrollView.contentSize.width / 2 - slideContentSize.width / 2
        for i in 0..<progressIndicatorViewList.count {
            let progressView = progressIndicatorViewList[i]
            progressView.center = CGPoint(x: startX + CGFloat(i) * (progressView.frame.width + spacing) + progressView.frame.width / 2, y: scrollView.frame.height / 2)
        }
    }
    
    func addIndicatorWith(limitNumber: Int, normalIconImage: CGImage?, dimmedIconImage: CGImage?) {
        let indicatorView = ProcessIndicatorView(frame: CGRect(x: 0, y: 0, width: iconLength, height: iconLength), limitNumber: limitNumber, normalIconImage: normalIconImage, dimmedIconImage: dimmedIconImage)
        indicatorView.delegate = self
        indicatorView.index = progressIndicatorViewList.count
        
        progressIndicatorViewList.append(indicatorView)
        scrollView.addSubview(indicatorView)
                                
        reArrangeIndicators()
    }
    
    func getSlideContentSize() -> CGSize {
        guard self.progressIndicatorViewList.count > 0 else {
            return scrollView.contentSize
        }
        
        let width = progressIndicatorViewList.map{ $0.frame.width }.reduce(0, +) + self.spacing * CGFloat(progressIndicatorViewList.count - 1)
        let height = scrollView.contentSize.height
        
        return CGSize(width: width, height: height)
    }
    
    func setActiveIndicatorIndex(_ index: Int = 0, animated: Bool = false) {
        if index < 0 {
            activeIndicatorIndex = 0
        } else if index > progressIndicatorViewList.count - 1 {
            activeIndicatorIndex = progressIndicatorViewList.count - 1
        } else {
            activeIndicatorIndex = index
        }
        
        guard let indicator = getActiveIndicator() else {
            return
        }
        
        indicator.active = true
        
        let slideContentSize = getSlideContentSize()
        let currentPositon = indicator.center
        let targetPosition = CGPoint(x: (scrollView.contentSize.width - slideContentSize.width) / 2 + iconLength / 2, y: 0)
        
        let offset = CGPoint(x: currentPositon.x - targetPosition.x, y: 0)
        scrollView.setContentOffset(offset, animated: animated)
    }
    
    func getActiveIndicator() -> ProcessIndicatorView? {
        guard 0..<progressIndicatorViewList.count ~= activeIndicatorIndex else {
            return nil
        }
    
        return progressIndicatorViewList[activeIndicatorIndex]
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
}

extension ProcessIndicatorContainer: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let kMaxIndex = progressIndicatorViewList.count

        let targetX = scrollView.contentOffset.x + velocity.x * 60.0
        var targetIndex = 0
        
        if (velocity.x > 0) {
            targetIndex = Int(ceil(targetX / pageWidth))
        } else if (velocity.x == 0) {
            targetIndex = Int(round(targetX / pageWidth))
        } else if (velocity.x < 0) {
            targetIndex = Int(floor(targetX / pageWidth))
        }

        if (targetIndex < 0) {
            targetIndex = 0
        }

        if (targetIndex > kMaxIndex) {
            targetIndex = kMaxIndex
        }

        targetContentOffset.pointee.x = CGFloat(targetIndex) * pageWidth;
        setActiveIndicatorIndex(targetIndex)
        
        guard let processIndicatorView = getActiveIndicator() else { return }
        if processIndicatorView.status == .editing {
            self.didActive(processIndicatorView.progress)
        }
    }
}

extension ProcessIndicatorContainer: ProcessIndicatorViewDelegate {
    func didActive(_ processIndicatorView: ProcessIndicatorView) {
        setActiveIndicatorIndex(processIndicatorView.index, animated: true)
        self.didActive(processIndicatorView.progress)
    }
    
    func didTempReset(_ processIndicatorView: ProcessIndicatorView) {
        self.didTempReset()
    }
    
    func didRemoveTempReset(_ processIndicatorView: ProcessIndicatorView) {
        self.didRemoveTempReset(processIndicatorView.progress)
    }
}
