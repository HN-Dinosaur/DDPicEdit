//
//  DataTrackObserver.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import Foundation

protocol DataTrackObserver: AnyObject {
    
    func track(page: AnyImagePage, state: AnyImagePageState)
    func track(event: AnyImageEvent, userInfo: [AnyImageEventUserInfoKey: Any])
}
