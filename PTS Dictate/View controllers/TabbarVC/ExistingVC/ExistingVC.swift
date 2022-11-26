//
//  ExistingVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 29/08/22.
//

import UIKit
import AVFoundation
import SoundWave


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
    @IBOutlet weak var mediaProgressView: AudioVisualizationView!
    @IBOutlet weak var tableView: UITableView!
    
    let existingViewModel = ExistingViewModel.shared
    
    var audioRecorder:AVAudioRecorder?
    var audioPlayer = AVAudioPlayer()
    var totalFiles = [String]()
    var totalFilesSelected : [String] = []
    var playingCellIndex = -1
    var fileDuration = 0
    var comments: [String: String] {
        return CoreData.shared.comments
    }
    var uploadingQueue: [String] = []
    var editFromExiting: Bool = false
    private var audioMeteringLevelTimer: Timer?
    var tag = -1
    private var currentlyPlayingAudio: URL?
    // wave form var
    fileprivate var startRendering = Date()
    fileprivate var endRendering = Date()
    fileprivate var startLoading = Date()
    fileprivate var endLoading = Date()
    fileprivate var profileResult = ""
    // MARK: - View Life-Cycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.newFileSaved(notification:)), name: Notification.Name("FileSaved"), object: nil)
        self.existingViewModel.existingViewController = self
        self.tabBarController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
        CoreData.shared.audioFiles = []
        CoreData.shared.dataSave()
        self.setUpWave()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.totalFilesSelected.removeAll()
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: Notification.Name("FileSaved"), object: nil)
    }
    
    // MARK: - UISetup
    func setUpUI(){
        hideLeftButton()
        setTitleWithImage("Existing Dictations", andImage: UIImage(named: "tabbar_existing_dictations_highlighted.png") ?? UIImage())
        tableView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        //        totalFiles = self.findFilesWith(fileExtension: "m4a")
        totalFiles = self.getSortedAudioList()
        setRightBarItem()
    }
    
    fileprivate func setRightBarItem() {
        if totalFiles.count > 0{
            self.lblPlayerStatus.text  = ""
            setRighButtonImage(imageName: "unchecked_checkbox", selector: #selector(onTapRightImage))
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
    
    func findFilesWith(fileExtension: String) -> [AnyObject]
    {
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
        do {
            let index = sender.tag
            self.lblFileName.text = self.totalFiles[index]
            //                let file = Bundle.main.url(forResource: "file_name", withExtension: "mp3")!
            let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let completePath = directoryPath.absoluteString + self.totalFiles[index]
            let completePathURL = URL(string: completePath)
            //                let file = directoryPath + fileEndPoint
            //                let dirURL = URL(string: file)
            
            audioPlayer.numberOfLoops = 0 // loop count, set -1 for infinite
            audioPlayer.volume = 1
            audioPlayer.prepareToPlay()
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            if audioPlayer.isPlaying{
                audioPlayer.pause()
//                self.mediaProgressView.pause()
                sender.setBackgroundImage(UIImage(named: "existing_play_btn"), for: .normal)
                self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            }else{
                self.playingCellIndex = index
                audioPlayer =  try AVAudioPlayer(contentsOf: completePathURL!)
                audioPlayer.delegate = self
                audioPlayer.play()
                //                self.mediaProgressView.audioURL = completePathURL!
//                self.mediaProgressView.meteringLevels = [0.1, 0.67, 0.13, 0.78, 0.31]
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
//                    self.mediaProgressView.play(for: self.audioPlayer.duration / self.audioPlayer.duration)
                }
                sender.setBackgroundImage(UIImage(named: "existing_pause_btn"), for: .normal)
                self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_pause_btn_normal"), for: .normal)
                tag = sender.tag
                self.audioMeteringLevelTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerDidUpdateMeter), userInfo: nil, repeats: true)
                self.lblTotalTime.text = self.getTimeDuration(filePath: self.totalFiles[index])
            }
            self.setTrimButtonInteraction(isInteractive: true)
        } catch _ {
            print("catch")
        }
    }
    
    @objc func timerDidUpdateMeter() {
        
        //        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! ExistingFileCell
        let min = Int(audioPlayer.currentTime / 60)
        let sec = Int(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d",min, sec)
        
        //            cell.lblFileTime.text = totalTimeString
        self.lblPlayingTime.text = totalTimeString
        self.audioPlayer.updateMeters()
        let averagePower = self.audioPlayer.averagePower(forChannel: 0)
        let percentage: Float = pow(10, (0.05 * averagePower))
        NotificationCenter.default.post(name: .audioPlayerManagerMeteringLevelDidUpdateNotification, object: self, userInfo: ["percentage": percentage])
    }
    
    // MARK: - @IBActions.
    @IBAction func onTapUpload(_ sender: UIButton) {
//        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                for file in totalFilesSelected {
//                    let completePath = directoryPath.absoluteString + file
//                    let url = URL(string: completePath)
//                    self.existingViewModel.uploadAudio(userName: CoreData.shared.userName, toUser: "pts", emailNotify: false, fileUrl: url!, fileName: file, description: AudioFiles.shared.getAudioComment(name: file)) {
//                        print("uploaded successfully")
//                    } failure: { error in
//                        print(error)
//                    }
//
//                }
        self.existingViewModel.uploadingQueue = totalFilesSelected
        if self.totalFilesSelected.count == 0{
            CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Please select atleast one file.", btnTitle: "OK")
        } else {
            let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
            self.setPushTransitionAnimation(VC)
            self.navigationController?.popViewController(animated: false)
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    @IBAction func onTapDelete(_ sender: UIButton) {
        if self.totalFilesSelected.count == 0{
            CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Please select atleast one file.", btnTitle: "OK")
        }else{
            CommonFunctions.showAlert(view: self, title: "PTS Dictate", message: "Are you sure want to Delete?", completion: {
                (success) in
                if success{
                    print("tF===____>>>", self.totalFiles)
                    print("tFSelect===____>>>", self.totalFilesSelected)
                    for av in self.totalFilesSelected {
                        self.removeAudio(itemName: av, fileExtension: "")
                    }
                    //                    self.totalFiles = self.findFilesWith(fileExtension: "m4a")
                    for file in self.totalFilesSelected {
                        AudioFiles.shared.deleteAudio(name: file)
                    }
                    self.totalFiles = self.getSortedAudioList()
                    self.setRightBarItem()
                }
            })
        }
    }
    func getSortedAudioList() -> [String] {
        var sortedDateArray = [String]()
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        guard let directoryURL = URL(string: paths.path) else {return [""]}
        do {
            let contents = try
            FileManager.default.contentsOfDirectory(at: directoryURL,
                                                    includingPropertiesForKeys:[.contentModificationDateKey],
                                                    options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            .filter { $0.lastPathComponent.hasSuffix(".m4a") }
            .sorted(by: {
                let date0 = try $0.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate!
                let date1 = try $1.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate!
                return date0.compare(date1) == .orderedDescending
            })
            
            // Print results
            for item in contents {
                guard let t = try? item.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate
                else {return [""]}
                print ("Hello,\(t)   \(item.lastPathComponent)")
                sortedDateArray.append(item.lastPathComponent)
            }
        } catch {
            print ("Finding date sorted error-->>",error.localizedDescription)
        }
        print("List array-->>",sortedDateArray)
        return sortedDateArray
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
    
    func setUpWave() {
        self.mediaProgressView.meteringLevelBarWidth = 1.0
        self.mediaProgressView.meteringLevelBarInterItem = 1.0
        self.mediaProgressView.meteringLevelBarCornerRadius = 0.0
        self.mediaProgressView.meteringLevelBarSingleStick = false
        self.mediaProgressView.gradientStartColor = #colorLiteral(red: 0.6509803922, green: 0.8235294118, blue: 0.9529411765, alpha: 1)
        self.mediaProgressView.gradientEndColor = #colorLiteral(red: 0.2273887992, green: 0.2274999917, blue: 0.9748747945, alpha: 1)
        self.mediaProgressView.add(meteringLevel: 0.6)
        self.mediaProgressView.audioVisualizationMode = .read
        self.mediaProgressView.meteringLevels = [0.1, 0.67, 0.13, 0.78, 0.31]
    }
    
    fileprivate func getSelectedAudioComment(selected audio: String) -> String {
        for (key, value) in comments where key == audio {
            return value
        }
        return ""
    }
    
    fileprivate func pushToComments(selected audio: String, index: Int) {
        let VC = CommentsVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        self.setPushTransitionAnimation(VC)
        VC.hidesBottomBarWhenPushed = true
        VC.updateComment = true
        VC.selectedAudio = audio
        VC.comment = getSelectedAudioComment(selected: audio)
        self.navigationController?.pushViewController(VC, animated: false)
    }
    
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
    
    private func getFilePath() -> URL{
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let completePath = directoryPath.absoluteString +  self.lblFileName.text!
        let completePathURL = URL(string: completePath)!
        return completePathURL
    }
    
    private func playAudio() {
        var playingMediaIndex = 0
        for (index, value) in self.totalFiles.enumerated() {
            if value as? String == self.lblFileName.text!  {
                print("Finding Index-->>",index)
                playingMediaIndex = index
            }
        }
        let cell  = tableView.cellForRow(at: IndexPath(row: playingMediaIndex, section: 0)) as? ExistingFileCell
        self.lblTotalTime.text = self.getTimeDuration(filePath: self.lblFileName.text!)
        settingUpPlayer()
        if audioPlayer.isPlaying{
            self.lblPlayerStatus.text = "Now Paused"
            audioPlayer.pause()
//            self.mediaProgressView.pause()
            cell?.btnPlay.setBackgroundImage(UIImage(named: "existing_play_btn"), for: .normal)
            self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
        }else{
            preparePlayerToPlay(completePathURL: getFilePath())
            self.lblPlayerStatus.text = "Now Playing"
            //                self.mediaProgressView.audioURL = completePathURL!
//            self.mediaProgressView.meteringLevels = [0.1, 0.67, 0.13, 0.78, 0.31]
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
//                self.mediaProgressView.play(for: self.audioPlayer.duration / self.audioPlayer.duration)
            }
            cell?.btnPlay.setBackgroundImage(UIImage(named: "existing_pause_btn"), for: .normal)
            self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_pause_btn_normal"), for: .normal)
            tag = playingMediaIndex
            self.audioMeteringLevelTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerDidUpdateMeter), userInfo: nil, repeats: true)
        }
        self.setTrimButtonInteraction(isInteractive: true)
    }
    
    private func controllAudioPlayer(controllerType: AudioControllers) {
        DispatchQueue.main.async {
            self.audioPlayer.pause()
            let currentTime = self.audioPlayer.currentTime
            switch controllerType {
            case .fastRewind:
                if currentTime > TimeInterval(10.0) {
                    self.audioPlayer.play(atTime: currentTime - 10.0)
                }
            case .rewind:
                if currentTime > TimeInterval(3.0) {
                    self.audioPlayer.play(atTime: currentTime - 3.0)
                }
            case .play:
                self.playAudio()
            case .forward:
                if currentTime > TimeInterval(0.0) && currentTime < self.audioPlayer.duration {
                    self.preparePlayerToPlay(completePathURL: self.getFilePath())
                    self.audioPlayer.play(atTime: currentTime + 3.0)
                }
            case .fastForward:
                if currentTime > TimeInterval(0.0) && currentTime < self.audioPlayer.duration {
                    self.audioPlayer.play(atTime: currentTime + 10.0)
                }
            }
        }
    }
    
    func selectAudioFileToPlay(audio index:Int?) {
        
    }
    
}

// MARK: - Extension for tableView delegate & dataSource methods.
extension ExistingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.totalFiles.count > 0{
            self.lblFileName.text = self.totalFiles[0] as? String
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExistingFileCell", for: indexPath) as! ExistingFileCell
        if self.totalFilesSelected.contains(self.totalFiles[indexPath.row]){
            cell.btnSelection.setImage(UIImage(named: "checked_checkbox"), for: .normal)
        }else{
            cell.btnSelection.setImage(UIImage(named: "unchecked_checkbox"), for: .normal)
        }
        cell.isUserInteractionEnabled = true
        cell.btnEdit.isHidden = false
        cell.lblFileSize.text = fileSize(itemName:  self.totalFiles[indexPath.row])
        cell.btnSelection.tag = indexPath.row
        cell.btnSelection.removeTarget(self, action: nil, for: .touchUpInside)
        cell.btnSelection.addTarget(self, action: #selector(btnActCheckBox(_:)), for: .touchUpInside)
        cell.lblFileName.text = self.totalFiles[indexPath.row]
        cell.btnComment.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
        cell.btnPlay.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(play), for: .touchUpInside)
        cell.btnComment.addTarget(self, action: #selector(openCommentVC), for: .touchUpInside)
        cell.btnEdit.addTarget(self, action: #selector(openRenameFileVc), for: .touchUpInside)
        
        DispatchQueue.main.async {
            let time = self.getTimeDuration(filePath: self.totalFiles[indexPath.row])
            cell.lblFileTime.text = time
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lblFileName.text = totalFiles[indexPath.row]
        
        //demo for now
//        if indexPath.row == 0{
//            //want to perform overwrite
//            /*
//             for overwrite, we're inserting the second file(4 seconds long) in the 4-8th seconds of first file which was originally 10 seconds long.
//             so the final result will be start file(2 seconds) + second file(4 seconds) + end file(4 seconds) and it will be 10 seconds long.
//             */
//            let firstUrl = self.getDocumentsDirectory().appendingPathComponent(totalFiles.first!)
//            let secondUrl = self.getDocumentsDirectory().appendingPathComponent(totalFiles.last!)
//            let startTime = CMTimeMakeWithSeconds(4, preferredTimescale: 1)
//            self.mergeAudioFiles(originalURL: secondUrl, replacingURL: firstUrl, startTime: startTime, folderName: "Demo", caseNumber: "test", taskToPerform: "Overwrite")
//        }else{
//            //want to perform insert
//            let firstUrl = self.getDocumentsDirectory().appendingPathComponent(totalFiles.first!)
//            let secondUrl = self.getDocumentsDirectory().appendingPathComponent(totalFiles.last!)
//            let startTime = CMTimeMakeWithSeconds(3, preferredTimescale: 1)
//            self.mergeAudioFiles(originalURL: secondUrl, replacingURL: firstUrl, startTime: startTime, folderName: "Demo", caseNumber: "test", taskToPerform: "Insert")
//        }
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
        //            if let completePathURL = URL(string: completePath){
        let completePathURL = URL(string: completePath)
        
        let audioAsset = AVURLAsset.init(url: completePathURL!, options: nil)
        let duration = audioAsset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        self.fileDuration = Int(durationInSeconds)
        let min = Int(durationInSeconds / 60)
        let sec = Int(durationInSeconds.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d",min, sec)
        //            }
        return totalTimeString
    }
    func fileSize(itemName: String) -> String? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return ""
        }
        let filePath = "\(dirPath)/\(itemName)"
        guard let size = try? FileManager.default.attributesOfItem(atPath: filePath)[FileAttributeKey.size],
              let fileSize = size as? UInt64 else {
            return nil
        }
        
        // bytes
        if fileSize < 1023 {
            return String(format: "%lu bytes", CUnsignedLong(fileSize))
        }
        // KB
        var floatSize = Float(fileSize / 1024)
        if floatSize < 1023 {
            return String(format: "%.1f KB", floatSize)
        }
        // MB
        floatSize = floatSize / 1024
        if floatSize < 1023 {
            return String(format: "%.1f MB", floatSize)
        }
        // GB
        floatSize = floatSize / 1024
        return String(format: "%.1f GB", floatSize)
    }
    @objc func openCommentVC(_ sender: UIButton){
        let audioFile = totalFiles[sender.tag]
        pushToComments(selected: audioFile, index: sender.tag)
    }
    
    @objc func openRenameFileVc(){
        //        let VC = RenameFileVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        //            self.setPushTransitionAnimation(VC)
        //        VC.hidesBottomBarWhenPushed = true
        //        self.navigationController?.pushViewController(VC, animated: false)
        let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
        self.setPushTransitionAnimation(VC)
        self.navigationController?.popViewController(animated: false)
        self.editFromExiting = true
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
                self.totalFilesSelected = self.totalFiles
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
}

// MARK: - Extension for AVAudioPlayerDelegate
extension ExistingVC: AVAudioPlayerDelegate {
    // Completion of playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            let cell  = tableView.cellForRow(at: IndexPath(row: self.playingCellIndex, section: 0)) as? ExistingFileCell
            cell?.btnPlay.setBackgroundImage(UIImage(named: "existing_play_btn"), for: .normal)
            self.lblPlayerStatus.text  = ""
            self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
//            self.mediaProgressView.reset()
            self.setUpWave()
            self.tableView.reloadData()
            print("Playing Completed")
        }
    }
}


extension ExistingVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: RecordVC.self as AnyClass) {
            let recordVC = tabBarController.viewControllers?[2] as! RecordVC
            recordVC.editFromExiting = false
        } else if viewController.isKind(of: UploadProgressVC.self as AnyClass) {
            let uploadVC = tabBarController.viewControllers?[1] as! UploadProgressVC
           // uploadVC.uploadingQueue = []
        }
            return true
        }
    }
    // MARK: - Extension for FDWaveformViewDelegate
    
    //extension ExistingVC: FDWaveformViewDelegate {
    //    func waveformViewWillRender(_ waveformView: FDWaveformView) {
    //        startRendering = Date()
    //    }
    //
    //    func waveformViewDidRender(_ waveformView: FDWaveformView) {
    //        endRendering = Date()
    //        NSLog("FDWaveformView rendering done, took %0.3f seconds", endRendering.timeIntervalSince(startRendering))
    //        profileResult.append(String(format: " render %0.3f ", endRendering.timeIntervalSince(startRendering)))
    //        UIView.animate(withDuration: 1, animations: {() -> Void in
    //            waveformView.alpha = 1.0
    //            waveformView.progressColor = #colorLiteral(red: 0.2273887992, green: 0.2274999917, blue: 0.9748747945, alpha: 1)
    //        })
    //    }
    //
    //    func waveformViewWillLoad(_ waveformView: FDWaveformView) {
    //        startLoading = Date()
    //    }
    //
    //    func waveformViewDidLoad(_ waveformView: FDWaveformView) {
    //        endLoading = Date()
    //        NSLog("FDWaveformView loading done, took %0.3f seconds", endLoading.timeIntervalSince(startLoading))
    //        profileResult.append(String(format: " load %0.3f ", endLoading.timeIntervalSince(startLoading)))
    //    }
    //}
    
    extension Notification.Name {
        static let audioPlayerManagerMeteringLevelDidUpdateNotification = Notification.Name("AudioPlayerManagerMeteringLevelDidUpdateNotification")
        static let audioPlayerManagerMeteringLevelDidFinishNotification = Notification.Name("AudioPlayerManagerMeteringLevelDidFinishNotification")
    }

