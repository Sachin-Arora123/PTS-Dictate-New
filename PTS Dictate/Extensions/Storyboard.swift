//
//  Storyboard.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 25/08/22.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    
    case Main = "Main"
    case Tabbar = "Tabbar"

    var instance: UIStoryboard{
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass : T.Type) -> T{
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController?{
        return instance.instantiateInitialViewController()
    }
}


extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryboard(appStoryboard: AppStoryboard) -> Self{
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
