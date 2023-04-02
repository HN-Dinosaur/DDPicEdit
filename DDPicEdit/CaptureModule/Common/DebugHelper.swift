//
//  DebugHelper.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import Foundation

var enableDebugLog = false

func _print(_ message: Any, _ file: String = #file, _ line: Int = #line) {
    #if DEBUG
    if enableDebugLog {
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):\(line)] \(message)")
    }
    #endif
}
