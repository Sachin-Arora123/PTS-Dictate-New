//
//  TabbarVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 25/08/22.
//

import UIKit


class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    
    var thirdTabbarItemImageView: UIImageView!
    var viewControllerToSelect: UIViewController?
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate = self
        
        let thirdItemView = self.tabBar.subviews[2]
        self.thirdTabbarItemImageView = thirdItemView.subviews.first as? UIImageView
        if thirdTabbarItemImageView != nil {
            self.thirdTabbarItemImageView.contentMode = .center
        }
        self.navigationController?.addCustomBottomLine(color: .black, height: 2.0)
        additionalSafeAreaInsets.bottom = UIDevice.current.hasNotch ? 0 : 12
        //First, remove the default top line and background
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        //Then, add the custom top line view with custom color. And set the default background color of tabbar
        let lineView = UIView(frame: CGRect(x: 0, y: -1, width: UIScreen.main.bounds.width, height: 1))
        lineView.backgroundColor = #colorLiteral(red: 0.5137254902, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
        self.tabBar.addSubview(lineView)
        lineView.layer.masksToBounds = true
        self.tabBar.sendSubviewToBack(lineView)
        //        self.tabBarController?.tabBar.backgroundColor = .white
        
//        let appearance = UITabBarItem.appearance()
//        let attributes = [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 10)]
//        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
//        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .selected)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        // access to list of tab bar items
        if let items = self.tabBar.items {
            for (ind, itemt) in items.enumerated() {
                if ind == 2{
                    return
                }
                // here customise image insets top and bottom
                itemt.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -5, right: 0)
                let viewTabBar = itemt.value(forKey: "view") as? UIView
                if viewTabBar?.subviews.count == 2 {
                    if let label = viewTabBar?.subviews[1] as? UILabel {
                        label.numberOfLines = 2
                        label.textAlignment = .center
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            label.frame = CGRect(x: label.frame.minX, y: label.frame.minY, width: ind == 0 ? UIScreen.main.bounds.width/9.8 : 44, height: 25)
                            viewTabBar?.layoutIfNeeded()
                            viewTabBar?.setNeedsLayout()
                            viewTabBar?.layoutSubviews()
                        }
                    }
                }
            }
        }
    }
    
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.2, 0.9, 1.1, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
    private func animate(_ imageView: UIImageView) {
        UIView.animate(withDuration: 0.6, animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.40, y: 1.40)
        }) { _ in
            UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: .curveEaseInOut, animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let currentIndex = tabBar.items?.firstIndex(of: item)
        let tabbarItemTag = item.tag
        print(self.navigationItem.hidesBackButton)
        switch tabbarItemTag {
        case 0:
            if currentIndex == 3{
                if let settingsVC = self.viewControllers?[3] as? UINavigationController{
                    settingsVC.popToRootViewController(animated: false)
                }
            }
            break
        case 2:
            if currentIndex != selectedIndex {
                if thirdTabbarItemImageView != nil {
                    animate(thirdTabbarItemImageView)
                }
            }
        default:
            break
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == "logout"{
            if isUploading{
                CommonFunctions.alertMessage(view: viewController, title: "PTS Dictate", msg: "Uploading In progress", btnTitle: "Ok", completion: nil)
                return false
            }else{
                CommonFunctions.showAlert(view: viewController, title: "PTS Dictate", message: "Are you sure you want to Logout?", completion: {
                    (result) in
                    if result{
                        print("Tapped Yes")
                        CoreData.shared.deleteProfile()
                        AppDelegate.sharedInstance().moveToLoginVC()
                    }else{
                        print("Tapped No")
                    }
                })
                return false
            }
        }else if viewController.title != "Record" {
            if isRecording{
                CommonFunctions.showAlert(view: viewController, title: "PTS Dictate", message: "Do you want to stop the current Recording ?", completion: {
                    (result) in
                    if result{
                        self.setTabBarHidden(true, animated: false)
                        NotificationCenter.default.post(name: Notification.Name("showBottomBtnView"), object: nil)
                    }
                })
                return false
            }
        }
        return true
    }
}

extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

extension UITabBarController {
    func setTabBarHidden(_ isHidden: Bool, animated: Bool, completion: (() -> Void)? = nil ) {
        if (tabBar.isHidden == isHidden) {
            completion?()
        }
        
        if !isHidden {
            tabBar.isHidden = false
        }
        
        let height = tabBar.frame.size.height
        let offsetY = view.frame.height - (isHidden ? 0 : height)
        let duration = (animated ? 0.50 : 0.0)
        
        let frame = CGRect(origin: CGPoint(x: tabBar.frame.minX, y: offsetY), size: tabBar.frame.size)
        UIView.animate(withDuration: duration, animations: {
            self.tabBar.frame = frame
        }) { _ in
            self.tabBar.isHidden = isHidden
            completion?()
        }
    }
}
