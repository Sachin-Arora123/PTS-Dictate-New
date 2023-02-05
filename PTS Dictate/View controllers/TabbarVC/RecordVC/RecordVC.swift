//
//  RecordVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 04/09/22.
//

import UIKit
import CoreData
import AVFoundation
import SCWaveformView

var isRecording: Bool = false
var audioRecorder:AVAudioRecorder?
//var audioPlayer:AVAudioPlayer?
//var player: AVAudioPlayer?
var tempChunks : [AVURLAsset] = []
var tempAudioFileURL: String = ""
var audioFileName: String = ""

enum RecorderState: Int {
    case none = 0
    case recording
    case pause
}

enum PerformingFunction: Int {
    case append
    case insert
    case overwrite
    case partialDelete
}

class RecordVC: BaseViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var customRangeBar: F3BarGauge!
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
    @IBOutlet weak var playerWaveView: SCScrollableWaveformView!
    @IBOutlet weak var bookmarkWaveTimeView: UIView!
    @IBOutlet weak var bookMarkView: UIView!
    @IBOutlet weak var btnLeftBookmark: UIButton!
    @IBOutlet weak var btnRightBookmark: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var viewClear: UIView!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var insertTimer: UILabel!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var segmentHeight: NSLayoutConstraint!
    @IBOutlet weak var customRangeBarHeight: NSLayoutConstraint!
    @IBOutlet weak var parentStackTop: NSLayoutConstraint!
    @IBOutlet weak var viewPlayerTiming: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - Variables.
    var sampleRateKey = 0
    var recorder: HPRecorder!
    var recorderState: RecorderState = .none
    var performingFunctionState: PerformingFunction = .append
    var audioFileURL: String = ""
    var chunkInt = 0
    let fileManager = FileManager.default
    var recordTimer:Timer!
    
    var articleChunks    = [AVURLAsset]()
    var settings         = [String : Any]()
    var currentRecordUpdateTimer: Timer!
    var fileURL1:URL!
    
    var insertStartingPoint = 0.0
    var overwritingStartingPoint = 0.0
    var overwritingEndPoint = 0.0
    var overwriteTimer : Timer?
    var pdStartingPoint = 0.0
    var pdEndPoint      = 0.0
    var isPerformingOverwrite = false
    var isPerformingInsert    = false
    var overwritingStartingTimerPoint = 0.0
    var insertStartingTimerPoint      = 0.0
    
