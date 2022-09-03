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
                let vc = TabbarVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
                    UIView.animate(withDuration: 0.50, animations: {() -> Void in
                    UIView.setAnimationCurve(.easeInOut)
                        self.loginViewController?.navigationController?.pushViewController(vc, animated: true)
                        UIView.setAnimationTransition(.flipFromRight, for: (self.loginViewController?.navigationController?.view)!, cache: false)
                })
                CoreData.shared.isRemeberMe = self.loginViewController?.isRemember ?? false
                CoreData.shared.userName = userName
                CoreData.shared.password = password
                CoreData.shared.addData(loginData: LoginAPI)
            }else{
                CommonFunctions.toster("PTS Dictate",titleDesc: "Please enter valid username & password")
            }
            
        }, onFailure: { (reload, error) in
//            CommonFunctions.hideLoader()
            print(error)
        }, method: ApiMethod.POST, img: nil, imageParamater: nil, headerPresent: false)
    }
}
