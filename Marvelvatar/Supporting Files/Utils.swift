//
//  Utils.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 13/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit

class Utils {
    
    static func isInternetReachable() -> Bool {
    return Reachability.forInternetConnection().currentReachabilityStatus() == ReachableViaWiFi || Reachability.forInternetConnection().currentReachabilityStatus() == ReachableViaWWAN
    }
    
    static func showAlert(title: String?, message: String?, sender: UIViewController?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        sender?.present(alertController, animated: true, completion: nil)
    }
    
}
