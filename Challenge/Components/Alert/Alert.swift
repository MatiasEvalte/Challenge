//
//  Alert.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import Foundation
import UIKit

open class Alert {
    
    public static func alert(title: String = "Atenção", msg: String, viewController: UIViewController? = nil, _ btnName: String = "OK", _ completionOKClicked: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnName, style: .default, handler: { _ in
            completionOKClicked?()
        }))
        
        if let vc = viewController {
            vc.present(alert, animated: true, completion: nil)
        } else {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alert, animated: true, completion: nil)
            }
        }
    }
}
