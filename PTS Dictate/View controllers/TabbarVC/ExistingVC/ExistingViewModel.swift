//
//  ExistingViewModel.swift
//  PTS Dictate
//
//  Created by Hero's on 14/10/22.
//

import Foundation
import Alamofire

class  ExistingViewModel{
    
    class var shared: ExistingViewModel{
        struct singleTon {
            static let instance = ExistingViewModel()
        }
        return singleTon.instance
    }
    
    var existingViewController : ExistingVC?
    
    func uploadAudio(userName : String, toUser: String, emailNotify: Bool, fileUrl: URL) {
        let params : [String : Any] = [
            "Login_Name" : userName as Any,
            "To_User" : toUser as Any,
            "Email_Notification" : emailNotify as Any
        ]
        CommonFunctions.showLoader(title: "")
        ApiHandler.uploadMediaFile(url: "\(ApiPath.upload.rawValue)", withParameters: params as [String : AnyObject], ofType: UploadAPI.self, onSuccess: { (UploadAPI) in
            CommonFunctions.hideLoader()
            print(UploadAPI)
            
        }, onFailure: { (reload, error) in
            CommonFunctions.hideLoader()
            print(error)
        }, method: ApiMethod.POST, fileUrl: fileUrl, headerPresent: false)
    }
}
