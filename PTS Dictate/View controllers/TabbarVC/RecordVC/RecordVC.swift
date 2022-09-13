//
//  RecordVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 04/09/22.
//

import UIKit
import CoreData
import AVFoundation

var isRecording: Bool = false
var audioRecorder:AVAudioRecorder?
var audioPlayer:AVAudioPlayer?

class RecordVC: BaseViewController {
    
    // MARK: - @IBOutlets.
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnForwardTrim: UIButton!
    @IBOutlet weak var btnForwardTrimEnd: UIButton!
    @IBOutlet weak var btnBackwardTrim: UIButton!
    @IBOutlet weak var btnBackwardTrimEnd: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFName: UILabel!
    @IBOutlet weak var lblFNameValue: UILabel!
    @IBOutlet weak var lblFSize: UILabel!
    @IBOutlet weak var lblFSizeValue: UILabel!
    @IBOutlet weak var lblMaxFSize: UILabel!
    @IBOutlet weak var lblMaxFSizeValue: UILabel!
    @IBOutlet weak var viewBottomButton: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDiscard: UIButton!
    @IBOutlet weak var lblPlayerStatus: UILabel!
    
    let fileManager = FileManager.default
    let audioSession = AVAudioSession.sharedInstance()
    var soundsNoteID: String!        // populated from incoming seque
    var soundsNoteTitle: String!     // populated from incoming seque
    var soundURL: String!            // store in CoreData
    var recordTimer:Timer!
    var audioFileName: String = ""
    var dataListArray = [AnyObject]()
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.recorderSetUp()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.onDiscardRecorderSetUp), name: Notification.Name("refreshRecorder"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showBottomView), name: Notification.Name("showBottomBtnView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
        self.recorderSetUp()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioRecorder = nil
        self.tabBarController?.setTabBarHidden(false, animated: false)
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self, name: Notification.Name("showBottomBtnView"), object: nil)
    }
    
    // MARK: - UISetup
    func setUpUI(){
        hideLeftButton()
        setTitleWithImage("Record", andImage: UIImage(named: "title_record_normal.png") ?? UIImage())
    }
 
    @objc func showBottomView() {
        audioRecorder?.stop()
//        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            print("Stop")
            btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
            btnRecord.isUserInteractionEnabled = false
            btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            btnBackwardTrim.setBackgroundImage(UIImage(named: "existing_rewind_normal"), for: .normal)
            btnBackwardTrimEnd.setBackgroundImage(UIImage(named: "existing_backward_fast_normal"), for: .normal)
            btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_disable"), for: .normal)
            btnPlay.isUserInteractionEnabled = true
            btnBackwardTrim.isUserInteractionEnabled = true
            btnBackwardTrimEnd.isUserInteractionEnabled = true
            btnStop.isUserInteractionEnabled = false
//            self.viewBottomButton.isHidden = false
            CommonFunctions.showHideViewWithAnimation(view:  self.viewBottomButton, hidden: false, animation: .transitionFlipFromBottom)
            lblPlayerStatus.text = "Stopped"
        } catch _ {
        }
    }
    func initiallyBtnStateSetup(){
        btnStop.isUserInteractionEnabled = false
        btnPlay.isUserInteractionEnabled = false
        btnForwardTrim.isUserInteractionEnabled = false
        btnForwardTrimEnd.isUserInteractionEnabled = false
        btnBackwardTrim.isUserInteractionEnabled = false
        btnBackwardTrimEnd.isUserInteractionEnabled = false
        lblPlayerStatus.text = ""
    }
    
    func recorderSetUp() {
        audioRecorder = nil
        self.initiallyBtnStateSetup()
        self.viewBottomButton.isHidden = true
        // Microphone Authorization/Permission
        self.checkMicrophoneAccess()
        // Set the audio file
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
    }
    
    // MARK: - @IBActions.
    @IBAction func onTapRecord(_ sender: UIButton) {
             // Stop the audio player before recording
             if let player = audioPlayer {
                 if player.isPlaying {
                     player.stop()
//                     btnPlay.setImage(UIImage(named: ""), for: UIControl.State())
//                     btnPlay.isSelected = false
                 }
             }
        let audioFileURL = self.createURLForNewRecord()
        self.lblFNameValue.text = audioFileName
        print("File Name of recorded audio",audioFileURL)
        // Setup audio session

        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)), mode: .default)
        } catch _ {
        }

        // Define the recorder setting
        let recorderSetting = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
                               AVSampleRateKey: 44100.0,
                               AVNumberOfChannelsKey: 2 ]

        audioRecorder = try? AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
             if let recorder = audioRecorder {
                 if !recorder.isRecording {
//                     let audioSession = AVAudioSession.sharedInstance()
                     
                     do {
                         try audioSession.setActive(true)
                     } catch _ {
                     }
                     // Start recording
                     audioRecorder?.prepareToRecord()
                     recorder.record()
                     self.recordTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                     
                     self.lblPlayerStatus.text = "Recording"
                     self.btnRecord.setBackgroundImage(UIImage(named: "record_pause_btn_normal"), for: UIControl.State.normal)
                     self.btnStop.isUserInteractionEnabled = true
                     self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
                     
                     
                 } else {
                     // Pause recording
                     recorder.pause()
                     lblPlayerStatus.text = "Paused"
                     btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: UIControl.State.normal)
                     btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
                     btnBackwardTrim.setBackgroundImage(UIImage(named: "existing_rewind_normal"), for: .normal)
                     btnBackwardTrimEnd.setBackgroundImage(UIImage(named: "existing_backward_fast_normal"), for: .normal)
                     btnPlay.isUserInteractionEnabled = true
                     btnBackwardTrim.isUserInteractionEnabled = true
                     btnBackwardTrimEnd.isUserInteractionEnabled = true
//                     btnStop.isUserInteractionEnabled = true
                 }
                 isRecording = true
             }
    }
    
    @IBAction func onTapStop(_ sender: UIButton) {
        
//        if let recorder = audioRecorder {
//            if recorder.isRecording {
                audioRecorder?.stop()
//                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setActive(false)
                    print("Stop")
                    self.tabBarController?.setTabBarHidden(true, animated: false)
                    btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
                    btnRecord.isUserInteractionEnabled = false
                    btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
                    btnBackwardTrim.setBackgroundImage(UIImage(named: "existing_rewind_normal"), for: .normal)
                    btnBackwardTrimEnd.setBackgroundImage(UIImage(named: "existing_backward_fast_normal"), for: .normal)
                    btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_disable"), for: .normal)
                    btnPlay.isUserInteractionEnabled = true
                    btnBackwardTrim.isUserInteractionEnabled = true
                    btnBackwardTrimEnd.isUserInteractionEnabled = true
                    btnStop.isUserInteractionEnabled = false
//                    self.viewBottomButton.isHidden = false
                    CommonFunctions.showHideViewWithAnimation(view:  self.viewBottomButton, hidden: false, animation: .transitionFlipFromBottom)
                    lblPlayerStatus.text = "Stopped"
                } catch _ {
                }
