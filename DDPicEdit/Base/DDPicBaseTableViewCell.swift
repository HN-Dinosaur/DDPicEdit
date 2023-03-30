//
//  DDPicBaseTableViewCell.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit

public class DDPicBaseTableViewCell: UITableViewCell {

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable, message: "Unsupported init(coder:)")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
