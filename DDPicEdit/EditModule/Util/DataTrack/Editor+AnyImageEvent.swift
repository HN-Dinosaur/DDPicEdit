//
//  Editor+AnyImageEvent.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/17.
//

import Foundation

extension AnyImageEvent {
    
    // MARK: - Common
    /// UserInfo: [page: (editorPhoto|editorVideo)]
    public static let editorBack: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_BACK"
    
    /// UserInfo: [page: (editorPhoto|editorVideo)]
    public static let editorDone: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_DONE"
    
    /// UserInfo: [page: (editorPhoto|editorVideo)]
    public static let editorCancel: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_CANCEL"
    
    // MARK: - Photo
    
    public static let editorPhotoBrushUndo: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_BRUSH_UNDO"
    
    public static let editorPhotoMosaicUndo: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_MOSAIC_UNDO"
    
    /// UserInfo: [isOn: (true|false)]
    public static let editorPhotoTextSwitch: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_TEXT_SWITCH"
    
    public static let editorPhotoCropRotation: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_CROP_ROTATION"
    
    public static let editorPhotoCropCancel: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_CROP_CANCEL"
    
    public static let editorPhotoCropReset: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_CROP_RESET"
    
    public static let editorPhotoCropDone: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_CROP_DONE"
    
    public static let editorPhotoBrush: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_BRUSH"
    
    public static let editorPhotoMosaic: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_MOSAIC"
    
    public static let editorPhotoText: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_TEXT"
    
    public static let editorPhotoCrop: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_CROP"
    
    public static let editorPhotoWaterMark: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_WATER_MARK"
    
    public static let editorPhotoParameter: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_PARAMETER"
    
    public static let editorPhotoPaster: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_PASTER"
    
    public static let editorPhotoParameterChange: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_PARAMETER_CHANGE"
    
    public static let editorPhotoParameterCancel: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_PARAMETER_CANCEL"
    
    public static let editorPhotoParameterDone: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_PARAMETER_DONE"
    
    public static let editorPhotoPasterDone: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_PASTER_DONE"
    
    public static let editorPhotoPasterCancel: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_PASTER_CANCEL"
    
    public static let editorPhotoPasterSelect: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_PHOTO_PASTER_SELECT"
    
    // MARK: - Video
    
    /// UserInfo: [isOn: (true|false)] true=play, false=pause
    public static let editorVideoPlayPause: AnyImageEvent = "DDPICEDIT_EVENT_EDITOR_VIDEO_PLAY_PAUSE"
}
