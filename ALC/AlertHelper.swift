//
//  AlertHelper.swift
//  GoBetSearch
//
//  Created by Patrik Adolfsson on 2017-07-18.
//  Copyright © 2017 Patrik Adolfsson. All rights reserved.
//

import UIKit


class AlertHelper {
    
    private class func notificationAlert(title: String, message:String, showCancel:Bool, viewController : UIViewController, color: UIColor) {
        
        //Create alert Controller _> title, message, style
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // set the background color here
        alertController.view.backgroundColor = color
        
        //Create button Action -> title, style, action
        let successAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(successAction)
        
        //Create button Action -> title, style, action
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        if( showCancel ) {
            alertController.addAction(cancelAction)
        }
        
        // if iPads
        alertController.popoverPresentationController?.sourceView = viewController.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
        alertController.popoverPresentationController?.permittedArrowDirections = []
        
        viewController.present(alertController, animated: true, completion:nil)
    }
    
    class func displayError(title: String, message:String, viewController : UIViewController) {
        
        notificationAlert(title: title, message: message, showCancel: false, viewController: viewController, color: .clear)
    }
    
    class func displaySuccess(title: String, message:String, viewController : UIViewController) {
        
        notificationAlert(title: title, message: message, showCancel: false, viewController: viewController, color: .clear)
    }
    class func displayConfirm(title: String, message:String, viewController : UIViewController) {
        
        notificationAlert(title: title, message: message, showCancel: true, viewController: viewController, color: .clear)
        
    }
}
