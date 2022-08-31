//
//  LoginViewModel.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 31/08/22.
//

import Foundation
import UIKit

class LoginViewModel {
    
    class var shared: LoginViewModel{
        struct singleTon {
            static let instance = LoginViewModel()
        }
        return singleTon.instance
    }
    
    func LoginApiHit(userName : String, password: String){
        let params : [String : AnyObject] = [
            
            "Login_Name" : userName as AnyObject,
            "Password" : password as AnyObject,
        ]
//        CommonFunctions.showLoader()
        ApiHandler.callApiWithParameters(url: ApiPath.login.rawValue, withParameters: params as [String: AnyObject], ofType: LoginAPI.self, onSuccess: { (LoginAPI) in
//            CommonFunctions.hideLoader()
            print(LoginAPI.token ?? "")
            
        }, onFailure: { (reload, error) in
//            CommonFunctions.hideLoader()
            print(error)
        }, method: ApiMethod.POST, img: nil, imageParamater: nil, headerPresent: false)
    }
}
