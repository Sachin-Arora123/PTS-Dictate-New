//
//  ExistingVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 29/08/22.
//

import UIKit
import AVFoundation
import SCWaveformView


enum AudioControllers: Int {
    case fastRewind = 0, rewind, play, forward, fastForward
}

class ExistingVC: BaseViewController {
    
    // MARK: - @IBOutlets.
    @IBOutlet weak var viewNoRecordedFile: UIView!
    @IBOutlet weak var viewBottomPlayer: UIView!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblPlayerStatus: UILabel!
    @IBOutlet weak var lblPlayingTime: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnForwardTrim: UIButton!
    @IBOutlet weak var btnForwardTrimEnd: UIButton!
    @IBOutlet weak var btnBackwardTrim: UIButton!
    @IBOutlet weak var btnBackwardTrimEnd: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var mediaProgressView: SCScrollableWaveformView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var sliderView: UISlider!
    
    let existingViewModel = ExistingViewModel.shared
    
    var audioPlayer = AVAudioPlayer()
    var totalFiles  = [AudioFile]()
    var totalAsset  = [AVAsset]()
    var totalFilesSelected = [AudioFile]()
    var playingCellIndex = -1
    var isPlaying: Bool = false
    var pausedTime: Double?
//    var fileDuration = 0
    var uploadingQueue: [String] = []
    var audioForEditing: AudioFile?
    private var audioMeteringLevelTimer: Timer?
    var tag = -1
    
    final fileprivate let fastBackDisabled: UIImage? = UIImage(named: "existing_backward_fast_disable")
    final fileprivate let backDisabled: UIImage? = UIImage(named: "existing_rewind_disable")
    final fileprivate let fastNextDisabled: UIImage? = UIImage(named: "existing_forward_fast_disable")
    final fileprivate let nextDisabled: UIImage? = UIImage(named: "existing_forward_disable")
    
    final fileprivate let fastBackNormal: UIImage? = UIImage(named: "existing_backward_fast_normal")
    final fileprivate let backNormal: UIImage? = UIImage(named: "existing_rewind_normal")
    final fileprivate let fastNextNormal: UIImage? = UIImage(named: "existing_forward_fast_normal")
    final fileprivate let nextNormal: UIImage? = UIImage(named: "existing_forward_normal")
    
    fileprivate var audioTimer: TimeInterval? {
        didSet {
            if let time = audioTimer {
                DispatchQueue.main.async {
                    if time <= 3 && time >= 1 {
                        self.btnBackwardTrim.setBackgroundImage(self.backNormal, for: .normal)
                        self.btnBackwardTrimEnd.setBackgroundImage(self.fastBackDisabled, for: .normal)
                        self.btnForwardTrim.setBackgroundImage(self.nextNormal, for: .normal)
                        self.btnForwardTrimEnd.setBackgroundImage(self.fastNextNormal, for: .normal)
                        
                        self.btnBackwardTrim.isEnabled = true
                        self.btnBackwardTrimEnd.isEnabled = false
                        self.btnForwardTrim.isEnabled = true
                        self.btnForwardTrimEnd.isEnabled = true
                    } else if time <= 1 {
                        self.btnBackwardTrim.setBackgroundImage(self.backDisabled, for: .normal)
                        self.btnBackwardTrimEnd.setBackgroundImage(self.fastBackDisabled, for: .normal)
                        self.btnForwardTrim.setBackgroundImage(self.nextNormal, for: .normal)
                        self.btnForwardTrimEnd.setBackgroundImage(self.fastNextNormal, for: .normal)
                        
                        self.btnBackwardTrim.isEnabled = false
                        self.btnBackwardTrimEnd.isEnabled = false
                        self.btnForwardTrim.isEnabled = true
                        self.btnForwardTrimEnd.isEnabled = true
                    } else if time >= self.audioPlayer.duration - 3 && time >= self.audioPlayer.duration -  1 {
                        self.btnBackwardTrim.setBackgroundImage(self.backNormal, for: .normal)
                        self.btnBackwardTrimEnd.setBackgroundImage(self.fastBackNormal, for: .normal)
                        self.btnForwardTrim.setBackgroundImage(self.nextNormal, for: .normal)
                        self.btnForwardTrimEnd.setBackgroundImage(self.fastNextDisabled, for: .normal)
                        
                        self.btnBackwardTrim.isEnabled = true
                        self.btnBackwardTrimEnd.isEnabled = true
                        self.btnForwardTrim.isEnabled = true
                        self.btnForwardTrimEnd.isEnabled = false
                    } else if time >= self.audioPlayer.duration -  1 {
                        self.btnBackwardTrim.setBackgroundImage(self.backNormal, for: .normal)
                        self.btnBackwardTrimEnd.setBackgroundImage(self.fastBackNormal, for: .normal)
                        self.btnForwardTrim.setBackgroundImage(self.nextDisabled, for: .normal)
                        self.btnForwardTrimEnd.setBackgroundImage(self.fastNextDisabled, for: .normal)
                        
                        self.btnBackwardTrim.isEnabled = true
                        self.btnBackwardTrimEnd.isEnabled = true
                        self.btnForwardTrim.isEnabled = false
                        self.btnForwardTrimEnd.isEnabled = false
                    } else {
                        self.btnBackwardTrim.setBackgroundImage(self.backNormal, for: .normal)
                        self.btnBackwardTrimEnd.setBackgroundImage(self.fastBackNormal, for: .normal)
                        self.btnForwardTrim.setBackgroundImage(self.nextNormal, for: .normal)
                        self.btnForwardTrimEnd.setBackgroundImage(self.fastNextNormal, for: .normal)
                        
                        self.btnBackwardTrim.isEnabled = true
                        self.btnBackwardTrimEnd.isEnabled = true
                        self.btnForwardTrim.isEnabled = true
                        self.btnForwardTrimEnd.isEnabled = true
                    }
                }
            }
        }
    }
    
