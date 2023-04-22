//
//  DDPicEditViewController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit

class DDPicEditViewController: DDPicBaseTableViewController {
    
    var options = EditorPhotoOptionsInfo()
    
    private enum RowType: Int, CaseIterable, DDPicRowConfigProtocol {
        
        case editOptions = 0
        case penWidth
        case mosaicOptions
        case mosaicWidth
        case mosaicLevel
        case cropOptions
        
        var title: String {
            switch self {
            case .editOptions:
                return "EditOptions"
            case .penWidth:
                return "PenWidth"
            case .mosaicOptions:
                return "MosaicOptions"
            case .mosaicWidth:
                return "MosaicWidth"
            case .mosaicLevel:
                return "MosaicLevel"
            case .cropOptions:
                return "CropOptions"
            }
        }
        
        var subTitle: String {
            switch self {
            case .editOptions:
                return ".editOptions"
            case .penWidth:
                return ".brushWidth"
            case .mosaicOptions:
                return ".mosaicOptions"
            case .mosaicWidth:
                return ".mosaicWidth"
            case .mosaicLevel:
                return ".mosaicLevel"
            case .cropOptions:
                return ".cropOptions"
            }
        }
        
        var defaultValue: String {
            switch self {
            case .editOptions:
                return "Pen+Text+Crop+Mosaic"
            case .penWidth:
                return "5.0"
            case .mosaicOptions:
                return "Default+Colorful"
            case .mosaicWidth:
                return "15.0"
            case .mosaicLevel:
                return "30"
            case .cropOptions:
                return "Free/1:1/3:4/4:3/9:16/16:9"
            }
        }
        
        func getFunction<T>(_ controller: T) -> ClickCellBlock where T : UIViewController {
            guard let controller = controller as? DDPicEditViewController else { return { _ in } }
            switch self {
            case .editOptions:
                return controller.editOptionsTapped
            case .penWidth:
                return controller.penWidthTapped
            case .mosaicOptions:
                return controller.mosaicOptionsTapped
            case .mosaicWidth:
                return controller.mosaicWidthTapped
            case .mosaicLevel:
                return controller.mosaicLevelTapped
            case .cropOptions:
                return controller.cropOptionsTapped
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PicEdit"
        self.tableView.registerCellClasses(classes: [DDPicCaptureConfigCell.self])
        self.setupNavigation()
    }
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(openEditorTapped))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DDPicCaptureConfigCell = tableView.dequeueCell(indexPath: indexPath)
        let rowType = RowType.allCases[indexPath.row]
        cell.setData(data: rowType)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowType = RowType.allCases[indexPath.row]
        rowType.getFunction(self)(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Options"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DDPicCaptureConfigCell.staticHeight
    }
    
    @objc private func openEditorTapped() {
        options.enableDebugLog = true
        let image = UIImage(named: "EditorTestImage")!
        let controller = ImageEditorController(photo: image, options: options, delegate: self)
        controller.trackDelegate = self
        present(controller, animated: true, completion: nil)
    }
    
    private func afterClickCellBlock(indexPath: IndexPath, action: UIAlertAction, _ completion: Block) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell else { return }
        completion()
        cell.contentLabel.text = action.title
    }
    
