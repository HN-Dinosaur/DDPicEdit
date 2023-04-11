//
//  BundleHelper.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/1.
//

import UIKit

struct BundleHelper {
    
    static var appName: String {
        if let info = Bundle.main.infoDictionary {
            if let appName = info["CFBundleDisplayName"] as? String { return appName }
            if let appName = info["CFBundleName"] as? String { return appName }
            if let appName = info["CFBundleExecutable"] as? String { return appName }
        }
        return ""
    }
}
