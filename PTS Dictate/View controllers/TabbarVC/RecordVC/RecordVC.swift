//
//  RecordVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 04/09/22.
//

import UIKit
import CoreData
import AVFoundation
import SoundWave

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

enum PerformingFunction: Int {
    case append
    case insert
    case overwrite
    case partialDelete
}

class RecordVC: BaseViewController {
    
    // MARK: - @IBOutlets
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
    @IBOutlet weak var playerWaveView: AudioVisualizationView!
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
    var performingFunctionState: PerformingFunction = .append
    var audioFileURL: String = ""
    var chunkInt = 0
    let fileManager = FileManager.default
    var recordTimer:Timer!
    var audioFileName: String = ""
    var articleChunks = [AVURLAsset]()
    var settings         = [String : Any]()
    var currentRecordUpdateTimer: Timer!
    var fileURL1:URL!
    var insertStartingPoint = 0
    
    var overwritingStartingPoint = 0
    var overwritingEndPoint = 0
    var overwriteTimer : Timer?
    
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
    
    // MARK: Audio visualization view properties
    private let audioVisualizationViewModel = AudioVisualizationViewModel()
    private var chronometer: Chronometer?
    private var meteringLevels: [Float] = []
    private var currentVisualizationState: AudioVisualizationState = .ready {
        didSet{
            self.audioVisualizationView.audioVisualizationMode = self.currentVisualizationState.audioVisualizationMode
        }
    }
    @IBOutlet private var audioVisualizationView: AudioVisualizationView!

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

        visualizationViewSetup()

        if editFromExiting {
            setUpUIForEditing()
        }
        
        setupRecorder()
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
        
        for asset in self.recorder.articleChunks {
            try! FileManager.default.removeItem(at: asset.url)
        }
        
