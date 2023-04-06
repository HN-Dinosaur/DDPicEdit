//
//  Capture+CGImage.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/5.
//

import Foundation
import CoreGraphics
import ImageIO

extension CGImage {
    
    func jpegData(compressionQuality: CGFloat) -> Data? {
        let options: [CFString: Any] = [kCGImageDestinationLossyCompressionQuality: compressionQuality as CFNumber]
        return data(fileType: .jpeg, options: options)
    }
    
    func pngData() -> Data? {
        return data(fileType: .png)
    }
    
    private func data(fileType: FileType, options: [CFString: Any] = [:]) -> Data? {
        guard
            let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, fileType.utType, 1, nil)
            else {
                return nil
        }
        CGImageDestinationAddImage(destination, self, options as CFDictionary)
        // TODO: add meta
        // CGImageDestinationAddImageAndMetadata
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}