//            }
//        }
        
        // Stop the audio player if playing
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
        // If user recorded then stopped then allow SAVE now (even without a title)
//        btnSave.isEnabled = true
    }
    //MARK: Slide View - Top To Bottom
    func viewSlideInFromTopToBottom(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        view.layer.add(transition, forKey: kCATransition)
    }
    @IBAction func onTapPlay(_ sender: UIButton) {
        if let recorder = audioRecorder {
              if !recorder.isRecording {
                  audioPlayer?.delegate = self
                  if ((audioPlayer?.isPlaying) == true){
                      audioPlayer?.pause()
                      btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
                      btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: .normal)
                      btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
                  }else{
                      audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                      audioPlayer?.play()
                      btnPlay.setBackgroundImage(UIImage(named: "existing_controls_pause_btn_normal"), for: .normal)
                      btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_disable"), for: .normal)
                      btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
                  }
              }
          }
    }
    @IBAction func onTapForwardTrim(_ sender: UIButton) {
        print("Forward Trim")
    }
    @IBAction func onTapForwardTrimEnd(_ sender: UIButton) {
        print("Forward Trimfast End")
    }
    
    @IBAction func onTapBackwardTrim(_ sender: UIButton) {
        print("Backward Trim")

    }
    
    @IBAction func onTapBackwardTrimEnd(_ sender: UIButton) {
        print("Backward TrimFast End")

    }
    
    func listVideos() -> [URL] {
        let documentDirectory = self.getDocumentsDirectory()
        let files = try? fileManager.contentsOfDirectory(
            at: documentDirectory,
            includingPropertiesForKeys: nil,
            options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles]
        ).filter {
            ["m4a"].contains($0.pathExtension.lowercased())
        }
        return files ?? []
    }
    
    func findFilesWith(fileExtension: String) -> [AnyObject]{
        var matches = [AnyObject]()
        let files = fileManager.enumerator(atPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        // *** this section here adds all files with the chosen extension to an array ***
        for item in files! {
            let fileURL = item as! NSString
            if (fileURL.pathExtension == fileExtension) {
                matches.append(fileURL)
            }
        }
        return matches
    }
    
    func saveRecordedAudio(completion: @escaping(_ result: Bool) -> Void) {
        let url = getDocumentsDirectory().appendingPathComponent(".m4a")
         do {
             try self.audioFileName.write(to: url, atomically: true, encoding: .utf8)
             let input = try String(contentsOf: url)
             let dataDict:[String: String] = ["file": input]
             NotificationCenter.default.post(name: Notification.Name("FileSaved"), object: nil, userInfo: dataDict)
             print("Saved File--->>",input)
             completion(true)
         } catch {
             print("Saving error-->>",error.localizedDescription)
         }
    }
    
    @IBAction func onTapSave(_ sender: UIButton) {
        print("Saved")
        CommonFunctions.showAlert(view: self, title: "PTS Dictate", message: "Do you want to save the current Recording ?", completion: {
            (success) in
            if success{
                self.saveRecordedAudio() { (success) in
                    if success{
                        self.onDiscardRecorderSetUp()
                    }
                }
//                NotificationCenter.default.post(name: Notification.Name("refreshRecorder"), object: nil)
                DispatchQueue.main.async {
                    let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
                    self.setPushTransitionAnimation(VC)
                    self.navigationController?.popViewController(animated: false)
                   self.tabBarController?.selectedIndex = 0
                }
            }
        })
    }
    @IBAction func onTapEdit(_ sender: UIButton) {
        print("Edit")
        let allFiles =  self.listVideos()
        print("all data files--->>",allFiles.count)
        let allFind = self.findFilesWith(fileExtension: "m4a")
        print("all find data files--->>",allFind.count)
//            self.getSavedFiles()
    }
    @IBAction func onTapDiscard(_ sender: UIButton) {
        CommonFunctions.showAlert(view: self, title: "PTS Dictate", message: "Do you want to discard the current Recording?", completion: {
            (success) in
            if success{
                isRecording = false
                self.removeDiscardAudio(itemName: self.audioFileName, fileExtension: "m4a")
                self.onDiscardRecorderSetUp()
                self.viewBottomButton.isHidden = true
                self.tabBarController?.setTabBarHidden(false, animated: true)
//                self.recorderSetUp()
            }
        })
        print("Discard")
    }
    
   @objc func onDiscardRecorderSetUp(){
//        self.recorderSetUp()
        self.recordTimer.invalidate()
        self.lblTime.text = "00:00:00"
        self.btnRecord.isUserInteractionEnabled = true
        self.btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: .normal)
        self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_diable"), for: .normal)
        self.btnBackwardTrim.setBackgroundImage(UIImage(named: "existing_rewind_disable"), for: .normal)
        self.btnBackwardTrimEnd.setBackgroundImage(UIImage(named: "existing_backward_fast_disable"), for: .normal)
        self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
    }
    
     func removeDiscardAudio(itemName: String, fileExtension: String) {
//      let fileManager = NSFileManager.defaultManager()
//      let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
//      let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
//      let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//      guard let dirPath = paths.first else {
//        return
//      }
//         let filePath = "\(self.getDocumentsDirectory())/\(itemName)"
//      do {
//          try fileManager.removeItem(atPath: filePath)
//      } catch let error as NSError {
//        print("Error on removing---->>>",error.localizedDescription)
//      }
         // Fine documents directory on device
         var filePath = ""
          let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)

         if dirs.count > 0 {
             let dir = dirs[0] //documents directory
             filePath = dir.appendingFormat("/" + itemName)
             print("Local path = \(filePath)")
          
         } else {
             print("Could not find local directory to store file")
             return
         }


         do {
              let fileManager = FileManager.default
             
             // Check if file exists
             if fileManager.fileExists(atPath: filePath) {
                 // Delete file
                 try fileManager.removeItem(atPath: filePath)
                 print("Discard File Success")
             } else {
                 print("File does not exist")
             }
          
         }
         catch let error as NSError {
             print("An error took place: \(error)")
         }
    }
    // Upadte Timer method.
   @objc func updateAudioMeter(timer: Timer) {
        if let recorder = audioRecorder {
        if recorder.isRecording
        {
            let hr = Int((recorder.currentTime / 60) / 60)
            let min = Int(recorder.currentTime / 60)
            let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            self.lblTime.text = totalTimeString
            recorder.updateMeters()
         }
        }
    }

    func finishAudioRecording(success: Bool) {
        if let recorder = audioRecorder {
            if success {
                recorder.stop()
//                audioRecorder = nil
                recordTimer.invalidate()
                print("recorded successfully.")
            }else {
                print("Recording Failed")
            }
        }
    }
    // Microphone Access
        func checkMicrophoneAccess() {
            // Check Microphone Authorization
            switch AVAudioSession.sharedInstance().recordPermission {
                
            case AVAudioSession.RecordPermission.granted:
                print(#function, " Microphone Permission Granted")
                break
                
            case AVAudioSession.RecordPermission.denied:
                // Dismiss Keyboard (on UIView level, without reference to a specific text field)
                UIApplication.shared.sendAction(#selector(UIView.endEditing(_:)), to:nil, from:nil, for:nil)
                CommonFunctions.showAlert(view: self, title: "Microphone Error!", message: "PTS Dictate is Not Authorized to Access the Microphone!", completion: {
                    (result) in
                    if result {
                        DispatchQueue.main.async {
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                            }
                        }
                    }else{
                        print("No Message")
                    }
                })
                return
                
            case AVAudioSession.RecordPermission.undetermined:
                print("Request permission here")
                // Dismiss Keyboard (on UIView level, without reference to a specific text field)
                UIApplication.shared.sendAction(#selector(UIView.endEditing(_:)), to:nil, from:nil, for:nil)
                
                AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                    // Handle granted
                    if granted {
                        print(#function, " Now Granted")
                    } else {
                        print("Pemission Not Granted")
                        
                    } // end else
                })
            @unknown default:
                print("ERROR! Unknown Default. Check!")
            } // end switch
            
        }

    // Helper function inserted by Swift migrator.
    fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
        return input.rawValue
    }

    // Helper function inserted by Swift migrator.
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    func getDocumentsDirectory() -> URL
    {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let  documentsDirectory = paths[0]
        return documentsDirectory
    }
    private func createURLForNewRecord() -> URL {
        let appGroupFolderUrl = self.getDocumentsDirectory()
        let fileNamePrefix = DateFormatter.sharedDateFormatter.string(from: Date())
        let fullFileName = "pixel01_" + fileNamePrefix + ".m4a"
        self.audioFileName = fullFileName
        let newRecordFileName = appGroupFolderUrl.appendingPathComponent(fullFileName)
        return newRecordFileName
    }
}

extension RecordVC: AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    // completion of recording
       func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
           if flag {
               print("Recording Completed")
               self.finishAudioRecording(success: true)
           }
       }
    
    // Completion of playing
       func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
           print("Playing Completed")
       }
}

extension DateFormatter {
    static var sharedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        // Add your formatter configuration here
        dateFormatter.dateFormat = "ddMMyyyy_ss_SSS"
        return dateFormatter
    }()
}
