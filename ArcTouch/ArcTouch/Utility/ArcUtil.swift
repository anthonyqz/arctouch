//
//  ArcUtil.swift
//  ArcTouch
//
//  Created by Christian Quicano on 11/13/16.
//  Copyright © 2016 ca9z. All rights reserved.
//

import UIKit

class ArcUtil: NSObject {

    //MARK:- class methods
    class func showAlert(title:String?, message:String?) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let rootViewController = appDelegate.window?.rootViewController {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Accept", style: .default, handler: nil)
                alert.addAction(okAction)
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