//Demo code below to check insert and overwrite that needs to remove.
extension ExistingVC{
    func mergeAudioFiles(originalURL: URL, replacingURL:URL, startTime:CMTime, folderName:String, caseNumber:String, taskToPerform:String) {
            
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey:true]
        let originalAsset  = AVURLAsset(url: originalURL, options: options)
        let replacingAsset = AVURLAsset(url: replacingURL, options: options)
        print("####### Original Asset Duration",originalAsset.duration.seconds)
        print("####### Replacing Asset Duration",replacingAsset.duration.seconds)
        
        if let replacingTrack = replacingAsset.tracks.first, let originalTrack = originalAsset.tracks.first {
            print("####### Original Track Duration",originalTrack.timeRange.duration.seconds)
            print("####### Replacing Track Duration",replacingTrack.timeRange.duration.seconds)
            
            let duration = replacingTrack.timeRange.duration.scaled
            let replacingRange = CMTimeRange(start: startTime, duration: duration)
            
            self.trimOriginalAssetFor(taskToPerform: taskToPerform, asset: originalAsset, replacingRange: replacingRange, replacingURL: replacingURL, folderName: folderName,  caseNumber:caseNumber) { (finalURLs) in
                self.exportFinalOutput(from: finalURLs, folderName: folderName,  caseNumber:caseNumber, completionHandler: { (isCompleted) in
                    if isCompleted {
                        print("Merge Successful")
                    } else {
                        print("Merge Failed")
                    }
                })
            }
        }
    }
    
    func trimOriginalAssetFor(taskToPerform:String, asset:AVAsset, replacingRange:CMTimeRange, replacingURL:URL, folderName:String, caseNumber:String, completionHandler handler: @escaping (_ finalURLs:[URL]) -> Void) {
            
        var finalURLs = [URL]()
        
//        let startURL = self.getCurrentDirectory(with: folderName, caseNumber: caseNumber).appendingPathComponent("StartTrim.m4a")
//        let endURL = self.getCurrentDirectory(with: folderName, caseNumber: caseNumber).appendingPathComponent("EndTrim.m4a")
        
        let startURL = self.getDocumentsDirectory().appendingPathComponent("StartTrim.m4a")
        let endURL = self.getDocumentsDirectory().appendingPathComponent("EndTrim.m4a")
        
        self.removeFileIfAlreadyExists(at: startURL)
        self.removeFileIfAlreadyExists(at: endURL)
        
        
        if let originalTrack = asset.tracks(withMediaType: AVMediaType.audio).first {
            
            var rangeStart : CMTimeRange!
            var rangeEnd : CMTimeRange!
            
            if taskToPerform == "Overwrite"{
                //Overwrite
                
                //Range for first file(which will be from 0 to raplacing file's start point)
                rangeStart = CMTimeRange(start: .zero, duration: replacingRange.start.scaled)
                print("start file start : ==== \(rangeStart.start.seconds)  end : ==== \(rangeStart.end.seconds)")
                
                print("inserting file start : ==== \(replacingRange.start.seconds)  end : ==== \(replacingRange.end.seconds)")
                
                let endFileDuration = originalTrack.timeRange.duration.scaled - (replacingRange.start.scaled + replacingRange.duration.scaled)
                
                let endFileStartTime = replacingRange.start.scaled + replacingRange.duration.scaled
                rangeEnd = CMTimeRange(start: endFileStartTime.scaled, duration: endFileDuration.scaled)
                
                print("end file start : ==== \(rangeEnd.start.seconds)  end : ==== \(rangeEnd.end.seconds)")
            }else{
                //Insert
                //Range for start file(which will be from 0 to raplacing file's start point)
                rangeStart = CMTimeRange(start: .zero, duration: replacingRange.start.scaled)
                print("start file start : ==== \(rangeStart.start.seconds)  end : ==== \(rangeStart.end.seconds)")
                
                print("inserting file start : ==== \(replacingRange.start.seconds)  end : ==== \(replacingRange.end.seconds)")
                
                //Range for end file
                let endFileDuration = originalTrack.timeRange.duration.scaled - rangeStart.duration.scaled
                let endFileStartTime = rangeStart.duration.scaled
                rangeEnd = CMTimeRange(start: endFileStartTime.scaled, duration: endFileDuration.scaled)
                
                print("end file start : ==== \(rangeEnd.start.seconds)  end : ==== \(rangeEnd.end.seconds)")
            }
            
            asset.export(to: startURL, timeRange: rangeStart) { (isCompleted) in
                if isCompleted {
                    //Second file export
                    asset.export(to: endURL, timeRange: rangeEnd) { (isCompleted) in
                        if isCompleted {
                            finalURLs.append(contentsOf:[startURL,replacingURL,endURL])
                            handler(finalURLs)
                        }
                    }
                }
            }
        }
    }

    func exportFinalOutput(from urls:[URL] , folderName:String, caseNumber:String, completionHandler handler: @escaping (Bool) -> Void) {
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey:true]
        let composition = AVMutableComposition(urlAssetInitializationOptions: options)
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        //Export Trimmed Audio Files
        do {
            try compositionAudioTrack?.append(urls: urls)
        } catch {
            print("Error Occured while apending", error.localizedDescription)
        }
        
        //Export Final Audio //Dictation_10162018095338_20424047
