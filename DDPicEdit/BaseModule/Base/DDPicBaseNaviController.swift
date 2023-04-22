//
//  DDPicBaseNaviController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit

open class DDPicBaseNaviController: UINavigationController {
    
    private var hasOverrideGeneratingDeviceOrientation: Bool = false
    open weak var trackDelegate: ImageKitDataTrackDelegate?
    open var enableForceUpdate: Bool = false
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? [.portrait]
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable, message: "Unsupported init(coder:)")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataTrackObserver
extension DDPicBaseNaviController: DataTrackObserver {
    
    func track(page: AnyImagePage, state: AnyImagePageState) {
        trackDelegate?.dataTrack(page: page, state: state)
    }
    
    func track(event: AnyImageEvent, userInfo: [AnyImageEventUserInfoKey: Any]) {
        trackDelegate?.dataTrack(event: event, userInfo: userInfo)
    }
}

extension DDPicBaseNaviController {
    
    func beginGeneratingDeviceOrientationNotifications() {
        if !UIDevice.current.isGeneratingDeviceOrientationNotifications {
            hasOverrideGeneratingDeviceOrientation = true
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
    }
    
    func endGeneratingDeviceOrientationNotifications() {
        if UIDevice.current.isGeneratingDeviceOrientationNotifications && hasOverrideGeneratingDeviceOrientation {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
            hasOverrideGeneratingDeviceOrientation = false
        }
    }
}
