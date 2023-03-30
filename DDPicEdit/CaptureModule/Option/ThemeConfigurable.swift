//
//  ThemeConfigurable.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/29.
//

import UIKit

public typealias ThemeConfigurable = ThemeColorConfigurable & ThemeIconConfigurable & ThemeStringConfigurable

public protocol ThemeColorConfigurable {
    associatedtype ColorKey: Hashable
    
    subscript(color key: ColorKey) -> UIColor { set get }
}

public protocol ThemeIconConfigurable {
    
    associatedtype IconKey: Hashable
    
    subscript(icon key: IconKey) -> UIImage? { set get }
    
}

public protocol ThemeStringConfigurable {
    
    subscript(string key: StringConfigKey) -> String { set get }
    
}
