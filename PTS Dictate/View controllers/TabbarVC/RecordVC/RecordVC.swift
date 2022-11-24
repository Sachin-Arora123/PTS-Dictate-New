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
var player: AVAudioPlayer?
var tempChunks : [AVURLAsset] = []
var tempAudioFileURL: String = ""

enum RecorderState: Int {
    case none = 0
    case recording
    case pause
}
class RecordVC: BaseViewController {
    
    // MARK: - @IBOutlets.
    
    @IBOutlet weak var customRangeBar: F3BarGauge!
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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var currentPlayingTime: UILabel!
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var playerTotalTime: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var playerWaveView: UIView!
    @IBOutlet weak var bookmarkWaveTime: UIView!
    @IBOutlet weak var bookMarkView: UIView!
    @IBOutlet weak var btnLeftBookmark: UIButton!
    @IBOutlet weak var btnRightBookmark: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var viewClear: UIView!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var insertTimer: UILabel!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var segmentHeight: NSLayoutConstraint!
    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var customRangeBarHeight: NSLayoutConstraint!
    @IBOutlet weak var parentStackTop: NSLayoutConstraint!
    @IBOutlet weak var viewPlayerTiming: UIView!

    // MARK: - Variables.
    var sampleRateKey = 0
    var recorder: HPRecorder!
    var recorderState: RecorderState = .none
    var audioFileURL: String = ""
    var chunkInt = 0
    let fileManager = FileManager.default
    var recordTimer:Timer!
    var audioFileName: String = ""
    var articleChunks = [AVURLAsset]()
    var settings         = [String : Any]()
    var currentRecordUpdateTimer: Timer!
    private var isCommentsOn:Bool {
        return CoreData.shared.commentScreen == 1 ?  true : false
    }
    private var isCommentsMandotary:Bool {
        return CoreData.shared.commentScreenMandatory == 1 ?  true : false
    }
    
       private lazy var stopwatch = Stopwatch(timeUpdated: { [weak self] timegap in
            guard let strongSelf = self else { return }
             strongSelf.lblTime.text = strongSelf.timeString(from: timegap)
           strongSelf.updateAudioMeter()
        })
    
    var editFromExiting: Bool {
        // getting the value from exiting view controller's variable
        get {
            return (self.tabBarController!.viewControllers![0] as! ExistingVC).editFromExiting
        }
        // assign the new value to this view controller's variable
        set {
            (self.tabBarController!.viewControllers![0] as! ExistingVC).editFromExiting = newValue
        }
    }
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showBottomView), name: Notification.Name("showBottomBtnView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate(notification:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //UI setup
        audioRangeMeterSetUp()
        hideLeftButton()
        setTitleWithImage("Record", andImage: UIImage(named: "title_record_normal.png") ?? UIImage())
        setUpUI()
        self.initiallyBtnStateSetup()
        self.viewBottomButton.isHidden = true
        //setup file name
        self.setupFileName()
        isRecording = false

        if editFromExiting {
            setUpUIForEditing()
        }
        self.recorder = HPRecorder()
             self.recorder.askPermission {[weak self] (grandted) in
                 DispatchQueue.main.async {
                     if !grandted {
                         print("granted")
                     }
                 }
             }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioRecorder = nil
        self.tabBarController?.setTabBarHidden(false, animated: false)
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self, name: Notification.Name("showBottomBtnView"), object: nil)
      NotificationCenter.default.removeObserver(self)
