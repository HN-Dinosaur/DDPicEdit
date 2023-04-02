//
//  CaptureResult.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import Foundation

public struct CaptureResult: Equatable {
    
    public let mediaURL: URL
    
    /// Media type
    public let type: MediaType
    
    init(mediaURL: URL, type: MediaType) {
        self.mediaURL = mediaURL
        self.type = type
    }
}