//    var isPlayerInitialized = false
    var playFirstTime           = false
    var editAssetDuration       = 0.0
    var bookmarkTimingsArray    = [Int]()
    var totalBookmarkButtons    = [UIButton]()
    var totalBookmarkTimeLabels = [UILabel]()
    var initialHandleLabel      = UILabel()
    var bookmarkWidth           = 0.0
    
    private var isCommentsOn:Bool {
        return CoreData.shared.commentScreen == 1 ?  true : false
    }
    private var isCommentsMandotary:Bool {
        return CoreData.shared.commentScreenMandatory == 1 ?  true : false
    }
    
    private lazy var stopwatch = Stopwatch(timeUpdated: { [weak self] timeVal in
        guard let strongSelf = self else { return }
        if strongSelf.isPerformingOverwrite{
            strongSelf.overwritingStartingTimerPoint += 1
            strongSelf.insertTimer.text = strongSelf.timeString(from: strongSelf.overwritingStartingTimerPoint)
        }else if strongSelf.isPerformingInsert{
            strongSelf.insertStartingTimerPoint += 1
            strongSelf.insertTimer.text = strongSelf.timeString(from: strongSelf.insertStartingTimerPoint)
        }else{
            print("time ===== \(strongSelf.timeString(from: timeVal))")
            strongSelf.lblTime.text = strongSelf.timeString(from: timeVal + strongSelf.editAssetDuration)
        }
        strongSelf.updateAudioMeter()
    })
    
    var audioForEditing: String? {
        // getting the value from exiting view controller's variable
        get {
            return (self.tabBarController!.viewControllers![0] as! ExistingVC).audioForEditing ?? nil
        }
        // assign the new value to this view controller's variable
        set {
            (self.tabBarController!.viewControllers![0] as! ExistingVC).audioForEditing = newValue
        }
    }
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showBottomView), name: Notification.Name("showBottomBtnView"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate(notification:)), name: UIApplication.willTerminateNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleInterupption), name: Notification.Name("handleInterupption"), object: nil)
    }
    
    @objc func handleInterupption(){
        //stop the recording
        self.recorder.endRecording()
        self.recorderState = .pause
        stopwatch.pause()
        
        self.tabBarController?.setTabBarHidden(true, animated: false)
        btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
        btnRecord.isUserInteractionEnabled = false
        btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
        btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_disable"), for: .normal)
        btnPlay.isUserInteractionEnabled = true
        btnStop.isUserInteractionEnabled = false
        CommonFunctions.showHideViewWithAnimation(view:  self.viewBottomButton, hidden: false, animation: .transitionFlipFromBottom)
        lblPlayerStatus.text = "Stopped"
        self.setUpStopAndPauseUI()
        
        CommonFunctions.alertMessage(view: self, title: Constants.appName, msg: "Due to a phone call, the recording has been auto saved. Please go back to Existing Dictations screen, and choose Edit/Append to continue recording.", btnTitle: "Ok") {
            self.recorder.concatChunks(filename: self.audioFileURL){
                success in
                if success{
                    self.chunkInt = 0
                    print("Success save chunks removed")
                    DispatchQueue.main.async {
                        self.proceedAutoSave()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //setup microphone senstivity tracking view
        audioRangeMeterSetUp()
        
        //hide navigation bar left button.
        hideLeftButton()
        
        //set navigation bar title
        setTitleWithImage("Record", andImage: UIImage(named: "title_record_normal.png") ?? UIImage())
        
        //Setup some other UI components
        setUpUI()
        
        //Setup control button's initial state.
        self.initiallyBtnStateSetup()
        
        //Hide bottom view(included save,edit,descard)
        self.viewBottomButton.isHidden = true
        
        //setup file name and fileurl before recording
        self.setupFileName()

        //setup audio recorder
        setupRecorder()
        
        //If comes for editing the audio from existing dictations screen, setup the UI according to that.
        if let _ = self.audioForEditing { // if value is nil then its not for editing, if that's hold any string value then setup the ui for editing that audio
            
            //assigning editing asset to the article chunks array fot future refrence.
            let editingAsset = AVURLAsset(url: Constants.documentDir.appendingPathComponent(self.audioForEditing ?? ""))
            self.recorder.articleChunks = [editingAsset]
            self.editAssetDuration = editingAsset.duration.seconds
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                self.playerWaveView.waveformView.progressTime = CMTimeMakeWithSeconds(editingAsset.duration.seconds, preferredTimescale: 0)
//            })
            
            setUpUIForEditing()
        }
        
        isRecording = false
        insertTimer.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.isPlayerInitialized = false
        self.playFirstTime = false
        self.tabBarController?.setTabBarHidden(false, animated: false)
        self.audioForEditing = nil
        self.editAssetDuration = 0.0
        
        self.removeInsertStartingPoint()
        self.removeOverwritePoints()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("showBottomBtnView"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("handleInterupption"), object: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View life cycle end.
    // MARK: - ==== Setup components starts here ====
    func audioRangeMeterSetUp() {
        self.customRangeBar.backgroundColor = .white
        print(self.customRangeBar.frame)
        self.customRangeBar.numBars = 20
        self.customRangeBar.minLimit = -100
        self.customRangeBar.maxLimit = -10
        self.customRangeBar.normalBarColor = hexStringToUIColor(hex: "F74118")
        self.customRangeBar.warningBarColor = UIColor(red: 105.0/255.0, green: 105.0/255.0, blue: 105.0/255.0, alpha: 1.0)
        self.customRangeBar.dangerBarColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.customRangeBar.outerBorderColor = .gray
        self.customRangeBar.innerBorderColor = .black
        self.customRangeBar.alpha = 1.0
        self.customRangeBar.value = -160
    }
    
    //UI setup while the view appears mainly
    func setUpUI(){
        //top segment
        segmentControl.isHidden = true
        segmentHeight.constant = 0
        
        //microphone sensitivity range bar
        customRangeBar.isHidden = false
        customRangeBarHeight.constant = 45
        self.parentStackTop.constant = 35
        
        //player timing view
        viewPlayerTiming.isHidden = true
        
        //wave view
        self.playerWaveView.isHidden = true
        
        //record button
        self.btnRecord.isUserInteractionEnabled = true
        self.btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: .normal)
        
        //stop button
        self.btnStop.isUserInteractionEnabled = false
        self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
        
        //timings
        self.lblTime.text = "00:00:00"
        
        //play button
        self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_diable"), for: .normal)
        
//        if CoreData.shared.indexing == 1{
//            //show indexing view as well
//            //indexing controls stack view
//            stackView.isHidden = false
//            stackViewHeight.constant = 150
//            self.btnBookmark.isUserInteractionEnabled = false
//            self.btnLeftBookmark.isUserInteractionEnabled = false
//            self.btnRightBookmark.isUserInteractionEnabled = false
////            self.btnClear.isUserInteractionEnabled = false
//
//            addIntialHandle()
//        }else{
            //hide it
            stackView.isHidden = true
            stackViewHeight.constant = 0
//        }
      
    }
    
    //need for indexing functionality
//    func addIntialHandle(){
//        let width = -2.0
//        let yVal = bookmarkWaveTimeView.frame.origin.y + 7.5
//        if width != 0{
//            self.initialHandleLabel = UILabel(frame: CGRect(x: width, y: yVal, width: 1.5, height: 27))
//            self.initialHandleLabel.backgroundColor = .red
//            self.bookmarkWaveTimeView.addSubview(self.initialHandleLabel)
//        }
//    }
    
    func initiallyBtnStateSetup(){
        btnStop.isUserInteractionEnabled = false
        btnPlay.isUserInteractionEnabled = false
        btnForwardTrim.isUserInteractionEnabled = false
        btnForwardTrimEnd.isUserInteractionEnabled = false
        btnBackwardTrim.isUserInteractionEnabled = false
        btnBackwardTrimEnd.isUserInteractionEnabled = false
        lblPlayerStatus.text = ""
    }
    
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

        //need to check recording file count here as well(each day the file count should starts from 001)
        var count = 1
        if let lastUploadedDate = UserDefaults.standard.value(forKey: "FileUploadedDate") as? Date{
            if Calendar.current.isDate(lastUploadedDate, inSameDayAs: Date()){
                //no need to change the file count to 1
                count = CoreData.shared.fileCount
            }
        }
        
        if self.audioForEditing != nil{
            //editing
            var fileName = self.audioForEditing ?? ""
            if let dotRange = fileName.range(of: ".") {
                fileName.removeSubrange(dotRange.lowerBound..<fileName.endIndex)
            }
            self.audioFileURL       = fileName
            self.lblFNameValue.text = fileName + ".m4a"
            audioFileName           = fileName + ".m4a"
        }else{
            self.audioFileURL       = nameToShow + "_" + convertedDateStr + "_File_" + String(format: "%03d", count)
            self.lblFNameValue.text = nameToShow + "_" + convertedDateStr + "_File_" + String(format: "%03d", count) + ".m4a"
            audioFileName           = nameToShow + "_" + convertedDateStr + "_File_" + String(format: "%03d", count) + ".m4a"
        }
        self.lblFSizeValue.text = "0.00 Mb"
        
        //setup file url as well.
        self.fileURL1 = Constants.documentDir.appendingPathComponent((self.lblFNameValue.text ?? "") + ".m4a")
    }
    
    func setupRecorder(){
        let index = CoreData.shared.audioQuality
        var sampleRateKey = 0

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
        
        let recorderSetting = [
            //giving the AVSampleRateKey according to the microphone senstivity value in settings.
            AVSampleRateKey : sampleRateKey,
            AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
            AVNumberOfChannelsKey : NSNumber(value: 1),
            AVEncoderAudioQualityKey : NSNumber(value: AVAudioQuality.medium.rawValue)
        ] as [String : Any]
        
        self.recorder = HPRecorder(settings: recorderSetting, audioFilename: self.fileURL1, audioInput: AudioInput().defaultAudioInput())
        
        self.recorder.askPermission { (granted) in
            DispatchQueue.main.async {
                if !granted {
                    print("granted")
                }
            }
        }
    }
    
    // MARK: - Handle app terminate notification
//    @objc func applicationWillTerminate(notification: Notification) {
//        print("Notification received.")
//        AudioFiles.shared.saveNewAudioFile(name: audioFileName, autoSaved: true) // mohit new changes
//        if self.recorder.audioRecorder != nil {
//            self.recorder.endRecording()
//            CoreData.shared.fileCount += 1
//            CoreData.shared.dataSave()
//        }
//
//        self.recorderState = .none
//        tempAudioFileURL = self.audioFileURL
//        stopwatch.stop()
//        print("temp",tempAudioFileURL)
//
//        for asset in self.recorder.articleChunks {
//            try! FileManager.default.removeItem(at: asset.url)
//        }
//    }
        
    // MARK: - Setup audio waves for the recorded audio
    func setUpWave() {
        self.playerWaveView.isHidden = false

        self.playerWaveView.waveformView.asset = self.getFullAsset()
        self.playerWaveView.waveformView.progressTime = CMTimeMakeWithSeconds(self.playerWaveView.waveformView.asset.duration.seconds, preferredTimescale: 0)
        self.playerWaveView.waveformView.normalColor = .lightGray
        self.playerWaveView.waveformView.progressColor = .blue
        
        // Set the precision, 1 being the maximum
        self.playerWaveView.waveformView.precision = 0.1 // We are going to render one line per four pixels
        
        // Set the lineWidth so we have some space between the lines
        self.playerWaveView.waveformView.lineWidthRatio = 0.5

        // Show stereo if available
        self.playerWaveView.waveformView.channelStartIndex = 0
        self.playerWaveView.waveformView.channelEndIndex = 1

        // Show only right channel
        self.playerWaveView.waveformView.channelStartIndex = 1
        self.playerWaveView.waveformView.channelEndIndex = 1

        // Add some padding between the channels
        self.playerWaveView.waveformView.channelsPadding = 10
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
        CommonFunctions.showHideViewWithAnimation(view:  self.viewBottomButton, hidden: false, animation: .transitionFlipFromBottom)
        lblPlayerStatus.text = "Stopped"
    }
        
    
    // MARK: - @IBActions.
    @IBAction func onTapRecord(_ sender: UIButton) {
        
        checkMicrophoneAccess(completionHandler: { value in
            if value{
                switch self.recorderState {
                case .none:
                    let fileName = self.audioForEditing != nil ? "\(self.chunkInt)" : self.audioFileURL
                    self.recorder.startRecording(fileName: fileName)
                    self.recorderState = .recording
                    self.stopwatch.start()

                    self.lblPlayerStatus.text = "Recording"
                    self.btnRecord.setBackgroundImage(UIImage(named: "record_pause_btn_normal"), for: .normal)
                    self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
                    self.btnStop.isUserInteractionEnabled = true
                    
                case .recording:
                    self.recorder.pauseRecording()
//                    self.recorder.initilaizePlayer()
//                    self.isPlayerInitialized = true
                    self.recorderState = .pause
                    self.stopwatch.pause()
                        
                    self.lblPlayerStatus.text = "Paused"
                    self.btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: .normal)
                    self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
                    self.btnPlay.isUserInteractionEnabled = true
                    
                    var fileName = (self.audioForEditing != nil ? self.audioForEditing : self.audioFileURL) ?? ""
                    //need to remove .m4a in case of editing
                    if let dotRange = fileName.range(of: ".") {
                        fileName.removeSubrange(dotRange.lowerBound..<fileName.endIndex)
                    }
                    
                    self.recorder.concatChunks(filename: fileName){
                        success in
                        if success{
                            DispatchQueue.main.async {
                                self.setUpStopAndPauseUI()
                            }
                        }
                    }
                    
                    self.btnStop.isUserInteractionEnabled = true
                    
                case .pause:
                    self.stopwatch.start()
                    self.setUpUI()
                    self.initiallyBtnStateSetup()
                    self.customRangeBar.isHidden = false
                    self.customRangeBarHeight.constant = 45
                    self.parentStackTop.constant = 35
                    self.lblPlayerStatus.text = "Recording"
                    self.recorder.startRecording(fileName: "\(self.chunkInt)")
                    self.chunkInt += 1
                    self.recorderState = .recording
                    self.btnRecord.setBackgroundImage(UIImage(named: "record_pause_btn_normal"), for: .normal)
                    self.btnStop.isUserInteractionEnabled = true
                    self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
                }
                
                isRecording = true
                self.lblPlayerStatus.stopBlink()
                self.lblPlayerStatus.startBlink()
//                if CoreData.shared.indexing == 1{
//                    self.enableDisableBookmarkButton()
//                }
            }else{
                CommonFunctions.alertMessage(view: self, title: "Microphone Access Denied", msg: "This app requires access to your device's Microphone. \n Please enable Microphone access for this app in Settings / Privacy / Microphone", btnTitle: "Ok", completion: nil)
            }
        })
    }
    
    @IBAction func onTapStop(_ sender: UIButton) {
        self.recorder.pauseRecording()
        self.recorderState = .pause
        stopwatch.pause()
        
        self.tabBarController?.setTabBarHidden(true, animated: false)
        btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
        btnRecord.isUserInteractionEnabled = false
        btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
        btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_disable"), for: .normal)
        btnPlay.isUserInteractionEnabled = true
        btnStop.isUserInteractionEnabled = false
        CommonFunctions.showHideViewWithAnimation(view:  self.viewBottomButton, hidden: false, animation: .transitionFlipFromBottom)
        
        if (self.audioForEditing != nil) && lblPlayerStatus.text == ""{
            //user is here for editing and press stop button without doing anything.
            print("Here we are.")
            //remove start,end points if there any.
            self.removePartialDeletePoints()
            self.removeOverwritePoints()
            self.removeInsertStartingPoint()
            
            //hide segement from top.
            segmentControl.isHidden = true
            segmentHeight.constant = 0
            
            stackView.isHidden = true
            self.stackViewHeight.constant = 0
            
            return
        }
        
        if lblPlayerStatus.text == "Inserting"{
            self.isPerformingInsert    = false
            self.insertTimer.isHidden  = true
            CommonFunctions.alertMessage(view: self, title: Constants.appName, msg: "Insert complete", btnTitle: "Ok", completion: nil)
        }
        lblPlayerStatus.text = "Stopped"
        self.setUpStopAndPauseUI()
        
        
        if self.performingFunctionState == .append{
            self.recorder.concatChunks(filename: self.audioFileURL){
                success in
                if success{
                    self.chunkInt = 0
                    print("Success save chunks removed")
                }
            }
        }else if (self.performingFunctionState == .insert || self.performingFunctionState == .overwrite){
            //need to perform insert or overwrite here.
            let startTime = (self.performingFunctionState == .insert) ? CMTimeMakeWithSeconds(Float64(self.insertStartingPoint), preferredTimescale: 1) : CMTimeMakeWithSeconds(Float64(self.overwritingStartingPoint), preferredTimescale: 1)
            if let originalUrl = self.recorder.articleChunks.first?.url, let replacingUrl = self.recorder.articleChunks.last?.url{
                self.mergeAudioFiles(originalURL: originalUrl, replacingURL: replacingUrl, startTime: startTime, taskToPerform: self.performingFunctionState == .insert ? "Insert" : "Overwrite")
            }
        }
        
    }
    
    func setUpStopAndPauseUI(){
        self.customRangeBar.isHidden = true
        self.customRangeBarHeight.constant = 0
    
        viewPlayerTiming.isHidden = false
        
        parentStackTop.constant = 100
        currentPlayingTime.text = self.lblTime.text
        playerTotalTime.text = self.lblTime.text
        
        setUpWave()
        
//        if CoreData.shared.indexing == 1{
//            self.enableDisableBookmarkButton()
//        }
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
            //play the recording
//            if !self.isPlayerInitialized{
//                //need initialization of player
//                self.recorder.startPlayer()
//                self.isPlayerInitialized = true
//            }else{
//                //already initialized
//                self.recorder.queuePlayerPlaying = true
//                self.recorder.queuePlayer?.play()
//            }
            
            
            if !self.playFirstTime{
                //need initialization of player
                self.recorder.startPlayer()
                self.playFirstTime = true
            }else{
                //already initialized
                self.recorder.queuePlayerPlaying = true
                self.recorder.queuePlayer?.play()
            }
            
            btnPlay.setBackgroundImage(UIImage(named: "existing_controls_pause_btn_normal"), for: .normal)
            btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_disable"), for: .normal)
            btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
            btnRecord.isUserInteractionEnabled = false
            btnStop.isUserInteractionEnabled = false
            
            self.enableDisableForwardBackwardButtons(enable: true)
            
            enableBookmarkButton(enable: true)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.recorder.playerItem)
            
            let timeScale = CMTimeScale(NSEC_PER_SEC)
            let time = CMTime(seconds: 0.25, preferredTimescale: timeScale)
            //observing the player after every 0.25 seconds.
            self.recorder.queuePlayer?.addPeriodicTimeObserver(forInterval: time, queue: .main, using: { time in
                if self.recorder.queuePlayer?.currentItem?.status == .readyToPlay {
                    let currentTime = CMTimeGetSeconds(self.recorder.queuePlayer?.currentTime() ?? CMTime.zero)
                    print("currentTime == \(currentTime)")
                    self.currentPlayingTime.text = self.timeString(from: currentTime)
                    self.playerWaveView.waveformView.progressTime = self.recorder.queuePlayer?.currentTime() ?? CMTime.zero
                }
            })
            
        }else{
            //pause the recording
            self.recorder.stopPlayer()
            self.onStopPlayerSetupUI()
            self.enableDisableForwardBackwardButtons(enable: true)
            
            enableBookmarkButton(enable: false)
        }
    }
    
    func enableDisableForwardBackwardButtons(enable:Bool){
        self.btnBackwardTrim.isUserInteractionEnabled    = enable
        self.btnBackwardTrimEnd.isUserInteractionEnabled = enable
        self.btnForwardTrim.isUserInteractionEnabled     = enable
        self.btnForwardTrimEnd.isUserInteractionEnabled  = enable
        
        let imageBtnBackward     = enable ? UIImage(named: "existing_rewind_normal") : UIImage(named: "existing_rewind_disable")
        let imageBtnFastBackward = enable ? UIImage(named: "existing_backward_fast_normal") : UIImage(named: "existing_backward_fast_disable")
        let imageBtnForward      = enable ? UIImage(named: "existing_forward_normal") : UIImage(named: "existing_forward_disable")
        let imageBtnFastForward  = enable ? UIImage(named: "existing_forward_fast_normal") : UIImage(named: "existing_forward_fast_disable")
        
        self.btnBackwardTrim.setBackgroundImage(imageBtnBackward, for: .normal)
        self.btnBackwardTrimEnd.setBackgroundImage(imageBtnFastBackward, for: .normal)
        self.btnForwardTrim.setBackgroundImage(imageBtnForward, for: .normal)
        self.btnForwardTrimEnd.setBackgroundImage(imageBtnFastForward, for: .normal)
    }
    
    func enableBookmarkButton(enable:Bool){
        if CoreData.shared.indexing == 1{
            self.btnBookmark.isUserInteractionEnabled = enable
            let image = enable ? UIImage(named: "record_bookmark_btn_normal") : UIImage(named: "record_bookmark_btn_disable")
            self.btnBookmark.setImage(image, for: .normal)
        }
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
//        self.recorder.initilaizePlayer()
        self.onStopPlayerSetupUI()
//        self.isPlayerInitialized = false
        
        self.playFirstTime = false
        
        self.recorder.queuePlayerPlaying = false
        
        self.enableDisableForwardBackwardButtons(enable: false)
        enableBookmarkButton(enable: false)
    }
    
    // MARK: - @IBAction Forward.
    @IBAction func onTapForwardTrim(_ sender: UIButton) {
//        print(self.recorder.audioRecorder.currentTime)
        self.recorder.seekForward(timeInterval: 1)
    }
    
    // MARK: - @IBAction Fast Forward.
    @IBAction func onTapForwardTrimEnd(_ sender: UIButton) {
        self.recorder.seekForward(timeInterval: 3)
    }
    
    // MARK: - @IBAction Backward Trim.
    @IBAction func onTapBackwardTrim(_ sender: UIButton) {
        self.recorder.seekBackwards(timeInterval: 1)
    }
    
    // MARK: - @IBAction Fast Backward Trim.
    @IBAction func onTapBackwardTrimEnd(_ sender: UIButton) {
        self.recorder.seekBackwards(timeInterval: 3)
    }
    
//    func fastForwardByTime(timeVal: Double) {
//        audioPlayer = try? AVAudioPlayer(contentsOf: self.recorder.audioRecorder.url)
//        audioPlayer?.delegate = self
//        var time: TimeInterval = audioPlayer?.currentTime ?? 0.0
//        time += timeVal
//        if time > audioPlayer!.duration {
//            if let player = audioPlayer {
//                if player.isPlaying {
//                    player.stop()
//                }
//            }
//        } else {
//            audioPlayer?.currentTime = time
//            let min = Int(audioPlayer!.currentTime / 60)
//            let sec = Int(audioPlayer!.currentTime.truncatingRemainder(dividingBy: 60))
//            let totalTimeString = String(format: "%02d:%02d", min, sec)
//            self.lblTime.text = totalTimeString
//            audioPlayer?.updateMeters()
//        }
//    }
    
//    func fastBackwardByTime(timeVal: Double) {
//        audioPlayer = try? AVAudioPlayer(contentsOf:   self.recorder.audioRecorder.url)
//        var time: TimeInterval = audioPlayer?.currentTime ?? 0.0
//        time -= timeVal
//        if time < 0 {
//            audioPlayer?.stop()
//        } else {
//            audioPlayer?.currentTime = time
//            let min = Int(audioPlayer!.currentTime / 60)
//            let sec = Int(audioPlayer!.currentTime.truncatingRemainder(dividingBy: 60))
//            let totalTimeString = String(format: "%02d:%02d", min, sec)
//            self.lblTime.text = totalTimeString
//            audioPlayer?.updateMeters()
//        }
//    }
    
    // MARK: - @IBAction Segment Control.
    @IBAction func segmentChanged(_ sender: Any) {
        checkMicrophoneAccess { value in
            if value{
                switch self.segmentControl.selectedSegmentIndex {
                case 0:
                    self.performingFunctionState = .append
                    self.btnClear.tag = 1
                    self.viewClear.isHidden = true
                    self.recorderState = .pause
                    self.btnRecord.isUserInteractionEnabled = true
                    self.btnStop.isUserInteractionEnabled = true
                    self.btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: .normal)
                    self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
                    
                    if CoreData.shared.disableEditingHelp == 0{
                        CommonFunctions.alertMessage(view: self, title: "Append", msg: Constants.appendMsg, btnTitle: "OK", completion: nil)
                    }
                    break
                case 1:
                    self.performingFunctionState = .insert
                    self.btnClear.tag = 2
                    self.recorderState = .pause
                    self.setInsert_PartialDeleteUI()
                    if CoreData.shared.disableEditingHelp == 0{
                        CommonFunctions.alertMessage(view: self, title: "Insert", msg: Constants.insertMsg, btnTitle: "OK", completion: nil)
                    }
                    self.recorder.startPlayer()
                    self.observePlayerAfterEdit()
                    break
                case 2:
                    self.performingFunctionState = .overwrite
                    self.btnClear.tag = 3
                    self.recorderState = .pause
                    self.setInsert_PartialDeleteUI()
                    if CoreData.shared.disableEditingHelp == 0{
                        CommonFunctions.alertMessage(view: self, title: "Overwrite", msg: Constants.overwriteMsg, btnTitle: "OK", completion: nil)
                    }
                    self.recorder.startPlayer()
                    self.observePlayerAfterEdit()
                    break
                case 3:
                    self.performingFunctionState = .partialDelete
                    self.btnClear.tag = 4
                    if CoreData.shared.disableEditingHelp == 0{
                        CommonFunctions.alertMessage(view: self, title: "Partial Delete", msg: Constants.partialDeleteMsg, btnTitle: "OK", completion: nil)
                    }
                    self.setInsert_PartialDeleteUI()
                    self.recorder.startPlayer()
                    self.observePlayerAfterEdit()
                    break
                default:
                    break
                }
            }else{
                CommonFunctions.alertMessage(view: self, title: "Microphone Access Denied", msg: "This app requires access to your device's Microphone. \n Please enable Microphone access for this app in Settings / Privacy / Microphone", btnTitle: "Ok", completion: nil)
            }
        }
    }
    
    func observePlayerAfterEdit(){
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.25, preferredTimescale: timeScale)
        self.recorder.queuePlayer?.addPeriodicTimeObserver(forInterval: time, queue: .main, using: { time in
            if self.recorder.queuePlayer?.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(self.recorder.queuePlayer?.currentTime() ?? CMTime.zero)
                self.currentPlayingTime.text = self.timeString(from: currentTime)
                self.playerWaveView.waveformView.progressTime = self.recorder.queuePlayer?.currentTime() ?? CMTime.zero
            }
        })
    }

    func setInsert_PartialDeleteUI() {
        self.stackView.isHidden = false
        self.stackViewHeight.constant = 50
        self.viewClear.isHidden    = false
        self.bookMarkView.isHidden = true
        self.bookmarkWaveTimeView.isHidden = true
        self.btnClear.setImage(UIImage(named: "btn_start_point_normal"), for: .normal)
        self.btnClear.setBackgroundImage(UIImage(named: ""), for: .normal)
        
        self.btnStop.isUserInteractionEnabled = false
        self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
        self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_pause_btn_normal"), for: .normal)
    }

    func pushCommentVC(){
        let VC = CommentsVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        self.setPushTransitionAnimation(VC)
        VC.hidesBottomBarWhenPushed = true
        VC.isCommentsMandotary = isCommentsMandotary
        VC.fileName = self.audioFileURL + ".m4a"  // mohit changes
        self.navigationController?.pushViewController(VC, animated: false)
    }
    
    // MARK: - @IBAction Save.
    @IBAction func onTapSave(_ sender: UIButton) {
        CommonFunctions.showAlert(view: self, title: Constants.appName, message: "Do you want to save the current Recording ?", completion: {
            (success) in
            if success{
                // Stop Recorder & Change State
                if self.recorder.audioRecorder != nil {
                    self.recorder.endRecording()
                }
                self.lblTime.text = "00:00:00"
                self.recorderState = .none
                
                //not in case of edit
                if self.audioForEditing == nil{
                    CoreData.shared.fileCount += 1
                }
                
                CoreData.shared.dataSave()
                
                isRecording = false
                audioFileName = ""
                self.onDiscardRecorderSetUp()
                
                self.resetValues()
                
                DispatchQueue.main.async {
                    if self.isCommentsOn {
                        self.pushCommentVC()
                    } else {
                        AudioFiles.shared.saveNewAudioFile(name: self.audioFileURL + ".m4a")  // mohit new changes
                        let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
                        self.setPushTransitionAnimation(VC)
                        self.navigationController?.popViewController(animated: false)
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            }
        })
    }
    
    func proceedAutoSave(){
        if self.recorder.audioRecorder != nil {
            self.recorder.endRecording()
        }
        self.lblTime.text = "00:00:00"
        self.recorderState = .none
        
        //not in case of edit
        if self.audioForEditing == nil{
            CoreData.shared.fileCount += 1
        }
        
        CoreData.shared.dataSave()
        
        isRecording = false
        audioFileName = ""
        self.onDiscardRecorderSetUp()
        
        self.resetValues()
        
        AudioFiles.shared.saveNewAudioFile(name: self.audioFileURL + ".m4a", autoSaved: true)
        let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
        self.setPushTransitionAnimation(VC)
        self.navigationController?.popViewController(animated: false)
        self.tabBarController?.selectedIndex = 0
    }
    
    func resetValues(){
        self.insertStartingPoint      = 0.0
        self.overwritingStartingPoint = 0.0
        self.overwritingEndPoint      = 0.0
        self.pdStartingPoint          = 0.0
        self.pdEndPoint               = 0.0
        self.overwritingStartingTimerPoint = 0.0
        self.insertStartingTimerPoint = 0.0
        
        self.performingFunctionState = .append
        self.editAssetDuration = 0.0
        self.bookmarkWidth = 0.0
    }
    
    // MARK: - @IBAction Edit.
    @IBAction func onTapEdit(_ sender: UIButton) {
        if let _ = self.audioForEditing {
            setUpUIForEditing()
        }else{
            CommonFunctions.alertMessage(view: self, title: Constants.appName, msg: "Please save the file before doing an edit", btnTitle: "Ok", completion: nil)
        }
    }
    
    // MARK: - @IBAction Discard.
    @IBAction func onTapDiscard(_ sender: UIButton) {
        CommonFunctions.showAlert(view: self, title: Constants.appName, message: "Do you want to discard the current Recording?", completion: {
            (success) in
            if success{
                //in case of edit, not delete the dictation and simply go back to existing dictation screen.
                if let _ = self.audioForEditing {
                    let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
                    self.setPushTransitionAnimation(VC)
                    self.navigationController?.popViewController(animated: false)
                    self.tabBarController?.selectedIndex = 0
                }else{
                    self.lblPlayerStatus.text = ""
                    isRecording               = false
                    audioFileName             = ""
                    for asset in self.recorder.articleChunks {
                        try? FileManager.default.removeItem(at: asset.url)
                    }
                    self.recorder.articleChunks.removeAll()
                    self.onDiscardRecorderSetUp()
                    self.viewBottomButton.isHidden = true
                    self.updateTimer()
                    self.resetValues()
    //                if CoreData.shared.indexing == 1{
    //                    self.removeAllBookmarks()
    //                    self.initialHandleLabel.isHidden = false
    //                }
                    self.tabBarController?.setTabBarHidden(false, animated: true)
                }
            }
        })
    }
    
    // MARK: - @IBAction Clear.
    @IBAction func onTapClear(_ sender: UIButton) {
        switch sender.tag {
        case 2:
            //insert
            onTapEditPerformInsertFunction(sender)
        case 3:
            //Overwrite
            onTapEditPerformOverwriteFunction(sender)
        case 4:
            //Partial delete
            onTapEditPerformPartialDeleteFunction(sender)
        default:
            print("delete bookmark functionality.")
        }
    }
    
    func onTapEditPerformInsertFunction(_ sender: UIButton){
        //check if start point is the end of the file
        if self.checkIfStartPointIsAtEnd(){
            CommonFunctions.alertMessage(view: self, title: Constants.appName, msg: "Start Point should not be end of the file.", btnTitle: "Ok", completion: nil)
            return
        }
        
        if sender.imageView?.image == UIImage(named: "btn_start_point_normal") {
            self.insertStartingPoint = CMTimeGetSeconds(self.recorder.queuePlayer?.currentTime() ?? .zero)
            
            //need to add a label on insertStartingPoint to show the user the starting point.
            self.showInsertStartingPoint(timeVal: self.playerWaveView.waveformView.progressTime.seconds)
            
            self.recorder.stopPlayer()
            self.btnClear.setImage(UIImage(named: "btn_start_inserting_normal"), for: .normal)
        }else if sender.imageView?.image == UIImage(named: "btn_start_inserting_normal") {
            removeInsertStartingPoint()
            self.insertTimer.isHidden = false
            self.insertTimer.text     = self.timeString(from: self.insertStartingPoint)
            self.isPerformingInsert   = true
            self.insertStartingTimerPoint = self.insertStartingPoint
            self.proceedForInsert()
        }
    }
    
    func checkIfStartPointIsAtEnd() -> Bool{
        let currentTime = Int(self.playerWaveView.waveformView.progressTime.seconds)
        let editAsset   = AVAsset(url: Constants.documentDir.appendingPathComponent(self.audioForEditing ?? ""))
        if currentTime == Int(editAsset.duration.seconds){
            return true
        }
        return false
    }
    
    func removeInsertStartingPoint(){
        let insertStartPointButton       = self.view.viewWithTag(1001) as? UIButton
        let insertStartPointTimerLabel   = self.view.viewWithTag(1002) as? UILabel
        insertStartPointButton?.removeFromSuperview()
        insertStartPointTimerLabel?.removeFromSuperview()
    }
    
    func removeOverwritePoints(){
        let overwriteStartPointButton       = self.view.viewWithTag(2001) as? UIButton
        let overwriteStartPointTimerLabel   = self.view.viewWithTag(2002) as? UILabel
        let overwriteEndPointButton         = self.view.viewWithTag(3001) as? UIButton
        let overwriteEndPointTimerLabel     = self.view.viewWithTag(3002) as? UILabel
        overwriteStartPointButton?.removeFromSuperview()
        overwriteStartPointTimerLabel?.removeFromSuperview()
        overwriteEndPointButton?.removeFromSuperview()
        overwriteEndPointTimerLabel?.removeFromSuperview()
    }
    
    func removePartialDeletePoints(){
        let pdStartPointButton       = self.view.viewWithTag(4001) as? UIButton
        let pdStartPointTimerLabel   = self.view.viewWithTag(4002) as? UILabel
        let pdEndPointButton         = self.view.viewWithTag(5001) as? UIButton
        let pdEndPointTimerLabel     = self.view.viewWithTag(5002) as? UILabel
        pdStartPointButton?.removeFromSuperview()
        pdStartPointTimerLabel?.removeFromSuperview()
        pdEndPointButton?.removeFromSuperview()
        pdEndPointTimerLabel?.removeFromSuperview()
    }
    
    func proceedForInsert(){
        stopwatch.start()
        self.setUpUI()
        self.initiallyBtnStateSetup()
        
        self.customRangeBarHeight.constant = 45
        self.parentStackTop.constant = 35
        lblPlayerStatus.text = "Inserting"
        lblPlayerStatus.stopBlink()
        lblPlayerStatus.startBlink()
        let asset = AVAsset(url: Constants.documentDir.appendingPathComponent(self.audioForEditing ?? ""))
        self.lblTime.text = self.timeString(from: asset.duration.seconds)
        self.recorder.startRecording(fileName: "file_to_insert")
        self.chunkInt += 1
        self.recorderState = .recording
        
        self.btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_disable"), for: .normal)
        self.btnRecord.isUserInteractionEnabled = true
        
        self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
        self.btnStop.isUserInteractionEnabled = true
    }
    
    func onTapEditPerformOverwriteFunction(_ sender: UIButton){
        if sender.imageView?.image == UIImage(named: "btn_start_point_normal") {
            if self.checkIfStartPointIsAtEnd(){
                CommonFunctions.alertMessage(view: self, title: Constants.appName, msg: "Start Point should not be end of the file.", btnTitle: "Ok", completion: nil)
                return
            }
            
            self.showOverwritePoint(startingPoint: true)
            overwritingStartingPoint = CMTimeGetSeconds(self.recorder.queuePlayer?.currentTime() ?? .zero)
            self.btnClear.setImage(UIImage(named: "btn_end_point_normal"), for: .normal)
        }else if sender.imageView?.image == UIImage(named: "btn_end_point_normal") {
            overwritingEndPoint = CMTimeGetSeconds(self.recorder.queuePlayer?.currentTime() ?? .zero)
            //need to check if endpoint is equal to start point.
            if Int(self.overwritingStartingPoint) == Int(self.overwritingEndPoint){
                CommonFunctions.alertMessage(view: self, title: Constants.appName, msg: "End Point should be greater than Start Point", btnTitle: "Ok", completion: nil)
                return
            }
            self.showOverwritePoint(startingPoint: false)
            self.btnClear.setImage(UIImage(named: "btn_start_overwriting_normal"), for: .normal)
            self.recorder.stopPlayer()
            self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            self.btnStop.isUserInteractionEnabled = true
            self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
        }else {
            //Here we need to start recording from the start point to the end point and stop the recorder as soon as users records till end point.
            self.insertTimer.isHidden = false
            self.insertTimer.text = self.timeString(from: self.overwritingStartingPoint)
            self.isPerformingOverwrite = true
            self.overwritingStartingTimerPoint = self.overwritingStartingPoint
            self.proceedForOverwrite()
            self.removeOverwritePoints()
        }
    }
    
    func proceedForOverwrite(){
        stopwatch.start()
        self.setUpUI()
        self.initiallyBtnStateSetup()
        self.customRangeBar.isHidden = false
        self.customRangeBarHeight.constant = 45
        self.parentStackTop.constant = 35
        lblPlayerStatus.text = "Overwriting"
        let asset = AVAsset(url: Constants.documentDir.appendingPathComponent(self.audioForEditing ?? ""))
        self.lblTime.text = self.timeString(from: asset.duration.seconds)
        lblPlayerStatus.stopBlink()
        lblPlayerStatus.startBlink()
        self.recorder.startRecording(fileName: "\(chunkInt)")
        self.chunkInt += 1
        self.recorderState = .recording
        
        //need to start a timer which will observe and stop recording when user reach at the end point.
        let time = overwritingEndPoint - overwritingStartingPoint
        
        self.overwriteTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: true) { timer in
            self.recorder.pauseRecording()
            self.recorderState = .pause
            self.stopwatch.pause()
           
            self.tabBarController?.setTabBarHidden(true, animated: false)
            self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: .normal)
            self.btnRecord.isUserInteractionEnabled = false
            self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            self.btnBackwardTrim.setBackgroundImage(UIImage(named: "existing_rewind_normal"), for: .normal)
            self.btnBackwardTrimEnd.setBackgroundImage(UIImage(named: "existing_backward_fast_normal"), for: .normal)
            self.btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_disable"), for: .normal)
            self.btnPlay.isUserInteractionEnabled = true
            self.btnBackwardTrim.isUserInteractionEnabled = true
            self.btnBackwardTrimEnd.isUserInteractionEnabled = true
            self.btnStop.isUserInteractionEnabled = false
            CommonFunctions.showHideViewWithAnimation(view:  self.viewBottomButton, hidden: false, animation: .transitionFlipFromBottom)
            self.lblPlayerStatus.text = "Stopped"
            self.setUpStopAndPauseUI()
            
            self.overwriteTimer?.invalidate()
            
            CommonFunctions.alertMessage(view: self, title: Constants.appName, msg: "Overwrite complete", btnTitle: "Ok", completion: nil)
            self.insertTimer.isHidden  = true
            self.isPerformingOverwrite = false
            if let originalUrl = self.recorder.articleChunks.first?.url, let replacingUrl = self.recorder.articleChunks.last?.url{
                self.mergeAudioFiles(originalURL: originalUrl, replacingURL: replacingUrl, startTime: CMTimeMakeWithSeconds(Float64(self.overwritingStartingPoint), preferredTimescale: 1), taskToPerform: "Overwrite")
            }
        }
    }
    
    func onTapEditPerformPartialDeleteFunction(_ sender: UIButton){
        if sender.imageView?.image == UIImage(named: "btn_start_point_normal") {
            if self.checkIfStartPointIsAtEnd(){
                CommonFunctions.alertMessage(view: self, title: Constants.appName, msg: "Start Point should not be end of the file.", btnTitle: "Ok", completion: nil)
                return
            }
            self.showPartialPoint(startingPoint: true)
            self.pdStartingPoint = CMTimeGetSeconds(self.recorder.queuePlayer?.currentTime() ?? CMTime.zero)
            self.btnClear.setImage(UIImage(named: "btn_end_point_normal"), for: .normal)
        }else if sender.imageView?.image == UIImage(named: "btn_end_point_normal") {
            self.pdEndPoint = CMTimeGetSeconds(self.recorder.queuePlayer?.currentTime() ?? CMTime.zero)
            if Int(self.pdStartingPoint) == Int(self.pdEndPoint){
                CommonFunctions.alertMessage(view: self, title: Constants.appName, msg: "End Point should be greater than Start Point", btnTitle: "Ok", completion: nil)
                return
            }
            
            self.showPartialPoint(startingPoint: false)
            self.btnClear.setImage(UIImage(named: "btn_start_deleting_normal"), for: .normal)
            self.recorder.stopPlayer()
        }else if sender.imageView?.image == UIImage(named: "btn_start_deleting_normal") {
            self.removePartialDeletePoints()
            self.partialDeleteAudio(outputUrl: Constants.documentDir.appendingPathComponent("final.m4a"), startTime: Double(self.pdStartingPoint), endTime: Double(self.pdEndPoint)) { result in
                print(result)
            }
        }
    }
    
    func partialDeleteAudio(outputUrl: URL,startTime: Double,endTime: Double, completion: @escaping(_ result: Bool) -> Void){
        // create empty mutable composition
        let composition: AVMutableComposition = AVMutableComposition()
        
        // copy all of original asset into the mutable composition, effectively creating an editable copy
        for asset in self.recorder.articleChunks.reversed() {
            do{
                try composition.insertTimeRange( CMTimeRangeMake( start: .zero, duration: asset.duration), of: asset, at: .zero)
            }catch{
                print("Error")
            }
        }

        // now edit as required, e.g. delete a time range
        let startTime = CMTime(seconds: startTime, preferredTimescale: 100)
        let endTime   = CMTime(seconds: endTime, preferredTimescale: 100)
        composition.removeTimeRange(CMTimeRangeFromTimeToTime(start: startTime, end: endTime))
        
        //export that composition
        composition.export(to: outputUrl) { status in
            if status{
                self.removeFileChunksInDocDirectory()
                DispatchQueue.main.async {
                    self.stackView.isHidden = true
                    self.stackViewHeight.constant = 0
                    self.segmentControl.isHidden = true
                    self.segmentHeight.constant = 0
                    self.btnStop.isUserInteractionEnabled = false
                    self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_active"), for: UIControl.State.normal)
                    CommonFunctions.alertMessage(view: self, title: Constants.appName, msg: Constants.pDeleteMsg, btnTitle: "OK", completion: nil)
                    self.setUpWave()
                    CommonFunctions.showHideViewWithAnimation(view:  self.viewBottomButton, hidden: false, animation: .transitionFlipFromBottom)
                    self.tabBarController?.setTabBarHidden(true, animated: false)
                }
            }
        }
    }
    
    func getFullAsset() -> AVAsset?{
        // create empty mutable composition
        let composition: AVMutableComposition = AVMutableComposition()
        
        // copy all of original asset into the mutable composition, effectively creating an editable copy
        for asset in self.recorder.articleChunks.reversed() {
            do{
                try composition.insertTimeRange( CMTimeRangeMake( start: .zero, duration: asset.duration), of: asset, at: .zero)
            }catch{
                print("Error")
            }
        }
        
        if let session = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A){
            print(session.asset.duration.seconds)
            return session.asset
        }
        
        return nil
    }
    
    func updateTimer(){
        DispatchQueue.main.async {
            if self.recorder.articleChunks.count > 0{
                self.lblTime.text            = self.timeString(from: self.recorder.articleChunks[0].duration.seconds)
            }else{
                self.lblTime.text            = "00:00:00"
            }
            
            self.currentPlayingTime.text = self.lblTime.text
            self.playerTotalTime.text    = self.lblTime.text
        }
    }
    
    // MARK: - Bookmark view actions.
    /*
    @IBAction func addBookmarkAction(_ sender: Any) {
        //need to get current timing and add that into an array.
        if self.recorderState == .recording{
            //recording
            let currentTime = self.recorder.audioRecorder.currentTime
            print("currentTime ==== \(currentTime)")
            addBookmark(time: Int(currentTime))
        }else{
            //playing
            let currentTime = CMTimeGetSeconds(self.recorder.queuePlayer?.currentTime() ?? .zero)
            addBookmark(time: Int(currentTime))
        }
    }

    func addBookmark(time:Int){
        if self.bookmarkTimingsArray.contains(time){
            //show banner
            DispatchQueue.main.async {
                CommonFunctions.toster("PTS Dictate", titleDesc: "Already indexed", true, false)
            }
        }else{
            self.bookmarkTimingsArray.append(time)
            self.showBookmark(timeVal: time)
        }
    }

    func showBookmark(timeVal:Int){
        var width = Double(self.progressView.frame.width) * Double(timeVal) / 50
        width += 15.0
        let yVal = bookmarkWaveTimeView.frame.origin.y + 7.5
        let height = bookmarkWaveTimeView.frame.size.height - 20

        if width > self.progressView.frame.width{
            self.btnBookmark.isUserInteractionEnabled = false
            self.btnBookmark.setImage(UIImage(named: "record_bookmark_btn_disable"), for: .normal)
            return
        }

        if width != 0{
            let bookmarkButton = UIButton(frame: CGRect(x: width - 2, y: yVal, width: 1.5, height: height))
            bookmarkButton.backgroundColor = .black
            bookmarkButton.tag = timeVal
            bookmarkButton.isSelected = false
            self.bookmarkWaveTimeView.addSubview(bookmarkButton)
            self.totalBookmarkButtons.append(bookmarkButton)

            let yVal = (self.progressView.frame.origin.y + self.progressView.frame.size.height + 6)
            let xVal = width - 3
            let timeLbl = UILabel(frame: CGRect(x: CGFloat(xVal), y: yVal, width: 12, height: 15))
            timeLbl.text = "\(timeVal)"
            timeLbl.font = UIFont.boldSystemFont(ofSize: 7)
            timeLbl.textColor = .gray
            self.bookmarkWaveTimeView.addSubview(timeLbl)
            self.totalBookmarkTimeLabels.append(timeLbl)
        }
    }

    func removeAllBookmarks(){
        //remove labels from superviews
        self.totalBookmarkButtons.forEach { (button) in
            button.removeFromSuperview()
        }
        //remove labels from array
        self.totalBookmarkButtons.removeAll()

        //remove labels from superviews
        self.totalBookmarkTimeLabels.forEach { (label) in
            label.removeFromSuperview()
        }
        //remove labels from array
        self.totalBookmarkTimeLabels.removeAll()

        //remove bookmarkTimingsArray
        self.bookmarkTimingsArray.removeAll()

        //disable right bookmark button.
        self.btnRightBookmark.isUserInteractionEnabled = false
        self.btnRightBookmark.setImage(UIImage(named: "record_bookmark_forward_btn_disable"), for: .normal)
    }

    @IBAction func forwardBookmarkAction(_ sender: Any) {
        //need to sort the bookmarkTimingsArray and totalBookmarkButtons first.
        sortBookmarkArrays()

        //need to change the timing, player duration, waves progress, bookmark button selection
        if bookmarkTimingsArray.count > 0{
            //need to check which bookmark button is already selected. If no one is selected, choose the first one.
            let selectedBookmarksArray = self.totalBookmarkButtons.filter({$0.isSelected})
            if selectedBookmarksArray.count > 0{
                if let selectedBookmark = selectedBookmarksArray.first{
                    if let index = self.totalBookmarkButtons.firstIndex(of: selectedBookmark){
                        if index == self.totalBookmarkButtons.count - 1{
                            //last one, can't go ahaed.
                            //make the forward trim disable.
                            self.btnRightBookmark.isUserInteractionEnabled = false
                            self.btnRightBookmark.setImage(UIImage(named: "record_bookmark_forward_btn_disable"), for: .normal)
                        }else{
                            //go ahead
                            let targetTime = CMTime(seconds: Double(bookmarkTimingsArray[index + 1]), preferredTimescale: 1)
                            self.seekPlayerTime(time: targetTime)

                            let targetButton = self.totalBookmarkButtons[index + 1]

                            self.totalBookmarkButtons.forEach { (button) in
                                button.isSelected = false
                                button.backgroundColor = .black
                            }

                            targetButton.isSelected = true
                            targetButton.backgroundColor = .red
                        }
                    }
                }
            }else{
                let targetTime = CMTime(seconds: Double(bookmarkTimingsArray[0]), preferredTimescale: 1)
                self.seekPlayerTime(time: targetTime)

                self.totalBookmarkButtons[0].isSelected = true
                self.totalBookmarkButtons[0].backgroundColor = .red
            }

            self.initialHandleLabel.isHidden = true
            self.btnLeftBookmark.isUserInteractionEnabled = true
            self.btnLeftBookmark.setImage(UIImage(named: "record_bookmark_backward_btn_normal"), for: .normal)
//            self.isPlayerInitialized = true
        }
    }

    func sortBookmarkArrays(){
        bookmarkTimingsArray.sort()
        totalBookmarkButtons.sort{
            return $0.tag < $1.tag
        }
    }

    
    @IBAction func backwardBookmarkAction(_ sender: Any) {
        if bookmarkTimingsArray.count > 0{
            //need to check which bookmark button is already selected. If no one is selected, choose the first one.
            let selectedBookmarksArray = self.totalBookmarkButtons.filter({$0.isSelected})
            if selectedBookmarksArray.count > 0{
                if let selectedBookmark = selectedBookmarksArray.first{
                    if let index = self.totalBookmarkButtons.firstIndex(of: selectedBookmark){
                        //need to check if it is the first bookmark
                        if index == 0{
                            //first one
                            //1. make the backword trim disable.
                            self.btnLeftBookmark.isUserInteractionEnabled = false
                            self.btnLeftBookmark.setImage(UIImage(named: "record_bookmark_backward_btn_disable"), for: .normal)

                            //2. show the initial handle
                            self.initialHandleLabel.isHidden = false

                            //3. disable clear button.


                            let targetTime = CMTime(seconds: Double(0.0), preferredTimescale: 1)
                            self.seekPlayerTime(time: targetTime)
                            self.totalBookmarkButtons.forEach { (button) in
                                button.isSelected = false
                                button.backgroundColor = .black
                            }
                        }else{
                            let targetTime = CMTime(seconds: Double(bookmarkTimingsArray[index - 1]), preferredTimescale: 1)
                            self.seekPlayerTime(time: targetTime)

                            let targetButton = self.totalBookmarkButtons[index - 1]

                            self.totalBookmarkButtons.forEach { (button) in
                                button.isSelected = false
                                button.backgroundColor = .black
                            }

                            targetButton.isSelected = true
                            targetButton.backgroundColor = .red
                        }
                    }

                    //enable forward bookmark button.
                    self.btnRightBookmark.isUserInteractionEnabled = true
                    self.btnRightBookmark.setImage(UIImage(named: "record_bookmark_forward_btn_normal"), for: .normal)
                }
            }
//            self.isPlayerInitialized = true
        }
    }
     
     func enableDisableBookmarkButton(){
         if self.recorderState == .pause{
             //disable bookmark buttons, enable right bookmark button, show initial bookmark label if it is hide.
             self.btnBookmark.isUserInteractionEnabled = false
             self.btnBookmark.setImage(UIImage(named: "record_bookmark_btn_disable"), for: .normal)

             self.btnRightBookmark.isUserInteractionEnabled = true
             self.btnRightBookmark.setImage(UIImage(named: "record_bookmark_forward_btn_normal"), for: .normal)

             //show initial bookmark label

         }else{
             //enable bookmark button, disable right buttons,
             self.btnBookmark.isUserInteractionEnabled = true
             self.btnBookmark.setImage(UIImage(named: "record_bookmark_btn_normal"), for: .normal)

             self.btnRightBookmark.isUserInteractionEnabled = false
             self.btnRightBookmark.setImage(UIImage(named: "record_bookmark_forward_btn_disable"), for: .normal)
         }
     }
    */
     
    func showInsertStartingPoint(timeVal:Double){
        let editAsset = AVAsset(url: Constants.documentDir.appendingPathComponent(self.audioForEditing ?? ""))
        let xVal = (Double(self.playerWaveView.frame.width) * timeVal / editAsset.duration.seconds) + 15
        let yVal = playerWaveView.frame.origin.y
        let height = playerWaveView.frame.size.height
        
        if xVal != 0{
            let bookmarkButton = UIButton(frame: CGRect(x: xVal - 2, y: yVal, width: 2, height: height))
            bookmarkButton.backgroundColor = .black
            bookmarkButton.tag = 1001
            self.view.addSubview(bookmarkButton)

            let yVal = (self.playerWaveView.frame.origin.y + self.playerWaveView.frame.size.height)
            let xVal = xVal - 5
            let timeLbl = UILabel(frame: CGRect(x: CGFloat(xVal), y: yVal, width: 30, height: 12))
            timeLbl.tag = 1002
            timeLbl.text = "\(Int(timeVal)) s"
            timeLbl.font = UIFont.boldSystemFont(ofSize: 10)
            timeLbl.textColor = .black
            self.view.addSubview(timeLbl)
        }
    }
    
    func showOverwritePoint(startingPoint:Bool){
        let editAsset = AVAsset(url: Constants.documentDir.appendingPathComponent(self.audioForEditing ?? ""))
        let xVal = (Double(self.playerWaveView.frame.width) * self.playerWaveView.waveformView.progressTime.seconds / editAsset.duration.seconds) + 15
        let yVal = playerWaveView.frame.origin.y
        let height = playerWaveView.frame.size.height
        
        if xVal != 0{
            let bookmarkButton = UIButton(frame: CGRect(x: xVal - 2, y: yVal, width: 2, height: height))
            bookmarkButton.backgroundColor = .black
            bookmarkButton.tag = startingPoint ? 2001 : 3001
            self.view.addSubview(bookmarkButton)

            let yVal = (self.playerWaveView.frame.origin.y + self.playerWaveView.frame.size.height)
            let xVal = xVal - 5
            let timeLbl = UILabel(frame: CGRect(x: CGFloat(xVal), y: yVal, width: 30, height: 12))
            timeLbl.tag = startingPoint ? 2002 : 3002
            timeLbl.text = "\(Int(self.playerWaveView.waveformView.progressTime.seconds)) s"
            timeLbl.font = UIFont.boldSystemFont(ofSize: 10)
            timeLbl.textColor = .black
            self.view.addSubview(timeLbl)
        }
    }
    
    func showPartialPoint(startingPoint:Bool){
        let editAsset = AVAsset(url: Constants.documentDir.appendingPathComponent(self.audioForEditing ?? ""))
        let xVal = (Double(self.playerWaveView.frame.width) * self.playerWaveView.waveformView.progressTime.seconds / editAsset.duration.seconds) + 15
        let yVal = playerWaveView.frame.origin.y
        let height = playerWaveView.frame.size.height
        
        if xVal != 0{
            let bookmarkButton = UIButton(frame: CGRect(x: xVal - 2, y: yVal, width: 2, height: height))
            bookmarkButton.backgroundColor = .black
            bookmarkButton.tag = startingPoint ? 4001 : 5001
            self.view.addSubview(bookmarkButton)

            let yVal = (self.playerWaveView.frame.origin.y + self.playerWaveView.frame.size.height)
            let xVal = xVal - 5
            let timeLbl = UILabel(frame: CGRect(x: CGFloat(xVal), y: yVal, width: 30, height: 12))
            timeLbl.tag = startingPoint ? 4002 : 5002
            timeLbl.text = "\(Int(self.playerWaveView.waveformView.progressTime.seconds)) s"
            timeLbl.font = UIFont.boldSystemFont(ofSize: 10)
            timeLbl.textColor = .black
            self.view.addSubview(timeLbl)
        }
    }
    
    func seekPlayerTime(time:CMTime){
        self.recorder.queuePlayer?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { result in
            if result{
                //update waves.
                let currentTime = self.recorder.queuePlayer?.currentTime().seconds ?? 0.0
                self.playerWaveView.waveformView.progressTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 1)
                
                //update timings.
                self.currentPlayingTime.text = self.timeString(from: currentTime)
            }
        })
    }
    
    // MARK: - Discard Recorder setUp.
    @objc func onDiscardRecorderSetUp(){
        stopwatch.stop()
        self.recorderState = .none
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
        viewPlayerTiming.isHidden = true
        insertTimer.isHidden = true
        segmentHeight.constant = 0
        self.playerWaveView.isHidden = true
    }
    
    // MARK: - Editing UI setup.
    func setUpUIForEditing() {
        //show segment control
        segmentControl.isHidden = false
        segmentControl.selectedSegmentIndex = -1
        segmentHeight.constant = 31
        
        //show timing view
        self.viewPlayerTiming.isHidden = false
        
        //show wave view and setup according to the editing asset
        self.setUpWave()
        
        //hide range bar
        self.customRangeBar.isHidden = true
        
        // stop button
        btnStop.isUserInteractionEnabled = true
        btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
        
        //record button
        btnRecord.isUserInteractionEnabled = false
        btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_disable"), for: .normal)
        
        CommonFunctions.showHideViewWithAnimation(view:  self.viewBottomButton, hidden: true, animation: .transitionFlipFromBottom)
        self.tabBarController?.setTabBarHidden(false, animated: false)
        
        //timings
        let asset = AVAsset(url: Constants.documentDir.appendingPathComponent(self.audioForEditing ?? ""))
        self.lblTime.text            = self.timeString(from: asset.duration.seconds)
        self.currentPlayingTime.text = self.lblTime.text
        self.playerTotalTime.text    = self.lblTime.text
        
        //play button
        self.btnPlay.isUserInteractionEnabled = true
        self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
    }
 
    // MARK: - Upadte Timer method.
    @objc func updateAudioMeter() {
       if let recorder = self.recorder.audioRecorder {
            if recorder.isRecording{
                self.lblFSizeValue.text = String(format: "%.2f", Float(try! Data(contentsOf: recorder.url).count) / 1024.0 / 1024.0) + " Mb"
                recorder.updateMeters()
                
                let decibels = Float(recorder.peakPower(forChannel: 0))
//                let value = [3.5, 3.4, 3.3, 3.2, 3.1, 3.0]
                self.customRangeBar.value = decibels * 3.5
             }
        }
    }
    
    // MARK: - finishAudioRecording.
    func finishAudioRecording(success: Bool) {
        if let recorder = self.recorder.audioRecorder {
            if success {
                recorder.stop()
//                recordTimer.invalidate()
//                currentRecordUpdateTimer.invalidate()
                print("recorded successfully.")
            }else {
                print("Recording Failed")
            }
        }
    }
    
    // Microphone Access
    func checkMicrophoneAccess(completionHandler handler: @escaping (Bool) -> Void) {
        // Check Microphone Authorization
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print(#function, " Microphone Permission Granted")
            handler(true)
            break
            
        case .denied, .undetermined:
            handler(false)
            return
        @unknown default:
            print("ERROR! Unknown Default. Check!")
        }
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
           self.finishAudioRecording(success: true)
       }
    }
    
    // Completion of playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == self.recorder.queuePlayer{
            if flag{
                btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            }
        }
    }
}

