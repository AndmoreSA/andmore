//
//  WindowManager.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 02/06/2021.
//

import UIKit

enum StoryboardName: String {
    case seller = "owner"
    case user = "user"
    case login = "Main"
}

class WindowManager {
    
    fileprivate static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    class func show(storyboard: StoryboardName, animated: Bool) {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() {
            appDelegate.window?.rootViewController = controller
            
            if animated {
                UIView.transition(with: appDelegate.window!, duration: 0.4, options: [.transitionCrossDissolve], animations: {
                    appDelegate.window?.rootViewController = controller
                }, completion: nil)
                
            }else{
                appDelegate.window?.rootViewController = controller
            }
        }
    }
}