//      stopwatch.stop()
    }
    @objc func applicationWillTerminate(notification: Notification) {
        print("Notification received.")
        if self.recorder.audioRecorder != nil {
            self.recorder.endRecording()
        }
        self.recorderState = .none
        tempAudioFileURL = self.audioFileURL
        stopwatch.stop()
        print("temp",tempAudioFileURL)
//        UserDefaults.standard.set(audioFileURL, forKey: "terminatedRecording")
        

//
//        do{
//            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: tempChunks, requiringSecureCoding: false)
//            let userDefaults = UserDefaults.standard
//            userDefaults.set(encodedData, forKey: "assetChunks")
//        }catch (let error){
//            #if DEBUG
//                print("Failed to convert UIColor to Data : \(error.localizedDescription)")
//            #endif
//        }
        
//        CoreData.shared.fileCount += 1
        for asset in self.recorder.articleChunks {
            try! FileManager.default.removeItem(at: asset.url)
        }
//        DispatchQueue.main.async {
//            self.recorder.concatChunks(filename: self.audioFileURL){
//                success in
//                if success{
//                    CoreData.shared.fileCount += 1
//                    print("success saved")
//                }else{
//                    print("Fail")
//                }
//            }
//        }
    }
    // MARK: - UISetup
    func setUpUI(){
        segmentControl.isHidden = true
        stackView.isHidden = true
        stackViewHeight.constant = 0
        viewPlayerTiming.isHidden = true
        insertTimer.isHidden = true
        segmentHeight.constant = 0
        viewProgress.isHidden = true
        progressViewHeight.constant = 45
        self.playerWaveView.isHidden = true
    }
    // MARK: - File Name Setup.
    func setupFileName(){
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateStr = dateFormatter.string(from: currentDate)
        let convertedDate = dateFormatter.date(from: currentDateStr) ?? Date()
        let fileFormatString = CoreData.shared.dateFormat

        if fileFormatString.count == 0 {
            dateFormatter.dateFormat = "ddMMyyyy"
        }else{
            dateFormatter.dateFormat = fileFormatString.replacingOccurrences(of: "mm", with: "MM")
        }

        let convertedDateStr = "\(dateFormatter.string(from: convertedDate))"

        let nameToShow = (CoreData.shared.fileName.count != 0) ? CoreData.shared.fileName : CoreData.shared.profileName

        //need to check recording file count here as well
        self.audioFileURL = nameToShow + "_" + convertedDateStr + "_File_" + "\(CoreData.shared.fileCount)"
        self.lblFNameValue.text = nameToShow + "_" + convertedDateStr + "_File_" + "\(CoreData.shared.fileCount)" + ".m4a"
        self.lblFSizeValue.text = "0.00 Mb"
    }
    
    // MARK: - Bottom Button View.
    @objc func showBottomView() {
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
    }
    
    // MARK: - Initially button state setup.
    func initiallyBtnStateSetup(){
        btnStop.isUserInteractionEnabled = false
        btnPlay.isUserInteractionEnabled = false
        btnForwardTrim.isUserInteractionEnabled = false
        btnForwardTrimEnd.isUserInteractionEnabled = false
        btnBackwardTrim.isUserInteractionEnabled = false
        btnBackwardTrimEnd.isUserInteractionEnabled = false
        lblPlayerStatus.text = ""
    }
    
    // MARK: - @IBActions.
    @IBAction func onTapRecord(_ sender: UIButton) {
        let index = CoreData.shared.audioQuality
//        var sampleRateKey = 0

        switch index {
        case 0:
            sampleRateKey  = 11025
        case 1:
            sampleRateKey  = 22050
        case 2:
            sampleRateKey  = 44100
        default:
            sampleRateKey  = 11025
        }
        switch recorderState {
              case .none:
            self.recorder.startRecording(sampleRateKey: Float(sampleRateKey), fileName:  "P")
                  self.recorderState = .recording
            stopwatch.start()
//            self.recordTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            self.lblPlayerStatus.text = "Recording"
            self.btnRecord.setBackgroundImage(UIImage(named: "record_pause_btn_normal"), for: UIControl.State.normal)
            self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: UIControl.State.normal)
            self.btnStop.isUserInteractionEnabled = true
            print("recording")
              case .recording:
                  self.recorder.pauseRecording()
            stopwatch.pause()
//            self.audioFileURL = self.recorder.audioFilename
                  self.recorderState = .pause
            lblPlayerStatus.text = "Paused"
            btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: UIControl.State.normal)
            btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            btnBackwardTrim.setBackgroundImage(UIImage(named: "existing_rewind_normal"), for: .normal)
            btnBackwardTrimEnd.setBackgroundImage(UIImage(named: "existing_backward_fast_normal"), for: .normal)
            btnPlay.isUserInteractionEnabled = true
            btnBackwardTrim.isUserInteractionEnabled = true
            btnBackwardTrimEnd.isUserInteractionEnabled = true
            print("pause")
            self.setUpStopAndPauseUI()
            self.btnStop.isUserInteractionEnabled = true
              case .pause:
            stopwatch.start()
            self.setUpUI()
            self.initiallyBtnStateSetup()
            self.customRangeBar.isHidden = false
            self.customRangeBarHeight.constant = 45
            self.parentStackTop.constant = 35
            lblPlayerStatus.text = "Recording"
            self.recorder.startRecording(sampleRateKey: Float(sampleRateKey), fileName: "\(chunkInt)")
            self.chunkInt += 1
            self.recorderState = .recording
            self.btnRecord.setBackgroundImage(UIImage(named: "record_pause_btn_normal"), for: UIControl.State.normal)
            self.btnStop.isUserInteractionEnabled = true
            print("resume")

              }
                isRecording = true
    }
    
    @IBAction func onTapStop(_ sender: UIButton) {
            self.recorder.pauseRecording()
            self.recorderState = .pause
//            stopwatch.toggle()
        stopwatch.pause()
        /* `ListRecordings` is updated in `self.concatChunks` as temporary
         files are deleted there asynchronously, and calling `reloadData`
         here would result in runtime crash.
         */
        print("stop")
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
        CommonFunctions.showHideViewWithAnimation(view:  self.viewBottomButton, hidden: false, animation: .transitionFlipFromBottom)
        lblPlayerStatus.text = "Stopped"
        self.setUpStopAndPauseUI()
    }
    func setUpStopAndPauseUI(){
        self.customRangeBar.isHidden = true
        self.customRangeBarHeight.constant = 0
        progressViewHeight.constant = 0
        viewProgress.isHidden = true
        stackView.isHidden = true
        playerWaveView.isHidden = false
        bookMarkView.isHidden = true
        viewClear.isHidden = true
        viewPlayerTiming.isHidden = false
        parentStackTop.constant = 60
        currentPlayingTime.text = self.lblTime.text
        playerTotalTime.text = self.lblTime.text
    }
    // MARK: - Audio meter range setup.
    func audioRangeMeterSetUp() {
        self.customRangeBar.backgroundColor = .white
        self.customRangeBar.numBars = 30
        self.customRangeBar.minLimit = -100
        self.customRangeBar.maxLimit = -10
        self.customRangeBar.normalBarColor = hexStringToUIColor(hex: "F74118")
        self.customRangeBar.warningBarColor = UIColor(red: 105.0/255.0, green: 105.0/255.0, blue: 105.0/255.0, alpha: 1.0)
        self.customRangeBar.dangerBarColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.customRangeBar.outerBorderColor = .gray
        self.customRangeBar.innerBorderColor = .black
        self.customRangeBar.alpha = 1.0
    }
    
            
    // MARK: - Slide View - Top To Bottom
    func viewSlideInFromTopToBottom(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        view.layer.add(transition, forKey: kCATransition)
    }
    
    // MARK: - @IBAction Play.
    @IBAction func onTapPlay(_ sender: UIButton)  {
       if !self.recorder.queuePlayerPlaying {
           self.recorder.startPlayer()
           btnPlay.setBackgroundImage(UIImage(named: "existing_controls_pause_btn_normal"), for: .normal)
           btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_disable"), for: .normal)
           btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
           btnRecord.isUserInteractionEnabled = false
           btnStop.isUserInteractionEnabled = false
       }else{
           self.recorder.stopPlayer()
           self.onStopPlayerSetupUI()
       }
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.recorder.playerItem)
        self.recorder.queuePlayer?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { (time) in
                if self.recorder.queuePlayer?.currentItem?.status == .readyToPlay {
                    let currentTime = CMTimeGetSeconds(self.recorder.queuePlayer?.currentTime() ?? CMTime.zero)
                    self.currentPlayingTime.text = self.timeString(from: currentTime)
                }
        })
    }
    func onStopPlayerSetupUI(){
        btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
        btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: .normal)
        btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
        btnRecord.isUserInteractionEnabled = true
        btnStop.isUserInteractionEnabled = true
        btnPlay.isUserInteractionEnabled = true
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
//        btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
        self.onStopPlayerSetupUI()
        print("Finished playing")
    }
    // MARK: - @IBAction Forward.
    @IBAction func onTapForwardTrim(_ sender: UIButton) {
        print("Forward Trim")
        self.recorder.seekForward(timeInterval: 1)
    }
    
    // MARK: - @IBAction Fast Forward.
    @IBAction func onTapForwardTrimEnd(_ sender: UIButton) {
        print("Forward Trimfast End")
        self.recorder.seekForward(timeInterval: 3)
    }
    
    // MARK: - @IBAction Backward Trim.
    @IBAction func onTapBackwardTrim(_ sender: UIButton) {
        print("Backward Trim")
        self.recorder.seekBackwards(timeInterval: 1)
    }
    
    // MARK: - @IBAction Fast Backward Trim.
    @IBAction func onTapBackwardTrimEnd(_ sender: UIButton) {
        print("Backward TrimFast End")
        self.recorder.seekBackwards(timeInterval: 3)
    }
    
    func fastForwardByTime(timeVal: Double) {
//        audioPlayer = try? AVAudioPlayer(contentsOf: audioRecorder!.url)
        audioPlayer = try? AVAudioPlayer(contentsOf: self.recorder.audioRecorder.url)
        audioPlayer?.delegate = self
        var time: TimeInterval = audioPlayer?.currentTime ?? 0.0
        time += timeVal
        if time > audioPlayer!.duration {
            if let player = audioPlayer {
                if player.isPlaying {
                    player.stop()
                }
            }
        } else {
            audioPlayer?.currentTime = time
            let min = Int(audioPlayer!.currentTime / 60)
            let sec = Int(audioPlayer!.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            self.lblTime.text = totalTimeString
            audioPlayer?.updateMeters()
        }
    }
    
    func fastBackwardByTime(timeVal: Double) {
//        audioPlayer = try? AVAudioPlayer(contentsOf: audioRecorder!.url)
        audioPlayer = try? AVAudioPlayer(contentsOf:   self.recorder.audioRecorder.url)
        var time: TimeInterval = audioPlayer?.currentTime ?? 0.0
        time -= timeVal
        if time < 0 {
            audioPlayer?.stop()
        } else {
            audioPlayer?.currentTime = time
            let min = Int(audioPlayer!.currentTime / 60)
            let sec = Int(audioPlayer!.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            self.lblTime.text = totalTimeString
            audioPlayer?.updateMeters()
        }
    }
    // MARK: - @IBAction Segment Control.
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.btnClear.tag = 1
            self.viewClear.isHidden = true
            self.recorderState = .pause
            self.stackViewHeight.constant = 0
            self.btnRecord.isUserInteractionEnabled = true
            self.btnStop.isUserInteractionEnabled = true
            btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: .normal)
            btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
            CommonFunctions.alertMessage(view: self, title: "Append", msg: Constants.appendMsg, btnTitle: "OK")
            break
        case 1:
            self.btnClear.tag = 2
            CommonFunctions.alertMessage(view: self, title: "Insert", msg: Constants.insertMsg, btnTitle: "OK")
            settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: Double(savedAudioQuality(audioQuality: AudioQuality(rawValue: CoreData.shared.audioQuality)!)),
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            self.recorderState = .pause
            self.btnRecord.isUserInteractionEnabled = true
            self.btnStop.isUserInteractionEnabled = true
            btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: .normal)
            btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
            self.setInsert_PartialDeleteUI()
