//
//  UIAlertController+SystemAlert.swift
//
//  Created by Errol Cheong on 2019-02-09.
//
import UIKit
extension UIAlertController {
    enum ActionTitle: String {
        case ok = "Ok"
        case confirm = "Confirm"
        case dismiss = "Dismiss"
        case cancel = "Cancel"
        case delete = "Delete"
        case settings = "Settings"
    }
    class func confirmAlert(_ title: String?, message: String?, confirmTitle: ActionTitle, confirm: ((UIAlertAction) -> Void)? = nil, cancel: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        // Create Alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Add Cancel Action
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: cancel))
        // Add Ok Action
        alert.addAction(UIAlertAction(title: confirmTitle.rawValue, style: .default, handler: confirm))
        return alert
    }
    class func systemAlert(_ title: String?, message: String?, actionTitle: ActionTitle = .ok, _ completionHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        // Create Alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Add Ok Action
        alert.addAction(UIAlertAction(title: actionTitle.rawValue, style: .default, handler: completionHandler))
        return alert
    }
}