//        let finalAudioURL = self.getCurrentDirectory(with: folderName, caseNumber: caseNumber).appendingPathComponent("Dictation_\(folderName)_\(caseNumber).m4a")
        let finalAudioURL = self.getDocumentsDirectory().appendingPathComponent("final.m4a")
        self.removeFileIfAlreadyExists(at: finalAudioURL)
        self.removeAllFilesExceptNewRecording(withFolderName: folderName, caseNumber: caseNumber)
        composition.export(to: finalAudioURL, completionHandler: handler)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getCurrentDirectory(with folderName:String, caseNumber:String)  -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let appendedURL = documentsDirectory.appendingPathComponent(caseNumber).appendingPathComponent(folderName)
        return appendedURL
    }
    
    func removeFileIfAlreadyExists(at url:URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch { }
    }
    
    func removeAllFilesExceptNewRecording(withFolderName : String, caseNumber : String){
        let newRecording = "Dictation_New_\(withFolderName).m4a"
        let newOverwrite = "Dictation_\(withFolderName)_\(caseNumber)_newOverWrite.m4a"
        
        let startTrim = self.getCurrentDirectory(with: withFolderName, caseNumber: caseNumber).appendingPathComponent("StartTrim.m4a")
        let endTrim = getCurrentDirectory(with: withFolderName, caseNumber: caseNumber).appendingPathComponent("EndTrim.m4a")
        let newRec = getCurrentDirectory(with: withFolderName, caseNumber: caseNumber).appendingPathComponent(newRecording)
        let newOver = getCurrentDirectory(with: withFolderName, caseNumber: caseNumber).appendingPathComponent(newOverwrite)
        
        do{
            try FileManager.default.removeItem(at: startTrim)
        }catch{
            print("File not Found in Directory..!!")
        }
        
        do{
            try FileManager.default.removeItem(at: endTrim)
        }catch{
            print("File not Found in Directory..!!")
        }
        
        do{
            try FileManager.default.removeItem(at: newRec)
        }catch{
            print("File not Found in Directory..!!")
        }
        
        do{
            try FileManager.default.removeItem(at: newOver)
        }catch{
            print("File not Found in Directory..!!")
        }
    }
}