        self.saveRecordedAudio() { (success) in
            if success{
                print(self.meteringLevels)
                AudioFiles.shared.saveNewAudioFile(name: self.audioFileName, autoSaved: true, meteringLevels: self.meteringLevels)
                print("Bg success saved")
            }
        }
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
//        setUpWave()
    }
    
    func setUpWave() {
//        self.playerWaveView.meteringLevelBarWidth = 1.0
//        self.playerWaveView.meteringLevelBarInterItem = 1.0
//        self.playerWaveView.meteringLevelBarCornerRadius = 0.0
//        self.playerWaveView.meteringLevelBarSingleStick = false
//        self.playerWaveView.gradientStartColor = #colorLiteral(red: 0.6509803922, green: 0.8235294118, blue: 0.9529411765, alpha: 1)
//        self.playerWaveView.gradientEndColor = #colorLiteral(red: 0.2273887992, green: 0.2274999917, blue: 0.9748747945, alpha: 1)
//        self.playerWaveView.add(meteringLevel: 0.6)
//        self.playerWaveView.audioVisualizationMode = .read
//        self.playerWaveView.meteringLevels = self.meteringLevels
        
        self.playerWaveView.meteringLevelBarWidth = 1.0
        self.playerWaveView.meteringLevelBarInterItem = 2.5
        self.playerWaveView.meteringLevelBarCornerRadius = 0.0
        self.playerWaveView.meteringLevelBarSingleStick = false
        self.playerWaveView.gradientStartColor = #colorLiteral(red: 0.6509803922, green: 0.8235294118, blue: 0.9529411765, alpha: 1)
        self.playerWaveView.gradientEndColor = #colorLiteral(red: 0.2273887992, green: 0.2274999917, blue: 0.9748747945, alpha: 1)
        self.playerWaveView.meteringLevels = meteringLevels
        self.playerWaveView.audioVisualizationMode = .read
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
        self.audioFileName = nameToShow + "_" + convertedDateStr + "_File_" + "\(CoreData.shared.fileCount)" + ".m4a"
        self.lblFNameValue.text = nameToShow + "_" + convertedDateStr + "_File_" + "\(CoreData.shared.fileCount)" + ".m4a"
        self.lblFSizeValue.text = "0.00 Mb"
        
        //setup file url as well.
        self.fileURL1 = Constants.documentDir.appendingPathComponent((self.lblFNameValue.text ?? "") + ".m4a")
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
        switch recorderState {
            case .none:
                self.recorder.startRecording(fileName: (self.lblFNameValue.text ?? ""))
                self.recorderState = .recording
                stopwatch.start()
    //            self.recordTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                self.lblPlayerStatus.text = "Recording"
                self.btnRecord.setBackgroundImage(UIImage(named: "record_pause_btn_normal"), for: .normal)
                self.btnStop.setBackgroundImage(UIImage(named: "record_stop_btn_normal"), for: .normal)
                self.btnStop.isUserInteractionEnabled = true
                print("recording")
            
            case .recording:
                self.recorder.pauseRecording()
                stopwatch.pause()
//            self.audioFileURL = self.recorder.audioFilename
                self.recorderState = .pause
                lblPlayerStatus.text = "Paused"
                btnRecord.setBackgroundImage(UIImage(named: "record_record_btn_normal"), for: .normal)
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
                self.recorder.startRecording(fileName: "\(chunkInt)")
                self.chunkInt += 1
                self.recorderState = .recording
                self.btnRecord.setBackgroundImage(UIImage(named: "record_pause_btn_normal"), for: .normal)
                self.btnStop.isUserInteractionEnabled = true
                print("resume")
            }
        isRecording = true
        visualizationViewControlls()
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
        
        if self.performingFunctionState == .append{
            self.recorder.concatChunks(filename: self.audioFileURL){
                success in
                if success{
                    self.chunkInt = 0
                    print("Success save chunks removed")
                }
            }
        }else if (self.performingFunctionState == .insert || self.performingFunctionState == .overwrite){
            //need to perform insert here.
            let startTime = (self.performingFunctionState == .insert) ? CMTimeMakeWithSeconds(Float64(self.insertStartingPoint), preferredTimescale: 1) : CMTimeMakeWithSeconds(Float64(self.overwritingStartingPoint), preferredTimescale: 1)
            if let originalUrl = self.recorder.articleChunks.first?.url, let replacingUrl = self.recorder.articleChunks.last?.url{
                self.mergeAudioFiles(originalURL: originalUrl, replacingURL: replacingUrl, startTime: startTime, folderName: "Demo", caseNumber: "test", taskToPerform: self.performingFunctionState == .insert ? "Insert" : "Overwrite")
            }
        }
        
    }
    
    
    func setUpStopAndPauseUI(){
        self.customRangeBar.isHidden = true
        self.customRangeBarHeight.constant = 0
        progressViewHeight.constant = 0
        viewProgress.isHidden = true
        stackView.isHidden = true
        playerWaveView.isHidden = false
        setUpWave()
        bookMarkView.isHidden = true
        viewClear.isHidden = true
        viewPlayerTiming.isHidden = false
        parentStackTop.constant = 60
        currentPlayingTime.text = self.lblTime.text
        playerTotalTime.text = self.lblTime.text
        visualizationViewControlls()
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
        self.customRangeBar.value = 0.0
    }
    
            
    // MARK: - Slide View - Top To Bottom
    func viewSlideInFromTopToBottom(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromBottom
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
            self.performingFunctionState = .append
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
            self.performingFunctionState = .insert
            self.btnClear.tag = 2
            self.recorderState = .pause
            self.setInsert_PartialDeleteUI()
            CommonFunctions.alertMessage(view: self, title: "Insert", msg: Constants.insertMsg, btnTitle: "OK")
            break
        case 2:
            self.performingFunctionState = .overwrite
            self.btnClear.tag = 3
            self.recorderState = .pause
            self.setInsert_PartialDeleteUI()
            CommonFunctions.alertMessage(view: self, title: "Overwrite", msg: Constants.overwriteMsg, btnTitle: "OK")
            break
        case 3:
            self.performingFunctionState = .partialDelete
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
        VC.meteringLevels = meteringLevels
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
                
                self.performingFunctionState = .append
                
                DispatchQueue.main.async {
                    if self.isCommentsOn {
                        self.pushCommentVC()
                    } else {
                        AudioFiles.shared.saveNewAudioFile(name: self.audioFileName, meteringLevels: self.meteringLevels)
                        let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
                        self.setPushTransitionAnimation(VC)
                        self.navigationController?.popViewController(animated: false)
                        self.tabBarController?.selectedIndex = 0
                    }
                }
                
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
    
    // MARK: - @IBAction Clear button action(multiple functionality).
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
            print("Nothing to do")
        }
    }
    
    func onTapEditPerformInsertFunction(_ sender: UIButton){
        if sender.imageView?.image == UIImage(named: "btn_start_point_normal") {
            insertStartingPoint = 4
            self.btnClear.setImage(UIImage(named: "btn_start_inserting_normal"), for: .normal)
        }else if sender.imageView?.image == UIImage(named: "btn_start_inserting_normal") {
            self.proceedForInsert()
        }
    }
    
    func onTapEditPerformOverwriteFunction(_ sender: UIButton){
        if sender.imageView?.image == UIImage(named: "btn_start_point_normal") {
            overwritingStartingPoint = 4
            self.btnClear.setImage(UIImage(named: "btn_end_point_normal"), for: .normal)
        }else if sender.imageView?.image == UIImage(named: "btn_end_point_normal") {
            overwritingEndPoint = 8
            self.btnClear.setImage(UIImage(named: "btn_start_overwriting_normal"), for: .normal)
        }else {
            print("Overwriting === start recording new audio")
            //Here we need to start recording from the start point to the end point and stop the recorder as soon as users records till end point.
            self.proceedForOverwrite()
        }
    }
    
    func onTapEditPerformPartialDeleteFunction(_ sender: UIButton){
        if sender.imageView?.image == UIImage(named: "btn_start_point_normal") {
            print("Got Start Point")
            self.btnClear.setImage(UIImage(named: "btn_end_point_normal"), for: .normal)
        }else if sender.imageView?.image == UIImage(named: "btn_end_point_normal") {
            print("Got End Point")
            self.btnClear.setImage(UIImage(named: "btn_start_deleting_normal"), for: .normal)
        }else if sender.imageView?.image == UIImage(named: "btn_start_deleting_normal") {
            print("Delete proceed")
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
    }
    
    func proceedForInsert(){
        stopwatch.start()
        self.setUpUI()
        self.initiallyBtnStateSetup()
        self.customRangeBar.isHidden = false
        self.customRangeBarHeight.constant = 45
        self.parentStackTop.constant = 35
        lblPlayerStatus.text = "Recording"
        self.recorder.startRecording(fileName: "file_to_insert")
        self.chunkInt += 1
        self.recorderState = .recording
        self.btnRecord.setBackgroundImage(UIImage(named: "record_pause_btn_normal"), for: .normal)
        self.btnStop.isUserInteractionEnabled = true
    }
    
    func proceedForOverwrite(){
        stopwatch.start()
        self.setUpUI()
        self.initiallyBtnStateSetup()
        self.customRangeBar.isHidden = false
        self.customRangeBarHeight.constant = 45
        self.parentStackTop.constant = 35
        lblPlayerStatus.text = "Recording"
        self.recorder.startRecording(fileName: "\(chunkInt)")
        self.chunkInt += 1
        self.recorderState = .recording
//        self.btnRecord.setBackgroundImage(UIImage(named: "record_pause_btn_normal"), for: .normal)
//        self.btnStop.isUserInteractionEnabled = true
//        print("resume")
        
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
            
            CommonFunctions.alertMessage(view: self, title: "PTS", msg: "Overwrite complete", btnTitle: "Ok")
            if let originalUrl = self.recorder.articleChunks.first?.url, let replacingUrl = self.recorder.articleChunks.last?.url{
                self.mergeAudioFiles(originalURL: originalUrl, replacingURL: replacingUrl, startTime: CMTimeMakeWithSeconds(Float64(self.overwritingStartingPoint), preferredTimescale: 1), folderName: "Demo", caseNumber: "test", taskToPerform: "Overwrite")
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
                
                let decibels = Float(recorder.peakPower(forChannel: 0))
//                let value = [3.5, 3.4, 3.3, 3.2, 3.1, 3.0]
                self.customRangeBar.value = decibels * 3.5
             }
        }
    }

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

