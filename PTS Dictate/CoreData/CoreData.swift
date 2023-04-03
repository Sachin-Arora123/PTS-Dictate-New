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
    // 1 - true for switch on & 0 - false for switch off
    var accessToken: String =  ""
    
    //username entered by user while login
    var userName : String = ""
    
    //created by app for user to creating file name for upload
    var profileName : String = ""
    
    //return by login api to show in welcome mesaage
    var welcomeName : String = ""
    
    var userId : String = ""
    var email: String = ""
    var privilege: String = ""
    var isRemeberMe : Bool = false
    var password = ""
    var audioQuality = 0
    var voiceActivation = 0 // 1 - true & 0 - false
    var disableEmailNotify = 0 // 1 - true & 0 - false
    var commentScreen = 0 // 1 - true & 0 - false
    var commentScreenMandatory = 0 // 1 - true & 0 - false
    var indexing = 0 // 1 - true & 0 - false
    var disableEditingHelp = 0 // 1 - true & 0 - false
    var fileCount: Int = 1
    var dateFormat: String = ""
    var archiveFile = 1 // 1 - true & 0 - false
    var archiveFileDays = 3 // 3 - day default
    var uploadViaWifi = 0 // 1 - true & 0 - false
    var sleepModeOverride = 0 // 1 - true & 0 - false
    var microSensitivityValue : Double = 1.0
    var fileName : String = ""
    var filePath : String = ""
    var userInfo = [String]()
    var audioFiles: [AudioFile] = [] {
        didSet {
            AudioFiles.shared.audioFiles = audioFiles
        }
    }
    
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
            dataSave(loginData: loginData)
    }
    
    // MARK: - saveLocalData
