//
//  IndicatorContainer.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/1.
//

import UIKit
import Anchorage

public class IndicatorContainer: DDPicBaseView {

    var activeIndicatorIndex = 0
    var iconLength: CGFloat = 50
    var indicatorModels: [IndicatorModel] = [] {
        didSet {
            let leftInset = (UIKitConstant.UIScreenWidth - (CGFloat(indicatorModels.count) * iconLength) - (CGFloat(indicatorModels.count - 1) * 10)) / 2
            collectionView.contentInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
            self.collectionView.reloadData()
        }
    }
    
    var didActive: ((Float) -> Void) = { _ in }
    var didTempReset = {}
    var didRemoveTempReset: ((Float) -> Void) = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = .clear
        self.addSubview(self.collectionView)
        self.collectionView.edgeAnchors == self.edgeAnchors
    }
    
    func setActiveIndicatorIndex(_ index: Int = 0, animated: Bool = false) {
        if index < 0 {
            activeIndicatorIndex = 0
        } else if index > self.indicatorModels.count - 1 {
            activeIndicatorIndex = self.indicatorModels.count - 1
        } else {
            activeIndicatorIndex = index
        }
        
        guard let indicator = getActiveIndicator() else {
            return
        }
        
        indicator.active = true
    }
    
    func getActiveIndicator() -> IndicatorView? {
        guard 0..<self.indicatorModels.count ~= activeIndicatorIndex,
              let cell = self.collectionView.cellForItem(at: IndexPath(item: self.activeIndicatorIndex, section: 0)) as? IndicatorCell else {
            return nil
        }
        
    
        return cell.indicatorView
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: iconLength, height: IndicatorCell.staticHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCellClasses(classes: [IndicatorCell.self])
        return collectionView
    }()
}

extension IndicatorContainer: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.indicatorModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IndicatorCell = collectionView.dequeueCell(indexPath: indexPath)
        cell.delegate = self
        cell.setData(data: self.indicatorModels[indexPath.item], index: indexPath.item)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let velocity = scrollView.panGestureRecognizer.velocity(in: self)
//
//        // 算出根据滑动定在哪个indicator上
//        let kMaxIndex = self.indicatorModels.count
//        let targetX = scrollView.contentOffset.x + velocity.x * 60.0
//        var targetIndex = 0
//        if (velocity.x > 0) {
//            targetIndex = Int(ceil(targetX / pageWidth))
//        } else if (velocity.x == 0) {
//            targetIndex = Int(round(targetX / pageWidth))
//        } else if (velocity.x < 0) {
//            targetIndex = Int(floor(targetX / pageWidth))
//        }
//        if (targetIndex < 0) {
//            targetIndex = 0
//        }
//        if (targetIndex > kMaxIndex) {
//            targetIndex = kMaxIndex
//        }
//        scrollView.contentOffset.x = CGFloat(targetIndex) * pageWidth;
//
//        setActiveIndicatorIndex(targetIndex)
//
//        guard let processIndicatorView = getActiveIndicator() else { return }
//        if processIndicatorView.status == .editing {
//            self.didActive(processIndicatorView.progress)
//        }
//    }
}

extension IndicatorContainer: IndicatorViewDelegate {
    func didActive(_ indicatorView: IndicatorView) {
        setActiveIndicatorIndex(indicatorView.index)
        self.didActive(indicatorView.progress)
    }
    
    func didTempReset(_ indicatorView: IndicatorView) {
        self.didTempReset()
    }
    
    func didRemoveTempReset(_ indicatorView: IndicatorView) {
        self.didRemoveTempReset(indicatorView.progress)
    }
}