extension AVMutableCompositionTrack {
    func append(urls: [URL]) throws {
        for url in urls {
            let newAsset = AVURLAsset(url: url)
            let range = CMTimeRange(start:.zero, duration:newAsset.duration)
            let end = timeRange.end
            if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
                try insertTimeRange(range, of: track, at: end)
            }
        }
    }
}

extension AVAsset {
    func export(to url:URL, timeRange: CMTimeRange? = nil ,completionHandler handler: @escaping (Bool) -> Void) {
        if let assetExportSession = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetAppleM4A) {
            assetExportSession.outputFileType = AVFileType.m4a
            assetExportSession.audioTimePitchAlgorithm = .timeDomain
            assetExportSession.outputURL = url
            if let range = timeRange {
                assetExportSession.timeRange = range
                print("Exporting Range from",range.start,"Duration",range.duration,url.lastPathComponent)
            }
            assetExportSession.exportAsynchronously(completionHandler: {
                if assetExportSession.status == .completed {
                    handler(true)
                } else if let error = assetExportSession.error {
                    print("STATUS:",assetExportSession.status,"ERROR:",error.localizedDescription,"URL",url)
                    handler(false)
                } else {
                    handler(false)
                }
            })
        } else {
            print("Export failed")
        }
    }
}

extension CMTime {
    var scaled : CMTime {
        return self.convertScale(60000, method: CMTimeRoundingMethod.roundAwayFromZero)
    }
}
