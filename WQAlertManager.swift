//
//  WQAlertManager.swift
//  UMengShared
//
//  Created by 王强 on 2017/4/6.
//  Copyright © 2017年 moviewisdom. All rights reserved.
//

import UIKit

class WQAlertManager: NSObject {

    static let sharedInstance = WQAlertManager()
    private override init() {}
    
    func showAlert(targetVC: UIViewController, title: String?, message: String?, style: UIAlertControllerStyle, confirmTitle: String?, cancelTitle: String?) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: style)
        let confirmA = UIAlertAction.init(title: confirmTitle, style: .default) { (action) in
            
        }
        alertVC.addAction(confirmA)
        
        if cancelTitle != nil {
            let cancelA = UIAlertAction.init(title: cancelTitle, style: .cancel, handler: nil)
            alertVC.addAction(cancelA)
        }
        
        targetVC.present(alertVC, animated: true, completion: nil)
    }
}