    // MARK: - View Life-Cycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.existingViewModel.existingViewController = self
        self.tabBarController?.delegate = self
        self.audioTimer = 0
        addObservers()
        totalFiles = self.getSortedAudioList()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        if totalFiles.count > 0{
            let completePathURL       = Constants.documentDir.appendingPathComponent(self.totalFiles[0].filePath ?? "")
            setupPlayer(url: completePathURL)
            playingCellIndex = 0
            self.lblFileName.text = self.totalFiles[0].changedName != "" ? self.totalFiles[0].changedName : self.totalFiles[0].name
            self.lblTotalTime.text = self.getTimeDuration(filePath: self.totalFiles[0].filePath ?? "")
        }
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                //move to file rename screen to rename the filename.
                let audioFile = totalFiles[indexPath.row]
                pushToFileRenameScreen(selected: audioFile, index: indexPath.row)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
        if totalFiles.count > 0 {
            let completePathURL       = Constants.documentDir.appendingPathComponent(self.totalFiles[0].filePath ?? "")
            setupPlayer(url: completePathURL)
            playingCellIndex = 0
            self.lblFileName.text = self.totalFiles[0].changedName != "" ? self.totalFiles[0].changedName : self.totalFiles[0].name
            self.lblTotalTime.text = self.getTimeDuration(filePath: self.totalFiles[0].filePath ?? "")
            self.setUpWave(index: 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkArchiveDate()
    }
    
    func showBanner(){
        //view
        let topWelcomeView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        topWelcomeView.backgroundColor = .clear
        view.addSubview(topWelcomeView)

        //label
        let username = CoreData.shared.welcomeName
        let lblWelcome = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: topWelcomeView.frame.size.height - 5))
        lblWelcome.textColor = .black
        lblWelcome.textAlignment = .center
        lblWelcome.numberOfLines = 0
        lblWelcome.text = "Welcome \n \(username)"
        lblWelcome.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)

        var text: NSMutableAttributedString? = nil
        if let attributedText = lblWelcome.attributedText{
            text = NSMutableAttributedString(attributedString: attributedText)
        }

        text?.addAttribute( .foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 7))
        text?.addAttribute( .foregroundColor, value: UIColor.red, range: NSRange(location: 10, length: username.count))
        lblWelcome.attributedText = text
        
        topWelcomeView.addSubview(lblWelcome)

        
        UIView.animate(withDuration: 1.0) {
            self.tableViewTop.constant = 50
            topWelcomeView.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 50)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            UIView.animate(withDuration: 1.0) {
                topWelcomeView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
                topWelcomeView.isHidden = true
                self.tableViewTop.constant = 0
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.totalFilesSelected.removeAll()
        self.audioPlayer.stop()
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    deinit{
        removeObservers()
    }
    
    // MARK: - UISetup
    func setUpUI(){
        hideLeftButton()
        setTitleWithImage("Existing Dictations", andImage: UIImage(named: "tabbar_existing_dictations_highlighted.png") ?? UIImage())
        tableView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        //        totalFiles = self.findFilesWith(fileExtension: "m4a")
        totalFiles = self.getSortedAudioList()
        
        totalAsset.removeAll()
        totalFiles.forEach { audio in
            let asset = AVAsset(url: Constants.documentDir.appendingPathComponent(audio.filePath ?? ""))
            totalAsset.append(asset)
        }
        
        setRightBarItem()
    }
    
    fileprivate func setRightBarItem() {
        if totalFiles.count > 0{
            if totalFiles.filter({$0.fileInfo?.isUploaded == false || $0.fileInfo?.uploadedStatus == false}).count > 0{
                setRighButtonImage(imageName: "unchecked_checkbox", selector: #selector(onTapRightImage))
            }else{
                self.navigationItem.rightBarButtonItem = nil
            }
            self.lblPlayerStatus.text  = ""
        }else{
            setRighButtonImage(imageName: "quickAdd", selector: #selector(onTapRightImage))
        }
        self.tableView.reloadData()
    }
    
    @objc func newFileSaved(notification: Notification) {
        //        totalFiles = self.findFilesWith(fileExtension: "m4a")
        totalFiles = self.getSortedAudioList()
        self.tableView.reloadData()
    }
    
    func findFilesWith(fileExtension: String) -> [AnyObject]{
        var matches = [AnyObject]()
        let files = FileManager.default.enumerator(atPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        // *** this section here adds all files with the chosen extension to an array ***
        for item in files! {
            let fileURL = item as! NSString
            if (fileURL.pathExtension == fileExtension) {
                matches.append(fileURL)
            }
        }
        return matches
    }
    
    @objc func play(_ sender: UIButton){
        playAudio(index: sender.tag)
    }
    
    func playAudio(index:Int? = nil) {
        //new
        var playingMediaIndex = 0
        if index == nil{
            for (index, audio) in self.totalFiles.enumerated() {
                if audio.name == self.lblFileName.text!  {
                    playingMediaIndex = index
                }
            }
        }else{
            playingMediaIndex = index!
        }
        
        let index                 = playingMediaIndex
        self.lblFileName.text     = self.totalFiles[index].changedName != "" ? self.totalFiles[index].changedName : self.totalFiles[index].name
        self.lblPlayerStatus.text = "Now Playing"
        let completePathURL       = Constants.documentDir.appendingPathComponent(self.totalFiles[index].filePath ?? "")
                    
        if isPlaying{
            //Pause
            if index != self.playingCellIndex {
                audioPlayer.stop()
            } else{
                audioPlayer.pause()
            }
            self.isPlaying = false
            self.pausedTime = self.audioPlayer.currentTime
            self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            self.audioMeteringLevelTimer?.invalidate()
        }else{
            //Play new
            //setup
            if index != self.playingCellIndex {
                self.audioMeteringLevelTimer?.invalidate()
                setupPlayer(url: completePathURL)
                audioPlayer.play()
                setUpWave(index: index)
            }else{
                if let audioTimer = self.audioTimer {
                    self.audioPlayer.currentTime = audioTimer
                }
                audioPlayer.play()
            }
            
            self.playingCellIndex = index
            self.isPlaying = true
            self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_pause_btn_normal"), for: .normal)
            tag = index
            self.audioMeteringLevelTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerDidUpdateMeter), userInfo: nil, repeats: true)
            self.lblTotalTime.text = self.getTimeDuration(filePath: self.totalFiles[index].filePath ?? "")
        }
        self.setTrimButtonInteraction(isInteractive: true)
        self.tableView.reloadData()
    }
    
    func setupPlayer(url:URL){
        do{
            audioPlayer.numberOfLoops = 0 // loop count, set -1 for infinite
            audioPlayer.volume = 1
            audioPlayer.prepareToPlay()
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer =  try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
//            audioPlayer.play()
        }catch _ {
            print("catch")
        }
    }
    
    @objc func timerDidUpdateMeter() {
        let min = Int(audioPlayer.currentTime / 60)
        let sec = Int(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d",min, sec)
        print("totalTimeString ===== \(totalTimeString)")
        self.audioTimer = audioPlayer.currentTime
        let cmTime = CMTime(seconds: audioPlayer.currentTime, preferredTimescale: 1000000)
        self.mediaProgressView.waveformView.progressTime = cmTime
        self.sliderView.value = Float(cmTime.seconds)
        self.lblPlayingTime.text = totalTimeString
        self.audioPlayer.updateMeters()
        
//        let averagePower = self.audioPlayer.averagePower(forChannel: 0)
//        let percentage: Float = pow(10, (0.05 * averagePower))
//        NotificationCenter.default.post(name: .audioPlayerManagerMeteringLevelDidUpdateNotification, object: self, userInfo: ["percentage": percentage])
    }
    
    // MARK: - @IBActions.
    @IBAction func onTapUpload(_ sender: UIButton) {
        if self.totalFilesSelected.count == 0{
            CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Please select atleast one file.", btnTitle: "OK", completion: nil)
        } else {
            let alreadyUploaded = self.checkIfAnyFileAlreadyUploaded()
            if alreadyUploaded {
                var alertMessage = ""
                if self.totalFilesSelected.count == 1{
                    alertMessage = "This file is already uploaded. Do you still want to re-upload this dictation?"
                }else{
                    alertMessage = "Few files are already uploaded. Do you still want to re-upload these dictations?"
                }
                
                CommonFunctions.showAlert(view: self, title: "PTS Dictate", message: alertMessage) { success in
                    if success {
                        self.uploadFiles()
                    } else {
                        return
                    }
                }
            } else {
                self.uploadFiles()
            }
        }
    }
    
    @IBAction func onTapDelete(_ sender: UIButton) {
        if self.totalFilesSelected.count == 0{
            CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Please select atleast one file.", btnTitle: "OK", completion: nil)
        }else{
            
            var alertMessage = ""
            
            if CoreData.shared.archiveFile == 0{
                if self.totalFilesSelected.count == 1 && checkIfAnyFileAlreadyUploaded(){
                    self.rerenderUI()
                    return
                }
                else if self.totalFilesSelected.count == 1 && checkIfAnyFileNotAlreadyUploaded(){
                    alertMessage = "File is not uploaded. Do you still want to delete this file?"
                }else if checkIfAnyFileNotAlreadyUploaded(){
                    alertMessage = "A few files are not uploaded. Do you still want to delete these files?"
                }else{
                    self.rerenderUI()
                    return
                }
                
            }else{
                if self.totalFilesSelected.count == 1 && checkIfAnyFileAlreadyUploaded(){
                    alertMessage = " File retention period is set to \(CoreData.shared.archiveFileDays). Do you still want to delete this file?"

                }
                else if self.totalFilesSelected.count == 1 && checkIfAnyFileNotAlreadyUploaded(){
                    alertMessage = "File is not uploaded. Do you still want to delete this file?"
                }else if checkIfAnyFileNotAlreadyUploaded(){
                    alertMessage = "A few files are not uploaded. Do you still want to delete these files?"
                }else{
                    alertMessage = " File retention period is set to \(CoreData.shared.archiveFileDays). Do you still want to delete these files?"
                }
                
            }
            

//
//            if self.totalFilesSelected.count == 1{
//                //user selected one file to delete.
//                //first check if the selected file is already uploaded or not.
//                if checkIfAnyFileAlreadyUploaded(){
//                    //already uploaded
//                //    alertMessage = "File retention period is set as \(CoreData.shared.archiveFileDays) days. Do you still want to delete this file?"
//                    self.rerenderUI()
//                    return
//                }else{
//                    //not uploaded
//                    alertMessage = "File retention period is set as \(CoreData.shared.archiveFileDays) days. Do you still want to delete this file?"//"File is not uploaded, Do you still want to delete this file?"
//                }
//            }else{
//                //greater than one.
//                //if any of the file is not uploaded, we need to show file not uploaded message.
//                if checkIfAnyFileNotAlreadyUploaded(){
//                    //Some files are not already uploaded
//                    alertMessage = "File retention period is set as \(CoreData.shared.archiveFileDays) days. Do you still want to delete these files?"//"Few files are not uploaded, Do you still want to delete these files?"
//                }else{
//                    //no file is uploaded from the selected files
//                  //  alertMessage = "File retention period is set as \(CoreData.shared.archiveFileDays) days. Do you still want to delete these files?"
//                    self.rerenderUI()
//                    return
//                }
//            }
//
            CommonFunctions.showAlert(view: self, title: "PTS Dictate", message: alertMessage, completion: {
                (success) in
                if success{
                    self.rerenderUI()
                }
            })
        }
    }
    func rerenderUI(){
        for file in self.totalFilesSelected {
            self.removeAudio(itemName: file.name ?? "", fileExtension: "")
            AudioFiles.shared.deleteAudio(path: file.filePath ?? "")
        }
        self.totalFilesSelected.removeAll()
        self.totalFiles = self.getSortedAudioList()
        self.setRightBarItem()
    }
    fileprivate func setupSlider(index:Int) {
      
        // Setup the slider
        sliderView.setValue(0.0, animated: true)
        sliderView.maximumValue = Float(self.totalAsset[index].duration.seconds)
        sliderView.minimumValue = 0.0
        sliderView.setThumbImage( UIImage(named: "slider")?.scaled(to: CGSize.init(width: 3, height: 50)) , for: .highlighted)
        sliderView.setThumbImage(UIImage(named: "slider")?.scaled(to: CGSize.init(width: 3, height: 50)) , for: .normal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
              self.sliderView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {

        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)

        let positionOfSlider: CGPoint = sliderView.frame.origin
        let widthOfSlider: CGFloat = sliderView.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(sliderView.maximumValue) / widthOfSlider)

        sliderView.setValue(Float(newValue), animated: true)
      //  self.recorder.moveToNewTiming(time: Float(newValue))
        self.moveToNewTiming(time: Float(newValue))
        debugPrint("sliderview \(newValue)")
    }
    
 
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        debugPrint("sliderview \(sender.value)")
      //  self.recorder.moveToNewTiming(time: sender.value)
        self.moveToNewTiming(time: sender.value)
    }
    
    public func moveToNewTiming(time:Float){

        self.audioTimer = TimeInterval(time)
        audioPlayer.currentTime = TimeInterval(time)
        sliderView.value = time
        self.mediaProgressView.waveformView.progressTime = CMTimeMakeWithSeconds(TimeInterval(time), preferredTimescale: 1)
    }

    
    //This function return true if any of the multiple file is already uploaded, else return false
    func checkIfAnyFileAlreadyUploaded() -> Bool {
        var status = false
        if totalFilesSelected.count > 0{
            for file in totalFilesSelected {
                let audioFile = getFileInfo(name: file.name ?? "")
                if audioFile?.fileInfo?.isUploaded ?? false && audioFile?.fileInfo?.uploadedStatus == true{
                    return true
                } else {
                    status = false
                }
            }
        }else{
            return status
        }
        
        return status
    }
    
    //This function return true if any of the multiple file is not already uploaded, else return false
    func checkIfAnyFileNotAlreadyUploaded() -> Bool {
        var status = false
        if totalFilesSelected.count > 0{
            for file in totalFilesSelected {
                let audioFile = getFileInfo(name: file.name ?? "")
                if !(audioFile?.fileInfo?.isUploaded ?? false) {
                    return true
                } else {
                    status = false
                }
            }
        }else{
            return status
        }
        
        return status
    }
    
    func uploadFiles() {
        if !Reachability.isConnectedToNetwork(){
            CommonFunctions.toster("Network Error",titleDesc: "Network is no longer available. Please reconnect your network and try again.", true, false)
            return
        }
        
        self.existingViewModel.uploadingQueue = self.totalFilesSelected
        let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
        self.setPushTransitionAnimation(VC)
        self.navigationController?.popViewController(animated: false)
        self.tabBarController?.selectedIndex = 1
    }
    
    func getSortedAudioList() -> [AudioFile] {
        var audioArray = [AudioFile]()
        
        let files = AudioFiles.shared.audioFiles
        var uploadedFiles   = [AudioFile]()
        var unUploadedFiles = [AudioFile]()
        for file in files where (file.fileInfo?.uploadedBy == CoreData.shared.userId){
            if let isUploaded = file.fileInfo?.isUploaded, isUploaded{
                //uploaded already
                uploadedFiles.append(file)
            }else{
                //not uploaded
                unUploadedFiles.append(file)
            }
        }
        
        audioArray.append(contentsOf: unUploadedFiles.reversed().sorted(by: {$0.name ?? "" > $1.name ?? ""}))
        audioArray.append(contentsOf: uploadedFiles.reversed().sorted(by: {$0.name ?? "" > $1.name ?? ""}))
        return audioArray
    }
    
    func removeAudio(itemName:String, fileExtension: String) {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        //      let filePath = "\(dirPath)/\(itemName).\(fileExtension)"
        let filePath = "\(dirPath)/\(itemName)"
        do {
            try fileManager.removeItem(atPath: filePath)
            print("Removed Successfully")
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    @IBAction func audioControllersTapped(_ sender: UIButton) {
        let controllerType: AudioControllers = AudioControllers(rawValue: sender.tag) ?? .play
        controllAudioPlayer(controllerType: controllerType)
    }
    
    func setUpWave(index: Int) {
        self.mediaProgressView.waveformView.asset = totalAsset[index]
        self.mediaProgressView.waveformView.normalColor = .lightGray
        self.mediaProgressView.waveformView.progressColor = .blue
        self.mediaProgressView.waveformView.progressTime = CMTimeMakeWithSeconds(0, preferredTimescale: 1)
        
        // Set the precision, 1 being the maximum
        self.mediaProgressView.waveformView.precision = 0.1 // We are going to render one line per four pixels
        
        // Set the lineWidth so we have some space between the lines
        self.mediaProgressView.waveformView.lineWidthRatio = 0.5
        
        // Show stereo if available
        self.mediaProgressView.waveformView.channelStartIndex = 0
        self.mediaProgressView.waveformView.channelEndIndex = 1
        
        // Show only right channel
        self.mediaProgressView.waveformView.channelStartIndex = 1
        self.mediaProgressView.waveformView.channelEndIndex = 1
        
        // Add some padding between the channels
        self.mediaProgressView.waveformView.channelsPadding = 10
        setupSlider(index: index)
    }
    
    fileprivate func pushToComments(selected audio: String, index: Int) {
        let VC = CommentsVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        self.setPushTransitionAnimation(VC)
        VC.hidesBottomBarWhenPushed = true
        let audioFile = getFileInfo(name: audio)
        let isUploaded = audioFile?.fileInfo?.uploadedStatus ?? false
        VC.fromExistingVC = true
        VC.canEditComments = isUploaded ? false : true
        VC.selectedAudio = audio
        VC.comment = audioFile?.fileInfo?.comment ?? ""
        VC.isCommentsMandotary = CoreData.shared.commentScreenMandatory == 1 ? true : false
        self.navigationController?.pushViewController(VC, animated: false)
    }
    
    fileprivate func pushToFileRenameScreen(selected audio: AudioFile, index: Int) {
        let VC = RenameFileVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        self.setPushTransitionAnimation(VC)
//        let changedNames = self.totalFiles.map({$0.changedName})
        let names = self.totalFiles.map({($0.changedName !=  "" ? $0.changedName : $0.name) ?? ""})
        VC.alreadyPresentNames = names
        let filename  = audio.changedName != "" ? audio.changedName : audio.name
        VC.fileName   = filename ?? ""
        VC.updatedFileNameCallback = { updatedChangedName in
            ///update the name in core data
            audio.changedName = updatedChangedName + ".m4a"
            CoreData.shared.dataSave()
        }
        self.navigationController?.pushViewController(VC, animated: false)
    }
    
//    func updateFilePathInDocDirectory(sourcefileName:String, destfileName:String){
////        let fileURLs = try FileManager.default.contentsOfDirectory(at: Constants.documentDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
////        print(fileURLs)
////        let sourceFilePath = Constants.documentDir.appendingPathComponent(sourcefileName)
////        let destFilePath = Constants.documentDir.appendingPathComponent(destfileName + ".m4a")
////        do{
////            _ = try FileManager.default.replaceItemAt(destFilePath, withItemAt: sourceFilePath)
////
////            //update the name in core data as well.
////
////        }catch{
////            print(error)
////        }
//
//        let file = self.getFileInfo(name: sourcefileName)
//        file?.name = destfileName + ".m4a"
//        CoreData.shared.dataSave()
//    }
    
    // notaFIXME: need to fix those functions to controll media
    private func settingUpPlayer() {
        do {
            audioPlayer.numberOfLoops = 0 // loop count, set -1 for infinite
            audioPlayer.volume = 1
            audioPlayer.prepareToPlay()
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        }  catch _ {
            print("can't settingup player")
        }
    }
    
    private func preparePlayerToPlay(completePathURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: completePathURL)
            audioPlayer.delegate = self
            audioPlayer.play()
        } catch _ {
            print("can't prepare player")
        }
    }
    
    private func controllAudioPlayer(controllerType: AudioControllers) {
        DispatchQueue.main.async {
            switch controllerType {
            case .fastRewind:
                self.fastBackwardByTime(timeVal: 3)
            case .rewind:
                self.fastBackwardByTime(timeVal: 1)
            case .play:
                self.playAudio(index: self.playingCellIndex == -1 ? 0 : self.playingCellIndex)
            case .forward:
                self.fastForwardByTime(timeVal: 1)
            case .fastForward:
                self.fastForwardByTime(timeVal: 3)
            }
        }
    }
    
    //Files which are uploaded and their file retention days are greater than the set retention days for that file will be removed from the list.
    func checkArchiveDate() {
        let audioFiles = AudioFiles.shared.audioFiles
        audioFiles.forEach { file in
            if file.fileInfo?.isUploaded ?? false && file.fileInfo?.archivedDays != 0{
                let currentDate  = Date().getUTCDateString()
                let uploadedDate = file.fileInfo?.uploadedAt ?? ""
                
                //number of days till it gets uploaded
                let diffDays = daysBetween(start: uploadedDate.getDateFromFormattedString(), end: currentDate.getDateFromFormattedString())
                
                //archive days value for that file
                let archivedDays = file.fileInfo?.archivedDays ?? 0
                
                if (archivedDays < diffDays || archivedDays == diffDays){
                    let fileName = file.name ?? ""
                    self.removeAudio(itemName: fileName, fileExtension: "")
                    AudioFiles.shared.deleteAudio(path: file.filePath ?? "")
                    self.totalFiles = self.getSortedAudioList()
                    self.setRightBarItem()
                }
            }
        }
    }
    
    private func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
}

// MARK: - Extension for tableView delegate & dataSource methods.
extension ExistingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.totalFiles.count > 0{
//            self.lblFileName.text = self.totalFiles[0].changedName != "" ? self.totalFiles[0].changedName : self.totalFiles[0].name
            self.tableView.isHidden = false
            self.viewBottomPlayer.isHidden = false
            self.viewNoRecordedFile.isHidden = true
            return self.totalFiles.count
        }else{
            self.tableView.isHidden = true
            self.viewNoRecordedFile.isHidden = false
            self.viewBottomPlayer.isHidden = true
            return 0
        }
    }
    func setCellData(cell: ExistingFileCell, audio: AudioFile?) {
        let file = audio
        cell.lblFileStatus.text = ""
        cell.lblFileStatus.stopBlink()
        if !(file?.fileInfo?.isUploaded ?? false) && file?.fileInfo?.comment != nil {
            //This is the case when file is not uploaded and it has some comemnt(even it is empty)
            cell.lblFileStatus.textColor = .black
            if file?.fileInfo?.autoSaved ?? false {
                cell.lblFileStatus.text = "Auto Saved File"
                cell.lblFileStatus.startBlink()
            }else{
                cell.lblFileStatus.text = ""
            }
            cell.btnComment.isUserInteractionEnabled = true
            cell.btnEdit.isUserInteractionEnabled = true
            cell.btnComment.isHidden = false
            
            if file?.fileInfo?.comment == ""{
                cell.btnComment.setBackgroundImage(UIImage(named: "no_comments_normal"), for: .normal)
            }else{
                cell.btnComment.setBackgroundImage(UIImage(named: "comments_normal"), for: .normal)
            }
            cell.btnEdit.setBackgroundImage(UIImage(named: "music_edit_normal"), for: .normal)
        } else if !(file?.fileInfo?.isUploaded ?? false) && file?.fileInfo?.comment == nil {
            //This is the case when file is not uploaded and it has no comemnt
            cell.lblFileStatus.textColor = .black
            if file?.fileInfo?.autoSaved ?? false {
                cell.lblFileStatus.text = "Auto Saved File"
                cell.lblFileStatus.startBlink()
            } else{
                cell.lblFileStatus.text = ""
            }
            cell.btnComment.isUserInteractionEnabled = true
            cell.btnEdit.isUserInteractionEnabled = true
            cell.btnComment.isHidden = true
            cell.btnComment.setBackgroundImage(UIImage(named: "no_comments_normal"), for: .normal)
            cell.btnEdit.setBackgroundImage(UIImage(named: "music_edit_normal"), for: .normal)
        } else if file?.fileInfo?.isUploaded ?? true && file?.fileInfo?.comment != nil{
            //This is the case when file is uploaded and it has comment(even it is empty)
            if let uploadStatus = file?.fileInfo?.uploadedStatus{
                cell.lblFileStatus.textColor = uploadStatus ? UIColor(red: 62/255, green: 116/255, blue: 36/255, alpha: 1.0) : .red
                cell.lblFileStatus.text = uploadStatus ? "Uploaded" : "Failed"
                cell.btnEdit.isUserInteractionEnabled = !uploadStatus
                cell.btnEdit.setBackgroundImage(UIImage(named: uploadStatus ? "music_edit_disable" : "music_edit_normal"), for: .normal)
                cell.btnComment.setBackgroundImage(UIImage(named: uploadStatus ? "comments_active" : "comments_normal"), for: .normal)

            }
            cell.btnComment.isUserInteractionEnabled = true
            cell.btnComment.isHidden = false
        } else if file?.fileInfo?.isUploaded ?? true && file?.fileInfo?.comment == nil {
            //This is the case when file is uploaded and it has no comment
            if let uploadStatus = file?.fileInfo?.uploadedStatus{
                cell.lblFileStatus.textColor = uploadStatus ? UIColor(red: 62/255, green: 116/255, blue: 36/255, alpha: 1.0) : .red
                cell.lblFileStatus.text = uploadStatus ? "Uploaded" : "Failed"
                cell.btnEdit.isUserInteractionEnabled = !uploadStatus
                cell.btnEdit.setBackgroundImage(UIImage(named: uploadStatus ? "music_edit_disable" : "music_edit_normal"), for: .normal)
            }
            cell.btnComment.isHidden = true
        }
    }
    
    func getFileInfo(name: String) -> AudioFile? {
        let audioFiles = AudioFiles.shared.audioFiles
        for file in audioFiles where file.name == name {
            return file
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExistingFileCell", for: indexPath) as! ExistingFileCell
        if self.totalFilesSelected.contains(self.totalFiles[indexPath.row]){
            cell.btnSelection.setImage(UIImage(named: "checked_checkbox"), for: .normal)
        }else{
            cell.btnSelection.setImage(UIImage(named: "unchecked_checkbox"), for: .normal)
        }
        cell.isUserInteractionEnabled = true
        cell.btnEdit.isHidden = false
        
        
        let fileUrl = Constants.documentDir.appendingPathComponent(self.totalFiles[indexPath.row].filePath ?? "")
        cell.lblFileSize.text = String(format: "%.2f",Double(fileUrl.fileSize )/1024.0 / 1024.0) + "Mb"
        
        cell.btnSelection.removeTarget(self, action: nil, for: .touchUpInside)
        cell.btnSelection.addTarget(self, action: #selector(btnActCheckBox(_:)), for: .touchUpInside)
        cell.lblFileName.text = self.totalFiles[indexPath.row].changedName != "" ? self.totalFiles[indexPath.row].changedName : self.totalFiles[indexPath.row].name
        
        cell.btnSelection.tag = indexPath.row
        cell.btnComment.tag   = indexPath.row
        cell.btnEdit.tag      = indexPath.row
        cell.btnPlay.tag      = indexPath.row
        
        cell.btnPlay.addTarget(self, action: #selector(play), for: .touchUpInside)
        let playBtnImage = (indexPath.row == playingCellIndex && isPlaying) ? UIImage(named: "existing_pause_btn") : UIImage(named: "existing_play_btn")
        cell.btnPlay.setBackgroundImage(playBtnImage, for: .normal)
        cell.btnComment.addTarget(self, action: #selector(openCommentVC), for: .touchUpInside)
        cell.btnEdit.addTarget(self, action: #selector(openRenameFileVc), for: .touchUpInside)
        setCellData(cell: cell, audio: totalFiles[indexPath.row])
        DispatchQueue.main.async {
            let time = self.getTimeDuration(filePath: self.totalFiles[indexPath.row].filePath ?? "")
            cell.lblFileTime.text = time
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Objective C Methods
extension ExistingVC{
    func setTrimButtonInteraction(isInteractive: Bool){
        self.btnForwardTrim.isUserInteractionEnabled = isInteractive
        self.btnForwardTrimEnd.isUserInteractionEnabled = isInteractive
        self.btnBackwardTrim.isUserInteractionEnabled = isInteractive
        self.btnBackwardTrimEnd.isUserInteractionEnabled = isInteractive
    }
    
    func getTimeDuration(filePath: String) -> String{
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let completePath = directoryPath.absoluteString + filePath
        let completePathURL = URL(string: completePath)
        
        let audioAsset = AVURLAsset.init(url: completePathURL!, options: nil)
        let duration = audioAsset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
//        self.fileDuration = Int(durationInSeconds)
        let min = Int(durationInSeconds / 60)
        let sec = Int(durationInSeconds.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d",min, sec)
        return totalTimeString
    }
//    func fileSize(itemName: String) -> String? {
//        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
//        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
//        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//        guard let dirPath = paths.first else {
//            return ""
//        }
//        let filePath = Constants.documentDir.appendingPathComponent(itemName).absoluteString
////        let filePath = "\(dirPath)/\(itemName)"
//        guard let size = try? FileManager.default.attributesOfItem(atPath: filePath)[FileAttributeKey.size],
//              let fileSize = size as? UInt64 else {
//            return nil
//        }
//
//        // bytes
//        if fileSize < 1023 {
//            return String(format: "%lu bytes", CUnsignedLong(fileSize))
//        }
//        // KB
//        var floatSize = Float(fileSize / 1024)
//        if floatSize < 1023 {
//            return String(format: "%.1f KB", floatSize)
//        }
//        // MB
//        floatSize = floatSize / 1024
//        if floatSize < 1023 {
//            return String(format: "%.1f MB", floatSize)
//        }
//        // GB
//        floatSize = floatSize / 1024
//        return String(format: "%.1f GB", floatSize)
//    }
    @objc func openCommentVC(_ sender: UIButton){
        let audioFile = totalFiles[sender.tag].name ?? ""
        pushToComments(selected: audioFile, index: sender.tag)
    }
    
    @objc func openRenameFileVc(_ sender: UIButton){
        self.audioForEditing = self.totalFiles[sender.tag]
        let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
        self.setPushTransitionAnimation(VC)
        self.navigationController?.popViewController(animated: false)
        self.tabBarController?.selectedIndex = 2
    }
    
    @objc func btnActCheckBox(_ sender : UIButton){
        if self.totalFilesSelected.contains(self.totalFiles[sender.tag]){
            if let ind = self.totalFilesSelected.firstIndex(of: self.totalFiles[sender.tag]){
                self.totalFilesSelected.remove(at: ind)
            }
        }else{
            self.totalFilesSelected.append(self.totalFiles[sender.tag])
        }
        self.tableView.reloadData()
    }
    // navbar right image action.
    @objc func onTapRightImage() {
        if totalFiles.count > 0 {
            if self.tabBarController?.navigationItem.rightBarButtonItem?.image == getRighButtonImage(imageName: "unchecked_checkbox") {
                self.totalFilesSelected = self.totalFiles.filter({!($0.fileInfo?.isUploaded ?? false) || $0.fileInfo?.uploadedStatus == false})
                setRighButtonImage(imageName: "checked_checkbox", selector: #selector(onTapRightImage))
            }else if self.tabBarController?.navigationItem.rightBarButtonItem?.image == getRighButtonImage(imageName: "unchecked_checkbox"){
                setRighButtonImage(imageName: "unchecked_checkbox", selector: #selector(onTapRightImage))
                self.totalFilesSelected.removeAll()
            }
        } else {
            let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
            self.setPushTransitionAnimation(VC)
            self.navigationController?.popViewController(animated: false)
            self.tabBarController?.selectedIndex = 2
        }
        self.tableView.reloadData()
    }
    
    func covertToFileString(with size: UInt64) -> String {
        var convertedValue: Double = Double(size)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        if isPlaying{
            //Pause
            self.audioPlayer.pause()
            self.isPlaying = false
            self.pausedTime = self.audioPlayer.currentTime
            self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            self.audioMeteringLevelTimer?.invalidate()
            self.tableView.reloadData()
        }
    }
    
    private func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.newFileSaved(notification:)), name: Notification.Name("FileSaved"), object: nil)
    }
    
    private func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: Notification.Name("FileSaved"), object: nil)
    }
}

// MARK: - Extension for AVAudioPlayerDelegate
extension ExistingVC: AVAudioPlayerDelegate {
    // Completion of playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            self.lblPlayerStatus.text  = ""
            self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            self.setUpWave(index: playingCellIndex)
            self.playingCellIndex = -1
            self.audioTimer = 0
            self.isPlaying = false
            self.lblPlayingTime.text = "00:00:00"
            self.tableView.reloadData()
            print("Playing Completed")
            
            audioMeteringLevelTimer?.invalidate()
        }
    }
}


extension ExistingVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: RecordVC.self as AnyClass) {
            let recordVC = tabBarController.viewControllers?[2] as! RecordVC
            recordVC.audioForEditing = nil
        } else if viewController.isKind(of: UploadProgressVC.self as AnyClass) {
            let _ = tabBarController.viewControllers?[1] as! UploadProgressVC
            self.existingViewModel.uploadingQueue = []
        }
        return true
    }
}