    private func editOptionsTapped(_ indexPath: IndexPath) {
        let action1 = UIAlertAction(title: "Brush+Text+Crop+Mosaic", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.toolOptions = EditorPhotoToolOption.allCases
            }
        }
        let action2 = UIAlertAction(title: "Brush", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.toolOptions = [.brush]
            }
        }
        let action3 = UIAlertAction(title: "Text", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.toolOptions = [.text]
            }
        }
        let action4 = UIAlertAction(title: "Crop", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.toolOptions = [.crop]
            }
        }
        let action5 = UIAlertAction(title: "Mosaic", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.toolOptions = [.mosaic]
            }
        }
        let alert = UIAlertController.show(title: "Edit Options", actions: [action1, action2, action3, action4, action5])
        present(alert, animated: true, completion: nil)
    }
    
    private func penWidthTapped(_ indexPath: IndexPath) {
        let action1 = UIAlertAction(title: "2.5", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.brushWidth = 15.0
            }
        }
        let action2 = UIAlertAction(title: "5.0", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.brushWidth = 20.0
            }
        }
        let action3 = UIAlertAction(title: "7.5", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.brushWidth = 25.0
            }
        }
        let action4 = UIAlertAction(title: "10.0", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.brushWidth = 30.0
            }
        }
        let alert = UIAlertController.show(title: "Brush Width", actions: [action1, action2, action3, action4])
        self.present(alert, animated: true)
    }
    
    private func mosaicOptionsTapped(_ indexPath: IndexPath) {
        let action1 = UIAlertAction(title: "Default+Colorful", style: .default) { [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.mosaicOptions = [.default, .colorful]
            }
        }
        let action2 = UIAlertAction(title: "Default", style: .default) { [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.mosaicOptions = [.default]
            }
        }
        let action3 = UIAlertAction(title: "Colorful", style: .default) { [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.mosaicOptions = [.colorful]
            }
        }
        let alert = UIAlertController.show(title: "Mosaic Options", actions: [action1, action2, action3])
        self.present(alert, animated: true)
    }
    
    private func mosaicWidthTapped(_ indexPath: IndexPath) {
        let action1 = UIAlertAction(title: "15.0", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.mosaicWidth = 15.0
            }
        }
        let action2 = UIAlertAction(title: "20.0", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.mosaicWidth = 20.0
            }
        }
        let action3 = UIAlertAction(title: "25.0", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.mosaicWidth = 25.0
            }
        }
        let action4 = UIAlertAction(title: "30.0", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.mosaicWidth = 30.0
            }
        }
        let alert = UIAlertController.show(title: "Mosaic Width", actions: [action1, action2, action3, action4])
        self.present(alert, animated: true)
    }
    
    private func mosaicLevelTapped(_ indexPath: IndexPath) {
        let action1 = UIAlertAction(title: "20", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.mosaicLevel = 20
            }
        }
        let action2 = UIAlertAction(title: "30", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.mosaicLevel = 30
            }
        }
        let action3 = UIAlertAction(title: "40", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.mosaicLevel = 40
            }
        }
        let action4 = UIAlertAction(title: "50", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.mosaicLevel = 50
            }
        }
        let alert = UIAlertController.show(title: "Mosaic Level", actions: [action1, action2, action3, action4])
        self.present(alert, animated: true)
    }
    
    private func cropOptionsTapped(_ indexPath: IndexPath) {
        let action1 = UIAlertAction(title: "Free/1:1/3:4/4:3/9:16/16:9", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.cropOptions = EditorCropOption.allCases
            }
        }
        let action2 = UIAlertAction(title: "Free", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.cropOptions = [.free]
            }
        }
        let action3 = UIAlertAction(title: "1:1", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.cropOptions = [.custom(w: 1, h: 1)]
            }
        }
        let action4 = UIAlertAction(title: "Free/9:16/16:9", style: .default) {
            [weak self] (action) in
            self?.afterClickCellBlock(indexPath: indexPath, action: action) {
                self?.options.cropOptions = [.free, .custom(w: 9, h: 16), .custom(w: 16, h: 9)]
            }
        }
        let alert = UIAlertController.show(title: "Crop Options", actions: [action1, action2, action3, action4])
        self.present(alert, animated: true)
    }
    

}

// MARK: - ImageKitDataTrackDelegate
extension DDPicEditViewController: ImageKitDataTrackDelegate {
    
    func dataTrack(page: AnyImagePage, state: AnyImagePageState) {
        switch state {
        case .enter:
            print("[Data Track] ENTER Page: \(page.rawValue)")
        case .leave:
            print("[Data Track] LEAVE Page: \(page.rawValue)")
        }
    }
    
    func dataTrack(event: AnyImageEvent, userInfo: [AnyImageEventUserInfoKey: Any]) {
        print("[Data Track] EVENT: \(event.rawValue), userInfo: \(userInfo)")
    }
}

// MARK: - ImageEditorPhotoDelegate
extension DDPicEditViewController: ImageEditorControllerDelegate {

    func imageEditor(_ editor: ImageEditorController, didFinishEditing result: EditorResult) {
        if result.type == .photo {
            guard let photoData = try? Data(contentsOf: result.mediaURL) else { return }
            guard let photo = UIImage(data: photoData) else { return }
            let controller = EditorResultViewController()
            controller.imageView.image = photo
            show(controller, sender: nil)
            editor.dismiss(animated: true, completion: nil)
        }
    }
}
