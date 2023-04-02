//
//  DDPicBaseViewController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit

open class DDPicBaseViewController: UIViewController {

    private var page: AnyImagePage = .undefined
    weak var trackObserver: DataTrackObserver?
    private var isStatusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    open override var prefersStatusBarHidden: Bool { isStatusBarHidden }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setTrack()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackObserver?.track(page: page, state: .enter)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        trackObserver?.track(page: page, state: .leave)
    }

    public func updateStatusBarHidden(isStatusBarHidden: Bool) {
        self.isStatusBarHidden = isStatusBarHidden
    }

    private func setTrack() {
        switch self {
        case _ as CaptureViewController:
            page = .capture
        default:
            page = .undefined
        }
    }
    
    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag)
        self.setTrackObserverOrDelegate(viewControllerToPresent)
    }
    
    private func setTrackObserverOrDelegate(_ viewControllerToPresent: UIViewController) {
        if let vc = viewControllerToPresent as? DDPicBaseViewController {
            vc.trackObserver = self.trackObserver
        } else if let navi = viewControllerToPresent as? DDPicBaseNaviController,
                  let currNavi = navigationController as? DDPicBaseNaviController  {
                      navi.trackDelegate = currNavi.trackDelegate
        }
    }
}


// MARK: -Permission
extension DDPicBaseViewController {
    
    func check(permission: Permission, authorized: @escaping () -> Void, limited: @escaping () -> Void, denied: @escaping (Permission) -> Void) {
        switch permission.status {
        case .notDetermined:
            permission.requestAccess { result in
                switch result {
                case .authorized:
                    authorized()
                case .denied:
                    denied(permission)
                default:
                    limited()
                }
            }
        case .authorized:
            authorized()
        case .limited:
            limited()
        case .denied:
            denied(permission)
        }
    }
    
    func check(permission: Permission, stringConfig: ThemeStringConfigurable, authorized: @escaping Block, canceled: @escaping PermissCancelBlock) {
        check(permission: permission, authorized: authorized, limited: authorized) { [weak self] _ in
            guard let self = self else { return }
            let title = String(format: stringConfig[string: .permissionIsDisabled], stringConfig[string: permission.localizedTitleKey])
            let message = String(format: stringConfig[string: permission.localizedAlertMessageKey], BundleHelper.appName)
            let action = UIAlertAction(title: stringConfig[string: .settings], style: .default) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url) { _ in
                    canceled(permission)
                }
            }
            let cancelAction = UIAlertAction(title: stringConfig[string: .cancel], style: .cancel) { _ in
                canceled(permission)
            }
            let alert = UIAlertController.show(title: title, message: message, actions: [action, cancelAction], isCustomCancelAction: true)
            self.present(alert, animated: true)
        }
    }
    
    func check(permissions: [Permission], stringConfig: ThemeStringConfigurable, authrized: @escaping Block, canceled: @escaping PermissCancelBlock) {
        if !permissions.isEmpty {
            var _permissions = permissions
            let permission = _permissions.removeLast()
            self.check(permission: permission, stringConfig: stringConfig, authorized: { [weak self] in
                guard let self = self else { return }
                self.check(permissions: _permissions, stringConfig: stringConfig, authrized: authrized, canceled: canceled)
            }, canceled: canceled)
        } else {
            authrized()
        }
    }
}
