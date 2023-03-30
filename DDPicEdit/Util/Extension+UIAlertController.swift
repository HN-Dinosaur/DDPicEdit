//
//  Extension+UIAlertController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/29.
//

import UIKit

extension UIAlertController {
    
    static func show(title: String? = nil, message: String? = nil, preferStyle: UIAlertController.Style = .alert, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferStyle)
        for action in actions {
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
}
