//
//  PhotoEditorContext.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/13.
//

import Foundation

final class PhotoEditorContext {
    
    var toolOption: EditorPhotoToolOption?
    
    let options: EditorPhotoOptionsInfo
    
    private var didReceiveAction: ((PhotoEditorAction) -> Bool)?
    
    init(options: EditorPhotoOptionsInfo) {
        self.options = options
    }
}

extension PhotoEditorContext {
    
    func didReceiveAction(_ callback: @escaping ((PhotoEditorAction) -> Bool)) {
        if didReceiveAction == nil {
            didReceiveAction = callback
        }
    }
    
    @discardableResult
    func action(_ action: PhotoEditorAction) -> Bool {
        return didReceiveAction?(action) ?? false
    }
}
