//
//  Extension+UIViewCobtroller.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 25/08/22.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setPushTransitionAnimation(_ viewController: UIViewController?) {
        let transition = CATransition()
        transition.duration = 0.9
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        viewController?.navigationController?.view.layer.add(transition, forKey: nil)
    }
}
