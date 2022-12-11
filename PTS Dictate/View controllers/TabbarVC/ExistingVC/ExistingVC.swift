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
    
    let existingViewModel = ExistingViewModel.shared
    
    var audioRecorder:AVAudioRecorder?
    var audioPlayer = AVAudioPlayer()
    var totalFiles = [String]()
    var totalAsset = [AVAsset]()
    var totalFilesSelected : [String] = []
    var playingCellIndex = -1
    var isPlaying: Bool = false
    var pausedTime: Double?
    var fileDuration = 0
    var uploadingQueue: [String] = []
    var audioForEditing: String?
    private var audioMeteringLevelTimer: Timer?
    var tag = -1
    private var currentlyPlayingAudio: URL?
    // wave form var
    fileprivate var startRendering = Date()
    fileprivate var endRendering = Date()
    fileprivate var startLoading = Date()
    fileprivate var endLoading = Date()
    fileprivate var profileResult = ""
    
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
                    if time <= 3 {
                        self.btnBackwardTrim.setBackgroundImage(self.backDisabled, for: .normal)
                        self.btnBackwardTrimEnd.setBackgroundImage(self.fastBackDisabled, for: .normal)
                        self.btnForwardTrim.setBackgroundImage(self.nextNormal, for: .normal)
                        self.btnForwardTrimEnd.setBackgroundImage(self.fastNextNormal, for: .normal)
                        
                        self.btnBackwardTrim.isEnabled = false
                        self.btnBackwardTrimEnd.isEnabled = false
                        self.btnForwardTrim.isEnabled = true
                        self.btnForwardTrimEnd.isEnabled = true
                    } else if time >= self.audioPlayer.duration - 3 {
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
        // Do any additional setup after loading the view.
        self.existingViewModel.existingViewController = self
        self.tabBarController?.delegate = self
        self.audioTimer = 0
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
        //        CoreData.shared.audioFiles = []
        //        CoreData.shared.dataSave()
        resetSoundWaves()
        if totalFiles.count > 0 {
            self.setUpWave(index: 0)
        }
        self.checkArchiveDate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.totalFilesSelected.removeAll()
        self.audioPlayer.stop()
        self.resetSoundWaves()
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
        totalFiles.forEach { fileString in
            let asset = AVAsset(url: Constants.documentDir.appendingPathComponent(fileString))
            totalAsset.append(asset)
        }
        
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
        playAudio(index: sender.tag)
    }
    
    func playAudio(index:Int? = nil) {
        //new
        var playingMediaIndex = 0
        if index == nil{
            for (index, value) in self.totalFiles.enumerated() {
                if value == self.lblFileName.text!  {
                    playingMediaIndex = index
                }
            }
        }else{
            playingMediaIndex = index!
        }
        
        let index                 = playingMediaIndex
        self.lblFileName.text     = self.totalFiles[index]
        self.lblPlayerStatus.text = "Now Playing"
        let completePathURL       = Constants.documentDir.appendingPathComponent(self.lblFileName.text ?? "")
                    
        if isPlaying{
            //Pause
            if index != self.playingCellIndex {
                audioPlayer.stop()
//                    resetSoundWaves()
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
                setUpWave(index: index)
            }else{
                audioPlayer.play()
            }
            
            self.playingCellIndex = index
            self.isPlaying = true
            self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_pause_btn_normal"), for: .normal)
            tag = index
            self.audioMeteringLevelTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerDidUpdateMeter), userInfo: nil, repeats: true)
            self.lblTotalTime.text = self.getTimeDuration(filePath: self.totalFiles[index])
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
            audioPlayer.play()
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
        
        self.lblPlayingTime.text = totalTimeString
        self.audioPlayer.updateMeters()
        
