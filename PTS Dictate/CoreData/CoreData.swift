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
    var userName : String = ""
    var profileName : String = ""
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
    var archiveFileDays = 30 // 30 - day default
    var uploadViaWifi = 0 // 1 - true & 0 - false
    var sleepModeOverride = 0 // 1 - true & 0 - false
    var microSensitivityValue : Double = 1.0
    var fileName : String = ""
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
        dataSave()
    }
    
    // MARK: - saveLocalData
//    func openDatabse()
//        {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
//            let newUser = NSManagedObject(entity: entity!, insertInto: context)
//            saveData(UserDBObj:newUser)
//        }
    
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
        newData.setValue(profileName, forKey: "profileName")
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
        newData.setValue(audioFiles, forKey: "audioFiles")
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
                    if let profileName = result.value(forKey: "profileName") as? String{
                        self.profileName = profileName
                        print("data get profileName \(profileName)")
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
        }
        catch (let e)
        {
            print("something error during getting data \(e)")
        }
    }
    
    // MARK: - deleteLocalData
    func deleteProfile() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Login"))
        accessToken =  ""
        email = ""
        userName = ""
        profileName = ""
        privilege = ""
        audioQuality = 0
        voiceActivation = 0
        disableEmailNotify = 0
        commentScreen = 0
        commentScreenMandatory = 0
        indexing = 0
        disableEditingHelp = 0
        dateFormat = ""
        archiveFile = CoreData.shared.archiveFile
        archiveFileDays = CoreData.shared.archiveFileDays
        uploadViaWifi = 0
        sleepModeOverride = 0
        microSensitivityValue = 1.0
        userInfo.removeAll()
        fileName = ""
//        audioFiles = []
        
        if !self.isRemeberMe{
            self.userId = ""
            self.password = ""
        }
        do {
            try context.execute(DelAllReqVar)
        } catch {
            print(error)
        }
    }
}
