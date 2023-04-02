//
//  ImageKitDataTrackDelegate.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import Foundation

public protocol ImageKitDataTrackDelegate: AnyObject {
    
    func dataTrack(page: AnyImagePage, state: AnyImagePageState)
    func dataTrack(event: AnyImageEvent, userInfo: [AnyImageEventUserInfoKey: Any])
}

extension ImageKitDataTrackDelegate {
    
    func dataTrack(page: AnyImagePage, state: AnyImagePageState) { }
    func dataTrack(event: AnyImageEvent, userInfo: [AnyImageEventUserInfoKey: Any]) { }
}
