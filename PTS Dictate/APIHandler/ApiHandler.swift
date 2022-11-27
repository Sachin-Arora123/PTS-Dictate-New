//
//  ApiHandler.swift
//  
//
//  Created by Paras Kamboj on 30/08/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

// MARK:- Api Method Type
enum ApiMethod {
    case GET
    case POST
    case PostWithImage
    case PostString
    case GetString
    case PostWithJSON
    case PUT
    case PUTWithImage
    case DELETE
    case DELETEWithJSON
    case PUTWithJSON
}

//if let navCon = keyWindow?.rootViewController as? UINavigationController{
//                               print(navCon.viewControllers)
//                           }
//if let navCon = UIWindow.key?.rootViewController as? UINavigationController{
//    print(navCon.viewControllers)
//}

class ApiHandler: NSObject {

    // MARK:- THIS METHOD RETURN RESPONSE IN CODEABLE
    static func callApiWithParameters<T:Codable>(url: String , withParameters parameters: [String: Any], ofType : T.Type, onSuccess:@escaping (T)->(), onFailure: @escaping (Bool, String)->(), method: ApiMethod, img: [UIImage]? , imageParamater: [String]?, headerPresent: Bool){
        
        var header : HTTPHeaders = [
            :
        ]
        
        // MARK:- HEADER CREATED, YOU CAN ALSO SEND YOUR CUSTOM HEADER
        if headerPresent{
//            header = [.authorization("coredata.shared.accessToken"), .accept("application/json")]
            header = ["token" : "Bearer"]
            
        }
        
        // MARK:- PRINT ALL REQUESTED DATA
//        print("Requested data :-\n URL: \(BaseURL)\(url)\n HttpMethod: \(method)\n Header: \(header)\n Requested Params: \(parameters)\n\n\n\n\n")
        print("\(BaseURL)\(url)")
        print(parameters)
        print(header)
        print(method)
        
        // MARK:- CHECK WHETHER INTERNET IS CONNECTED OR NOT
        if !Reachability.isConnectedToNetwork(){
            onFailure(false, "Internet not found")
            return
        }
        
        // MARK:- REQUESTED METHODS
        if method == .GET || method == .POST || method == .PUT || method == .DELETE{
            
            var kMehod: HTTPMethod?
            
            switch method {
            case .GET:
                kMehod = .get
            case .POST:
                kMehod = .post
            case .PUT:
                kMehod = .put
            case .DELETE:
                kMehod = .delete
            default:
                break
            }
            
            AF.sessionConfiguration.timeoutIntervalForRequest = 60              //FOR TIMEOUT SETTINGS
            AF.request("\(BaseURL)\(url)", method: kMehod ?? .get, parameters: parameters, encoding: URLEncoding.default, headers: header).response{ response in
                print(response)
                
                let statusCode = response.response?.statusCode
                switch response.result{
                case .success(_):
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let json = try JSONDecoder().decode(T.self, from: data)
                                print("json Data--->>",json)
                                onSuccess(json)
                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict["error"].stringValue != ""{
                                print(dict["error"].stringValue,"\n", dict["error_description"].stringValue)
                                onFailure(false,dict["error_description"].stringValue )
                            }else{
                                onFailure(false,dict["error_description"].stringValue)
                            }
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else{
                            if dict["error"].stringValue != ""{
                                print(dict["error"].stringValue,"\n", dict["error_description"].stringValue)
                                onFailure(false,dict["error_description"].stringValue )
                            }else{
                                onFailure(false,dict["error_description"].stringValue)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
            
        }else if method == .PostWithJSON || method == .PUTWithJSON || method == .DELETEWithJSON{
            
            let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            var request = URLRequest(url: URL(string: "\(BaseURL)\(url)")!)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.headers = header
            
            if method == .PostWithJSON{
                request.httpMethod = "POST"
            }else if method == .PUTWithJSON{
                request.httpMethod = "PUT"
            }else{
                request.httpMethod = "DELETE"
            }
            
            AF.request(request).response{response in
                print(response)
                let statusCode = response.response?.statusCode
                switch response.result{
                case .success(_):
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let json = try JSONDecoder().decode(T.self, from: data)
                                onSuccess(json)
                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict["error"].stringValue != ""{
                                print(dict["error"].stringValue,"\n", dict["error_description"].stringValue)
                                onFailure(false,dict["error_description"].stringValue )
                            }else{
                                onFailure(false,dict["error_description"].stringValue)
                            }
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else{
                            if dict["error"].stringValue != ""{
                                print(dict["error"].stringValue,"\n", dict["error_description"].stringValue)
                                onFailure(false,dict["error_description"].stringValue )
                            }else{
                                onFailure(false,dict["error_description"].stringValue)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
        }else if method == .GetString || method == .PostString{
            var kMehod: HTTPMethod?
            
            switch method {
            case .GetString:
                kMehod = .get
            case .PostString:
                kMehod = .post
            default:
                break
            }
            
            AF.request("\(BaseURL)\(url)", method: kMehod ?? .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseString{ response in
                print(response)
                let statusCode = response.response?.statusCode
                switch response.result{
                case .success(_):
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let json = try JSONDecoder().decode(T.self, from: data)
                                onSuccess(json)
                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict["error"].stringValue != ""{
                                print(dict["error"].stringValue,"\n", dict["error_description"].stringValue)
                                onFailure(false,dict["error_description"].stringValue )
                            }else{
                                onFailure(false,dict["error_description"].stringValue)
                            }
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else{
                            if dict["error"].stringValue != ""{
                                print(dict["error"].stringValue,"\n", dict["error_description"].stringValue)
                                onFailure(false,dict["error_description"].stringValue )
                            }else{
                                onFailure(false,dict["error_description"].stringValue)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
            
        }else{       // MARK:- UPLOAD IMAGE IN THIS CASE, However it is better to make upload 1 by 1 instead of uploading all at once.
            //                        because if it failed, it will only failed on 1 image. but upload all at once,
            //                         if 1 file failed user need to restart the uploading process from the beginning.
            //                         nevertheless here is what you going have to do if you want to upload multiple data at once.
            
            // MARK:- IMAGES AND IMAGE PARAMS MUST BE EQUAL
            if img?.count != imageParamater?.count{
                print("\nNumber of images and number of image parameters must be same.")
                return
            }
            
            var kMehod: HTTPMethod = .post
            
            if method == .PUTWithImage{
                kMehod = .put
            }
            
            AF.upload(multipartFormData: {multipartFormData in
                
                for (num, value) in (imageParamater ?? []).enumerated() {
                    guard let compressedImg = img?[num].jpegData(compressionQuality: 0.2)else{
                        return
                    }
                    multipartFormData.append(compressedImg, withName: value, fileName: "File-\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    print("\n param : \(value) \n imgName : \("File-\(Date().timeIntervalSince1970).jpeg") ")
                }
                
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
            }, to: "\(BaseURL)\(url)", method: kMehod, headers: header).uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }).responseJSON(completionHandler: { data in
                print("upload finished: \(data)")
            }).response { (response) in
                let statusCode = response.response?.statusCode
                switch response.result {
                case .success(let resut):
                    print("upload success result: \(resut ?? Data())")
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let json = try JSONDecoder().decode(T.self, from: data)
                                onSuccess(json)
                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict["error"].stringValue != ""{
                                print(dict["error"].stringValue,"\n", dict["error_description"].stringValue)
                                onFailure(false,dict["error_description"].stringValue )
                            }else{
                                onFailure(false,dict["error_description"].stringValue)
                            }
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else{
                            if dict["error"].stringValue != ""{
                                print(dict["error"].stringValue,"\n", dict["error_description"].stringValue)
                                onFailure(false,dict["error_description"].stringValue )
                            }else{
                                onFailure(false,dict["error_description"].stringValue)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
        }
    }
    
    static func uploadMediaFile<T:Codable>(url: String , withParameters parameters: [String: Any], ofType : T.Type, onSuccess:@escaping (T)->(), onFailure: @escaping (Bool, String)->(), method: ApiMethod, fileUrl: URL, headerPresent: Bool, fileName: String, description: String, emailNotifications: String) {
        let kMehod: HTTPMethod = .post
        let uatURL = "https://uat.etranscriptions.com.au/scripts/web_response.php?Case=UploadFile&Login_Name=\(CoreData.shared.userId)&File_Desc=\(description)&From_User=pts&To_User=pts&Email_Notification=\(emailNotifications)"
        
//    https://uat.etranscriptions.com.au/scripts/web_response.php?Case=UploadFile&Login_Name=nathanuat$01&File_Desc=new comment&From_User=pts&To_User=pts&Email_Notification=OFF
        let liveURL = "https://www.etranscriptions.com.au/scripts/web_response.php?Case=UploadFile&Login_Name=\(CoreData.shared.userId)&File_Desc=\(description)&From_User=pts&To_User=pts&Email_Notification=\(emailNotifications)"
        
        let header : HTTPHeaders = [
            :
        ]
            
            AF.upload(multipartFormData: {multipartFormData in
                multipartFormData.append(fileUrl, withName: "uploaded_file", fileName: "", mimeType: ".m4a")
//                for (key, value) in parameters {
//                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                }
                
            }, to: uatURL, method: kMehod, headers: header).uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }).responseJSON(completionHandler: { data in
                print("upload finished: \(data)")
            }).response { (response) in
                let statusCode = response.response?.statusCode
                switch response.result {
                case .success(let resut):
                    print("upload success result: \(resut ?? Data())")
                    if (200...299).contains(statusCode ?? 0){
                        if let data = response.data{
                            do{
                                let json = try JSONDecoder().decode(T.self, from: data)
                                onSuccess(json)
                            }
                            catch let error as NSError {
                                print("Could not save error named - \n\(error)\n\(error.userInfo)\n\(error.userInfo.debugDescription)")
                                print("\(error.localizedFailureReason ?? "")\n", error.localizedDescription)
                                onFailure(false, error.userInfo.debugDescription)
                            }
                        }
                    }else{
                        let dict = JSON(response.data ?? Data())
                        if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404){
                            if dict["error"].stringValue != ""{
                                print(dict["error"].stringValue,"\n", dict["error_description"].stringValue)
                                onFailure(false,dict["error_description"].stringValue )
                            }else{
                                onFailure(false,dict["error_description"].stringValue)
                            }
                        }else if (statusCode == 500 || statusCode == 503){
                            print("Server Error")
                            onFailure(false,"Server Error")
                        }else{
                            if dict["error"].stringValue != ""{
                                print(dict["error"].stringValue,"\n", dict["error_description"].stringValue)
                                onFailure(false,dict["error_description"].stringValue )
                            }else{
                                onFailure(false,dict["error_description"].stringValue)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    onFailure(false, error.localizedDescription)
                }
            }
    }
}