//        let averagePower = self.audioPlayer.averagePower(forChannel: 0)
//        let percentage: Float = pow(10, (0.05 * averagePower))
//        NotificationCenter.default.post(name: .audioPlayerManagerMeteringLevelDidUpdateNotification, object: self, userInfo: ["percentage": percentage])
    }
    
    // MARK: - @IBActions.
    @IBAction func onTapUpload(_ sender: UIButton) {
        if self.totalFilesSelected.count == 0{
            CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Please select atleast one file.", btnTitle: "OK")
        } else {
            let alreadyUploaded = self.checkFilesAlreadyUploadedOrNot()
            if alreadyUploaded {
                CommonFunctions.showAlert(view: self, title: "PTS Dictate", message: "Are you sure you want to re-upload?") { success in
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
            CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Please select atleast one file.", btnTitle: "OK")
        }else{
            CommonFunctions.showAlert(view: self, title: "PTS Dictate", message: "Are you sure want to Delete?", completion: {
                (success) in
                if success{
                    print("tF===____>>>", self.totalFiles)
                    print("tFSelect===____>>>", self.totalFilesSelected)
                    for file in self.totalFilesSelected {
                        self.removeAudio(itemName: file, fileExtension: "")
                        AudioFiles.shared.deleteAudio(name: file)
                    }
                    self.totalFilesSelected.removeAll()
                    self.totalFiles = self.getSortedAudioList()
                    self.setRightBarItem()
                }
            })
        }
    }
    
    func checkFilesAlreadyUploadedOrNot() -> Bool {
        for file in totalFilesSelected {
            let audioFile = getFileInfo(name: file)
            if audioFile?.fileInfo?.isUploaded ?? true {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func uploadFiles() {
        self.existingViewModel.uploadingQueue = self.totalFilesSelected
        let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
        self.setPushTransitionAnimation(VC)
        self.navigationController?.popViewController(animated: false)
        self.tabBarController?.selectedIndex = 1
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
    }
    
    fileprivate func pushToComments(selected audio: String, index: Int) {
        let VC = CommentsVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        self.setPushTransitionAnimation(VC)
        VC.hidesBottomBarWhenPushed = true
        let audioFile = getFileInfo(name: audio)
        let isUploaded = audioFile?.fileInfo?.isUploaded ?? false
        VC.fromExistingVC = true
        VC.canEditComments = isUploaded ? false : true
        VC.selectedAudio = audio
        VC.comment = audioFile?.fileInfo?.comment ?? ""
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
    
    func checkArchiveDate() {
        let currentDateString = Date().getFormattedDateString()
        let audioFiles = AudioFiles.shared.audioFiles
        
        for file in audioFiles where file.fileInfo?.isUploaded ?? false && file.fileInfo?.archivedDays != 0 {
            let uploadedDate = file.fileInfo?.uploadedAt ?? ""
            let archivedDays = file.fileInfo?.archivedDays ?? 0
            let diffDays = daysBetween(start: uploadedDate.getDateFromFormattedString(), end: currentDateString.getDateFromFormattedString())
            if diffDays > archivedDays {
                let fileName = file.name ?? ""
                self.removeAudio(itemName: fileName, fileExtension: "")
                AudioFiles.shared.deleteAudio(name: fileName)
                self.totalFiles = self.getSortedAudioList()
                self.setRightBarItem()
            }
        }
    }
    
    private func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func getAudioMeteringLevels(audio: String) {
        
    }
}

// MARK: - Extension for tableView delegate & dataSource methods.
extension ExistingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.totalFiles.count > 0{
            self.lblFileName.text = self.totalFiles[0]
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
    func setCellData(cell: ExistingFileCell, audioName: String) {
        let file = getFileInfo(name: audioName)
        if !(file?.fileInfo?.isUploaded ?? false) && file?.fileInfo?.comment != nil {
            cell.lblFileStatus.textColor = UIColor.black
            if file?.fileInfo?.autoSaved ?? true {
                cell.lblFileStatus.text = "Auto Saved File"
            }else{
                cell.lblFileStatus.text = ""
            }
            cell.btnComment.isUserInteractionEnabled = true
            cell.btnEdit.isUserInteractionEnabled = true
            cell.btnComment.isHidden = false
            cell.btnComment.setBackgroundImage(UIImage(named: "comments_normal"), for: .normal)
            cell.btnEdit.setBackgroundImage(UIImage(named: "music_edit_normal"), for: .normal)
        } else if !(file?.fileInfo?.isUploaded ?? false) && file?.fileInfo?.comment == nil {
            cell.lblFileStatus.textColor = UIColor.black
            if file?.fileInfo?.autoSaved ?? true {
                cell.lblFileStatus.text = "Auto Saved File"
            } else{
                cell.lblFileStatus.text = ""
            }
            cell.btnComment.isUserInteractionEnabled = true
            cell.btnEdit.isUserInteractionEnabled = true
            cell.btnComment.isHidden = true
            cell.btnComment.setBackgroundImage(UIImage(named: "no_comments_normal"), for: .normal)
            cell.btnEdit.setBackgroundImage(UIImage(named: "music_edit_normal"), for: .normal)
        } else if file?.fileInfo?.isUploaded ?? true && file?.fileInfo?.comment != nil{
            cell.lblFileStatus.textColor = UIColor(red: 62/255, green: 116/255, blue: 36/255, alpha: 1.0)
            if file?.fileInfo?.autoSaved ?? true {
                cell.lblFileStatus.text = "Auto Saved File"
            } else{
                cell.lblFileStatus.text = "Uploaded"
            }
            cell.lblFileStatus.text = "Uploaded"
            cell.btnComment.isUserInteractionEnabled = true
            cell.btnEdit.isUserInteractionEnabled = false
            cell.btnComment.isHidden = false
            cell.btnComment.setBackgroundImage(UIImage(named: "comments_active"), for: .normal)
            cell.btnEdit.setBackgroundImage(UIImage(named: "music_edit_disable"), for: .normal)
        } else if file?.fileInfo?.isUploaded ?? true && file?.fileInfo?.comment == nil {
            cell.lblFileStatus.textColor = UIColor(red: 62/255, green: 116/255, blue: 36/255, alpha: 1.0)
            if file?.fileInfo?.autoSaved ?? true {
                cell.lblFileStatus.text = "Auto Saved File"
            } else{
                cell.lblFileStatus.text = "Uploaded"
            }
            cell.lblFileStatus.text = "Uploaded"
            cell.btnComment.isUserInteractionEnabled = true
            cell.btnEdit.isUserInteractionEnabled = false
            cell.btnComment.isHidden = true
            cell.btnComment.setBackgroundImage(UIImage(named: "no_comments_active"), for: .normal)
            cell.btnEdit.setBackgroundImage(UIImage(named: "music_edit_disable"), for: .normal)
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
        cell.lblFileSize.text = fileSize(itemName:  self.totalFiles[indexPath.row])
        cell.btnSelection.tag = indexPath.row
        cell.btnSelection.removeTarget(self, action: nil, for: .touchUpInside)
        cell.btnSelection.addTarget(self, action: #selector(btnActCheckBox(_:)), for: .touchUpInside)
        cell.lblFileName.text = self.totalFiles[indexPath.row]
        cell.btnComment.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
        cell.btnPlay.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(play), for: .touchUpInside)
        let playBtnImage = (indexPath.row == playingCellIndex && isPlaying) ? UIImage(named: "existing_pause_btn") : UIImage(named: "existing_play_btn")
        cell.btnPlay.setBackgroundImage(playBtnImage, for: .normal)
        cell.btnComment.addTarget(self, action: #selector(openCommentVC), for: .touchUpInside)
        cell.btnEdit.addTarget(self, action: #selector(openRenameFileVc), for: .touchUpInside)
        setCellData(cell: cell, audioName: totalFiles[indexPath.row])
        DispatchQueue.main.async {
            let time = self.getTimeDuration(filePath: self.totalFiles[indexPath.row])
            cell.lblFileTime.text = time
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let fileName = self.totalFiles[indexPath.row]
            self.lblFileName.text = fileName
            if self.isPlaying {
                self.audioPlayer.stop()
                self.resetSoundWaves()
                self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            }
            self.playingCellIndex = -1
            self.setUpWave(index: indexPath.row)
            self.lblPlayerStatus.text  = ""
            self.tableView.reloadData()
        }
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
    
    private func resetSoundWaves() {
        //        self.mediaProgressView.stop()
        //        self.mediaProgressView.reset()
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
            self.resetSoundWaves()
            self.setUpWave(index: playingCellIndex)
            self.playingCellIndex = -1
            self.btnBackwardTrim.setBackgroundImage(self.backNormal, for: .normal)
            self.btnBackwardTrimEnd.setBackgroundImage(self.fastBackNormal, for: .normal)
            self.btnForwardTrim.setBackgroundImage(self.nextNormal, for: .normal)
            self.btnForwardTrimEnd.setBackgroundImage(self.fastNextNormal, for: .normal)
            
            self.btnBackwardTrim.isEnabled = true
            self.btnBackwardTrimEnd.isEnabled = true
            self.btnForwardTrim.isEnabled = true
            self.btnForwardTrimEnd.isEnabled = true
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
        
        //new one
        //we need to change three things(timing label, audio player's current time and sound wave progress)
        var currentTime = audioPlayer.currentTime
        currentTime += timeVal
        audioPlayer.currentTime = TimeInterval(integerLiteral: currentTime)
        audioPlayer.updateMeters()
        
        //update timings
        self.lblPlayingTime.text = self.timeString(from: currentTime)
        
        //update waves
        self.mediaProgressView.waveformView.progressTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 1)
        
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
            audioPlayer.pause()
            audioPlayer.currentTime = time
            if pausedTime != nil {
                audioPlayer.play()
            }
            let min = Int(audioPlayer.currentTime / 60)
            let sec = Int(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            self.audioTimer = audioPlayer.currentTime
            self.lblPlayingTime.text = totalTimeString
            audioPlayer.updateMeters()
        }
    }
}
