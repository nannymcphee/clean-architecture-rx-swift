//
//  AppDialog.swift
//  NetflixClone
//
//  Created by Duy Nguyen on 31/03/2022.
//

import UIKit

class AppDialog {
    /**
     * notify with alert
     */
    public static func withOk(controller: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    /**
     * notify with OK action button
     */
    public static func withOk(controller: UIViewController, title: String, message: String,
                              ok: @escaping ()->()){
        
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            ok()
        }
        refreshAlert.addAction(okAction)
        controller.present(refreshAlert, animated: true, completion: nil)
    }
    
    /**
     * notify with alert plus action button
     */
    public static func withOkCancel(controller: UIViewController, title: String, message: String,
                                    ok: @escaping ()->()){
        
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            ok()
        }
        refreshAlert.addAction(okAction)
        
        // Add cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        refreshAlert.addAction(cancelAction)
        controller.present(refreshAlert, animated: true, completion: nil)
    }
    
    public static func actionSheet(controller: UIViewController, title: String? = nil, message: String? = nil, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        actions.forEach({ alert.addAction($0) })
        alert.addAction(cancelAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
}