extension Notification.Name {
    static let audioPlayerManagerMeteringLevelDidUpdateNotification = Notification.Name("AudioPlayerManagerMeteringLevelDidUpdateNotification")
    static let audioPlayerManagerMeteringLevelDidFinishNotification = Notification.Name("AudioPlayerManagerMeteringLevelDidFinishNotification")
}

extension ExistingVC{
    // MARK: Seek Forward
    func fastForwardByTime(timeVal: Double) {
        //old one
//        var time: TimeInterval = audioPlayer.currentTime
//        time += timeVal
//        if time > audioPlayer.duration {
//                audioPlayer.stop()
//        } else {
//            audioPlayer.pause()
//            audioPlayer.currentTime = time
//            if pausedTime != nil {
//                audioPlayer.play()
//            }
//            let min = Int(audioPlayer.currentTime / 60)
//            let sec = Int(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60))
//            let totalTimeString = String(format: "%02d:%02d", min, sec)
//            self.audioTimer = audioPlayer.currentTime
//            self.lblPlayingTime.text = totalTimeString
//            audioPlayer.updateMeters()
//        }
        
//        let seconds : Int64 = Int64(time)
//        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
//        let newCurrentTime = audioPlayer.currentTime + targetTime
//
//        audioPlayer.currentTime = TimeInterval(integerLiteral: time)
        
        
//        if pausedTime != nil {
//            audioPlayer.play()
//        }
        
        
//        let min = Int(audioPlayer.currentTime / 60)
//        let sec = Int(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60))
//        let totalTimeString = String(format: "%02d:%02d", min, sec)
//        self.audioTimer = audioPlayer.currentTime
//        self.lblPlayingTime.text = totalTimeString
//        audioPlayer.updateMeters()
        
        //new one
        //we need to change three things(timing label, audio player's current time and sound wave progress)
        var currentTime = audioPlayer.currentTime
        currentTime += timeVal
        
        //update timings
        if currentTime <= audioPlayer.currentTime {
            self.lblPlayingTime.text = self.timeString(from: currentTime)
        } else {
            self.lblPlayingTime.text = self.timeString(from: currentTime)
        }
        
        audioPlayer.currentTime = TimeInterval(integerLiteral: currentTime)
        self.audioTimer = self.audioPlayer.currentTime
        audioPlayer.updateMeters()
        
        //update waves
        self.mediaProgressView.waveformView.progressTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 1)
        self.sliderView.value = Float(self.mediaProgressView.waveformView.progressTime.seconds)
    }
    
    func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 60 * 60) / 60)
        let hours = Int(timeInterval / 3600)
        return String(format: "%.2d:%.2d:%.2d", hours, minutes, seconds)
    }
    
    // MARK: - Seek Backward
    func fastBackwardByTime(timeVal: Double) {
        var time: TimeInterval = audioPlayer.currentTime
        time -= timeVal
        if time < 0 {
            audioPlayer.stop()
        } else {
        //    audioPlayer.pause()
            audioPlayer.currentTime = time
//            if pausedTime != nil {
//                audioPlayer.play()
//            }
//            let min = Int(audioPlayer.currentTime / 60)
//            let sec = Int(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60))
//            let totalTimeString = String(format: "%02d:%02d", min, sec)
//            self.audioTimer = audioPlayer.currentTime
            //self.lblPlayingTime.text = totalTimeString
            self.lblPlayingTime.text = self.timeString(from: time)
            audioPlayer.currentTime = TimeInterval(integerLiteral: time)
            self.audioTimer = self.audioPlayer.currentTime

            
            audioPlayer.updateMeters()
            
            //update waves
            self.mediaProgressView.waveformView.progressTime = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
            self.sliderView.value = Float(self.mediaProgressView.waveformView.progressTime.seconds)
        }
    }
}

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

}
