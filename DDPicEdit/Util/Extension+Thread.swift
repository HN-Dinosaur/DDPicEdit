//
//  Extension.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/29.
//

import Foundation

extension Thread {
    
    static func runOnMain(_ task: @escaping Block) {
        if isMainThread {
            task()
        } else {
            DispatchQueue.main.async {
                task()
            }
        }
    }
    
}