//    func openDatabse()
//        {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
//            let newUser = NSManagedObject(entity: entity!, insertInto: context)
//            saveData(UserDBObj:newUser)
//        }
    func uncheckOtherUser(loginData : LoginAPI){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        request.predicate = NSPredicate(format: "userId != %@", loginData.userID ?? "" )
        request.returnsObjectsAsFaults = true
        do{
            let results = try context.fetch(request)
            if(results.count > 0){
                for item in (results as? [Login])!{
                    item.setValue(false, forKey: "isLastLoggedIn")
                }
               
                try context.save()
            }
            
        }catch{
            debugPrint("eror")
        }}
    func checkUserAlreadyExistOrNot(loginData : LoginAPI)->Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        request.predicate = NSPredicate(format: "userId = %@", loginData.userID ?? "" )
        request.returnsObjectsAsFaults = true
        do{
            let results = try context.fetch(request)
            if(results.count > 0){
                let managedObject = results[0] as? Login
                managedObject?.setValue(true, forKey: "isLoggedIn")
                managedObject?.setValue(true, forKey: "isLastLoggedIn")
                managedObject?.setValue(isRemeberMe, forKey: "isRemeberMe")
                try context.save()
                return true
            }else{
                return false
            }
            
        }catch{
            return false
        }
    }
    func dataSave(loginData : LoginAPI?=nil){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if loginData != nil{
            uncheckOtherUser(loginData: loginData!)
            if !checkUserAlreadyExistOrNot(loginData: loginData!){
                //uncheckOtherUser(loginData: loginData!)
                resetLocalDataVariable()
            }else{
                
                return
            }
        }else{
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
            request.predicate = NSPredicate(format: "isLoggedIn = %@", NSNumber(value: true) )
            let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: request)

            do {
                try context.execute(DelAllReqVar)
            } catch {
                print(error)
            }
        }
      
        let newData = NSEntityDescription.insertNewObject(forEntityName: "Login", into: context)
        newData.setValue(accessToken, forKey: "accessToken")
        newData.setValue(userName, forKey: "userName")
        newData.setValue(profileName, forKey: "profileName")
        newData.setValue(welcomeName, forKey: "welcomeName")
        newData.setValue(userId, forKey: "userId")
        newData.setValue(isRemeberMe, forKey: "isRemeberMe")
        newData.setValue(password, forKey: "password")
        newData.setValue(email, forKey: "email")
        newData.setValue(privilege, forKey: "privilege")
        newData.setValue(audioQuality, forKey: "audioQuality")
        newData.setValue(voiceActivation, forKey: "voiceActivation")
        newData.setValue(disableEmailNotify, forKey: "disableEmailNotify")
        newData.setValue(commentScreen, forKey: "commentScreen")
        newData.setValue(commentScreenMandatory, forKey: "commentScreenMandatory")
        newData.setValue(indexing, forKey: "indexing")
        newData.setValue(disableEditingHelp, forKey: "disableEditingHelp")
        newData.setValue(fileCount, forKey: "fileCount")
        newData.setValue(dateFormat, forKey: "dateFormat")
        newData.setValue(archiveFile, forKey: "archiveFile")
        newData.setValue(archiveFileDays, forKey: "archiveFileDays")
        newData.setValue(uploadViaWifi, forKey: "uploadViaWifi")
        newData.setValue(sleepModeOverride, forKey: "sleepModeOverride")
        newData.setValue(microSensitivityValue, forKey: "microSensitivityValue")
        newData.setValue(fileName, forKey: "fileName")
        newData.setValue(filePath, forKey: "filePath")
        newData.setValue(audioFiles, forKey: "audioFiles")
        newData.setValue(true, forKey: "isLoggedIn")
        newData.setValue(true, forKey: "isLastLoggedIn")
        
        do {
            try context.save()
            print(newData)
            print("new data saved")
        }catch{
            print("new data save error")
        }
    }
    func getremembereddata(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        request.predicate = NSPredicate(format: "isLastLoggedIn = %@", NSNumber(value: true))

        
        request.returnsObjectsAsFaults = true
        do{
            let results = try context.fetch(request)
            if(results.count > 0){
                setUpData(results)
            }
        }
        catch (let e)
        {
            print("something error during getting data \(e)")
        }
    }
    
    // MARK: - getLocalData
    fileprivate func setUpData(_ results: [NSFetchRequestResult]) {
        for result in results as![NSManagedObject]{
            if let accessToken = result.value(forKey: "accessToken") as? String{
                self.accessToken = accessToken
                print("data get accessToken \(accessToken)")
            }
            if let userName = result.value(forKey: "userName") as? String{
                self.userName = userName
                print("data get userName \(userName)")
            }
            if let profileName = result.value(forKey: "profileName") as? String{
                self.profileName = profileName
                print("data get profileName \(profileName)")
            }
            if let welcomeName = result.value(forKey: "welcomeName") as? String{
                self.welcomeName = welcomeName
                print("data get welcomeName \(welcomeName)")
            }
            if let fileName = result.value(forKey: "fileName") as? String{
                self.fileName = fileName
                print("data get fileName \(fileName)")
            }
            if let filePath = result.value(forKey: "filePath") as? String{
                self.filePath = filePath
                print("data get filePath \(filePath)")
            }
            if let userId = result.value(forKey: "userId") as? String{
                self.userId = userId
                print("data get userId \(userId)")
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
                print("data get privilege \(privilege)")
            }
            if let audioQuality = result.value(forKey: "audioQuality") as? Int{
                self.audioQuality = audioQuality
                print("data get audioQuality \(audioQuality)")
            }
            if let voiceActivation = result.value(forKey: "voiceActivation") as? Int{
                self.voiceActivation = voiceActivation
                print("data get voiceActivation \(voiceActivation)")
            }
            if let disableEmailNotify = result.value(forKey: "disableEmailNotify") as? Int{
                self.disableEmailNotify = disableEmailNotify
                print("data get disableEmailNotify \(disableEmailNotify)")
            }
            if let commentScreen = result.value(forKey: "commentScreen") as? Int{
                self.commentScreen = commentScreen
                print("data get commentScreen \(commentScreen)")
            }
            if let commentScreenMandatory = result.value(forKey: "commentScreenMandatory") as? Int{
                self.commentScreenMandatory = commentScreenMandatory
                print("data get commentScreenMandatory \(commentScreenMandatory)")
            }
            if let indexing = result.value(forKey: "indexing") as? Int{
                self.indexing = indexing
                print("data get indexing \(indexing)")
            }
            if let disableEditingHelp = result.value(forKey: "disableEditingHelp") as? Int{
                self.disableEditingHelp = disableEditingHelp
                print("data get disableEditingHelp \(disableEditingHelp)")
            }
            if let fileCount = result.value(forKey: "fileCount") as? Int{
                self.fileCount = fileCount
                print("data get fileCount \(fileCount)")
            }
            if let dateFormat = result.value(forKey: "dateFormat") as? String{
                self.dateFormat = dateFormat
                print("data get dateFormat \(dateFormat)")
            }
            if let archiveFile = result.value(forKey: "archiveFile") as? Int{
                self.archiveFile = archiveFile
                print("data get archiveFile \(archiveFile)")
            }
            if let archiveFileDays = result.value(forKey: "archiveFileDays") as? Int{
                self.archiveFileDays = archiveFileDays
                print("data get archiveFileDays \(archiveFileDays)")
            }
            if let uploadViaWifi = result.value(forKey: "uploadViaWifi") as? Int{
                self.uploadViaWifi = uploadViaWifi
                print("data get uploadViaWifi \(uploadViaWifi)")
            }
            if let sleepModeOverride = result.value(forKey: "sleepModeOverride") as? Int{
                self.sleepModeOverride = sleepModeOverride
                print("data get id \(sleepModeOverride)")
            }
            if let microSensitivityValue = result.value(forKey: "microSensitivityValue") as? Double{
                self.microSensitivityValue = microSensitivityValue
                print("data get microSensitivityValue \(microSensitivityValue)")
            }
            guard let audioFiles = result.value(forKey: "audioFiles") as? [AudioFile] else {
                self.audioFiles = []
                print("Failed to load audio files from core data")
                return
            }
            self.audioFiles = audioFiles
            print("data get audio files \(audioFiles)")
        }
    }
    
    func getdata() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        request.predicate = NSPredicate(format: "isLoggedIn = %@", NSNumber(value: true))

        
        request.returnsObjectsAsFaults = true
        do{
            let results = try context.fetch(request)
            if(results.count > 0){
                setUpData(results)
            }
        }
        catch (let e)
        {
            print("something error during getting data \(e)")
        }
    }
    
    // MARK: - deleteLocalData
    func deleteProfile() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Login"))
        CoreData.shared.accessToken = ""
        CoreData.shared.email       = ""
        welcomeName = ""
        privilege = ""
        
       // self.dataSave()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        request.predicate = NSPredicate(format: "isLoggedIn = %@", NSNumber(value: true) )
        request.returnsObjectsAsFaults = true
        do{
            let results = try context.fetch(request)
            if(results.count > 0){
                
                var managedObject = results[0] as? Login
                managedObject?.setValue(false, forKey: "isLoggedIn")
                
            }
            try context.save()
        }catch{
            debugPrint("error while logout")
        }
