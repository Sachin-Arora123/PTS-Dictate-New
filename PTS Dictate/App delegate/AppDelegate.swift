//
//  AppDelegate.swift
//  PTS Dictate
//
//  Created by Sachin on 23/08/22.
//

import UIKit
import IQKeyboardManagerSwift
import CoreData
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.placeholderColor = .clear
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        
//        CoreData.shared.getdata()
//        if CoreData.shared.email != "" {
//            let vc = TabbarVC.instantiateFromAppStoryboard(appStoryboard: AppStoryboard.Tabbar)
//            let navigationController = UINavigationController(rootViewController: vc)
//            if UIApplication.shared.windows.count > 0 {
//                UIApplication.shared.windows[0].rootViewController = navigationController
//                navigationController.setNavigationBarHidden(true, animated: false)
//            }
////            let fileURL = UserDefaults.standard.object(forKey: "terminatedRecording") as? String
////            tempChunks = UserDefaults.standard.array(forKey: "assetChunks")  as? [AVURLAsset] ?? [AVURLAsset]()
////            let decoded  = UserDefaults.standard.data(forKey: "assetChunks")
////            tempChunks = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [AVURLAsset] ?? [AVURLAsset]()
////            do{
////                if let colorAsData = UserDefaults.standard.object(forKey: "assetChunks") as? Data{
////                    if let color = try NSKeyedUnarchiver.unarchiveObject(with: colorAsData) as? [AVURLAsset] {
////                        // Use Color
////                        print(color)
////                        tempChunks = color
////                    }
////                }
////            }catch (let error){
////                #if DEBUG
////                    print("Failed to convert UIColor to Data : \(error.localizedDescription)")
////                #endif
////            }
////
////            print("launch-->>",fileURL ?? "")
////            self.concatTempChunks(filename: fileURL ?? "") {
////                (success) in
////                print("Success launch")
////            }
//        }
//        sleep(2)
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    class func sharedInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func moveToLoginVC() {
        let loginVC = LoginVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        self.window = UIApplication.shared.windows.first
        // Embed loginVC in Navigation Controller and assign the Navigation Controller as windows root
        let nav = UINavigationController(rootViewController: loginVC)
//        window?.rootViewController = nav
//        nav.setNavigationBarHidden(true, animated: false)
        changeRootViewController(nav)
    }
    
    func changeRootViewController(_ vc: UIViewController, options: UIView.AnimationOptions = .transitionFlipFromLeft ,animated: Bool = true) {
        guard let window = self.window else {
            return
        }

        window.rootViewController = vc

        // add animation
        UIView.transition(with: window,
                          duration: 0.5,
                          options: options,
                          animations: nil,
                          completion: nil)

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
        print("isRecording == \(isRecording)")
        print("audioFileName == \(audioFileName)")
        if isRecording{
            //increase file count by 1
            CoreData.shared.fileCount += 1
            AudioFiles.shared.saveNewAudioFile(name: audioFileName, autoSaved: true)
            audioFileName = ""
        }
    }
    
    
//     func concatTempChunks(filename: String, completion: @escaping(_ result: Bool) -> Void) {
//        let composition = AVMutableComposition()
//
//        var insertAt = CMTimeRange(start: CMTime.zero, end: CMTime.zero)
//        for asset in tempChunks {
//            let assetTimeRange = CMTimeRange(
//                start: CMTime.zero,
//                end:   asset.duration)
//
//            do {
//                try composition.insertTimeRange(assetTimeRange,
//                                                of: asset,
//                                                at: insertAt.end)
//            } catch {
//                NSLog("Unable to compose asset track.")
//            }
//
//            let nextDuration = insertAt.duration + assetTimeRange.duration
//            insertAt = CMTimeRange(
//                start:    CMTime.zero,
//                duration: nextDuration)
//        }
//
//        let exportSession =
//            AVAssetExportSession(
//                asset:      composition,
//                presetName: AVAssetExportPresetAppleM4A)
//
//        exportSession?.outputFileType = AVFileType.m4a
//        exportSession?.outputURL = self.createNewRecordingURL(filename)
//        print("OP",   exportSession?.outputURL)
//
//     // Leaving here for debugging purposes.
//     // exportSession?.outputURL = self.createNewRecordingURL("exported-")
//
//     // TODO: #36
//     // exportSession?.metadata = ...
//
//        exportSession?.canPerformMultiplePassesOverSourceMediaData = true
//        /* TODO? According to the docs, if multiple passes are enabled and
//         "When the value of this property is nil, the export session
//         will choose a suitable location when writing temporary files."
//         */
//        // exportSession?.directoryForTemporaryFiles = ...
//
//        /* TODO?
//         Listing all cases for completeness sake, but may just use `.completed`
//         and ignore the rest with a `default` clause.
//         OR
//         because the completion handler is run async, KVO would be more appropriate
//         */
//        exportSession?.exportAsynchronously {
//
//            switch exportSession?.status {
//            case .unknown?:
//                completion(false)
//                break
//            case .waiting?:
//                completion(false)
//                break
//            case .exporting?:
//                completion(false)
//                break
//            case .completed?:
//                /* Cleaning up partial recordings
//                 */
//                for asset in tempChunks {
//                    try! FileManager.default.removeItem(at: asset.url)
//                }
//
//                /* https://stackoverflow.com/questions/26277371/swift-uitableview-reloaddata-in-a-closure
//                */
////                DispatchQueue.main.async {
////                    self.listRecordings.tableView.reloadData()
////                }
//                completion(true)
//                /* Resetting `articleChunks` here, because this function is
//                 called asynchronously and calling it from `queueTapped` or
//                 `submitTapped` may delete the files prematurely.
//                 */
//                tempChunks = [AVURLAsset]()
//                tempAudioFileURL = ""
//                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//            case .failed?:
//                print("error:-->>",exportSession?.error?.localizedDescription ?? "")
//                completion(false)
//                break
//            case .cancelled?:
//                completion(false)
//                break
//            case .none:
//                completion(false)
//                break
//            case .some(_):
//                completion(false)
//                break
//            }
//        }
//    }
    
//    func createNewRecordingURL(_ filename: String = "") -> URL {
//        let fileURL = filename + ".m4a"
//        return Constants.documentDir.appendingPathComponent(fileURL)
//    }
}

