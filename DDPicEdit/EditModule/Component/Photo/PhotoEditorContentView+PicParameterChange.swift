//
//  PhotoEditorContentView+PicParameterChange.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/4.
//

import UIKit

extension PhotoEditorContentView {

    func picParameterChange(data: PicParameterData) {
        guard self.lastPicData != data else { return }
        self.lastPicData = data
        DispatchQueue.main.async {
            self.imageView.image = self.image.editImage(contrast: data.contrast, brightness: data.brightness, saturation: data.saturation)
        }
    }
    
}