extension RecordVC{
    func mergeAudioFiles(originalURL: URL, replacingURL:URL, startTime:CMTime, folderName:String, caseNumber:String, taskToPerform:String) {
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey:true]
        let originalAsset  = AVURLAsset(url: originalURL, options: options)
        let replacingAsset = AVURLAsset(url: replacingURL, options: options)
        
        if let replacingTrack = replacingAsset.tracks.first{
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

extension RecordVC {
    func visualizationViewSetup() {
        self.audioVisualizationViewModel.askAudioRecordingPermission()

        self.audioVisualizationViewModel.audioMeteringLevelUpdate = { [weak self] meteringLevel in
            guard let self = self, self.audioVisualizationView.audioVisualizationMode == .write else {
                return
            }
            self.meteringLevels.append(meteringLevel)
//            self.audioVisualizationView.add(meteringLevel: meteringLevel)
        }

        self.audioVisualizationViewModel.audioDidFinish = { [weak self] in
            self?.currentVisualizationState = .recorded
            self?.audioVisualizationView.stop()
        }
    }
    
    func visualizationViewControlls() {
        switch self.currentVisualizationState {
        case .ready:
            self.currentVisualizationState = .recording
            self.audioVisualizationViewModel.startRecording { [weak self] soundRecord, error in
                if let error = error {
                 //   self?.showAlert(with: error)
                    print(error)
                    return
                }

                self?.currentVisualizationState = .recording

                self?.chronometer = Chronometer()
                self?.chronometer?.start()
            }
        case .recording:
            self.chronometer?.stop()
            self.chronometer = nil

            self.audioVisualizationViewModel.currentAudioRecord!.meteringLevels = self.audioVisualizationView.scaleSoundDataToFitScreen()
            self.audioVisualizationView.audioVisualizationMode = .read

            do {
                try self.audioVisualizationViewModel.stopRecording()
                self.currentVisualizationState = .recorded
            } catch {
                self.currentVisualizationState = .ready
             //   self.showAlert(with: error)
            }
        case .recorded, .paused:
            do {
                let duration = try self.audioVisualizationViewModel.startPlaying()
                self.currentVisualizationState = .playing
                self.audioVisualizationView.meteringLevels = self.audioVisualizationViewModel.currentAudioRecord!.meteringLevels
                self.audioVisualizationView.play(for: duration)
            } catch {
                self.showAlert(with: error)
            }
        case .playing:
            do {
                try self.audioVisualizationViewModel.pausePlaying()
                self.currentVisualizationState = .paused
                self.audioVisualizationView.pause()
            } catch {
              //  self.showAlert(with: error)
            }
        default:
            break
        }
    }
}
