//
//  TabbarVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 25/08/22.
//

import UIKit


class TabbarVC: UITabBarController, UITabBarControllerDelegate {

    var thirdTabbarItemImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // Do any additional setup after loading the view.
        let thirdItemView = self.tabBar.subviews[2]
        self.thirdTabbarItemImageView = thirdItemView.subviews.first as? UIImageView
        self.thirdTabbarItemImageView.contentMode = .center
    }
    
    override func viewWillLayoutSubviews() {

       }

    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.2, 0.9, 1.1, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
    private func animate(_ imageView: UIImageView) {
          UIView.animate(withDuration: 0.1, animations: {
              imageView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
          }) { _ in
              UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3.0, options: .curveEaseInOut, animations: {
                  imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
              }, completion: nil)
          }
      }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let tabbarItemTag = item.tag
          switch tabbarItemTag {
          case 0:
              break
          case 2:
              animate(thirdTabbarItemImageView)
          default:
              break
          }
      }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == "logout"{
            print("logout")
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
        return true
    }
}
