//
//  Extension+UIStackView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/11.
//

import UIKit

public extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView] = [],
                     axis: NSLayoutConstraint.Axis = .horizontal,
                     alignment: UIStackView.Alignment = .center,
                     distribution: UIStackView.Distribution = .fill,
                     spacing: CGFloat = 0,
                     insets: UIEdgeInsets = .zero)
    {
        self.init()
        arrangedSubviews.forEach {
            addArrangedSubview($0)
        }
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        if insets != .zero {
            isLayoutMarginsRelativeArrangement = true
            self.setLayoutMarginWithoutInsetFromSafeArea(insets: insets)
        }
    }
}
