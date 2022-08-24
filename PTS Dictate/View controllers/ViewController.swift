//
//  ViewController.swift
//  PTS Dictate
//
//  Created by Sachin on 23/08/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PTS Dictate"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.appThemeColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationController?.addCustomBottomLine(color: .black, height: 2.0)
        
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1.0
    }

    @IBAction func loginAction(_ sender: Any) {
        
    }
    
    @IBAction func remeberMeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}

extension UINavigationController{
    func addCustomBottomLine(color:UIColor,height:Double){
        //Hiding Default Line and Shadow
        navigationBar.setValue(true, forKey: "hidesShadow")
        
        //Creating New line
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width:0, height: height))
        lineView.backgroundColor = color
        navigationBar.addSubview(lineView)

        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.widthAnchor.constraint(equalTo: navigationBar.widthAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        lineView.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
    }
}

