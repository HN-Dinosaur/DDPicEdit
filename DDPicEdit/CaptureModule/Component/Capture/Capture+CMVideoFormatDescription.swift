//
//  Capture+CMVideoFormatDescription.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/5.
//

import AVFoundation

extension CMVideoFormatDescription {
    
    var dimensions: CMVideoDimensions {
        return CMVideoFormatDescriptionGetDimensions(self)
    }
    
}
