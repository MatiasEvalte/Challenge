//
//  LaunchScreen.swift
//  
//
//  Created by Matias Borges Evalte on 20/05/19.
//

import UIKit
import RealmSwift

class SplashScreen: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let viewController = ViewController(nibName: "Main", bundle: nil)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let navigationController = CustomNavigationController(rootViewController: viewController)
        appDelegate.window!.rootViewController = navigationController
    }
}
