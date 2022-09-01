//
//  CoreData.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 30/08/22.
//

import UIKit
import CoreData
import Foundation

class CoreData: NSObject {
    
    var accessToken: String =  ""
    var userName : String = ""
    var email: String = ""
    var privilege: String = ""
    var isRemeberMe : Bool = false
    var password = ""
    
    class var shared: CoreData{
        struct singleTon {
            static let instance = CoreData()
        }
        return singleTon.instance
    }


    func addData(loginData : LoginAPI){
        self.email = loginData.email ?? ""
        self.privilege = loginData.privilege ?? ""
//        self.accessToken = 
        dataSave()
    }
    
    // MARK: - saveLocalData
    func dataSave(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Login"))

        do {
            try context.execute(DelAllReqVar)
        } catch {
            print(error)
        }
        let newData = NSEntityDescription.insertNewObject(forEntityName: "Login", into: context)
        newData.setValue(accessToken, forKey: "accessToken")
        newData.setValue(userName, forKey: "userName")
        newData.setValue(isRemeberMe, forKey: "isRemeberMe")
        newData.setValue(password, forKey: "password")
        newData.setValue(email, forKey: "email")
        newData.setValue(privilege, forKey: "privilege")

        do {
            try context.save()
            print(newData)
            print("new data saved")
        }catch{
            print("new data save error")
        }
    }
    // MARK: - getLocalData
    func getdata() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        request.returnsObjectsAsFaults = true
        do{
            let results = try context.fetch(request)
            if(results.count > 0){
                for result in results as![NSManagedObject]{
                    if let accessToken = result.value(forKey: "accessToken") as? String{
                        self.accessToken = accessToken
                        print("data get accessToken \(accessToken)")
                    }
                    if let userName = result.value(forKey: "userName") as? String{
                        self.userName = userName
                        print("data get userName \(userName)")
                    }
                    if let isRemeberMe = result.value(forKey: "isRemeberMe") as? Bool{
                        self.isRemeberMe = isRemeberMe
                        print("data get isRemeberMe \(isRemeberMe)")
                    }
                    if let password = result.value(forKey: "password") as? String{
                        self.password = password
                        print("data get password \(password)")
                    }
                    if let email = result.value(forKey: "email") as? String{
                        self.email = email
                        print("data get email \(email)")
                    }
                    if let privilege = result.value(forKey: "privilege") as? String{
                        self.privilege = privilege
                        print("data get userName \(privilege)")
                    }
                }
            }
        }
        catch
        {
            print("something error during getting data")
        }
    }
    // MARK: - deleteLocalData
    func deleteProfile() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Login"))
        accessToken =  ""
        email = ""
        privilege = ""
        
        if !self.isRemeberMe{
            self.userName = ""
            self.password = ""
        }
        do {
            try context.execute(DelAllReqVar)
        } catch {
            print(error)
        }
    }
}
