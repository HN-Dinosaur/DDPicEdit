//
//  PhotoEditorAction.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/12.
//

import UIKit

enum PhotoEditorAction {
    case empty
    case back
    case done
    case toolOptionChanged(EditorPhotoToolOption?)

    case brushBeginDraw
    case brushUndo
    case brushChangeColor(UIColor)
    case brushFinishDraw([BrushData])

    case mosaicBeginDraw
    case mosaicUndo
    case mosaicChangeImage(Int)
    case mosaicFinishDraw([MosaicData])

    case cropUpdateOption(EditorCropOption)
    case cropRotate
    case cropReset
    case cropCancel
    case cropDone
    case cropFinish(CropData)

    case stickerWillBeginEdit(StickerData)
    case stickerBringToFront(StickerData)
    case stickerWillBeginMove
    case stickerDidFinishMove(data: StickerData, delete: Bool)
    case stickerCancel
    case stickerDone(StickerData)
    
    case waterMarkChange(WaterMarkData)
    
    case picParameterChange(PicParameterData)
    case picParameterCancel
    case picParameterDone
    
    case pasterSelect(StickerData)
    case pasterCancel
    case pasterDone
    
    case shapeBeginDraw
    case shapeUndo
    case shapeChange(Int)
    case shapeFinishDraw
    case shapeDidRemove(DrawShapeData)
    case shapeAddData(DrawShapeData)
}

extension PhotoEditorAction {

    var duration: TimeInterval {
        switch self {
        case .toolOptionChanged(let option):
            if let option = option, option == .crop {
                return 0.5
            }
            return 0.1
        case .pasterSelect(_):
            return 0.5
        case .cropUpdateOption, .cropReset:
            return 0.55
        case .cropRotate:
            return 0.3
        case .cropDone, .cropCancel, .picParameterCancel, .picParameterDone,
                .pasterDone, .pasterCancel:
            return 0.25
        default:
            return 0.0
        }
    }
}
