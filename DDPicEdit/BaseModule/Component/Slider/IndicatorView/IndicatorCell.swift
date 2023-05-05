//
//  IndicatorCell.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/4.
//

import UIKit
import Anchorage

public class IndicatorCell: DDPicBaseCollectionViewCell {
    
    public static let staticHeight: CGFloat = 70
    
    var delegate: IndicatorViewDelegate? {
        didSet {
            self.indicatorView.delegate = self.delegate
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        self.contentView.backgroundColor = .clear
        self.contentView.recursiveAddSubView(views: [self.indicatorView, self.describeLabel])
        self.indicatorView.horizontalAnchors == self.contentView.horizontalAnchors
        self.indicatorView.topAnchor == self.contentView.topAnchor
        self.indicatorView.heightAnchor == 50
        
        self.describeLabel.horizontalAnchors == self.contentView.horizontalAnchors
        self.describeLabel.topAnchor == self.indicatorView.bottomAnchor + 5
        self.describeLabel.heightAnchor == 15
    }
    
    func setData(data: IndicatorModel, index: Int) {
        self.indicatorView.limitNumber = data.limitNumber
        self.indicatorView.normalIconImage = data.normalIconImage
        self.indicatorView.dimmedIconImage = data.dimmedIconImage
        self.indicatorView.index = index
        self.describeLabel.text = data.describeStr
    }
    
    public lazy var indicatorView: IndicatorView = {
        let view = IndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return view
    }()
    private lazy var describeLabel = UILabel(color: .white, textFont: .PingFang(size: 12), textAlignment: .center)
}


