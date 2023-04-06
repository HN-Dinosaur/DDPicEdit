//
//  DDPicCaptureViewController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit

public class DDPicCaptureViewController: DDPicBaseTableViewController {
    
    enum CaptureRowType: Int, CaseIterable, DDPicRowConfigProtocol {
        
        case mediaOptions = 0
        case preferredPresets
        case photoAspectRatio
        case preferredPositions
        case flashMode
        
        var title: String {
            switch self {
            case .mediaOptions:
                return "MediaOptions"
            case .preferredPresets:
                return "PreferredPresets"
            case .photoAspectRatio:
                return "PhotoAspectRatio"
            case .preferredPositions:
                return "PreferredPositions"
            case .flashMode:
                return "FlashMode"
            }
        }
        
        var subTitle: String {
            switch self {
            case .mediaOptions:
                return ".mediaOptions"
            case .preferredPresets:
                return ".preferredPresets"
            case .photoAspectRatio:
                return ".photoAspectRatio"
            case .preferredPositions:
                return ".preferredPositions"
            case .flashMode:
                return ".flashMode"
            }
        }
        
        var defaultValue: String {
            switch self {
            case .mediaOptions:
                return "Photo"
            case .preferredPresets:
                return "High Resolution: NO, High FrameRate: YES"
            case .photoAspectRatio:
                return "4:3"
            case .preferredPositions:
                return "Back+Front"
            case .flashMode:
                return "Off"
            }
        }
        
        func getFunction<T>(_ controller: T) -> ClickCellBlock where T : UIViewController {
            guard let controller = controller as? DDPicCaptureViewController else { return { _ in } }
            switch self {
            case .mediaOptions:
                return controller.mediaOptionsTapped
            case .preferredPresets:
                return controller.preferredPresetTapped
            case .photoAspectRatio:
                return controller.photoAspectRatioTapped
            case .preferredPositions:
                return controller.preferredPositionsTapped
            case .flashMode:
                return controller.flashModeTapped
            }
        }
    }
    
    var options =  CaptureOptionsInfo()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PicCapture"
        self.tableView.registerCellClasses(classes: [DDPicCaptureConfigCell.self])
        self.setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        let rightBtn = UIBarButtonItem(title: "Open Camera", style: .plain, target: self, action: #selector(openCamera))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    @objc
    private func openCamera() {
        options.enableDebugLog = true
        let controller = ImageCaptureController(options: options, delegate: self)
        controller.trackDelegate = self
        present(controller, animated: true, completion: nil)
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CaptureRowType.allCases.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DDPicCaptureConfigCell = tableView.dequeueCell(indexPath: indexPath)
        cell.setData(data: CaptureRowType.allCases[indexPath.row])
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DDPicCaptureConfigCell.staticHeight
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Options"
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowType = CaptureRowType.allCases[indexPath.row]
        rowType.getFunction(self)(indexPath)
    }

}

extension DDPicCaptureViewController {

    private func mediaOptionsTapped(_ indexPath: IndexPath) {
        // 暂时只支持拍摄照片
        present(UIAlertController.show(title: "Only Capture Select Now", actions: []), animated: true)
    }
    
    private func preferredPresetTapped(_ indexPath: IndexPath) {
        let action1 = UIAlertAction(title: "High Resolution: YES, High FrameRate: YES", style: .default) { [weak self] (action) in
            self?.options.preferredPresets = CapturePreset.createPresets(enableHighResolution: true, enableHighFrameRate: true)
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        let action2 = UIAlertAction(title: "High Resolution: YES, High FrameRate: NO", style: .default) { [weak self] (action) in
            self?.options.preferredPresets = CapturePreset.createPresets(enableHighResolution: true, enableHighFrameRate: false)
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        let action3 = UIAlertAction(title: "High Resolution: NO, High FrameRate: YES", style: .default) { [weak self] (action) in
            self?.options.preferredPresets = CapturePreset.createPresets(enableHighResolution: false, enableHighFrameRate: true)
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        let action4 = UIAlertAction(title: "High Resolution: NO, High FrameRate: NO", style: .default) { [weak self] (action) in
            self?.options.preferredPresets = CapturePreset.createPresets(enableHighResolution: false, enableHighFrameRate: false)
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        present(UIAlertController.show(title: "Preferred Preset", actions: [action1, action2, action3, action4]), animated: true)
    }
    
    private func photoAspectRatioTapped(_ indexPath: IndexPath) {
        let action1 = UIAlertAction(title: "1:1", style: .default) { [weak self] (action) in
            self?.options.photoAspectRatio = .ratio1x1
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        let action2 = UIAlertAction(title: "4:3", style: .default) { [weak self] (action) in
            self?.options.photoAspectRatio = .ratio4x3
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        let action3 = UIAlertAction(title: "16:9", style: .default) { [weak self] (action) in
            self?.options.photoAspectRatio = .ratio16x9
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        present(UIAlertController.show(title: "Photo Aspect Ratio", actions: [action1, action2, action3]), animated: true)
    }
    
    private func preferredPositionsTapped(_ indexPath: IndexPath) {
        let action1 = UIAlertAction(title: "Back+Front", style: .default) { [weak self] (action) in
            self?.options.preferredPositions = [.back, .front]
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        let action2 = UIAlertAction(title: "Front+Back", style: .default) { [weak self] (action) in
            self?.options.preferredPositions = [.front, .back]
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        let action3 = UIAlertAction(title: "Front", style: .default) { [weak self] (action) in
            self?.options.preferredPositions = [.front]
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        let action4 = UIAlertAction(title: "Back", style: .default) { [weak self] (action) in
            self?.options.preferredPositions = [.back]
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        present(UIAlertController.show(title: "Preferred Positions", actions: [action1, action2, action3, action4]), animated: true)
    }
    
    private func flashModeTapped(_ indexPath: IndexPath) {
        let action1 = UIAlertAction(title: "Auto", style: .default) { [weak self] (action) in
            self?.options.flashMode = .auto
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        let action2 = UIAlertAction(title: "Off", style: .default) { [weak self] (action) in
            self?.options.flashMode = .off
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        let action3 = UIAlertAction(title: "On", style: .default) { [weak self] (action) in
            self?.options.flashMode = .on
            (self?.tableView.cellForRow(at: indexPath) as? DDPicCaptureConfigCell)?.contentLabel.text = action.title
        }
        present(UIAlertController.show(title: "Preferred Positions", actions: [action1, action2, action3]), animated: true)
    }
}

extension DDPicCaptureViewController: ImageCaptureControllerDelegate {
    public func imageCapture(_ capture: ImageCaptureController, didFinishCapturing result: CaptureResult) {
        
    }
}

// MARK: - ImageKitDataTrackDelegate
extension DDPicCaptureViewController: ImageKitDataTrackDelegate {
    
    public func dataTrack(page: AnyImagePage, state: AnyImagePageState) {
        switch state {
        case .enter:
            print("[Data Track] ENTER Page: \(page.rawValue)")
        case .leave:
            print("[Data Track] LEAVE Page: \(page.rawValue)")
        }
    }
    
    public func dataTrack(event: AnyImageEvent, userInfo: [AnyImageEventUserInfoKey: Any]) {
        print("[Data Track] EVENT: \(event.rawValue), userInfo: \(userInfo)")
    }
}
