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
    var uploadingQueue: [AudioFile] = []
    var uploadingInProgress: Bool = false
    func uploadAudio(userName : String, toUser: String, emailNotify: Bool, fileUrl: URL, fileName: String, description: String, completion: @escaping () -> Void, failure: @escaping (String) -> Void) {
        let params: [String: String] = [
            "Login_Name": userName,
            "To_User": toUser,
            "Email_Notification": emailNotify ? "ON" : "OFF"
        ]
        ApiHandler.uploadMediaFile(url: "\(ApiPath.upload.rawValue)", withParameters: params as [String : AnyObject], ofType: UploadAPI.self, onSuccess: { (UploadAPI) in
            print(UploadAPI)
            completion()
        }, onFailure: { (reload, error) in
            failure(error)
            print(error)
        }, method: ApiMethod.POST, fileUrl: fileUrl, headerPresent: false, fileName: fileName, description: description, emailNotifications: emailNotify ? "ON" : "OFF")
    }
}
