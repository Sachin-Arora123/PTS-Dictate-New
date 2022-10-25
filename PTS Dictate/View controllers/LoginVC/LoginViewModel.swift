//
//  LoginViewModel.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 31/08/22.
//

import Foundation
import UIKit
import iProgressHUD

class LoginViewModel {
    
    class var shared: LoginViewModel{
        struct singleTon {
            static let instance = LoginViewModel()
        }
        return singleTon.instance
    }
    
    var loginViewController : LoginVC?
    
    func LoginApiHit(userName : String, password: String){
        let params : [String : AnyObject] = [
            
            "Login_Name" : userName as AnyObject,
            "Password" : password as AnyObject,
        ]
        CommonFunctions.showLoader(title: "Logging In...")
        ApiHandler.callApiWithParameters(url: "\(ApiPath.login.rawValue)", withParameters: params as [String : AnyObject], ofType: LoginAPI.self, onSuccess: { (LoginAPI) in
            CommonFunctions.hideLoader()
            print(LoginAPI)
            if LoginAPI.email != nil{
//                let vc = TabbarVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
//                UIView.animate(withDuration: 0.50, animations: {() -> Void in
//                    UIView.setAnimationCurve(.easeInOut)
//                let navigationController = UINavigationController(rootViewController: vc)
//                if UIApplication.shared.windows.count > 0 {
//                    UIApplication.shared.windows[0].rootViewController = navigationController
//                }
//                    UIView.setAnimationTransition(.flipFromRight, for: (navigationController.view)!, cache: false)
//            })
                
                let vc = TabbarVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
//                    UIView.animate(withDuration: 0.50, animations: {() -> Void in
//                    UIView.setAnimationCurve(.easeInOut)
                let nav = UINavigationController(rootViewController: vc)
                if UIApplication.shared.windows.count > 0 {
                    UIApplication.shared.windows[0].rootViewController = nav
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        //show welcome banner
                        CommonFunctions.toster("Welcome", titleDesc: CoreData.shared.userName, false)
                    }
                }
                        AppDelegate.sharedInstance().changeRootViewController(nav, options: .transitionFlipFromRight,animated: true)
//                        self.loginViewController?.navigationController?.pushViewController(vc, animated: true)
//                        UIView.setAnimationTransition(.flipFromRight, for: (self.loginViewController?.navigationController?.view)!, cache: false)
//                })
                CoreData.shared.isRemeberMe = self.loginViewController?.isRemember ?? false
                CoreData.shared.userName = LoginAPI.userName ?? userName
                
                //make profile name and save
                let notAllowedChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890").inverted
                let resultString = userName.components(separatedBy: notAllowedChars).joined(separator: "")
                CoreData.shared.profileName = resultString
                
                CoreData.shared.userId = userName
                CoreData.shared.password = password
                CoreData.shared.addData(loginData: LoginAPI)
                CoreData.shared.userInfo.append(userName)
                CoreData.shared.userInfo.append(LoginAPI.userName ?? userName)
                CoreData.shared.userInfo.append(LoginAPI.email ?? "")
            }else{
                CommonFunctions.toster("PTS Dictate",titleDesc: "Please enter valid username & password", true)
            }
            
        }, onFailure: { (reload, error) in
//            CommonFunctions.hideLoader()
            print(error)
        }, method: ApiMethod.POST, img: nil, imageParamater: nil, headerPresent: false)
    }
}
