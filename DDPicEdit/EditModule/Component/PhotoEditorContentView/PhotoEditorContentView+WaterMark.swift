//
//  PhotoEditorContentView+WaterMark.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/29.
//

import UIKit
import Anchorage

extension PhotoEditorContentView {
    
    func addWaterMarkIn(data: WaterMarkData) {
        self.waterMarkLabel.isHidden = false
        switch data.waterMarkLocation {
        case .centerBottom:
            self.waterMarkLabelConstraint.rebatch {
                self.waterMarkLabel.centerXAnchor == self.imageView.centerXAnchor
                self.waterMarkLabel.bottomAnchor == self.imageView.bottomAnchor - 10
            }
        case .center:
            self.waterMarkLabelConstraint.rebatch {
                self.waterMarkLabel.centerAnchors == self.imageView.centerAnchors
            }
        case.rightBottom:
            self.waterMarkLabelConstraint.rebatch {
                self.waterMarkLabel.rightAnchor == self.imageView.rightAnchor - 10
                self.waterMarkLabel.bottomAnchor == self.imageView.bottomAnchor - 10
            }
        case .none:
            self.waterMarkLabel.isHidden = true
        }
    }
    
}
