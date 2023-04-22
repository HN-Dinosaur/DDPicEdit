//
//  EditorResult.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/19.
//

import Foundation

public struct EditorResult: Equatable {
    
    /// Local media url. Store in temporary directory.
    /// If you want to keep this file, you should move it to your document directory.
    public let mediaURL: URL
    
    /// Media type
    public let type: MediaType
    
    /// Media is edited or not
    public let isEdited: Bool
    
    init(mediaURL: URL, type: MediaType, isEdited: Bool) {
        self.mediaURL = mediaURL
        self.type = type
        self.isEdited = isEdited
    }
}
