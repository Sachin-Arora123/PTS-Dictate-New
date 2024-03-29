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
        configureView()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    // MARK: - Set Navigation Bar
    func configureView() {
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "shared_icon_navigation_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.btnBackAction))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        DispatchQueue.main.async {
            self.navigationController?.addCustomBottomLine(color: UIColor.lightGray, height: 0.5)
        }
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor:UIColor.appThemeColor]

            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setTitle(title: String) {
        self.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor:UIColor.appThemeColor]
        
        self.navigationController?.navigationBar.clipsToBounds = false
        

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
    
    func setTitleWithoutImage(_ title: String) {
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.textColor = UIColor.appThemeColor
        titleLbl.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        let titleView = UIStackView(arrangedSubviews: [titleLbl])
        titleView.axis = .horizontal
        titleView.spacing = 10.0
        
        if self.tabBarController != nil{
            self.tabBarController?.navigationItem.titleView = titleView
        }else{
            self.navigationItem.titleView = titleView
        }
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "shared_icon_navigation_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.btnBackAction))
        self.tabBarController?.navigationItem.leftBarButtonItem = leftBarButtonItem

    }
    func setRighButtonImage(imageName: String, selector: Selector) {
        let img = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        let rightButton = UIBarButtonItem(image: img,
                                          style: UIBarButtonItem.Style.plain,
                                          target: self,
                                          action: selector)
        self.tabBarController?.navigationItem.rightBarButtonItem = rightButton
    }
    
    func getRighButtonImage(imageName: String) -> UIImage {
        let img = UIImage(named: imageName)!.withRenderingMode(.alwaysOriginal)
        let rightButton = UIBarButtonItem(image: img,
                                          style: UIBarButtonItem.Style.plain,
                                          target: self,
                                          action: nil)
        self.tabBarController?.navigationItem.rightBarButtonItem = rightButton
        return rightButton.image ?? UIImage()
    }
    
    func hideLeftButton(){
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    func addRightButton(selector: Selector) {
        let rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: selector)
        UIBarButtonItem.appearance()
            .setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .heavy)], for: .normal)
        rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appThemeColor], for: .normal)
        if self.tabBarController != nil{
            self.tabBarController?.navigationItem.rightBarButtonItem = rightBarButtonItem
        }else{
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
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