extension RecordVC{
    func mergeAudioFiles(originalURL: URL, replacingURL:URL, startTime:CMTime, taskToPerform:String) {
            
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey:true]
        let originalAsset  = AVURLAsset(url: originalURL, options: options)
        let replacingAsset = AVURLAsset(url: replacingURL, options: options)
        
        if let replacingTrack = replacingAsset.tracks.first{
            let duration = replacingTrack.timeRange.duration.scaled
            let replacingRange = CMTimeRange(start: startTime, duration: duration)
            
            self.trimOriginalAssetFor(taskToPerform: taskToPerform, asset: originalAsset, replacingRange: replacingRange, replacingURL: replacingURL) { (finalURLs) in
                self.exportFinalOutput(from: finalURLs, completionHandler: { (isCompleted) in
                    if isCompleted {
                        print("Merge Successful")
                        //if merge successful, then remove all chunks except final.m4a from the doc directory and change its name as well.
                        self.removeFileChunksInDocDirectory()
                        
                        DispatchQueue.main.async {
                            self.setUpWave()
                        }
                    } else {
                        print("Merge Failed")
                    }
                })
            }
        }
    }
    
    func removeFileChunksInDocDirectory(){
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: Constants.documentDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs{
                //Do not remove the files which are already saved.
                
                if fileURL.standardizedFileURL.absoluteString.contains(CoreData.shared.profileName){
                    //that is some old saved file which we don't need to delete.
                    
                }else{
                    if fileURL.standardizedFileURL.absoluteString != Constants.documentDir.appendingPathComponent("final.m4a").absoluteString{
                        try FileManager.default.removeItem(at: fileURL)
                    }
                }
            }
        } catch  { print(error) }
        
        //change the name of final.m4a
        let sourcePath = Constants.documentDir.appendingPathComponent("final.m4a")
        
        DispatchQueue.main.async {
            var fileName = (self.audioForEditing != nil ? self.audioForEditing : self.audioFileURL) ?? ""
            //need to remove .m4a in case of editing
            if let dotRange = fileName.range(of: ".") {
                fileName.removeSubrange(dotRange.lowerBound..<fileName.endIndex)
            }
            
            let destPath = Constants.documentDir.appendingPathComponent(fileName + ".m4a")
            do{
                _ = try FileManager.default.replaceItemAt(destPath, withItemAt: sourcePath)
                
                //now the destPath has updated result. we can give that value to articleChunks array as well so that it can play the final one.
                let assetToAdd = AVURLAsset(url: destPath)
                self.recorder.articleChunks.removeAll()
                self.recorder.articleChunks.append(assetToAdd)
                
                self.updateTimer()
            }catch  { print(error) }
        }
    }
    
    func trimOriginalAssetFor(taskToPerform:String, asset:AVAsset, replacingRange:CMTimeRange, replacingURL:URL, completionHandler handler: @escaping (_ finalURLs:[URL]) -> Void) {
            
        var finalURLs = [URL]()
        
        let startURL = Constants.documentDir.appendingPathComponent("StartTrim.m4a")
        let endURL = Constants.documentDir.appendingPathComponent("EndTrim.m4a")
        
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

    func exportFinalOutput(from urls:[URL], completionHandler handler: @escaping (Bool) -> Void) {
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey:true]
        let composition = AVMutableComposition(urlAssetInitializationOptions: options)
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        //Export Trimmed Audio Files
        do {
            try compositionAudioTrack?.append(urls: urls)
        } catch {
            print("Error Occured while apending", error.localizedDescription)
        }
        
        let finalAudioURL = Constants.documentDir.appendingPathComponent("final.m4a")
        self.removeFileIfAlreadyExists(at: finalAudioURL)
        composition.export(to: finalAudioURL, completionHandler: handler)
    }
    
    func removeFileIfAlreadyExists(at url:URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch { }
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
        return self.convertScale(60000, method: .roundAwayFromZero)
    }
}