//        userName = CoreData.shared.userName
//        isRemeberMe = CoreData.shared.isRemeberMe
//        profileName = CoreData.shared.profileName
//        audioQuality = CoreData.shared.audioQuality
//        voiceActivation = CoreData.shared.voiceActivation
//        disableEmailNotify = CoreData.shared.disableEmailNotify
//        commentScreen = CoreData.shared.commentScreen
//        commentScreenMandatory = CoreData.shared.commentScreenMandatory
//        indexing = 0
//        disableEditingHelp = CoreData.shared.disableEditingHelp
//        dateFormat      = CoreData.shared.dateFormat
//        archiveFile     = CoreData.shared.archiveFile
//        archiveFileDays = CoreData.shared.archiveFileDays
//        uploadViaWifi   = CoreData.shared.uploadViaWifi
//        sleepModeOverride = CoreData.shared.sleepModeOverride
//        microSensitivityValue = CoreData.shared.microSensitivityValue
//        userInfo.removeAll()
//        fileName = CoreData.shared.fileName
//        filePath = CoreData.shared.filePath
        
        if !self.isRemeberMe{
            self.userName = ""
            self.password = ""
        }
//        do {
//            try context.execute(DelAllReqVar)
//        } catch {
//            print(error)
//        }
    }
    func resetLocalDataVariable(){
        
         audioQuality = 0
         voiceActivation = 0 // 1 - true & 0 - false
         disableEmailNotify = 0 // 1 - true & 0 - false
         commentScreen = 0 // 1 - true & 0 - false
         commentScreenMandatory = 0 // 1 - true & 0 - false
         indexing = 0 // 1 - true & 0 - false
         disableEditingHelp = 0 // 1 - true & 0 - false
         fileCount = 1
         dateFormat = ""
         archiveFile = 1 // 1 - true & 0 - false
         archiveFileDays = 3 // 3 - day default
         uploadViaWifi = 0 // 1 - true & 0 - false
         sleepModeOverride = 0 // 1 - true & 0 - false
         microSensitivityValue  = 1.0
         fileName  = ""
         filePath  = ""
         userInfo = [String]()
         audioFiles = []
    }
}