//            self.stackView.isHidden = false
//            self.stackViewHeight.constant = 50
//            self.viewClear.isHidden = false
//            self.bookMarkView.isHidden = true
//            self.bookmarkWaveTime.isHidden = true
//            self.btnClear.setImage(UIImage(named: "btn_start_point_normal"), for: .normal)
//            self.btnClear.setBackgroundImage(UIImage(named: ""), for: .normal)
//            startRecording()
            break
        case 2:
            self.btnClear.tag = 3
            CommonFunctions.alertMessage(view: self, title: "Overwrite", msg: Constants.overwriteMsg, btnTitle: "OK")
            break
        case 3:
            self.btnClear.tag = 4
            CommonFunctions.alertMessage(view: self, title: "Partial Delete", msg: Constants.partialDeleteMsg, btnTitle: "OK")
            self.setInsert_PartialDeleteUI()
            break
        default:
            break
        }
    }

    func setInsert_PartialDeleteUI() {
        self.stackView.isHidden = false
        self.stackViewHeight.constant = 50
        self.viewClear.isHidden = false
        self.bookMarkView.isHidden = true
        self.bookmarkWaveTime.isHidden = true
        self.btnClear.setImage(UIImage(named: "btn_start_point_normal"), for: .normal)
        self.btnClear.setBackgroundImage(UIImage(named: ""), for: .normal)
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
    // MARK: - Save Recording audio
    func saveRecordedAudio(completion: @escaping(_ result: Bool) -> Void) {
        let url = getDocumentsDirectory().appendingPathComponent(".m4a")
         do {
             try self.audioFileURL.write(to: url, atomically: true, encoding: .utf8)
             let input = try String(contentsOf: url)
             let dataDict:[String: String] = ["file": input]
             isRecording = false
//             NotificationCenter.default.post(name: Notification.Name("FileSaved"), object: nil, userInfo: dataDict)
             print("Saved File--->>",input)
             completion(true)
         } catch {
             print("Saving error-->>",error.localizedDescription)
             
         }
    }
    
    func pushCommentVC(){
        let VC = CommentsVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        self.setPushTransitionAnimation(VC)
        VC.hidesBottomBarWhenPushed = true
        VC.isCommentsMandotary = isCommentsMandotary
        VC.fileName = audioFileName
        self.navigationController?.pushViewController(VC, animated: false)
    }
    // MARK: - @IBAction Save.
    @IBAction func onTapSave(_ sender: UIButton) {
        print("Saved")
        CommonFunctions.showAlert(view: self, title: "PTS Dictate", message: "Do you want to save the current Recording ?", completion: {
            (success) in
            if success{
                // Stop Recorder & Change State
                if self.recorder.audioRecorder != nil {
                    self.recorder.endRecording()
                }
                self.lblTime.text = "00:00:00"
                self.recorderState = .none
                CoreData.shared.fileCount += 1
                isRecording = false
                self.onDiscardRecorderSetUp()
                self.recorder.concatChunks(filename: self.audioFileURL){
                    success in
                    if success{
                        self.chunkInt = 0
                        print("Succes save chunks removed")
                        DispatchQueue.main.async {
                            if self.isCommentsOn {
                                self.pushCommentVC()
                            } else {
                                AudioFiles.shared.saveNewAudioFile(name: self.audioFileURL)
                                let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
                                self.setPushTransitionAnimation(VC)
                                self.navigationController?.popViewController(animated: false)
                                self.tabBarController?.selectedIndex = 0
                            }
                        }
                    }
                }
//                NotificationCenter.default.post(name: Notification.Name("refreshRecorder"), object: nil)
            }
        })
    }
    // MARK: - @IBAction Edit.
    @IBAction func onTapEdit(_ sender: UIButton) {
        setUpUIForEditing()
    }
    // MARK: - @IBAction Discard.
    @IBAction func onTapDiscard(_ sender: UIButton) {
        CommonFunctions.showAlert(view: self, title: "PTS Dictate", message: "Do you want to discard the current Recording?", completion: {
            (success) in
            if success{
                self.lblPlayerStatus.text = ""
                isRecording = false
                for asset in self.recorder.articleChunks {
                    try? FileManager.default.removeItem(at: asset.url)
                }
                self.recorder.articleChunks.removeAll()
//                self.removeDiscardAudio(itemName: "P", fileExtension: "m4a")
                self.onDiscardRecorderSetUp()
                self.viewBottomButton.isHidden = true
                self.tabBarController?.setTabBarHidden(false, animated: true)
            }
        })
        print("Discard")
    }
    
    // MARK: - @IBAction Clear.
    @IBAction func onTapClear(_ sender: UIButton) {
        if sender.tag == 2{
            self.recorder.startInsertRecording(sampleRateKey: Float(sampleRateKey), fileName: "ra")
        }else if sender.tag == 4 {
            if sender.imageView?.image == UIImage(named: "btn_start_point_normal") {
                print("Start Point")
                self.btnClear.setImage(UIImage(named: "btn_end_point_normal"), for: .normal)
            }else if sender.imageView?.image == UIImage(named: "btn_end_point_normal") {
                print("End Point")
                self.btnClear.setImage(UIImage(named: "btn_start_deleting_normal"), for: .normal)
            }else if sender.imageView?.image == UIImage(named: "btn_start_deleting_normal") {
                print("Delete")
                self.recorder.deleteAudio(startTime: 2, endTime: 5){
                    (success) in
                    if success{
                        print("Delete Success")
                        self.stackView.isHidden = true
                        self.stackViewHeight.constant = 0
                        self.segmentControl.isHidden = true
                        self.segmentHeight.constant = 0
                        self.btnStop.isUserInteractionEnabled = false
                        self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: UIControl.State.normal)
                        CommonFunctions.alertMessage(view: self, title: Constants.appName, msg: Constants.pDeleteMsg, btnTitle: "OK")
                        DispatchQueue.main.async {
                            CommonFunctions.showHideViewWithAnimation(view:  self.viewBottomButton, hidden: false, animation: .transitionFlipFromBottom)
                            self.tabBarController?.setTabBarHidden(true, animated: false)
                        }
                    }
                }
            }
        }else {
            if sender.imageView?.image == UIImage(named: "btn_start_point_normal") {
                print("Start Point")
            }else{
                print("Clear")
            }
        }
    }
    
    // MARK: - Discard Recorder setUp.
    @objc func onDiscardRecorderSetUp(){
//        self.recordTimer.invalidate()
        stopwatch.stop()
        self.recorderState = .none
//        self.currentRecordUpdateTimer.invalidate()
        self.customRangeBar.isHidden = false
        self.customRangeBarHeight.constant = 45
        self.parentStackTop.constant = 35
        self.lblTime.text = "00:00:00"
        self.lblFSizeValue.text = "0.00 Mb"
        self.btnRecord.isUserInteractionEnabled = true
        self.btnPlay.isUserInteractionEnabled = false
        self.btnBackwardTrim.isUserInteractionEnabled = false
        self.btnBackwardTrimEnd.isUserInteractionEnabled = false
        self.btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: .normal)
        self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_diable"), for: .normal)
        self.btnBackwardTrim.setBackgroundImage(UIImage(named: "existing_rewind_disable"), for: .normal)
        self.btnBackwardTrimEnd.setBackgroundImage(UIImage(named: "existing_backward_fast_disable"), for: .normal)
        self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
        audioRangeMeterSetUp()
        segmentControl.isHidden = true
        stackView.isHidden = true
        stackViewHeight.constant = 0
        viewPlayerTiming.isHidden = true
        insertTimer.isHidden = true
        segmentHeight.constant = 0
        viewProgress.isHidden = true
        progressViewHeight.constant = 45
        self.playerWaveView.isHidden = true
    }
    // MARK: - Editing UI setup.
    func setUpUIForEditing() {
        segmentControl.selectedSegmentIndex = -1
        segmentHeight.constant = 31
        segmentControl.isHidden = false
        btnStop.isUserInteractionEnabled = true
        btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
        CommonFunctions.showHideViewWithAnimation(view:  self.viewBottomButton, hidden: true, animation: .transitionFlipFromBottom)
        self.tabBarController?.setTabBarHidden(false, animated: false)
    }
    // MARK: - Remove Discard Audio.
     func removeDiscardAudio(itemName: String, fileExtension: String) {
         let fileManager = FileManager.default
          let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
          let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
          let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
          guard let dirPath = paths.first else {
              return
          }
          let filePath = "\(dirPath)/\(itemName).\(fileExtension)"
          do {
            try fileManager.removeItem(atPath: filePath)
              print("Discard success")
          } catch let error as NSError {
              print("Error block")
            print(error.debugDescription)
          }
    }
    
    // MARK: - Upadte Timer method.
   @objc func updateAudioMeter() {
       if let recorder = self.recorder.audioRecorder {
            if recorder.isRecording{
//                let hr = Int((recorder.currentTime / 60) / 60)
//                let min = Int(recorder.currentTime / 60)
//                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
//                let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
//                self.lblTime.text = totalTimeString
                self.lblFSizeValue.text = String(format: "%.2f", Float(try! Data(contentsOf: recorder.url).count) / 1024.0 / 1024.0) + " Mb"
                recorder.updateMeters()
             }
        }
    }
    // MARK: - updateRecording.
    @objc func updateRecording(timer: Timer) {
        if let recorder = self.recorder.audioRecorder , recorder.isRecording == true {
            recorder.updateMeters()
            let decibels = Float(recorder.peakPower(forChannel: 0))
            let value = [3.5, 3.4, 3.3, 3.2, 3.1, 3.0]
            self.customRangeBar.value = decibels * Float(value[0])
        }
    }
    // MARK: - finishAudioRecording.
    func finishAudioRecording(success: Bool) {
        if let recorder = self.recorder.audioRecorder {
            if success {
                recorder.stop()
//                audioRecorder = nil
//                recordTimer.invalidate()
//                currentRecordUpdateTimer.invalidate()
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
    func getDocumentsDirectory() -> URL{
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let  documentsDirectory = paths[0]
        return documentsDirectory
    }
    private func createURLForNewRecord() -> URL {
        let appGroupFolderUrl = self.getDocumentsDirectory()
//        let fileNamePrefix = DateFormatter.sharedDateFormatter.string(from: Date())
//        let fullFileName = "pixel01_" + fileNamePrefix + ".m4a"
//        self.audioFileName = fullFileName
        let fullFileName = (self.lblFNameValue.text ?? "")
        let newRecordFileName = appGroupFolderUrl.appendingPathComponent(fullFileName)
        return newRecordFileName
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 60 * 60) / 60)
        let hours = Int(timeInterval / 3600)
        return String(format: "%.2d:%.2d:%.2d", hours, minutes, seconds)
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
        if player == self.recorder.queuePlayer{
            if flag{
                print("Playing Completed")
                btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            }
        }
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

// Extension for merge audio file
extension RecordVC {
    
    func mergeAudioFiles(audioFileUrls: [URL]) -> String? {
            let composition = AVMutableComposition()
               
            for i in 0 ..< audioFileUrls.count {
                let compositionAudioTrack :AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
                let filePath = "\(self.getDocumentsDirectory())" + self.getFileName(audioFileUrls[i].path)
                
                let asset = AVURLAsset(url: URL(string: filePath)!)
                            
                let trackContainer = asset.tracks(withMediaType: AVMediaType.audio)
                
                guard trackContainer.count > 0 else{
                    return nil
                }
                
                let audioTrack = trackContainer[0]
                let timeRange = CMTimeRange(start: CMTimeMake(value: 0, timescale: 600), duration: audioTrack.timeRange.duration)
                try! compositionAudioTrack.insertTimeRange(timeRange, of: audioTrack, at: composition.duration)
            }
            
            let finalUrl = URL(string: "\(getDocumentsDirectory())\(UUID().uuidString)_audio.m4a")
            
            let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
            assetExport?.outputFileType = AVFileType.m4a
            assetExport?.outputURL = finalUrl
            assetExport?.exportAsynchronously(completionHandler:{
                    switch assetExport!.status
                    {
                    case AVAssetExportSession.Status.failed:
                        print("AUDIO_MERGE -> failed \(String(describing: assetExport!.error!))")
                    case AVAssetExportSession.Status.cancelled:
                        print("AUDIO_MERGE -> cancelled \(String(describing: assetExport!.error))")
                    case AVAssetExportSession.Status.unknown:
                        print("AUDIO_MERGE -> unknown\(String(describing: assetExport!.error))")
                    case AVAssetExportSession.Status.waiting:
                        print("AUDIO_MERGE -> waiting\(String(describing: assetExport!.error))")
                    case AVAssetExportSession.Status.exporting:
                        print("AUDIO_MERGE -> exporting\(String(describing: assetExport!.error) )")
                    default:
                        print("Audio Concatenation Complete")
                        print("Old audio :: \(self.getFileName(audioFileUrls[0].path))")
                        print("New audio :: \(self.getFileName(finalUrl!.path))")
                        print("Merged    :: \(self.getFileName(finalUrl!.path))")
                       }
            })
            
            return finalUrl!.path
    }
    func getFileName(_ fileUrl : String) -> String{
            return URL(string: fileUrl)!.lastPathComponent
    }
}
