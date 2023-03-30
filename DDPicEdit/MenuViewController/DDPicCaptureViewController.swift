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
        case videoMaximumDuration
        
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
            case .videoMaximumDuration:
                return "VideoMaximumDuration"
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
            case .videoMaximumDuration:
                return ".videoMaximumDuration"
            }
        }
        
        var defaultValue: String {
            switch self {
            case .mediaOptions:
                return "Photo+Video"
            case .preferredPresets:
                return "High Resolution: NO, High FrameRate: YES"
            case .photoAspectRatio:
                return "4:3"
            case .preferredPositions:
                return "Back+Front"
            case .flashMode:
                return "Off"
            case .videoMaximumDuration:
                return "20"
            }
        }
        
        func getFunction<T>(_ controller: T) -> ((IndexPath) -> Void) where T : UIViewController {
            return { _ in }
        }
    }
    
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

}
