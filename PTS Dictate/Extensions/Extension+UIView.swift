//
//  Extension+UIView.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 30/08/22.
//

import Foundation
import UIKit

extension UIView{
    //extension UIView 
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-12.0, 12.0, -8.0, 8.0, -4.0, 4.0, -2.0, 2.0 ]
        layer.add(animation, forKey: "shake")
    }
}
