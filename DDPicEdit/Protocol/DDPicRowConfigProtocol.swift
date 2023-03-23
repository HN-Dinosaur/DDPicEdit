//
//  DDPicRowConfigProtocol.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit

public protocol DDPicRowConfigProtocol {
    
    var title: String { get }
    var subTitle: String { get }
    var defaultValue: String { get }
    
    func getFunction<T: UIViewController>(_ controller: T) -> ((IndexPath) -> Void)
}
