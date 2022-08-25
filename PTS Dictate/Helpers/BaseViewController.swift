//
//  BaseViewController.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 24/08/22.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    // MARK: - Set Navigation Bar
    func showNavigationBar(title : String, BackBtnImage : String, animated : Bool){
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .white
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: BackBtnImage), style: .done, target: self, action: #selector(self.btnActBack))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
        self.title = title.uppercased()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.black]
        
        DispatchQueue.main.async {
            self.navigationController?.addCustomBottomLine(color: UIColor.lightGray, height: 0.5)
        }
    }
    
    @objc func btnActBack(){
        if let navigationCon = self.navigationController {
            let viewControllersCount = navigationCon.viewControllers.count
            if viewControllersCount != 0 && viewControllersCount != 1 {
                self.navigationController?.popViewController(animated: true)
            } else {
                if self.presentingViewController == nil {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
