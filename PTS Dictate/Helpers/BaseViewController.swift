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
        configureView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    // MARK: - Set Navigation Bar
    func configureView() {
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "shared_icon_navigation_back"), style: .plain, target: self, action: #selector(self.btnBackAction))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        DispatchQueue.main.async {
            self.navigationController?.addCustomBottomLine(color: UIColor.lightGray, height: 0.5)
        }
    }
    
    func setTitle(title: String) {
        self.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
    }
    
    func setTitleWithImage(_ title: String, andImage image: UIImage) {
          let titleLbl = UILabel()
          titleLbl.text = title
          titleLbl.textColor = UIColor.appThemeColor
          titleLbl.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
          let imageView = UIImageView(image: image)
          let titleView = UIStackView(arrangedSubviews: [imageView, titleLbl])
          titleView.axis = .horizontal
          titleView.spacing = 10.0
        self.tabBarController?.navigationItem.titleView = titleView
      }
    
    func addRightButton(selector: Selector) {
        let rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: selector)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        UIBarButtonItem.appearance()
            .setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)], for: .normal)
        
    }
    
    @objc func btnBackAction() {
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
