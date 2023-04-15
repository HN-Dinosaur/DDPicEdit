//
//  CacheModule.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/13.
//

import UIKit

enum CacheModule {
    
    case picker(CacheModulePicker)
    case editor(CacheModuleEditor)
}

enum CacheModulePicker: String {
    
    case `default` = "Default"
}

enum CacheModuleEditor: String {

    case `default` = "Default"
    case bezierPath = "BezierPath"
}

extension CacheModule {
    
    var title: String {
        switch self {
        case .picker:
            return "Picker"
        case .editor:
            return "Editor"
        }
    }
    
    var subTitle: String {
        switch self {
        case .picker(let subModule):
            return subModule.rawValue
        case .editor(let subModule):
            return subModule.rawValue
        }
    }
    
    var path: String {
        let lib = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first ?? ""
        return "\(lib)/DDPicCache/\(title)/\(subTitle)/"
    }
}

extension CacheModuleEditor {
    
    static var imageModule: [CacheModuleEditor] {
        return [.default, .bezierPath]
    }
}
