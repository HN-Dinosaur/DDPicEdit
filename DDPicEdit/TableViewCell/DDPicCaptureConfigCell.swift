//
//  DDPicCaptureConfigCell.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit
import Anchorage

public class DDPicCaptureConfigCell: DDPicBaseTableViewCell {
    public static var staticHeight: CGFloat { return 64 }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.recursiveAddSubView(views: [self.titleLabel, self.subTitleLabel, self.contentLabel])
        self.titleLabel.leftAnchor == self.contentView.leftAnchor + 10
        self.titleLabel.topAnchor == self.contentView.topAnchor + 12
        
        self.subTitleLabel.leftAnchor == self.titleLabel.leftAnchor
        self.subTitleLabel.topAnchor == self.titleLabel.bottomAnchor + 4
        
        self.contentLabel.centerYAnchor == self.contentView.centerYAnchor
        self.contentLabel.rightAnchor == self.contentView.rightAnchor - 10
    }
    
    public func setData(data: DDPicRowConfigProtocol) {
        self.titleLabel.text = data.title
        self.subTitleLabel.text = data.subTitle
        self.contentLabel.text = data.defaultValue
    }
    
    private lazy var titleLabel = UILabel(color: .textMainColor1(), textFont: .PingFangMedium(size: 14))
    private lazy var subTitleLabel = {
        let label = InsetLabel(inset: .init(horizontal: 4, vertical: 2))
        label.textColor = .systemBlue
        label.font = .PingFang(size: 11)
        if #available(iOS 13.0, *) {
            label.backgroundColor = .tertiarySystemGroupedBackground
        } else {
            label.backgroundColor = .subTitleBackGroudColor()
        }
        label.textAlignment = .center
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        return label
    }()
    private lazy var contentLabel = UILabel(color: .textSubColor1(), textFont: .PingFang(size: 12))
}
