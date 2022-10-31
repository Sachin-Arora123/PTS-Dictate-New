//
//  RecordVCNew.swift
//  PTS Dictate
//
//  Created by Sachin on 28/10/22.
//

import AVFAudio
import UIKit
import AVFoundation
import FDWaveformView

//#import "PTSRecordViewController.h"
//#import "PTSCommentsViewController.h"

//#import <QuartzCore/QuartzCore.h>
//#import <CoreMedia/CoreMedia.h>
//#import <AudioToolbox/AudioServices.h>
//#import <AVFoundation/AVFoundation.h>

//#import "FDWaveformView.h"
//#import "NBTouchAndHoldButton.h"
//#import "F3BarGauge.h"
//#import "SCWaveformView.h"
//#import "FVSoundWaveView.h"
//#import "SoundManager.h"

// define K_OPERATION_INTERRUPTED @"Operation Interrupted"
// define K_RECORDING @"Recording"
// define K_PAUSED @"Paused"
// define K_OVERWRITING @"Overwriting"
// define K_STOPPED @"Stopped"
// define K_STOP_CURRENT_RECORD_ALERT @"Do you want to stop the current Recording ?"
// define K_SAVE_CURRENT_RECORD_ALERT @"Do you want to save the current Recording ?"
// define K_YES @"YES"
// define K_NO @"NO"
// define K_OK @"OK"
// define K_APPEND @"Append"
// define K_INSERT @"Insert"
// define K_OVERWRITE @"Overwrite"
// define K_PARTIAL_DELETE @"Partial Delete"
// define K_START_TIME @"00:00:00"

// define TAG_RECORD_BTN 101
// define TAG_STOP_BTN 102
// define TAG_TIMING_LBL 103
// define TAG_STATUS_LBL 104
// define TAG_PLAY_BTN 105
// define TAG_FILENAME_LBL 106
// define TAG_FILESIZE_LBL 107
// define TAG_BOOKMARK_BTN 108
// define TAG_BOOKMARK_BACKWARD_BTN 109
// define TAG_BOOKMARK_FORWARD_BTN 110
// define TAG_CURRENTTIME_LBL 111
// define TAG_DURATION_LBL 112
// define TAG_ERASE_BTN 113
// define TAG_START_POINT_BTN 123
// define TAG_END_POINT_BTN 124
// define TAG_START_OVERWRITE_BTN 125
// define TAG_END_OVERWRITE_BTN 126
// define TAG_DISCARD_BTN 114
// define TAG_SAVE_BTN 115
// define TAG_CLEAR_INDEX_BTN 116
// define TAG_EDIT_RECORD_BTN 117
// define TAG_OVERWRITE_LBL 118

// define TAG_REWIND_BTN 119
// define TAG_FAST_REWIND_BTN 120
// define TAG_FORWARD_BTN 121
// define TAG_FAST_FORWARD_BTN 122

// define TAG_EDIT_OVERWRITE 127

// define TAG_EDIT_APPEND 128
// define TAG_EDIT_INSERT 129
// define TAG_EDIT_PARTIAL_DELETE 130
// define TAG_EDIT_PARTIAL_DELETE_ALERT 131

// define FIRSTTIME 0
// define SECONDTIME 1

// define TAG_BOOKMARK_1 1001
// define TAG_BOOKMARK_2 1002
// define TAG_BOOKMARK_3 1003
// define TAG_BOOKMARK_4 1004
// define TAG_BOOKMARK_5 1005
// define TAG_BOOKMARK_6 1006
// define TAG_BOOKMARK_7 1007
// define TAG_BOOKMARK_8 1008
// define TAG_BOOKMARK_9 1009
// define TAG_BOOKMARK_10 1010
// define TAG_BOOKMARK_11 1011
// define TAG_BOOKMARK_12 1012
// define TAG_BOOKMARK_13 1013
// define TAG_BOOKMARK_14 1014
// define TAG_BOOKMARK_15 1015
// define TAG_BOOKMARK_16 1016
// define TAG_BOOKMARK_17 1017
// define TAG_BOOKMARK_18 1018
// define TAG_BOOKMARK_19 1019
// define TAG_BOOKMARK_20 1020

// define RECORDED_FILE @"/Player"

// define TAG_AUTO_SAVE_ALERT_ONE 101
// define TAG_AUTO_SAVE_ALERT_TWO 102
// define TAG_AUTO_SAVE_ALERT_THREE 103


// define TAG_SAVE_ALERT_TAG 104
// define TAG_DISCARD_ALERT_TAG 105
// define TAG_AUTO_SAVE_ALERT_TAG 106
// define TAG_ALERT_STOP_RECORD_TAG 107
// define TAG_ALERT_ALREADY_PAUSED_TAG 108
// define TAG_ALERT_ALREADY_STOPPED_TAG 109
// define TAG_FILE_SAVED_ALERT 110
// define TAG_BATTERY_FILE_SAVED_ALERT_PAUSED 111
// define TAG_BATTERY_FILE_SAVED_ALERT_STOPPED 112

// define TAG_WARNING_ALERT_ONE 1001
// define TAG_WARNING_ALERT_TWO 1002
// define TAG_RECORD_PERMISSION_DENIED 115


let BOOKMARK_1:Int = 1
let BOOKMARK_2:Int = 2
let BOOKMARK_3:Int = 3
let BOOKMARK_4:Int = 4
let BOOKMARK_5:Int = 5
let BOOKMARK_6:Int = 6
let BOOKMARK_7:Int = 7
let BOOKMARK_8:Int = 8
let BOOKMARK_9:Int = 9
let BOOKMARK_10:Int = 10
let BOOKMARK_11:Int = 11
let BOOKMARK_12:Int = 12
let BOOKMARK_13:Int = 13
let BOOKMARK_14:Int = 14
let BOOKMARK_15:Int = 15
let BOOKMARK_16:Int = 16
let BOOKMARK_17:Int = 17
let BOOKMARK_18:Int = 18
let BOOKMARK_19:Int = 19
let BOOKMARK_20:Int = 20

let FIRSTTIME:Int = 0
let SECONDTIME:Int = 1
let TAG_EDIT_PARTIAL_DELETE_ALERT = 131
let TAG_STATUS_LBL = 104
let TAG_BOOKMARK_1 = 1001
let TAG_BOOKMARK_2 = 1002
let TAG_BOOKMARK_3 = 1003
let TAG_BOOKMARK_4 = 1004
let TAG_BOOKMARK_5 = 1005
let TAG_BOOKMARK_6 = 1006
let TAG_BOOKMARK_7 = 1007
let TAG_BOOKMARK_8 = 1008
let TAG_BOOKMARK_9 = 1009
let TAG_BOOKMARK_10 = 1010
let TAG_BOOKMARK_11 = 1011
let TAG_BOOKMARK_12 = 1012
let TAG_BOOKMARK_13 = 1013
let TAG_BOOKMARK_14 = 1014
let TAG_BOOKMARK_15 = 1015
let TAG_BOOKMARK_16 = 1016
let TAG_BOOKMARK_17 = 1017
let TAG_BOOKMARK_18 = 1018
let TAG_BOOKMARK_19 = 1019
let TAG_BOOKMARK_20 = 1020
let TAG_RECORD_BTN = 101
let TAG_STOP_BTN = 102
let TAG_TIMING_LBL = 103
let TAG_PLAY_BTN = 105
let TAG_FILENAME_LBL = 106
let TAG_FILESIZE_LBL = 107
let TAG_BOOKMARK_BTN = 108
let TAG_BOOKMARK_BACKWARD_BTN = 109
let TAG_BOOKMARK_FORWARD_BTN = 110
let TAG_CURRENTTIME_LBL = 111
let TAG_DURATION_LBL = 112
let TAG_ERASE_BTN = 113
let TAG_START_POINT_BTN = 123
let TAG_END_POINT_BTN = 124
let TAG_START_OVERWRITE_BTN = 125
let TAG_END_OVERWRITE_BTN = 126
let TAG_DISCARD_BTN = 114
let TAG_SAVE_BTN = 115
let TAG_CLEAR_INDEX_BTN = 116
let TAG_EDIT_RECORD_BTN = 117
let TAG_OVERWRITE_LBL = 118
let TAG_SAVE_ALERT_TAG = 104
let TAG_DISCARD_ALERT_TAG = 105
let TAG_AUTO_SAVE_ALERT_TAG = 106
let TAG_ALERT_STOP_RECORD_TAG = 107
let TAG_ALERT_ALREADY_PAUSED_TAG = 108
let TAG_ALERT_ALREADY_STOPPED_TAG = 109
let TAG_FILE_SAVED_ALERT = 110
let TAG_BATTERY_FILE_SAVED_ALERT_PAUSED = 111
let TAG_BATTERY_FILE_SAVED_ALERT_STOPPED = 112

let TAG_WARNING_ALERT_ONE = 1001
let TAG_WARNING_ALERT_TWO = 1002
let TAG_RECORD_PERMISSION_DENIED = 115
let RECORDED_FILE = "/Player"
let TAG_REWIND_BTN = 119
let TAG_FAST_REWIND_BTN = 120
let TAG_FORWARD_BTN = 121
let TAG_FAST_FORWARD_BTN = 122

let TAG_EDIT_OVERWRITE = 127

let TAG_EDIT_APPEND = 128
let TAG_EDIT_INSERT = 129
let TAG_EDIT_PARTIAL_DELETE = 130
let K_OPERATION_INTERRUPTED = "Operation Interrupted"
let K_RECORDING = "Recording"
let K_PAUSED = "Paused"
let K_OVERWRITING = "Overwriting"
let K_STOPPED = "Stopped"
let K_STOP_CURRENT_RECORD_ALERT = "Do you want to stop the current Recording ?"
let K_SAVE_CURRENT_RECORD_ALERT = "Do you want to save the current Recording ?"
let K_YES = "YES"
let K_NO = "NO"
let K_OK = "OK"
let K_APPEND = "Append"
let K_INSERT = "Insert"
let K_OVERWRITE = "Overwrite"
let K_PARTIAL_DELETE = "Partial Delete"
let K_START_TIME = "00:00:00"




class RecordVCNew: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate {

    
    private var progressIn = 0.0
    private var playerCurrentTime = 0.0
    private var insertingTime = 0.0
    private var isErasing = 0
    private var isOverwriting = 0
    private var isEdit : Bool = false
    private var isAlertShown : Bool?
    private var isFirstTime : Bool?
    private var isRecordAtBeginning : Bool = false
    private var fileCountInt = 0
    private var previousFilelength = 0.0
    private var bookMarTapCount = 0
    private var sliderValue = 0.0
    private var trimCount = 0
    private var autoSaveIsOn : Bool = false
    private var isPaused : Bool = false
    private var isPausedFromTab : Bool = false
    private var isSaveAutoSaveFile : Bool = false
    private var isUploadWarning : Bool = false
    private var isLimitReached : Bool = false
    private var isRecordStopTapped : Bool = false
    private var isRecordStarted : Bool = false
    private var isVoiceActivation : Bool = false
    private var isAppend : Bool = false
    private var isSaving = 0.0
    private var isLoadingShowing : Bool = false
    private var isBookMarkTap : Bool = false
    private var editMode = 0
    private var startPointTime = 0
    private var endPointTime = 0
    private var isFirstTimeInEditing : Bool = false
    private var isAppendPopupShowed : Bool = false
    private var isEditButtonTapped : Bool = false
    private var isAppendWithOverwriting : Bool = false
    private var isStopBtnTappedWhileOverwriting : Bool = false
    private var pageScrollView : UIScrollView?
    private var headerView : UIView?
    private var segmentBgView : UIView?
    private var bookmarkView : UIView?
    private var partialDelView : UIView?
    private var graphView : UIView?
    private var bottomView : UIView?
    private var overWriteView : UIView?
    private var imgSlider : UIImageView?
    private var imgSliderStart : UIImageView?
    private var imgSliderEnd : UIImageView?
    private var segmentedControl : UISegmentedControl?
    private var audio_Recorder : AVAudioRecorder?
    private var tempRecorder : AVAudioRecorder?
    private var recordingFileUrl : URL?
    private var currentTimeUpdateTimer : Timer?
    private var playerTimer : Timer?
    private var tempTimer : Timer?
    private var rewindTimer : Timer?
    private var fastRewindTimer : Timer?
    private var forwardTimer : Timer?
    private var fastForwardTimer : Timer?
    private var playBtn : UIButton?
    private var recordBtn : UIButton?
    private var stopBtn : UIButton?
    private var eraseBtn : UIButton?
    private var bookmarkBtn : UIButton?
    private var bookmarkBackwardBtn : UIButton?
    private var bookmarkFordwardBtn : UIButton?
    private var clearIndex : UIButton?
    private var autoSaveBtn : UIButton?
    private var startPointBtn : UIButton?
    private var endPointBtn : UIButton?
    private var startOverwriteBtn : UIButton?
    private var endOverwriteBtn : UIButton?
    private var bookmarkSlider : UISlider?
    private var waveFormSlider : UISlider?
    private var rewindBtn : UIButton?
    private var fastRewindBtn : UIButton?
    private var forwardBtn : UIButton?
    private var fastForwardBtn : UIButton?
    private var waveform : FDWaveformView?
    private var customRangeBar : F3BarGauge?
    private var waveformView : SCWaveformView?
    private var recordedFileDuration = 0.0
    private var fileNameLbl : UILabel?
    private var fileSizeLbl : UILabel?
    private var fileCountStr : String?
    private var bookMarkArr : [String]?
    private var pauseArr : NSMutableArray?
    private var panRecognizer : UIPanGestureRecognizer?
//    private var _soundWaveView : FVSoundWaveView?
    private var dividerBgView : UIView?
    private var recordCtrlsView : UIView?
    private var playerCtrlsView : UIView?
    private var detailsView : UIView?
    private var startPointView : UIView?
    private var endPointView : UIView?
    private var lblStartPoint : UILabel?
    private var lblEndPoint : UILabel?
    private var eraseEndTime : String?
    private var thePlayerItem : AVPlayerItem?
    private var thePlayer : AVPlayer?
    private var thirtySecondPauseCounter = 0
    private var microPhoneSensitivityIndex = 0
    private var eraseStartTime = 0.0
    private var editRecording:Bool = false
    private var editDictionary:[String:String] = [:]


    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let deviceType = UIDevice.current.model

        self.view.frame = UIScreen.main.bounds
        self.view.backgroundColor = K_COLOR_WHITE_COLOR
        //PTSNAVIGATION.setNavigationTitle("Record", andTitleImage:"title_record_normal.png", viewController:self)
        self.title = "Record"
        let logo = UIImage(named: "title_record_normal.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.initAudioRecorder()
        
        self.createFolder(folderName: "Existing")

        trimCount = 1
        
        AppDelegate.sharedInstance().userDefaults.set(trimCount, forKey:K_KEY_IS_TRIMCOUNT)
        isRecording = (FIRSTTIME != 0)
        AppDelegate.sharedInstance().userDefaults.set("0", forKey:K_KEY_IS_RECORDING)
        //isErasing = isSaving = isOverwriting = FIRSTTIME
        isOverwriting = FIRSTTIME
        isErasing = isOverwriting
        isSaving = Double(isErasing)
        bookMarTapCount = 0
        sliderValue = 0
        autoSaveIsOn = false
        isPaused = false
        isSaveAutoSaveFile = false
        isLimitReached = false
        isUploadWarning = false
        isRecordStopTapped = false
        isRecordStarted = false
        isVoiceActivation = false
        isAppend = false
        isFirstTimeInEditing = true
        isEditButtonTapped = false
        isStopBtnTappedWhileOverwriting = false
        self.thirtySecondPauseCounter = 0

        microPhoneSensitivityIndex = AppDelegate.sharedInstance().userDefaults.integer(forKey: K_KEY_MICROPHONE_SENSITIVITY)

        let sensitivity = AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_MICROPHONE_SENSITIVITY)

        if sensitivity?.count == 0 {
            microPhoneSensitivityIndex = 5
        }


        let indexing = AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_INDEXING)

        if indexing?.count == 0 {
            //NSLog(@"indexing == 0");
            AppDelegate.sharedInstance().userDefaults.set(K_SWITCH_OFF, forKey:K_KEY_SWITCH_INDEXING)
        }

        let disablePopUp = AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_DISABLE_POPUP)

        if disablePopUp?.count == 0 {
            //NSLog(@"indexing == 0");
            AppDelegate.sharedInstance().userDefaults.set(K_SWITCH_OFF, forKey:K_KEY_SWITCH_DISABLE_POPUP)
        }

        self.bookMarkArr = []
        self.pauseArr = []

        // MONITORING BATTETY LEVEL
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
//        NotificationCenter.default.addObserver(self, selector:#selector(("batteryChanged:")), name:UIDevice.batteryLevelDidChangeNotification, object:device)

//        NotificationCenter.default.addObserver(self, selector: #selector(batteryChanged(notification: <#T##NSNotification!#>)), name: UIDevice.batteryLevelDidChangeNotification, object: device)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(notification:)), name: K_NOTICATION_RECORDING, object: nil)

//        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(notification:)), name: K_NOTICATION_RECORDING , object: nil)


        //NSNotificationCenter.default.addObserver(self, selector:Selector("receiveNotification:"), name:K_NOTICATION_RECORDING, object:nil)

        self.setupView()

        if editRecording {

            // NSLog(@" =========== > editRecording <===========");

            let filePath:String! = self.getRecordedFile()

            isRecording = (SECONDTIME != 0)
            AppDelegate.sharedInstance().userDefaults.set("1", forKey:K_KEY_IS_RECORDING)
//            self.setAllSettings(filePath: filePath)

           // self.allSettings = filePath

            //[PTSHELPER showLoadingIndicator:self];
            self.perform(#selector(self.updateWaveForm(filePath:)), with: filePath, afterDelay: 0.5)


            self.waveFormSlider?.setValue(Float(recordedFileDuration), animated:true)
            self.fileNameLbl?.text = self.editDictionary["filename"]
            

            AppDelegate.sharedInstance().userDefaults.set(self.editDictionary["rowId"], forKey:K_KEY_IS_ROW_ID)

            self.waveformView?.progressTime = CMTimeMakeWithSeconds(recordedFileDuration, preferredTimescale: 10000)

            let bookmarks:String! = self.editDictionary["bookmarks"]

            if bookmarks.count != 0 {

                //NSLog(@" ============= > HAVING DATAS <=============");
                
                self.bookMarkArr = bookmarks.components(separatedBy: ",") //bookmarks.componentsSeparatedByString(",").mutableCopy()
                self.bookmarkFordwardBtn?.isEnabled = true

//                self.createBookMarKDivider()
            }


            self.showSegmentView()


            if (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_INDEXING) == K_SWITCH_OFF) {

                if IS_IPHONE_5 {
                    self.pageScrollView?.contentSize = CGSize(width: 0, height: (self.headerView?.frame.size.height ?? 0) - 40)
                }
                else if IS_IPHONE_4 {
                    self.pageScrollView?.contentSize = CGSize(width: 0, height: (self.headerView?.frame.size.height ?? 0) + 40)

                }
            }
            else
            {
                if IS_IPHONE_5 {
                    self.pageScrollView?.contentSize = CGSize(width: 0, height: self.headerView?.frame.size.height ?? 0)
                }
                else if IS_IPHONE_4 {
                    self.pageScrollView?.contentSize = CGSize(width: 0, height: (self.headerView?.frame.size.height ?? 0) + 105)
                }
            }

            self.recordBtn?.isEnabled = false
            self.recordBtn?.setImage(UIImage(named: "record_record_btn_disable.png"), for: .disabled)

          //  self.recordBtn.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)

            self.stopBtn?.isEnabled = true
            self.stopBtn?.setImage(UIImage(named: "record_stop_btn_normal.png"), for: .normal)
            //self.stopBtn.setImage(K_SETIMAGE("record_stop_btn_normal.png"), forState:UIControlStateNormal)

            isEditButtonTapped = true
        }

        AppDelegate.sharedInstance().userDefaults.set(editRecording, forKey:K_KEY_EDIT_RECORD_FILE)

        //[self textTospeech:@"Your current recording going to saved."];
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createFolder(folderName: "Record")
        NotificationCenter.default.addObserver(self, selector: #selector(self.appHasTreminated(notification:)), name: UIApplication.willTerminateNotification, object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector:#selector("appHasTreminated"),
//                                               name:UIApplication.willTerminateNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackgroundFunction(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackgroundFunction(notification:), name: UIApplication.didEnterBackgroundNotification, object: nil))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.createFolder(folderName: "Record")
        if !editRecording {
//            self.changeFileNameCount()
        }
    }

    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, forKeyPath:"is_recording", context:nil)
        
       // NSNotificationCenter.default.removeObserver(self, name:K_NOTICATION_RECORDING, object:nil)
        NotificationCenter.default.removeObserver(self, name:UIDevice.batteryLevelDidChangeNotification, object:nil)

        //NSNotificationCenter.default.removeObserver(self, name:UIDeviceBatteryLevelDidChangeNotification, object:nil)

        self.stopAllProcess()
    }
    

    @objc func appInBackgroundFunction(notification: Notification) {
        self.pauseAudioPlayer()
    }
    
    @objc func appHasTreminated(notification: Notification){
        self.audio_Recorder?.stop()

        let session:AVAudioSession! = AVAudioSession.sharedInstance()
        do{
         try session.setActive(false)
        }catch{
            debugPrint(error)
        }

        isSaveAutoSaveFile = true

        if (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_AUTO_SAVING) == K_SWITCH_ON) {

            if self.isRecordStarted {

                //NSLog(@"appHasTreminated");

                let playerItem:AVPlayerItem! = self.thePlayer?.currentItem

                let currentTime:CMTime = playerItem.currentTime()

                let time:Float = Float(CMTimeGetSeconds(currentTime))

                AppDelegate.sharedInstance().userDefaults.set(self.getRecordedFile(), forKey:K_KEY_IS_PLAYER_FILE)
                AppDelegate.sharedInstance().userDefaults.set(time, forKey:K_KEY_IS_PLAYER_CURRENT_TIME)
                AppDelegate.sharedInstance().userDefaults.set(true, forKey:K_KEY_AUTO_SAVE_FILE)

                if !editRecording {
                    let filecountString:String! = String(format:"%@",fileCountStr as! CVarArg)
                    AppDelegate.sharedInstance().userDefaults.set(filecountString, forKey:K_KEY_RECORD_FILE_COUNT)
                }

                UserDefaults.standard.synchronize()

                //  NSLog(@"=======> appHasTreminated <=====");

            }
        }
    }

    

    // MARK: - PRIVATE METHODS DESIGNS
    func setupView() {

        // SEGMENT VIEW
        self.segmentBgView = UIView(frame:CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 50))
        self.segmentBgView?.backgroundColor = .cyan
        self.view.addSubview(self.segmentBgView ?? UIView())

        // SEGEMENT CONTROL
        self.segmentedControl = UISegmentedControl(items:[K_APPEND,K_INSERT,K_OVERWRITE,K_PARTIAL_DELETE])
        self.segmentedControl?.frame = CGRect(x: 5, y: 100, width: self.view.frame.size.width - 10, height: 30)
        self.segmentedControl?.addTarget(self, action: #selector(self.segmentedControlValueDidChange(segment:)), for: .valueChanged)
        self.segmentedControl?.selectedSegmentIndex = 0
        self.segmentedControl?.backgroundColor = .clear
        let font = UIFont(name: FONT_NORMAL, size:10)
        let attributes = NSDictionary(object: font,forKey:NSAttributedString.Key.font as NSCopying)
        self.segmentedControl?.setTitleTextAttributes(attributes as! [NSAttributedString.Key : Any], for: .normal)
        self.segmentBgView?.addSubview(self.segmentedControl ?? UIView())
        UISegmentedControl.appearance().tintColor = hexStringToUIColor(hex: "F74118")
        self.segmentBgView?.alpha = 1
        

         // HEADER VIEW
        self.headerView = UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - CGFloat(K_TABBAR_HEIGHT)))
        self.headerView?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.view.addSubview(self.headerView ?? UIView())

        //ScrollView
        self.pageScrollView = UIScrollView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.headerView?.frame.size.height ?? 0.0))
        // define the scroll view content size and enable paging
        self.pageScrollView?.isPagingEnabled = false
        self.pageScrollView?.scrollsToTop = false
        self.pageScrollView?.contentSize = CGSize(width: (self.headerView?.frame.size.width ?? 0.0), height: (self.headerView?.frame.size.height ?? 0.0))
        self.pageScrollView?.setContentOffset(CGPoint(x: 0, y: self.pageScrollView?.contentOffset.y ?? 0.0), animated: true)
        self.pageScrollView?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.pageScrollView?.isUserInteractionEnabled = true
        self.pageScrollView?.panGestureRecognizer.delaysTouchesBegan = ((self.pageScrollView?.delaysContentTouches) != nil)
        self.headerView?.addSubview(self.pageScrollView ?? UIView())


        //RANGE BAR
        self.customRangeBar = F3BarGauge(frame:CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 35))
        self.customRangeBar?.backgroundColor = UIColor.white
        self.customRangeBar?.numBars = 30
        self.customRangeBar?.minLimit = -100
        self.customRangeBar?.maxLimit = -10
        self.customRangeBar?.normalBarColor = hexStringToUIColor(hex: "F74118")
        self.customRangeBar?.warningBarColor = UIColor(red: 105/255.0, green: 105.0/255.0, blue: 105/255.0, alpha: 1)
        self.customRangeBar?.dangerBarColor = UIColor(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)
        self.customRangeBar?.outerBorderColor = UIColor.gray
        self.customRangeBar?.innerBorderColor = UIColor.black
        self.pageScrollView?.addSubview(self.customRangeBar ?? UIView())

        if !editRecording {
            self.customRangeBar?.alpha = 1.0
        } else {
            self.customRangeBar?.alpha = 0.0
        }

        // WAVE FORM BG VIEW
        self.graphView = UIView(frame:CGRect(x: 10, y: 10, width: self.pageScrollView?.frame.size.width ?? 0.0 - 20, height: 45))
        self.graphView?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.pageScrollView?.addSubview(self.graphView ?? UIView())

        playerCurrentTime = 0.0

        var originX:CGFloat = 50
        let LblHgt:CGFloat = 15

        let currentTimeLbl = UILabel(frame:CGRect(x: 0, y: 0, width: self.graphView?.frame.size.width ?? 0.0, height: LblHgt))
        currentTimeLbl.textColor = K_COLOR_DARK_COLOR
        currentTimeLbl.tag = TAG_CURRENTTIME_LBL
        currentTimeLbl.textAlignment = .right
        currentTimeLbl.font = UIFont(name: FONT_BOLD, size:12)
        currentTimeLbl.backgroundColor = K_COLOR_CLEAR_COLOR
        self.graphView?.addSubview(currentTimeLbl)

        self.waveformView = SCWaveformView()
        self.waveformView?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.waveformView?.frame = CGRect(x:0, y:12.5, width:self.graphView?.frame.size.width ?? 0.0, height:45)
        // Setting the waveform colors
        self.waveformView?.normalColor = hexStringToUIColor(hex: "80CEFB")
        self.waveformView?.progressColor = UIColor.blue
        self.waveformView?.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(1, preferredTimescale: 1))

        // Access the waveformView from there
        // Set the precision, 1 being the maximum
        self.waveformView?.precision = 0.9 // We are going to render one line per four pixels
        // Set the lineWidth so we have some space between the lines
        self.waveformView?.lineWidthRatio = 0.75
        // Add some padding between the channels
        self.waveformView?.channelsPadding = 5
        self.waveformView?.channelEndIndex = 0
        self.graphView?.addSubview(self.waveformView ?? UIView())

        let frame = CGRect(x: 0, y: 17.5, width: (self.graphView?.frame.width ?? 0.0), height:35.0)
        self.waveFormSlider = UISlider(frame:frame)
        self.waveFormSlider?.addTarget(self, action:#selector(self.sliderValueChanged(sender:)), for:.valueChanged)
        self.waveFormSlider?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.waveFormSlider?.minimumValue = 0.0
                self.waveFormSlider?.thumbTintColor = K_COLOR_BLACK_COLOR
        self.waveFormSlider?.isContinuous = true

        let sliderImage = UIImage(named: "slider")
//        let myIcon = PTSHELPER.imageWithImage(sliderImage, scaledToSize:CGSizeMake(3, 40))

        self.waveFormSlider?.setThumbImage(sliderImage, for:.normal)
        self.waveFormSlider?.setThumbImage(sliderImage, for:.highlighted)
        self.waveFormSlider?.setMinimumTrackImage(UIImage(), for:.normal)
        self.waveFormSlider?.setMaximumTrackImage(UIImage(), for:.normal)

        self.graphView?.addSubview(self.waveFormSlider ?? UIView())

        self.waveFormSlider?.alpha = 0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.sliderTapped(gestureRecognizer:)))
                self.waveFormSlider?.addGestureRecognizer(tapGestureRecognizer)

        self.panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(self.handlePanGesture(recognizer:)))
        self.panRecognizer?.delegate = self
        self.waveFormSlider?.addGestureRecognizer(self.panRecognizer ?? UIPanGestureRecognizer())

        self.imgSlider = UIImageView(frame:CGRect(x: self.waveform?.frame.origin.x ?? 0.0 + (self.waveform?.frame.size.width ?? 0.0) , y: self.waveform?.frame.origin.y ?? 0.0, width: sliderImage?.size.width ?? 0.0, height: sliderImage?.size.height ?? 0.0 + 2.5))
        self.imgSlider?.image = sliderImage
        self.imgSlider?.alpha = 0.0
        self.graphView?.addSubview(self.imgSlider ?? UIView())

        self.imgSliderStart = UIImageView(frame:CGRect(x: (self.waveform?.frame.origin.x ?? 0.0) + (self.waveform?.frame.size.width ?? 0.0) , y: (self.waveform?.frame.origin.y ?? 0.0), width: (sliderImage?.size.width ?? 0.0), height: (sliderImage?.size.height ?? 0.0) + 2.5))
        self.imgSliderStart?.image = sliderImage
        self.imgSliderStart?.alpha = 0.0
        self.graphView?.addSubview(self.imgSliderStart ?? UIView())

        self.imgSliderEnd = UIImageView(frame:CGRect(x: (self.waveform?.frame.origin.x ?? 0.0) + (self.waveform?.frame.size.width ?? 0.0), y: self.waveform?.frame.origin.y ?? 0.0, width: (sliderImage?.size.width ?? 0.0), height: (sliderImage?.size.height ?? 0.0) + 2.5))
        self.imgSliderEnd?.image = sliderImage
        self.imgSliderEnd?.alpha = 0.0
        self.graphView?.addSubview(self.imgSliderEnd ?? UIView())

        let durationLbl = UILabel(frame:CGRect(x: self.waveform?.frame.origin.x ?? 0.0 + (self.waveform?.frame.size.width ?? 0.0) + 4, y: (self.graphView?.frame.size.height ?? 0.0) * 0.5 - LblHgt * 0.5 , width: originX - 4, height: LblHgt))
        durationLbl.textColor = K_COLOR_DARK_COLOR
        durationLbl.text = "05:18"
        durationLbl.tag = TAG_CURRENTTIME_LBL
        durationLbl.textAlignment = .left
        durationLbl.font = UIFont(name: FONT_NORMAL, size:12)
        //[graphView addSubview:durationLbl];


        // BOOKMARK VIEW
        self.partialDelView = UIView(frame:CGRect(x: 0, y: (self.graphView?.frame.origin.y ?? 0.0) + (self.graphView?.frame.size.height ?? 0.0) + 20, width: self.pageScrollView?.frame.size.width ?? 0.0, height: 50))
        self.partialDelView?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.pageScrollView?.addSubview(self.partialDelView ?? UIView())
        self.partialDelView?.alpha = 0.0

        var btnSize:CGFloat = 120
        originX = (self.partialDelView?.frame.size.width ?? 0.0) * 0.5 - btnSize * 0.5

        //Erase button
        self.eraseBtn = UIButton(type: .custom)
        self.eraseBtn?.frame = CGRect(x: originX , y: 5, width: btnSize, height: 40)
//        self.eraseBtn?.addTarget(self, action:#selector(self.action(sender:)), for:.touchUpInside)
        self.eraseBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.eraseBtn?.tag = TAG_ERASE_BTN
        self.eraseBtn?.setImage(UIImage(named: "start_erase_btn_normal.png"), for: .normal)
        self.eraseBtn?.setImage(UIImage(named: "start_erase_btn_disable.png"), for: .highlighted)
        self.eraseBtn?.setImage(UIImage(named: "start_erase_btn_disable.png"), for: .disabled)
        // [self.partialDelView addSubview:self.eraseBtn];


        // OVERWRITE VIEW
        self.overWriteView = UIView(frame:CGRect(x: 0, y: (self.graphView?.frame.origin.y ?? 0.0) + (self.graphView?.frame.size.height ?? 0.0) + 20, width: self.pageScrollView?.frame.size.width ?? 0.0, height: 50))
        self.overWriteView?.backgroundColor = .gray
        self.pageScrollView?.addSubview(self.overWriteView ?? UIView())
        self.overWriteView?.alpha = 1.0

        btnSize = 120
        originX = self.overWriteView?.frame.size.width ?? 0.0 * 0.5 - btnSize * 0.5

        //Start point button
        self.startPointBtn = UIButton(type: .custom)
        self.startPointBtn?.frame = CGRect(x:originX , y:10, width:btnSize, height:30)
        self.startPointBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.startPointBtn?.tag = TAG_START_POINT_BTN
        self.startPointBtn?.setImage(UIImage(named: "btn_start_point_normal"), for: .normal)
        self.startPointBtn?.setImage(UIImage(named: "btn_start_point_highlight"), for: .highlighted)
//        self.startPointBtn.addTarget(self, action:#selector(self.action(sender:), forControlEvents:.touchUpInside))
        self.startPointBtn?.setTitle("Start Point", for: .normal)
        self.overWriteView?.addSubview(self.startPointBtn ?? UIView())

        //End point button
        self.endPointBtn = UIButton(type: .custom)
        self.endPointBtn?.frame = CGRect(x: originX , y: 10, width: btnSize, height: 30)
        self.endPointBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.endPointBtn?.tag = TAG_END_POINT_BTN
        self.endPointBtn?.alpha = 0
        self.endPointBtn?.setImage(UIImage(named: "btn_end_point_normal"), for: .normal)
        self.endPointBtn?.setImage(UIImage(named: "btn_end_point_highlight"), for: .highlighted)
//        self.endPointBtn?.addTarget(self, action: #selector(self.action(sender:), for:.touchUpInside)
        self.overWriteView?.addSubview(self.endPointBtn ?? UIView())

        startPointTime = 0
        endPointTime = 0

        //Start overwrite button
        self.startOverwriteBtn = UIButton(type: .custom)
        self.startOverwriteBtn?.frame = CGRect(x: originX , y: 10, width: btnSize, height: 30)
        self.startOverwriteBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.startOverwriteBtn?.tag = TAG_START_OVERWRITE_BTN
        self.startOverwriteBtn?.alpha = 0
        self.startOverwriteBtn?.setImage(UIImage(named: "btn_start_overwriting_normal"), for: .normal)
        self.startOverwriteBtn?.setImage(UIImage(named: "btn_start_overwriting_highlight"), for: .highlighted)
//        self.startOverwriteBtn?.addTarget(self, action:#selector(self.action(sender:), forControlEvents:.touchUpInside)
        self.overWriteView?.addSubview(self.startOverwriteBtn ?? UIView())

        //End overwrite button
        self.endOverwriteBtn = UIButton(type: .roundedRect)
        self.endOverwriteBtn?.frame = CGRect(x:originX , y:5, width:btnSize, height:40)
//        self.endOverwriteBtn?.addTarget(self, action:#selector(self.action(sender:), for:.touchUpInside)
        self.endOverwriteBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.endOverwriteBtn?.tag = TAG_START_OVERWRITE_BTN
        self.endOverwriteBtn?.alpha = 0
        self.endOverwriteBtn?.setTitle("End Overwrite", for:.normal)
        self.overWriteView?.addSubview(self.endOverwriteBtn ?? UIView())


        // BOOKMARK VIEW
        self.bookmarkView = UIView(frame:CGRect(x:0, y:(self.graphView?.frame.origin.y ?? 0.0) + (self.graphView?.frame.size.height ?? 0.0) + 10, width:self.view.frame.size.width, height:120))
        self.bookmarkView?.backgroundColor = .blue
        self.pageScrollView?.addSubview(self.bookmarkView ?? UIView())
        self.bookmarkView?.alpha = 1.0

        // Bookmark Slider
        let bookmarkSliderFrame = CGRect(x: 10.0, y: 10, width: (self.bookmarkView?.frame.width ?? 0) - 20.0, height: 10.0)
        self.bookmarkSlider = UISlider(frame:bookmarkSliderFrame)
//        self.bookmarkSlider?.addTarget(self, action:Selector("sliderValueChanged:"), forControlEvents:.valueChanged)
        self.bookmarkSlider?.backgroundColor = .clear
        self.bookmarkSlider?.minimumValue = 0.0
        self.bookmarkSlider?.maximumValue = 20.0
        self.bookmarkSlider?.thumbTintColor = .black
        self.bookmarkSlider?.isContinuous = true
        self.bookmarkSlider?.setThumbImage(sliderImage, for:.normal)
        self.bookmarkSlider?.setThumbImage(sliderImage, for:.highlighted)
        self.bookmarkSlider?.minimumTrackTintColor = .lightGray
        // [slider setMaximumTrackTintColor:[UIColor clearColor]];
        self.bookmarkView?.addSubview(self.bookmarkSlider ?? UIView())
        self.bookmarkSlider?.isUserInteractionEnabled = false


        btnSize = 40
        originX = 20

        // bookmark Backward Button
        self.bookmarkBackwardBtn = UIButton(type: .custom)
        var bookmarkBackwardBtnFrame = CGRect(x: originX , y: btnSize - 5, width: btnSize, height: btnSize)

//        if PTSHelper.isiPad(){
//            bookmarkBackwardBtnFrame.origin.y = btnSize - 15
//        }
        self.bookmarkBackwardBtn?.frame = bookmarkBackwardBtnFrame
        self.bookmarkBackwardBtn?.tag = TAG_BOOKMARK_BACKWARD_BTN
        self.bookmarkBackwardBtn?.setImage(UIImage(named: "record_bookmark_backward_btn_normal"), for:.normal)
        self.bookmarkBackwardBtn?.setImage(UIImage(named: "record_bookmark_backward_btn_disable"), for:.disabled)
//        self.bookmarkBackwardBtn.addTarget(self, action:#selector(self.action(sender:), forControlEvents:UIControlEventTouchUpInside)
        self.bookmarkBackwardBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.bookmarkBackwardBtn?.tag = TAG_BOOKMARK_BACKWARD_BTN
        self.bookmarkView?.addSubview(self.bookmarkBackwardBtn ?? UIView())


        self.bookmarkBtn = UIButton(type: .custom)
        var bookmarkBtnFrame = CGRect(x: (self.bookmarkView?.frame.size.width ?? 0) * 0.5 - btnSize * 0.5 , y: btnSize - 5, width: btnSize, height: btnSize)

//        if PTSHelper.isiPad()
//        {bookmarkBtnFrame.origin.y = btnSize - 15}

        self.bookmarkBtn?.frame = bookmarkBtnFrame
        self.bookmarkBtn?.tag = TAG_BOOKMARK_BTN
        self.bookmarkBtn?.setImage(UIImage(named: "record_bookmark_btn_normal.png"), for: .normal)
        self.bookmarkBtn?.setImage(UIImage(named: "record_bookmark_btn_disable.png"), for: .disabled)
//        self.bookmarkBtn.addTarget(self, action:#selector(self.action(sender:), forControlEvents:UIControlEventTouchUpInside)
        self.bookmarkBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.bookmarkBtn?.tag = TAG_BOOKMARK_BTN
        self.bookmarkView?.addSubview(self.bookmarkBtn ?? UIView())

        self.bookmarkFordwardBtn = UIButton(type: .custom)
        self.bookmarkFordwardBtn?.frame = CGRect(x: (self.bookmarkView?.frame.size.width ?? 0) - originX - btnSize, y: btnSize - 5, width: btnSize, height: btnSize)
        self.bookmarkFordwardBtn?.tag = TAG_BOOKMARK_FORWARD_BTN
        self.bookmarkFordwardBtn?.setImage(UIImage(named: "record_bookmark_forward_btn_normal"), for:.normal)
        self.bookmarkFordwardBtn?.setImage(UIImage(named: "record_bookmark_forward_btn_disable"), for:.disabled)
//                self.bookmarkFordwardBtn.addTarget(self, action:#selector(self.action(sender:), forControlEvents:.touchUpInside)
        self.bookmarkFordwardBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.bookmarkFordwardBtn?.tag = TAG_BOOKMARK_FORWARD_BTN
        self.bookmarkView?.addSubview(self.bookmarkFordwardBtn ?? UIButton())


        btnSize = 120
        originX = (self.bookmarkView?.frame.size.width ?? 0) * 0.5 - btnSize * 0.5
        let originY = CGFloat(self.bookmarkBtn?.frame.origin.y ?? 0) + CGFloat(self.bookmarkBtn?.frame.size.height ?? 0)

        self.clearIndex = UIButton(type: .custom)
        self.clearIndex?.frame = CGRect(x: originX, y: originY, width: btnSize, height: 40)
//                self.clearIndex.addTarget(self, action:#selector(self.action(sender:), forControlEvents:.touchUpInside)
        self.clearIndex?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.clearIndex?.tag = TAG_CLEAR_INDEX_BTN
        self.clearIndex?.setImage(UIImage(named: "index_clear_btn_normal"), for:.normal)
        self.clearIndex?.setImage(UIImage(named: "index_clear_btn_disable"), for:.highlighted)
        self.clearIndex?.setImage(UIImage(named: "index_clear_btn_disable"), for:.disabled)
        self.bookmarkView?.addSubview(self.clearIndex ?? UIButton())

        self.bookmarkBackwardBtn?.isEnabled = false
        self.bookmarkBtn?.isEnabled         = false
        self.bookmarkFordwardBtn?.isEnabled = false
        self.clearIndex?.isEnabled          = false



        // RECORD CONTROLS VIEW
        self.recordCtrlsView = UIView()
        if (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_INDEXING) == K_SWITCH_OFF) {
            self.bookmarkView?.isHidden = true
            self.recordCtrlsView?.frame = CGRect(x: 0, y: (self.graphView?.frame.origin.y ?? 0) + (self.graphView?.frame.size.height ?? 0) + 10, width: (self.pageScrollView?.frame.size.width ?? 0), height: 80)
        }else{
            self.recordCtrlsView?.frame = CGRect(x: 0, y: (self.bookmarkView?.frame.origin.y ?? 0) + (self.bookmarkView?.frame.size.height ?? 0), width: (self.pageScrollView?.frame.size.width ?? 0), height: 80)
        }
        self.recordCtrlsView?.backgroundColor = .green
        self.pageScrollView?.addSubview(self.recordCtrlsView ?? UIView())

        btnSize = 55
        originX = 20

//        var recordBtnFrame = CGRect(x: originX , y: self.recordCtrlsView.frame.size.height * 0.5 - btnSize * 0.5, width: btnSize, height: btnSize)

//        if PTSHelper.isiPad() & (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_INDEXING) == K_SWITCH_ON) {
//            recordBtnFrame.origin.y = self.recordCtrlsView.frame.size.height * 0.5 - btnSize
//        }

        self.recordBtn = UIButton(type: .custom)
        self.recordBtn?.frame = CGRect(x: originX , y: self.recordCtrlsView?.frame.size.height ?? 0 * 0.5 - btnSize * 0.5, width: btnSize, height: btnSize)
        self.recordBtn?.tag = TAG_RECORD_BTN
        self.recordBtn?.setImage(UIImage(named: "record_record_btn_normal"), for:.normal)
        self.recordBtn?.setImage(UIImage(named: "record_record_btn_disable"), for:.disabled)
//                self.recordBtn.addTarget(self, action:#selector(self.action(sender:), forControlEvents:.touchUpInside)
        self.recordBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.recordBtn?.layer.cornerRadius = (self.recordBtn?.frame.size.width ?? 0) * 0.5
        self.recordCtrlsView?.addSubview(self.recordBtn ?? UIButton())

//        var stopBtnFrame = CGRect(self.recordCtrlsView.frame.size.width - originX - btnSize, self.recordCtrlsView.frame.size.height * 0.5 - btnSize * 0.5, btnSize, btnSize)

//                if PTSHelper.isiPad() & (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_INDEXING) == K_SWITCH_ON) {
//                    stopBtnFrame.origin.y = self.recordCtrlsView.frame.size.height * 0.5 - btnSize
//                }

        self.stopBtn = UIButton(type: .custom)
        self.stopBtn?.frame = CGRect(x: (self.recordCtrlsView?.frame.size.width ?? 0) - originX - btnSize, y: (self.recordCtrlsView?.frame.size.height ?? 0) * 0.5 - btnSize * 0.5, width: btnSize, height: btnSize)
        self.stopBtn?.tag = TAG_STOP_BTN
        self.stopBtn?.setImage(UIImage(named: "record_stop_btn_normal"), for:.normal)
        self.stopBtn?.setImage(UIImage(named: "record_stop_btn_active"), for:.disabled)
//                self.stopBtn.addTarget(self, action:#selector(self.action(sender:), forControlEvents:.touchUpInside)
        self.stopBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.stopBtn?.layer.cornerRadius = (self.recordBtn?.frame.size.width ?? 0) * 0.5
        self.recordCtrlsView?.addSubview(self.stopBtn ?? UIButton())

//                if isAutoSavedFile {
//                    self.stopBtn.enabled = true
//                } else {
//                    self.stopBtn.enabled = false
//                }

        let timingLbl = UILabel()
        let xValue = Float(self.recordBtn?.frame.origin.x ?? 0) + Float(self.recordBtn?.frame.size.width ?? 0)
        let yValue = (self.recordBtn?.frame.origin.y ?? 0)
        let widthValue = (self.recordCtrlsView?.frame.size.width ?? 0) - (((self.recordBtn?.frame.origin.x ?? 0) + (self.recordBtn?.frame.size.width ?? 0)) + originX + btnSize)
        timingLbl.frame = CGRect(x: CGFloat(xValue), y: yValue, width: widthValue, height: btnSize)
        timingLbl.textColor = K_COLOR_DARK_COLOR
        timingLbl.text = K_START_TIME
        timingLbl.tag = TAG_TIMING_LBL
        timingLbl.textAlignment = .center
        timingLbl.font = UIFont(name: FONT_BOLD, size:30)
        timingLbl.backgroundColor = K_COLOR_CLEAR_COLOR
        self.recordCtrlsView?.addSubview(timingLbl)

        let overWriteLbl = UILabel(frame:CGRect(x: timingLbl.frame.origin.x, y: 0 , width: timingLbl.frame.size.width , height: 15))
        overWriteLbl.textColor = K_COLOR_PRIMARY_COLOR
        overWriteLbl.tag = TAG_OVERWRITE_LBL
        overWriteLbl.textAlignment = .center
        overWriteLbl.font = UIFont(name: FONT_BOLD, size:15)
        overWriteLbl.backgroundColor = K_COLOR_CLEAR_COLOR
        self.recordCtrlsView?.addSubview(overWriteLbl)

        let statusLbl = UILabel(frame:CGRect(x: timingLbl.frame.origin.x, y: timingLbl.frame.origin.y + timingLbl.frame.size.height , width: timingLbl.frame.size.width, height: 15))
        statusLbl.textColor = K_COLOR_DARK_COLOR
        statusLbl.text = K_RECORDING
        statusLbl.tag = TAG_STATUS_LBL
        statusLbl.textAlignment = .center
        statusLbl.font = UIFont(name: FONT_BOLD, size:12)
        statusLbl.backgroundColor = K_COLOR_CLEAR_COLOR
        statusLbl.alpha = 0.0
        self.recordCtrlsView?.addSubview(statusLbl)


        // PLAYER CONTROLS VIEW
        var playerCtrlsViewFrame = CGRect(x: 0, y: (self.recordCtrlsView?.frame.size.height ?? 0) + (self.recordCtrlsView?.frame.origin.y ?? 0), width: self.view.frame.size.width, height: 50)
        self.playerCtrlsView = UIView(frame:playerCtrlsViewFrame)
        self.playerCtrlsView?.backgroundColor = .yellow
        self.pageScrollView?.addSubview(self.playerCtrlsView ?? UIView())

        //Play button
        self.playBtn    = UIButton(type: .custom)
        let xForPlayBtn = ((self.playerCtrlsView?.frame.size.width ?? 0) * 0.5) - ((self.playerCtrlsView?.frame.size.height ?? 0) * 0.5)
        self.playBtn?.frame = CGRect(x: xForPlayBtn, y: 0, width: self.playerCtrlsView?.frame.size.height ?? 0, height: self.playerCtrlsView?.frame.size.height ?? 0)
        self.playBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.playBtn?.tag = TAG_PLAY_BTN
        self.playBtn?.setImage(UIImage(named: "existing_controls_play_btn_normal"), for:.normal)
        self.playBtn?.setImage(UIImage(named: "existing_controls_play_btn_disable"), for:.disabled)
//                self.playBtn.addTarget(self, action:#selector(self.action(sender:), forControlEvents:.touchUpInside)
        self.playerCtrlsView?.addSubview(self.playBtn ?? UIButton())

        //Rewind buttom
        btnSize    = (self.playerCtrlsView?.frame.size.height ?? 0) - 10
        self.rewindBtn = UIButton(type: .custom)
        self.rewindBtn?.frame = CGRect(x: (self.playBtn?.frame.origin.x ?? 0) - 15 - btnSize, y: (self.playerCtrlsView?.frame.size.height ?? 0) * 0.5 - btnSize * 0.5, width: btnSize, height: btnSize)
        self.rewindBtn?.tag = TAG_REWIND_BTN
        self.rewindBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.rewindBtn?.setImage(UIImage(named: "existing_rewind_normal"), for:.normal)
        self.rewindBtn?.setImage(UIImage(named: "existing_rewind_disable"), for:.disabled)
//        self.rewindBtn?.addTarget(self, action:Selector("rewindTouchUpInside:"), forControlEvents:.touchUpInside)
        self.playerCtrlsView?.addSubview(self.rewindBtn ?? UIButton())

//                let rewindBtn_LongPress_gesture:UILongPressGestureRecognizer! = UILongPressGestureRecognizer(target:self, action:Selector("handleBtnLongPressgesture:"))
//                self.rewindBtn.addGestureRecognizer(rewindBtn_LongPress_gesture)

        //Fast rewind button
        self.fastRewindBtn = UIButton(type: .custom)
        self.fastRewindBtn?.frame = CGRect(x: (self.rewindBtn?.frame.origin.x ?? 0) - 15 - btnSize, y: (self.playerCtrlsView?.frame.size.height ?? 0) * 0.5 - btnSize * 0.5, width: btnSize, height: btnSize)
        self.fastRewindBtn?.tag = TAG_FAST_REWIND_BTN
        self.fastRewindBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.fastRewindBtn?.setImage(UIImage(named: "existing_backward_fast_normal"), for:.normal)
        self.fastRewindBtn?.setImage(UIImage(named: "existing_backward_fast_disble"), for:.disabled)
//        self.fastRewindBtn.addTarget(self, action:Selector("fastRewindTouchUpInside:"), forControlEvents:.touchUpInside)
        self.playerCtrlsView?.addSubview(self.fastRewindBtn ?? UIButton())

//                let fastRewindBtn_LongPress_gesture:UILongPressGestureRecognizer! = UILongPressGestureRecognizer(target:self, action:Selector("handleBtnLongPressgesture:"))
//                self.fastRewindBtn.addGestureRecognizer(fastRewindBtn_LongPress_gesture)

        //Forward button
        self.forwardBtn = UIButton(type: .custom)
        self.forwardBtn?.frame = CGRect(x: (self.playBtn?.frame.size.width ?? 0) + (self.playBtn?.frame.origin.x ?? 0) + 15, y: (self.playerCtrlsView?.frame.size.height ?? 0) * 0.5 - btnSize * 0.5, width: btnSize, height: btnSize)
        self.forwardBtn?.tag = TAG_FORWARD_BTN
        self.forwardBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.forwardBtn?.setImage(UIImage(named: "existing_forward_normal"), for:.normal)
        self.forwardBtn?.setImage(UIImage(named: "existing_forward_disabel"), for:.disabled)
//        self.forwardBtn?.addTarget(self, action:Selector("forwardTouchUpinSide:"), forControlEvents:.touchUpInside)
        self.playerCtrlsView?.addSubview(self.forwardBtn ?? UIButton())

//                let forwardBtn_LongPress_gesture = UILongPressGestureRecognizer(target:self, action:Selector("handleBtnLongPressgesture:"))
//                self.forwardBtn.addGestureRecognizer(forwardBtn_LongPress_gesture)

        //Fast forward button
        self.fastForwardBtn = UIButton(type: .custom)
        self.fastForwardBtn?.frame = CGRect(x: (self.forwardBtn?.frame.origin.x ?? 0) + 15 + (self.forwardBtn?.frame.size.width ?? 0), y: (self.playerCtrlsView?.frame.size.height ?? 0) * 0.5 - btnSize * 0.5, width: btnSize, height: btnSize)
        self.fastForwardBtn?.tag = TAG_FAST_FORWARD_BTN
        self.fastForwardBtn?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.fastForwardBtn?.setImage(UIImage(named: "existing_forward_fast_normal"), for:.normal)
        self.fastForwardBtn?.setImage(UIImage(named: "existing_forward_fast_disable"), for:.disabled)
//        self.fastForwardBtn?.addTarget(self, action:Selector("fastForwardTouchUpinSide:"), forControlEvents:.touchUpInside)
        self.playerCtrlsView?.addSubview(self.fastForwardBtn ?? UIButton())

//                let fastForwardBtn_LongPress_gesture = UILongPressGestureRecognizer(target:self, action:Selector("handleBtnLongPressgesture:"))
//                self.fastForwardBtn.addGestureRecognizer(fastForwardBtn_LongPress_gesture)

//        self.playerButtonsEnable = false


        // DETAILS VIEW
        self.detailsView = UIView()
        let yForDetailsView = CGFloat(self.playerCtrlsView?.frame.size.height ?? 0) + CGFloat((self.playerCtrlsView?.frame.origin.y ?? 0) - 7.5)
        let heightFirstPart = (self.headerView?.frame.size.height ?? 0)
        let heightSecondtPart = (CGFloat(self.playerCtrlsView?.frame.size.height ?? 0) + CGFloat(self.playerCtrlsView?.frame.origin.y ?? 0))
        let heightForDetailsView = heightFirstPart - heightSecondtPart
        self.detailsView?.frame = CGRect(x: 0, y: yForDetailsView, width: self.view.frame.size.width, height: heightForDetailsView)
        self.detailsView?.backgroundColor = .red
        self.pageScrollView?.addSubview(self.detailsView ?? UIView())

   
        //fileNameTitleLbl
        var fileNameTitleLblFrame = CGRect(x: 7.5, y: 10 , width: 75, height: 20)
        let fileNameTitleLbl = UILabel(frame:fileNameTitleLblFrame)
        fileNameTitleLbl.textColor = K_COLOR_DARK_COLOR
        fileNameTitleLbl.tag = TAG_FILENAME_LBL
        fileNameTitleLbl.text = "File Name:"
        fileNameTitleLbl.textAlignment = .left
        fileNameTitleLbl.font = UIFont(name: FONT_BOLD, size:14)
        fileNameTitleLbl.backgroundColor = K_COLOR_CLEAR_COLOR
        self.detailsView?.addSubview(fileNameTitleLbl)
        
        
        //fileNameLbl
        var fileNameLblFrame = CGRect(x: fileNameTitleLbl.frame.origin.x + fileNameTitleLbl.frame.size.width , y: 10, width: (self.detailsView?.frame.size.width ?? 0) - (fileNameTitleLbl.frame.origin.x + fileNameTitleLbl.frame.size.width)  , height: 20)
        self.fileNameLbl = UILabel(frame:fileNameLblFrame)
        self.fileNameLbl?.textColor = K_COLOR_DARK_COLOR
        self.fileNameLbl?.textAlignment = .left
        self.fileNameLbl?.font = UIFont(name: FONT_NORMAL, size:12)
        self.fileNameLbl?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.detailsView?.addSubview(self.fileNameLbl ?? UILabel())

        //fileSizeTitleLbl
        var fileSizeTitleLblFrame = CGRect(x: fileNameTitleLbl.frame.origin.x, y: (fileNameLbl?.frame.origin.y ?? 0) + (fileNameLbl?.frame.size.height ?? 0) + 5 , width: 65, height: 20)
        let fileSizeTitleLbl = UILabel(frame:fileSizeTitleLblFrame)
        fileSizeTitleLbl.textColor = K_COLOR_DARK_COLOR
        fileSizeTitleLbl.text = "File Size:"
        fileSizeTitleLbl.textAlignment = .left
        fileSizeTitleLbl.font = UIFont(name: FONT_BOLD, size:14)
        fileSizeTitleLbl.backgroundColor = K_COLOR_CLEAR_COLOR
        self.detailsView?.addSubview(fileSizeTitleLbl)

        //file size label
        self.fileSizeLbl = UILabel()
        self.fileSizeLbl?.frame = CGRect(x: fileSizeTitleLbl.frame.origin.x + fileSizeTitleLbl.frame.size.width, y: fileSizeTitleLbl.frame.origin.y , width: (self.detailsView?.frame.size.width ?? 0) - (fileNameTitleLbl.frame.origin.x + fileNameTitleLbl.frame.size.width) , height: 20)
        self.fileSizeLbl?.textColor = K_COLOR_DARK_COLOR
        self.fileSizeLbl?.text = "0.00 Mb"
        self.fileSizeLbl?.tag = TAG_FILENAME_LBL
        self.fileSizeLbl?.textAlignment = .left
        self.fileSizeLbl?.font = UIFont(name: FONT_NORMAL, size:12)
        self.fileSizeLbl?.backgroundColor = K_COLOR_CLEAR_COLOR
        self.detailsView?.addSubview(self.fileSizeLbl ?? UILabel())

        //maxFileSizeTitleLbl
        var maxFileSizeTitleLblFrame = CGRect(x: fileSizeTitleLbl.frame.origin.x, y: (self.fileSizeLbl?.frame.origin.y ?? 0) + (self.fileNameLbl?.frame.size.height ?? 0) + 5 , width: 132, height: 20)
        let maxFileSizeTitleLbl = UILabel(frame:maxFileSizeTitleLblFrame)
        maxFileSizeTitleLbl.textColor = K_COLOR_DARK_COLOR
        maxFileSizeTitleLbl.text = "Max File Size Limit:"
        maxFileSizeTitleLbl.textAlignment = .left
        maxFileSizeTitleLbl.font = UIFont(name: FONT_BOLD, size:14)
        maxFileSizeTitleLbl.backgroundColor = K_COLOR_CLEAR_COLOR
        self.detailsView?.addSubview(maxFileSizeTitleLbl)

        //maxFileSizeLbl
        let maxFileSizeLbl = UILabel(frame:CGRect(x: maxFileSizeTitleLbl.frame.origin.x + maxFileSizeTitleLbl.frame.size.width , y: maxFileSizeTitleLbl.frame.origin.y , width: (self.detailsView?.frame.size.width ?? 0) - (fileNameTitleLbl.frame.origin.x + fileNameTitleLbl.frame.size.width) , height: 20))
        maxFileSizeLbl.textColor = K_COLOR_DARK_COLOR
        maxFileSizeLbl.text = "80 Mb"
        maxFileSizeLbl.textAlignment = .left
        maxFileSizeLbl.font = UIFont(name: FONT_NORMAL, size:12)
        maxFileSizeLbl.backgroundColor = K_COLOR_CLEAR_COLOR
        self.detailsView?.addSubview(maxFileSizeLbl ?? UILabel())

        
        
        
        
        
        //Bottom view
        self.bottomView = UIView(frame:CGRect(x: 0, y: Int(self.view.frame.size.height) - K_TABBAR_HEIGHT, width: Int(self.view.frame.size.width), height: K_TABBAR_HEIGHT))
        self.bottomView?.backgroundColor = UIColor(hex: 0xE6E6E6)
        self.bottomView?.alpha = 0.0
        self.view.addSubview(self.bottomView ?? UIView())

        //editRecord
        let btnWidth   = 90
        let editRecord = UIButton(type: .custom)
        let xForeditRecord = ((self.bottomView?.frame.size.width ?? 0) * 0.5) - (CGFloat(btnWidth) * 0.5)
        editRecord.frame = CGRect(x: Int(xForeditRecord), y: 15, width: btnWidth, height: 30)
        editRecord.tag = TAG_EDIT_RECORD_BTN
    //  editRecord.addTarget(self, action:#selector(self.action(sender:), forControlEvents:.touchUpInside)
        editRecord.backgroundColor = K_COLOR_CLEAR_COLOR
        editRecord.setImage(UIImage(named: "record_edit_btn_normal"), for:.normal)
        editRecord.setImage(UIImage(named: "record_edit_btn_disable"), for:.highlighted)
        self.bottomView?.addSubview(editRecord)

        //Save button
        let saveBtn   = UIButton(type: .custom)
        saveBtn.frame = CGRect(x: Int(editRecord.frame.origin.x) - btnWidth - 10, y: 15, width: btnWidth,  height: 30)
        saveBtn.tag = TAG_SAVE_BTN
//            saveBtn.addTarget(self, action:#selector(self.action(sender:), forControlEvents:.touchUpInside)
        saveBtn.setImage(UIImage(named: "record_save_btn_normal"), for:.normal)
        saveBtn.setImage(UIImage(named: "record_save_btn_highlighted"), for:.highlighted)
        self.bottomView?.addSubview(saveBtn)

        //Discard button
        let discardBtn   = UIButton(type: .custom)
        discardBtn.frame = CGRect(x: Int(editRecord.frame.origin.x) + btnWidth + 10, y: Int(saveBtn.frame.origin.y), width: btnWidth,  height: 30)
        discardBtn.backgroundColor = K_COLOR_CLEAR_COLOR
        discardBtn.tag = TAG_DISCARD_BTN
//        discardBtn.addTarget(self, action:#selector(self.action(sender:), forControlEvents:.touchUpInside)
        discardBtn.setImage(UIImage(named: "discard_btn_normal"), for: .normal)
        discardBtn.setImage(UIImage(named: "discard_btn_highlighted"), for: .highlighted)
        self.bottomView?.addSubview(discardBtn)

        isEdit = false
        AppDelegate.sharedInstance().userDefaults.set("0", forKey:K_KEY_IS_EDITING)
    }


    // MARK: - UISEGMENT CONTROL EVENT METHODS
    @objc func segmentedControlValueDidChange(segment:UISegmentedControl) {
//        isStopBtnTappedWhileOverwriting = false
//        switch (segment.selectedSegmentIndex) {
//
//
//
//            case 0:
//
//                if !self.isRecordPermissionGiven() {
//                    let disbleAlert:UIAlertView! = UIAlertView(title:"Microphone Access Denied", message:"This app requires access to your device's Microphone.\n\nPlease enable Microphone access for this app in Settings / Privacy / Microphone", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:nil)
//                    disbleAlert.tag = TAG_RECORD_PERMISSION_DENIED
//                    disbleAlert.show()
//                    segmentedControl?.selectedSegmentIndex = -1
//                    return
//                }
//
//                editMode = 0
//
//            let thePlayerduration = Float(CMTimeGetSeconds(self.thePlayerItem?.asset.duration))
//            self.recordedFileDuration = Double(lroundf(thePlayerduration))
//            self.waveFormSlider?.alpha = 1.0
//
//            self.waveFormSlider?.maximumValue = Float(lroundf(thePlayerduration))
//            self.waveformView?.progressTime = CMTimeMakeWithSeconds(Float64(lroundf(thePlayerduration)), preferredTimescale: 10000)
//            self.waveFormSlider?.setValue(Float(lroundf(thePlayerduration)), animated:true)
//
//            let currentTime = self.view.viewWithTag(TAG_CURRENTTIME_LBL)
//            currentTime.text = String(format:"%@ | %@", self.timeFormatted(totalSeconds: lroundf(thePlayerduration)),self.timeFormatted(totalSeconds: lroundf(thePlayerduration)))
//
//                let delayInSeconds:Double = 0.5
//            let popTime = dispatch_time(.now(), ((delayInSeconds * NSEC_PER_SEC) as! int64_t))
//            dispatch_after(popTime, dispatch_get_main_queue(), { ($arg1) in
//
//                let (TypeName) = arg1
//                self.pauseAudioPlayer()
//                })
//
//                self.didFinishOverwrite()
//
//               // [self.waveFormSlider setValue:1 animated:YES];
//                if (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_DISABLE_POPUP) == K_SWITCH_OFF) {
//
//                    self.customRangeBar?.alpha = 0.0
//
//                    let alert = UIAlertView(title:"Append", message:"When the append function is selected, the cursor will automatically move to the end of the original recording. If you want the Append to start at a different point, move the cursor to a desired point and tap the orange Record button to start the Append function.", delegate:self, cancelButtonTitle:"OK", otherButtonTitles:nil, nil)
//                    alert.tag = TAG_EDIT_APPEND
//                    alert.show()
//                }
//
//                break
//
//            case 1:
//
//                if !self.isRecordPermissionGiven() {
//                    let disbleAlert:UIAlertView! = UIAlertView(title:"Microphone Access Denied", message:"This app requires access to your device's Microphone.\n\nPlease enable Microphone access for this app in Settings / Privacy / Microphone", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:nil)
//                    disbleAlert.tag = TAG_RECORD_PERMISSION_DENIED
//                    disbleAlert.show()
//                    segmentedControl?.selectedSegmentIndex = -1
//                    return
//                }
//
//                editMode = 1
//                if (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_DISABLE_POPUP) == K_SWITCH_ON) {
//                    self.showOverwriteView()
//                } else {
//
//                    let alert = UIAlertView(title:"Insert", message:"To start insert, tap the Start Point button marker whilst listening to the audio. Tap the Start Inserting button to initiate the insert. The insert will end when the orange Stop button is tapped.", delegate:self, cancelButtonTitle:"OK", otherButtonTitles:nil, nil)
//                    alert.tag = TAG_EDIT_INSERT
//                    alert.show()
//                }
//
//                break
//
//            case 2:
//
//                if !self.isRecordPermissionGiven() {
//                    let disbleAlert:UIAlertView! = UIAlertView(title:"Microphone Access Denied", message:"This app requires access to your device's Microphone.\n\nPlease enable Microphone access for this app in Settings / Privacy / Microphone", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:nil)
//                    disbleAlert.tag = TAG_RECORD_PERMISSION_DENIED
//                    disbleAlert.show()
//                    segmentedControl?.selectedSegmentIndex = -1
//                    return
//                }
//
//                editMode = 2
//            if (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_DISABLE_POPUP) == K_SWITCH_ON) {
//                    self.showOverwriteView()
//                } else {
//                    //[APPDELEGATE.userDefaults setBool:YES forKey:K_OVERWRITING];
//
//                    let alert:UIAlertView! = UIAlertView(title:"Overwrite", message:"To start overwrite, tap the Start Point and End Point button markers whilst listening to the audio. The End Point button determines where the overwrite finishes. Tap the Start Overwriting button to initiate the overwrite. The overwrite will end when the End Point marker is reached.", delegate:self, cancelButtonTitle:"OK", otherButtonTitles:nil, nil)
//                    alert.tag = TAG_START_OVERWRITE_BTN
//                    alert.show()
//                }
//
//
//                break
//
//            case 3:
//
//                // [self showPartialDeleteView];
//                editMode = 3
//            if (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_DISABLE_POPUP) == K_SWITCH_ON) {
//                    self.showOverwriteView()
//                } else {
//                    let alert:UIAlertView! = UIAlertView(title:"Partial Delete", message:"To start partial delete, tap the Start Point and End Point button markers whilst listening to the audio. The End Point button determines where the partial delete finishes. Tap the Start Deleting button to initiate the partial delete. The partial delete will end when the End Point marker is reached.", delegate:self, cancelButtonTitle:"OK", otherButtonTitles:nil, nil)
//                    alert.tag = TAG_EDIT_PARTIAL_DELETE
//                    alert.show()
//                }
//
//                break
//
//            default:
//                self.hidePartialDeleteView()
//                break
//        }

    }

    // MARK: -
    // MARK: UILongPressGestureRecognizer CALL BACKS

    func rewindTouchUpInside(sender:AnyObject) {
        self.rewindTimer?.invalidate()
        self.rewindTimer = nil
        self.rewindFunctionality()
    }

    func fastRewindTouchUpInside(sender:AnyObject) {
        self.fastRewindTimer?.invalidate()
        self.fastRewindTimer = nil
        self.fastRewindFunctionality()
    }

    func forwardTouchUpinSide(sender:AnyObject) {
        self.forwardTimer?.invalidate()
        self.forwardTimer = nil
        self.forwardFunctionality()
    }

    func fastForwardTouchUpinSide(sender:AnyObject) {
        self.fastForwardTimer?.invalidate()
        self.fastForwardTimer = nil
        self.fastForwardFunctionality()
    }

    func rewindFunctionality() {
//        self.rewindTapped(sender: self.rewindBtn)
    }

    func fastRewindFunctionality() {
//        self.fastRewindTapped(sender: self.fastRewindBtn)
    }

    func forwardFunctionality() {
//        self.forwardTapped(sender: self.forwardBtn)
    }

    func fastForwardFunctionality() {
//        self.fastForwardTapped(sender: self.fastForwardBtn)
    }

//    func handleBtnLongPressgesture(recognizer:UILongPressGestureRecognizer!) {
//
//                if recognizer.view?.tag == TAG_REWIND_BTN {
//
//            //as you hold the button this would fire
//
//            if recognizer.state == .began {
//                self.rewindTimer = Timer.scheduledTimerWithTimeInterval(0.1,  target:self, selector:Selector("rewindFunctionality"), userInfo:nil, repeats:true)
//            }
//
//            //as you release the button this would fire
//
//            if recognizer.state == .ended {
//                self.rewindTimer?.invalidate()
//                self.rewindTimer = nil
//            }
//        }
//
//        if recognizer.view.tag == TAG_FAST_REWIND_BTN {
//
//            //as you hold the button this would fire
//
//            if recognizer.state == .began {
//                self.fastRewindTimer = Timer.scheduledTimer(timeInterval: 0.1,  target:self, selector:Selector("fastRewindFunctionality"),
//                                                                      userInfo:nil, repeats:true)
//            }
//
//            //as you release the button this would fire
//
//            if recognizer.state == .ended {
//                self.fastRewindTimer?.invalidate()
//                self.fastRewindTimer = nil
//            }
//        }
//
//                if recognizer.view?.tag == TAG_FORWARD_BTN {
//
//            //as you hold the button this would fire
//
//            if recognizer.state == .began {
//                self.forwardTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:Selector("forwardFunctionality"),
//                                                                   userInfo:nil, repeats:true)
//            }
//
//            //as you release the button this would fire
//
//            if recognizer.state == .ended {
//                self.forwardTimer?.invalidate()
//                self.forwardTimer = nil
//            }
//
//        }
//
//                if recognizer.view?.tag == TAG_FAST_FORWARD_BTN {
//
//            //as you hold the button this would fire
//
//            if recognizer.state == .began {
//                self.fastForwardTimer = Timer.scheduledTimerWithTimeInterval(0.1,  target:self, selector:Selector("fastForwardFunctionality"),
//                                                                       userInfo:nil, repeats:true)
//            }
//
//            //as you release the button this would fire
//            if recognizer.state == .ended {
//                self.fastForwardTimer?.invalidate()
//                self.fastForwardTimer = nil
//            }
//        }
//    }

    // MARK: -
    // MARK: BUTTON CALL BACKS
//   @objc func action(sender:UIButton) {
//        switch (sender.tag) {
//            case TAG_RECORD_BTN:
//                if self.isRecordPermissionGiven() {
//                    if editMode == 1 {
//
//                        if self.stringsAreEqual() {
//
//                            let saveAlert:UIAlertView! = UIAlertView(title:"PTS Dictate", message:"Start Point should not be end of the file.", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles: nil)
//                            //saveAlert.tag = TAG_END_OVERWRITE_BTN;
//                            saveAlert.show()
//                            return
//                        }
//                    }
//
//                    self.recordButtonTapped(self.recordBtn, flag:false)
//                } else {
//                    let disbleAlert:UIAlertView! = UIAlertView(title:"Microphone Access Denied", message:"This app requires access to your device's Microphone.\n\nPlease enable Microphone access for this app in Settings / Privacy / Microphone", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:nil)
//                    disbleAlert.tag = TAG_RECORD_PERMISSION_DENIED
//                    disbleAlert.show()
//                }
//                break
//
//            case TAG_STOP_BTN:
//                self.recordStopButtonTapped(false, button:self.stopBtn)
//                break
//
//            case TAG_PLAY_BTN:
//
//                self.playTapped(sender)
//
//                break
//
//            case TAG_BOOKMARK_BTN:
//                self.bookMarkButtonTapped(sender)
//                break
//
//            case TAG_BOOKMARK_BACKWARD_BTN:
//                self.bookMarkBackWardButtonTapped()
//                break
//
//            case TAG_BOOKMARK_FORWARD_BTN:
//                self.bookMarkForWardButtonTapped()
//                break
//
//            case TAG_ERASE_BTN:
//            self.eraseBtnTapped(sender: sender)
//                break
//
//            case TAG_START_POINT_BTN:
//            self.startPointBtnTapped(sender: sender)
//                break
//
//            case TAG_END_POINT_BTN:
//            self.endPointBtnTapped(sender: sender)
//                break
//
//            case TAG_START_OVERWRITE_BTN:
//            self.startOverwriteBtnTapped(sender: sender)
//                break
//
//            case TAG_SAVE_BTN:
//
//                self.stopAudioPlayer()
//                PTSHELPER.buttonAnimation = sender
//                self.saveBtnTapped()
//
//                break
//
//            case TAG_DISCARD_BTN:
//
//                PTSHELPER.buttonAnimation = sender
//
//                self.stopAudioPlayer()
//
//                let alert:UIAlertView! = UIAlertView(title:K_KEY_APP_TITLE, message:"Do you want to discard the current Recording?", delegate:self, cancelButtonTitle:K_YES, otherButtonTitles:K_NO, nil)
//                alert.tag = TAG_DISCARD_ALERT_TAG
//                alert.show()
//
//                break
//
//            case TAG_CLEAR_INDEX_BTN:
//            self.clearButtonTapped(sender: sender)
//                break
//
//            case TAG_EDIT_RECORD_BTN:
//            self.editRecordButtonTapped(sender: sender)
//                break
//
//
//            default:
//                break
//        }
//    }

    func editRecordButtonTapped(sender:UIButton!) {
//        self.segmentedControl?.selectedSegmentIndex = UISegmentedControlNoSegment
//
//        isEditButtonTapped = true
//
//        PTSHELPER.buttonAnimation = sender
//
//        self.recordBtn?.enabled = false
//        self.stopBtn?.enabled = true
//
//        //NSLog(@"=======> editRecordButtonTapped <========");
//        self.stopAudioPlayer()
//        isLimitReached = false
//        isUploadWarning = false
//        isRecordStopTapped = false
//
//        self.hideSaveBottomView()
    }

//    func clearButtonTapped(sender:UIButton) {
//        if Int(sliderValue) == BOOKMARK_1 {
//            self.bookMarkArr?.remove(at: 0)
//        }else if Int(sliderValue) == BOOKMARK_2{
//            self.bookMarkArr?.remove(at: 1)
//        }else if Int(sliderValue) == BOOKMARK_3{
//            self.bookMarkArr?.remove(at: 2)
//        }else if Int(sliderValue) == BOOKMARK_4{
//            self.bookMarkArr?.remove(at: 3)
//        }else if Int(sliderValue) == BOOKMARK_5 {
//            self.bookMarkArr?.remove(at: 4)
//        }else if Int(sliderValue) == BOOKMARK_6{
//            self.bookMarkArr?.remove(at: 5)
//        }else if Int(sliderValue) == BOOKMARK_7{
//            self.bookMarkArr?.remove(at: 6)
//        }else if Int(sliderValue) == BOOKMARK_8{
//            self.bookMarkArr?.remove(at: 7)
//        }else if Int(sliderValue) == BOOKMARK_9{
//            self.bookMarkArr?.remove(at: 8)
//        }else if Int(sliderValue) == BOOKMARK_10{
//            self.bookMarkArr?.remove(at: 9)
//        } else if Int(sliderValue) == BOOKMARK_11{
//            self.bookMarkArr?.remove(at: 10)
//        }else if Int(sliderValue) == BOOKMARK_12{
//            self.bookMarkArr?.remove(at: 11)
//        }else if Int(sliderValue) == BOOKMARK_13{
//            self.bookMarkArr?.remove(at: 12)
//        }else if Int(sliderValue) == BOOKMARK_14{
//            self.bookMarkArr?.remove(at: 13)
//        }else if Int(sliderValue) == BOOKMARK_15{
//            self.bookMarkArr?.remove(at: 14)
//        }else if Int(sliderValue) == BOOKMARK_16{
//            self.bookMarkArr?.remove(at: 15)
//        }else if Int(sliderValue) == BOOKMARK_17{
//            self.bookMarkArr?.remove(at: 16)
//        }else if Int(sliderValue) == BOOKMARK_18 {
//            self.bookMarkArr?.remove(at: 17)
//        }else if Int(sliderValue) == BOOKMARK_19{
//            self.bookMarkArr?.remove(at: 18)
//        }else if Int(sliderValue) == BOOKMARK_20{
//            self.bookMarkArr?.remove(at: 19)
//        }
//
//        self.createBookMarKDivider()
//    }

//    func bookMarkBackWardButtonTapped() {
//        self.bookmarkFordwardBtn?.isEnabled = true
//        self.pauseArr?.removeAllObjects()
//
//        var currentTime = 0.0
//
//        if Int(sliderValue) == BOOKMARK_1 {
//            sliderValue = 0
//            self.bookmarkBackwardBtn?.isEnabled = false
//            self.showBookMark(flag: 0)
//            currentTime = 0.0
//        }else if Int(sliderValue) == BOOKMARK_2 {
//            sliderValue = 1
//            self.showBookMark(flag: 1)
////            currentTime = self.convertSecs(string: self.bookMarkArr?.object(at: 0))
//        }else if Int(sliderValue) == BOOKMARK_3 {
//            sliderValue = 2
//            self.showBookMark(flag: 2)
////            currentTime = self.convertSecs(string: self.bookMarkArr?.object(at: 1)).floatValue
//        }else if Int(sliderValue) == BOOKMARK_4 {
//            sliderValue = 3
//            self.showBookMark(flag: 3)
////            currentTime = self.convertSecs(string: self.bookMarkArr?.object(at: 2)).floatValue
//        }else if Int(sliderValue) == BOOKMARK_5 {
//            sliderValue = 4
//            self.showBookMark(flag: 4)
////            currentTime = self.convertSecs(string: self.bookMarkArr?.object(at: 3)).floatValue
//        }else if Int(sliderValue) == BOOKMARK_6 {
//            sliderValue = 5
//            self.showBookMark(flag: 5)
////            currentTime = self.convertSecs(string: self.bookMarkArr?.object(at: 4)).floatValue
//        }else if Int(sliderValue) == BOOKMARK_7 {
//            sliderValue = 6
////            currentTime = self.convertSecs(string: self.bookMarkArr?.object(at: 5)).floatValue
//            self.showBookMark(flag: 6)
//        }else if Int(sliderValue) == BOOKMARK_8 {
//            sliderValue = 7
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(6)).floatValue()
//            self.showBookMark(flag: 7)
//        }else  if Int(sliderValue) == BOOKMARK_9 {
//            sliderValue = 8
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(7)).floatValue()
//            self.showBookMark(flag: 8)
//        }else if Int(sliderValue) == BOOKMARK_10 {
//            sliderValue = 9
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(8)).floatValue()
//            self.showBookMark(flag: 9)
//        }else  if Int(sliderValue) == BOOKMARK_11 {
//            sliderValue = 10
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(9)).floatValue()
//            self.showBookMark(flag: 10)
//        }else if Int(sliderValue) == BOOKMARK_12 {
//            sliderValue = 11
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(10)).floatValue()
//            self.showBookMark(flag: 11)
//        }else if Int(sliderValue) == BOOKMARK_13 {
//            sliderValue = 12
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(11)).floatValue()
//            self.showBookMark(flag: 12)
//        }else if Int(sliderValue) == BOOKMARK_14 {
//            sliderValue = 13
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(12)).floatValue()
//            self.showBookMark(flag: 13)
//        }else if Int(sliderValue) == BOOKMARK_15 {
//            sliderValue = 14
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(13)).floatValue()
//            self.showBookMark(flag: 14)
//        }else if Int(sliderValue) == BOOKMARK_16 {
//            sliderValue = 15
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(14)).floatValue()
//            self.showBookMark(flag: 15)
//        }else if Int(sliderValue) == BOOKMARK_17 {
//            sliderValue = 16
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(15)).floatValue()
//            self.showBookMark(flag: 16)
//        }else  if Int(sliderValue) == BOOKMARK_18 {
//            sliderValue = 17
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(16)).floatValue()
//            self.showBookMark(flag: 17)
//        }
//        else if Int(sliderValue) == BOOKMARK_19 {
//            sliderValue = 18
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(17)).floatValue()
//            self.showBookMark(flag: 18)
//        }else if Int(sliderValue) == BOOKMARK_20 {
//            sliderValue = 19
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(18)).floatValue()
//            self.showBookMark(flag: 19)
//        }
//
//        let newTime:CMTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 1)
//
//        self.updateTime(newTime: newTime)
//
//    }


//    func bookMarkForWardButtonTapped() {
//        self.bookmarkBackwardBtn?.isEnabled = true
//        self.pauseArr?.removeAllObjects()
//        self.clearIndex?.isEnabled = true
//
//        var currentTime = 0.0
//
//        if sliderValue == 0 {
//            sliderValue = 1
//            if self.bookMarkArr?.count == 1 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(0)).floatValue()
//            self.showBookMark(flag: 1)
//        }else if sliderValue == 1 {
//            sliderValue = 2
//            if self.bookMarkArr?.count == 2 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(1)).floatValue()
//            self.showBookMark(flag: 2)
//        }else if sliderValue == 2 {
//            sliderValue = 3
//            if self.bookMarkArr?.count == 3 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(2)).floatValue()
//            self.showBookMark(flag: 3)
//        }else if sliderValue == 3 {
//            sliderValue = 4
//            if self.bookMarkArr?.count == 4 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(3)).floatValue()
//            self.showBookMark(flag: 4)
//        }else if sliderValue == 4 {
//            sliderValue = 5
//            if self.bookMarkArr?.count == 5 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(4)).floatValue()
//            self.showBookMark(flag: 5)
//
//        }else if sliderValue == 5 {
//            sliderValue = 6
//            if self.bookMarkArr?.count == 6 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
//
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(5)).floatValue()
//            self.showBookMark(flag: 6)
//        }else if sliderValue == 6 {
//            sliderValue = 7
//            if self.bookMarkArr?.count == 7 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(6)).floatValue()
//            self.showBookMark(flag: 7)
//
//        }else if sliderValue == 7 {
//            sliderValue = 8
//            if self.bookMarkArr?.count == 8 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(7)).floatValue()
//            self.showBookMark(flag: 8)
//
//        }else if sliderValue == 8 {
//            sliderValue = 9
//            if self.bookMarkArr?.count == 9 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(8)).floatValue()
//            self.showBookMark(flag: 9)
//        }else if sliderValue == 9 {
//            sliderValue = 10
//            if self.bookMarkArr?.count == 10 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
//
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(9)).floatValue()
//            self.showBookMark(flag: 10)
//
//        }else if sliderValue == 10 {
//            sliderValue = 11
//            if self.bookMarkArr?.count == 11 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
//
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(10)).floatValue()
//            self.showBookMark(flag: 11)
//        }else if sliderValue == 11 {
//            sliderValue = 12
//            if self.bookMarkArr?.count == 12 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
//
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(11)).floatValue()
//            self.showBookMark(flag: 12)
//        }else if sliderValue == 12 {
//            sliderValue = 13
//            if self.bookMarkArr?.count == 13 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(12)).floatValue()
//            self.showBookMark(flag: 13)
//        }else if sliderValue == 13 {
//            sliderValue = 14
//            if self.bookMarkArr?.count == 14 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(13)).floatValue()
//            self.showBookMark(flag: 14)
//        }else if sliderValue == 14 {
//            sliderValue = 15
//            if self.bookMarkArr?.count == 15 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(14)).floatValue()
//            self.showBookMark(flag: 15)
//        }else if sliderValue == 15 {
//            sliderValue = 16
//            if self.bookMarkArr?.count == 16 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(15)).floatValue()
//            self.showBookMark(flag: 16)
//        }
//        else if sliderValue == 16 {
//            sliderValue = 17
//            if self.bookMarkArr?.count == 17 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
//
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(16)).floatValue()
//
//            self.showBookMark(flag: 17)
//
//        }else if sliderValue == 17 {
//            sliderValue = 18
//            if self.bookMarkArr?.count == 18 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
//
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(17)).floatValue()
//            self.showBookMark(flag: 18)
//
//        }else if sliderValue == 18 {
//            sliderValue = 19
//            if self.bookMarkArr?.count == 19 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(18)).floatValue()
//            self.showBookMark(flag: 19)
//        }else if sliderValue == 19 {
//            sliderValue = 20
//            if self.bookMarkArr?.count == 20 {
//                self.bookmarkFordwardBtn?.isEnabled = false
//            }
////            currentTime = self.convertSecs(self.bookMarkArr.objectAtIndex(19)).floatValue()
//            self.showBookMark(flag: 20)
//        }
//
//        let newTime:CMTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: 1)
//        self.updateTime(newTime: newTime)
//
//    }
    
//    func bookMarkButtonTapped(sender:UIButton!) {
//            isBookMarkTap = true
//            bookMarTapCount += 1
//
//            if bookMarTapCount == 20 {
//                self.bookmarkBtn?.isEnabled = false
//            }
//
//            let timing = self.view.viewWithTag(TAG_TIMING_LBL)
//            let currentTimeLabel = self.view.viewWithTag(TAG_CURRENTTIME_LBL)
//            let overWrite = self.view.viewWithTag(TAG_OVERWRITE_LBL)
//            let playerTime = UILabel()
//
//            let bookTime:String! = String(format:"%@",self.timeFormatted(lroundf(playerCurrentTime)))
//
//            NSLog("TIMING TEXT ===> %@", bookTime)
//
//            if self.isPlaying()
//            {
//                NSLog("INDEXING WHILE PLAYING  @@@@@@@@@@@")
//                let time:CMTime = self.thePlayer?.currentItem.currentTime
//                let durationInSeconds:Double = CMTimeGetSeconds(time)
//
//                //NSLog(@"CURRENT TIME ==> %f", CMTimeGetSeconds(time));
//
//                //UILabel *timing = (UILabel*)[self.view viewWithTag:2000];
//
//                //UILabel *timing = [[UILabel alloc] init];
//
//                playerTime.text = self.timeFormatted((floor(durationInSeconds)))
//            }
//            if (timing.text == K_START_TIME)
//            {
//                bookMarTapCount--
//                PTSHELPER.showErrorNoticeView(self, title:K_KEY_APP_TITLE, message:"Index not possible at starting.")
//                return
//            }
//
//            NSLog("PlayerTime:%@",playerTime.text)
//            NSLog("BookTime:%@",bookTime)
//            if ((bookTime == K_START_TIME) && self.isPlaying()) || (playerTime.text == nil && self.isPlaying()) || ((playerTime.text == K_START_TIME) && self.isPlaying()) {
//                bookMarTapCount--
//                PTSHELPER.showErrorNoticeView(self, title:K_KEY_APP_TITLE, message:"Index not possible at starting.")
//                return
//            }
//            // Commented below line to fix PTS-18
//            //else if ([self.bookMarkArr containsObject:timing.text]) {
//            else if self.bookMarkArr.containsObject(playerTime.text) {
//                bookMarTapCount--
//                PTSHELPER.showErrorNoticeView(self, title:K_KEY_APP_TITLE, message:"Already indexed.")
//            }
//
//            else  if self.bookMarkArr.containsObject(overWrite.text) {
//                bookMarTapCount--
//                PTSHELPER.showErrorNoticeView(self, title:K_KEY_APP_TITLE, message:"Already indexed.")
//            }
//
//            else
//            {
//                if (playerCurrentTime != 0  && self.segmentedControl.selectedSegmentIndex == 2) || (playerCurrentTime != 0  && self.segmentedControl.selectedSegmentIndex == 1) {
//
//                    if self.recordedFileDuration < (self.audio_Recorder.currentTime + playerCurrentTime) {
//                        self.bookMarkArr.addObject(timing.text)
//                    }
//                    else
//                    {
//                        self.bookMarkArr.addObject(overWrite.text)
//                    }
//                } else if self.isPlaying()
//                {
//                    NSLog("INDEXING WHILE PLAYING  @@@@@@@@@@@")
//                    /*  CMTime time = self.thePlayer.currentItem.currentTime;
//                     double durationInSeconds = CMTimeGetSeconds(time);
//
//                     UILabel *timing = (UILabel*)[self.view viewWithTag:TAG_TIMING_LBL];
//
//                     timing.text = [self timeFormatted:(lroundf(durationInSeconds))]; */
//
//                    self.bookMarkArr.addObject(playerTime.text)
//                } else {
//                    // Added condition to fix PTS-24
//                    if self.bookMarkArr.containsObject(timing.text) {
//                        bookMarTapCount--
//                        PTSHELPER.showErrorNoticeView(self, title:K_KEY_APP_TITLE, message:"Already indexed.")
//                    } else {
//                        self.bookMarkArr.addObject(timing.text)
//                    }
//                }
//
//                NSLog("BOOKMARK ARRAY ===> %@", self.bookMarkArr)
//
//                /*    if ([self isPlaying])
//                 {
//                 NSLog(@"INDEXING WHILE PLAYING  @@@@@@@@@@@");
//                 CMTime time = self.thePlayer.currentItem.currentTime;
//                 double durationInSeconds = CMTimeGetSeconds(time);
//
//                 UILabel *timing = (UILabel*)[self.view viewWithTag:TAG_TIMING_LBL];
//
//                 timing.text = [self timeFormatted:(lroundf(durationInSeconds))];
//
//                 [self.bookMarkArr addObject:timing.text];
//                 } */
//
//                self.createBookMarKDivider()
//            }
//
//            // NSLog(@"==============> self.bookMarkArr <=============== :%@", self.bookMarkArr);
//
//            self.bookmarkFordwardBtn.enabled = self.bookmarkBackwardBtn.enabled = false
//        }
    
    //one function pending there
    
//    func startPointBtnTapped(sender:UIButton) {
//
//        //    [PTSHELPER setFloatingAnimation:self.startPointBtn float:0.9f];
//
//        if editMode == 1 || editMode == 2 || editMode == 3 {
//
//            if self.stringsAreEqual() {
//
//                let saveAlert:UIAlertView! = UIAlertView(title:"PTS Dictate", message:"Start Point should not be end of the file.", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles: nil)
//                saveAlert.tag = TAG_END_OVERWRITE_BTN
//                saveAlert.show()
//
//                self.pauseAudioPlayer()
//
//                return
//            }
//        }
//
//        let x:Float = self.xPositionFromSliderValue(self.waveFormSlider)
//
//        let playerItem:AVPlayerItem! = self.thePlayer.currentItem
//        let currentTime:CMTime = playerItem.currentTime
//
//        // PTS-131 round of to floor change
//        startPointTime = floor(CMTimeGetSeconds(currentTime))//lroundf(CMTimeGetSeconds(currentTime));
//
//        if startPointTime == 0
//            {startPointTime = 1}
//
//        startPointView = UIView(frame:CGRect(x, 2, 2, 35))
//        startPointView.backgroundColor = UIColor.darkGrayColor()
//        self.waveformView.addSubview(startPointView)
//
//        let  origin:Float = startPointView.frame.origin.x - 15
//
//        lblStartPoint = UILabel(frame:CGRect(origin, startPointView.frame.origin.y + startPointView.frame.size.height - 3, 30, 15))
//        lblStartPoint.backgroundColor = K_COLOR_CLEAR_COLOR
//        lblStartPoint.textColor = K_COLOR_DARK_COLOR
//
//        if PTSHelper.isiPad() {
//            lblStartPoint.font = UIFont.fontWithName(FONT_NORMAL, size:6)
//        } else {
//            lblStartPoint.font = UIFont.fontWithName(FONT_NORMAL, size:10)
//        }
//
//        lblStartPoint.textAlignment = NSTextAlignmentCenter
//        let time:CMTime = self.thePlayer.currentItem.currentTime
//        let durationInSeconds:Double = CMTimeGetSeconds(time)
//        lblStartPoint.text = self.timeShorted(self.timeFormatted((floor(durationInSeconds))))
//
//        if lblStartPoint.text.length() == 0 {
//
//            lblStartPoint.text = "1s"
//        }
//
//        //NSLog(@"lblStartPoint.text ==> %@  %d", lblStartPoint.text, [lblStartPoint.text length]);
//        self.waveformView.addSubview(lblStartPoint)
//
//        if self.segmentedControl.selectedSegmentIndex == 1 || editMode == 1 {
//            self.startOverwriteBtn.tag = TAG_START_OVERWRITE_BTN
//            //[self.startOverwriteBtn setTitle:@"Start Inserting" forState:UIControlStateNormal];
//            self.startOverwriteBtn.setImage(K_SETIMAGE("btn_start_inserting_normal.png"), forState:UIControlStateNormal)
//            self.startOverwriteBtn.setImage(K_SETIMAGE("btn_start_inserting_highlight.png"), forState: UIControlStateHighlighted)
//            self.startOverwriteBtn.alpha = 1
//            self.playTapped(self.playBtn)
//
//            self.recordBtn.enabled = FALSE
//            self.recordBtn.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)
//        } else if self.segmentedControl.selectedSegmentIndex == 3 || editMode == 3 {
//            self.startOverwriteBtn.setImage(K_SETIMAGE("btn_start_deleting_normal.png"), forState:UIControlStateNormal)
//            self.startOverwriteBtn.setImage(K_SETIMAGE("btn_start_deleting_highlight.png"), forState: UIControlStateHighlighted)
//            //[self.startOverwriteBtn setTitle:@"Start Deleting" forState:UIControlStateNormal];
//            self.endPointBtn.alpha = 1.0
//        } else {
//            //[self.startOverwriteBtn setTitle:@"Start Overwriting" forState:UIControlStateNormal];
//            self.startOverwriteBtn.setImage(K_SETIMAGE("btn_start_overwriting_normal.png"), forState:UIControlStateNormal)
//            self.startOverwriteBtn.setImage(K_SETIMAGE("btn_start_overwriting_highlight.png"), forState: UIControlStateHighlighted)
//            self.endPointBtn.alpha = 1.0
//        }
//
//        self.startPointBtn.alpha = 0.0
//    }
    
    func endPointBtnTapped(sender:UIButton) {
        
        //    [PTSHELPER setFloatingAnimation:self.endPointBtn float:0.9f];
        
//        let x:Float = self.xPositionFromSliderValue(self.waveFormSlider)
//
//        let playerItem:AVPlayerItem! = self.thePlayer.currentItem
//        let currentTime:CMTime = playerItem.currentTime
//        endPointTime = ceil(CMTimeGetSeconds(currentTime))//lroundf(CMTimeGetSeconds(currentTime));
//
//        if startPointTime >= endPointTime || (startPointTime >= endPointTime - 1 && self.isPlaying()) {
//
//            let saveAlert:UIAlertView! = UIAlertView(title:"PTS Dictate", message:"End Point should be greater than Start Point", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles: nil)
//            saveAlert.tag = TAG_END_OVERWRITE_BTN
//            saveAlert.show()
//
//            //        // Added below code to fix PTS-26
//            //        if (self.segmentedControl.selectedSegmentIndex == 2){
//            //            isRecordStopTapped = true;
//            //        }
//
//            self.pauseAudioPlayer()
//
//            return
//        }
//
//        endPointView = UIView(frame:CGRect(x, 2, 2, 35))
//        endPointView.backgroundColor = UIColor.darkGrayColor()
//        self.waveformView.addSubview(endPointView)
//
//        let  origin:Float = endPointView.frame.origin.x - 15
//
//        lblEndPoint = UILabel(frame:CGRect(origin, endPointView.frame.origin.y + endPointView.frame.size.height - 3, 30, 15))
//        lblEndPoint.backgroundColor = K_COLOR_CLEAR_COLOR
//        lblEndPoint.textColor = K_COLOR_DARK_COLOR
//        if PTSHelper.isiPad() {
//
//            lblEndPoint.font = UIFont.fontWithName(FONT_NORMAL, size:6)
//        } else {
//            lblEndPoint.font = UIFont.fontWithName(FONT_NORMAL, size:10)
//        }
//        lblEndPoint.textAlignment = NSTextAlignmentCenter
//        let time:CMTime = self.thePlayer.currentItem.currentTime
//        let durationInSeconds:Double = CMTimeGetSeconds(time)
//
//        //lblEndPoint.text = [self timeShorted:[self timeFormatted:(floor(durationInSeconds))]];
//
//        // PTS-131 floor to Ceil change
//        lblEndPoint.text = self.timeShorted(self.timeFormatted((ceil(durationInSeconds))))
//        self.waveformView.addSubview(lblEndPoint)
//
//        //self.segmentedControl.selectedSegmentIndex = 2;
//
//        self.endPointBtn.alpha = 0.0
//        //[self hideOverwriteView];
//        self.startOverwriteBtn.alpha = 1
//
//        if self.segmentedControl.selectedSegmentIndex == 3 || editMode == 3 {
//
//            self.startOverwriteBtn.tag = TAG_ERASE_BTN
//        } else {
//            self.startOverwriteBtn.tag = TAG_START_OVERWRITE_BTN
//        }
//
//        self.playTapped(self.playBtn)
//
//        self.recordBtn.enabled = FALSE
//
//        //[self.recordBtn setImage:K_SETIMAGE(@"record_record_btn_normal.png") forState:UIControlStateNormal];
//        self.recordBtn.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)
    }
    
    // overwrite button tap
    func startOverwriteBtnTapped(sender:UIButton) {

    //    [PTSHELPER setFloatingAnimation:self.startOverwriteBtn float:0.9f];
        //self.graphView.frame = CGRect(10, 40, self.pageScrollView.frame.size.width - 20, 45);

        self.recordButtonTapped(sender: self.recordBtn, flag:true)
        isFirstTimeInEditing = false
        self.bookmarkFordwardBtn?.isEnabled = false
//        self.hideOverwriteView()
    }

    func eraseBtnTapped(sender:UIButton) {
//        self.stopRecordingTimer()
//        self.hideOverwriteView()
//
//        // STOP AUDIO RECORDER
//        self.audio_Recorder.stop()
//
//        let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//        statusLbl.text = K_PAUSED
//
//        self.recordBtn.setImage(K_SETIMAGE("record_record_btn_normal.png"), forState:UIControlStateNormal)
//        self.recordBtn.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)
//
//        let currentTime:UILabel! = self.view.viewWithTag(TAG_CURRENTTIME_LBL)
//
//        let timeArray:[AnyObject]! = currentTime.text.componentsSeparatedByString("|")
//
//        var firstString:String!
//
//        if timeArray.count > 0 {
//            firstString = timeArray.objectAtIndex(0).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        }

        /* To Fix PTS-29,30
        if ([self stringsAreEqual]) {

            NSLog(@"==============> COMING <===============");

            UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:K_KEY_APP_TITLE message:@"ERASE - Cannot start at end of the file" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [saveAlert show];

            return;
        }
         */

       // if (isErasing == SECONDTIME) {

            // STOP AUDIO PLAYER
            self.stopAudioPlayer()

           // eraseEndTime = (float)endPointTime;

         //   float value = [[self convertSecs:eraseEndTime] floatValue];

//        if startPointTime > endPointTime {
//
//            // NSLog(@"==============> COMING THIS SCENARIOS 1 <===============");
//
//            let saveAlert:UIAlertView! = UIAlertView(title:K_KEY_APP_TITLE, message:"ERASE - End erase time should be greater than Start erase time !", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles: nil)
//            saveAlert.show()
//
//            return
//        }
//        else if startPointTime == endPointTime
//        {
//            //NSLog(@"==============> COMING THIS SCENARIOS 2 <===============");
//
//            let saveAlert:UIAlertView! = UIAlertView(title:K_KEY_APP_TITLE, message:"ERASE - Start and End erase time should not be same !", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles: nil)
//            saveAlert.show()
//
//            return
//        }
//        else
//        {
//            AppDelegate.sharedInstance().userDefaults.setBool(true, forKey:K_KEY_IS_RECORD_STARTED)
//
//            self.showLoading()
//
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//
//                    let dataPath:String! = self.getDocumentDirectory().stringByAppendingPathComponent(String(format:"%@/", "Insert"))
//
//                    let success:Bool = NSFileManager.defaultManager().removeItemAtPath(dataPath, error:nil)
//
//                    dispatch_async(dispatch_get_main_queue(), {
//                        if success {
//                            // NSLog(@"FOLDER DELETED");
//                        }
//                        if !NSFileManager.defaultManager().fileExistsAtPath(dataPath)
//                            {NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories:false, attributes:nil, error:nil)}
//                        // NSLog(@"FOLDER CREATED");
//
//
//                        if startPointTime != 0 && (endPointTime as! float) != recordedFileDuration
//                        {
//                            NSLog("==============> 1st Conditions <===============")
//                            self.eraseFunction(0)
//                            isEdit = false
//                        }
//                        else if startPointTime == 0 && (endPointTime as! float) != recordedFileDuration
//                        {
//                            NSLog("==============> 2nd Conditions <===============")
//                            self.eraseFunction(1)
//                            isEdit = false
//                        }
//                        else  if (startPointTime == 0) && (endPointTime as! float) == recordedFileDuration {
//
//                            NSLog("==============> 3rd Conditions <===============")
//
//                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//
//                                let currentFilePath:String! = self.getRecordedFile()
//
//                                // DELETE PREVIOUS PLAYER FILE
//                                self.deleteParticularFileInFolder(currentFilePath)
//
//                                isEdit = false
//
//                                AppDelegate.sharedInstance().userDefaults.set("0", forKey:K_KEY_IS_EDITING)
//
//                                dispatch_async(dispatch_get_main_queue(), {
//
//                                    self.recordButtonsEnable = true
//
//                                    self.hideLoading()
//
//                                    isRecording = FIRSTTIME
//                                    AppDelegate.sharedInstance().userDefaults.set("0", forKey:K_KEY_IS_RECORDING)
//
//                                    let timing:UILabel! = self.view.viewWithTag(TAG_TIMING_LBL)
//                                    timing.text = K_START_TIME
//
//                                    let currentTime:UILabel! = self.view.viewWithTag(TAG_CURRENTTIME_LBL)
//                                    currentTime.text = String(format:"%@ | %@", K_START_TIME,K_START_TIME)
//
//                                   // [sender setImage:K_SETIMAGE(@"start_erase_btn_normal.png") forState:UIControlStateNormal];
//                                   // [sender setImage:K_SETIMAGE(@"start_erase_btn_disable.png") forState:UIControlStateHighlighted];
//                                   // [sender setImage:K_SETIMAGE(@"start_erase_btn_disable.png") forState:UIControlStateDisabled];
//                                    isRecordStarted = false
//
//                                    self.stopAudioPlayer()
//
//                                    self.fileSizeLbl.text = "0.00 Mb"
//
//                                    self.playerButtonsEnable = false
//
//                                })
//                            })
//                        }
//                        else if startPointTime != 0 && (endPointTime as! float) == recordedFileDuration
//                        {
//                            NSLog("==============> 4th Conditions <===============")
//                            self.eraseFunction(2)
//                            isEdit = false
//                        }
//                    })
//                })
//            })
//        }
    }
    
    func playTapped(sender:UIButton) {
//        isBookMarkTap = false
//
//        //stop the NSTimer
//        self.playerTimer.invalidate()
//        self.playerTimer = nil
//
//        if self.isPlaying() {
//            NSLog(" ======> PAUSE <=======")
//            self.pauseAudioPlayer()
//            self.bookmarkBtn.enabled = false
//        }
//        else
//        {
//            NSLog(" ======> PLAY <=======")
//            self.playAudioPlayer()
//
//            if bookMarTapCount == 20 {
//                self.bookmarkBtn.enabled = false
//
//            } else {
//                self.bookmarkBtn.enabled = true
//            }
//        }
    }

    //record tapped
    func recordButtonTapped(sender:UIButton!, flag temp:Bool) {

        // NSLog(@"===========>  recordButtonTapped  <==========");

    //    [PTSHELPER setFloatingAnimation:sender float:0.9f];

        // //SETUP AUDIO SESSION FOR RECORDING

        // Category will be AVAudioSessionCategoryRecord
        // AVAudioSessionPortOverrideSpeaker for increasing output volume..

//        var setOverrideError:NSError!
//        var setCategoryError:NSError!
//
//        let session:AVAudioSession! = AVAudioSession.sharedInstance()
//        session.setCategory(AVAudioSessionCategoryRecord, error:&setCategoryError)
//        session.setActive(true, error:&setCategoryError)
//
//        if (setCategoryError != nil) {
//            NSLog("%@", setCategoryError.description())
//        }
//
//        session.overrideOutputAudioPort(AVAudioSessionPortOverrideSpeaker, error:&setOverrideError)
//
//        if (setOverrideError != nil) {
//            NSLog("%@", setOverrideError.description())
//        }
//
//        ///// =============> <================= //////
//
//        self.stopRecordingTimer()
//
//        isPausedFromTab = false
//
//        // STOP AUDIO PLAYER
//        self.stopAudioPlayer()
//
//        if !temp {
//            isVoiceActivation = false
//            self.stopTempRecorderAndTimer()
//        }
//
//        isRecordStopTapped = false
//
//        isRecordStarted = true
//
//        // FOR AUTOSAVING .. Testing
//        AppDelegate.sharedInstance().userDefaults.set(self.fileNameLbl.text, forKey:K_KEY_IS_FILE_NAME)
//        AppDelegate.sharedInstance().userDefaults.setBool(true, forKey:K_KEY_IS_RECORD_STARTED)
//        AppDelegate.sharedInstance().userDefaults.setBool(false, forKey:K_KEY_IS_RECORD_STOPPED)
//        AppDelegate.sharedInstance().userDefaults.synchronize()
//
//        self.stopBtn.enabled =  true
//
//        if IS_IPHONE_4 {
//
//            self.pageScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height + 30)
//
//            if (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_INDEXING) == K_SWITCH_ON) {
//                self.pageScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height + 95)
//            }
//        }
//
//        let thePlayerDuration:Float = CMTimeGetSeconds(self.thePlayerItem.asset.duration)
//
//        NSLog("start point ==> %d, end point ==> %d", startPointTime, endPointTime)
//
//        if (playerCurrentTime == nil) > 0.0 && thePlayerDuration > 0.0 && !self.stringsAreEqual() && editMode == 1 {
//
//            //NSLog(@"PLAYER CURRENT TIME ===> %f", playerCurrentTime);
//
//            isEdit = true
//
//            isRecordAtBeginning = true
//
//            AppDelegate.sharedInstance().userDefaults.setBool(true, forKey:K_KEY_INSERT_AT_BEGINNING)
//
//            //self.segmentedControl.selectedSegmentIndex = 1;
//            //NSLog(@"FIRST LOOP ########");
//        } else if self.stringsAreEqual() && startPointTime == 0 && endPointTime == 0 {
//            //self.segmentedControl.selectedSegmentIndex = 0;
//            editMode = 0
//
//            // To Fix PTS-31
//            // Reseting to 0 Invalidate the Start Button Event which result not displaying alert.
//            if self.segmentedControl.selectedSegmentIndex == 2 {
//                editMode = 2
//            }
//
//           // [self didFinishOverwrite];
//
//          /*  float thePlayerduration = CMTimeGetSeconds(self.thePlayerItem.asset.duration);
//            self.recordedFileDuration = lroundf(thePlayerduration);
//            self.waveFormSlider.alpha = 1.0;
//
//            self.waveFormSlider.maximumValue = lroundf(thePlayerduration);
//            self.waveformView.progressTime = CMTimeMakeWithSeconds(lroundf(thePlayerduration), 10000);
//            [self.waveFormSlider setValue:lroundf(thePlayerduration) animated:YES]; */
//
//            self.pauseAudioPlayer()
//
//            isAppendWithOverwriting = false
//
//          /*  if (!isAppendPopupShowed) {
//                if ([[[APPDELEGATE userDefaults] valueForKey:K_KEY_SWITCH_DISABLE_POPUP] isEqualToString:K_SWITCH_OFF]) {
//                    isAppendPopupShowed = YES;
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Append" message:@"When the Append function is selected, the cursor will automatically move to the end of the original recording. Tap Record button and start recording." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    [alert setTag:TAG_EDIT_APPEND];
//                    [alert show];
//                    return;
//                }
//            } */
//            NSLog("SECOND LOOP ########")
//        } else if startPointTime >= 0 && endPointTime > 0 && editMode == 2 {
//            isEdit = true
//            isAppendWithOverwriting = false
//            //self.segmentedControl.selectedSegmentIndex = 2;
//            NSLog("THIRD LOOP ########")
//        } else if startPointTime >= 0 && editMode == 3 {
//            isEdit = true
//            isAppendWithOverwriting = false
//            //self.segmentedControl.selectedSegmentIndex = 3;
//            NSLog("FOURTH LOOP ########")
//        } else if startPointTime >= 0 && editMode == 1 {
//            isEdit = true
//            isAppendWithOverwriting = false
//            //self.segmentedControl.selectedSegmentIndex = 1;
//            NSLog("FIFTH LOOP ########")
//        }
//        /*
//        else if (startPointTime >= 0 && editMode == 0 && ![self stringsAreEqual]) {
//            NSLog(@"LAST LOOP ########");
//         isEdit = YES;
//            editMode = 2;
//            isAppendWithOverwriting = YES;
//        }
//        */
//        //PI-35 Fix
//        if startPointTime == 0 && editMode == 0 && !self.stringsAreEqual() {
//            NSLog("RESUME LOOP ########")
//            isEdit = false
//            editMode = 0
//            isAppendWithOverwriting = false
//
//        }
//
//        //End
//
//        NSLog("EDIT MODE ==> %d", editMode)
//
//        if thePlayerDuration > 0.0 && !self.audio_Recorder.recording {
//
//            var currentTime:Float
//
//            if playerCurrentTime > 0.0 {
//                currentTime = playerCurrentTime
//            } else {
//                currentTime = thePlayerDuration
//            }
//
//            //PI-35 Fix
//            if editMode == 0 && isAppendWithOverwriting == false
//            {
//                currentTime = thePlayerDuration
//            }
//            //End
//            if lroundf(currentTime) < lroundf(thePlayerDuration)
//            {
//                self.bookmarkBtn.enabled = false
//                self.clearIndex.enabled = false
//
//                if self.segmentBgView.alpha == 0  {
//                    self.showSegmentView()
//                    isEdit = true
//                    AppDelegate.sharedInstance().userDefaults.set("1", forKey:K_KEY_IS_EDITING)
//                }
//                else
//                {
//                    isEdit = true
//                    AppDelegate.sharedInstance().userDefaults.set("1", forKey:K_KEY_IS_EDITING)
//                    if self.segmentedControl.selectedSegmentIndex == 0
//                    {
//                        previousFilelength = self.fSize * lroundf(currentTime) / lroundf(thePlayerDuration)
//                    }
//                    if self.segmentedControl.selectedSegmentIndex == 3 {
//
//                        self.showPartialDeleteView()
//
//                        self.recordBtn.enabled = self.stopBtn.enabled =  self.eraseBtn.enabled = false
//
//                        self.eraseBtn.setImage(K_SETIMAGE("start_erase_btn_normal.png"), forState:UIControlStateNormal)
//                        self.eraseBtn.setImage(K_SETIMAGE("start_erase_btn_disable.png"), forState:UIControlStateHighlighted)
//                        self.eraseBtn.setImage(K_SETIMAGE("start_erase_btn_disable.png"), forState:UIControlStateDisabled)
//                        self.playBtn.setImage(K_SETIMAGE("existing_controls_play_btn_normal.png"), forState:UIControlStateNormal)
//                        self.playBtn.setImage(K_SETIMAGE("existing_controls_play_btn_disable.png"), forState:UIControlStateDisabled)
//
//                        self.playerButtonsEnable = true
//
//                        isErasing = FIRSTTIME
//                        isEdit = true
//                        AppDelegate.sharedInstance().userDefaults.set("1", forKey:K_KEY_IS_EDITING)
//                    }
//                    self.recordProcess(self.recordBtn, flag:temp)
//                }
//                return
//            }
//        }
//
//        self.bookmarkBtn.enabled = true
//        self.clearIndex.enabled = false
//
//        if self.bookMarkArr.count == 20 {
//            self.bookmarkBtn.enabled = false
//        }
//
//        if SYSTEM_VERSION_LESS_THAN("7.0") {
//            // FOR SIMULATOR PURPOSE
//            self.recordProcess(self.recordBtn, flag:temp)
//        }
//        else
//        {
//            // FOR DEVICE PURPOSE
//
//            if session.respondsToSelector(Selector("requestRecordPermission:")) {
//                session.performSelector(Selector("requestRecordPermission:"), withObject:{ (granted:Bool) in
//
//                    if granted {
//                        // Microphone enabled code
//                        //NSLog(@"Microphone is enabled..");
//
//                        self.recordProcess(self.recordBtn, flag:temp)
//                    }
//                    else {
//
//                        // Microphone disabled code
//                        // NSLog(@"Microphone is disabled..");
//                        // We're in a background thread here, so jump to main thread to do UI work.
//
//                        dispatch_async(dispatch_get_main_queue(), {
//
//                            let disbleAlert:UIAlertView! = UIAlertView(title:"Microphone Access Denied", message:"This app requires access to your device's Microphone.\n\nPlease enable Microphone access for this app in Settings / Privacy / Microphone", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:nil)
//                            disbleAlert.show()
//                        })
//                    }
//                })
//            }
//        }
    }
    
    func recordProcess(sender:UIButton, flag:Bool) {

//        let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//
//        if !isFirstTime {
//
//            isFirstTime = !isFirstTime
//
//            if (AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_SWITCH_AUTO_SAVING) == K_SWITCH_ON) {
//
//                let index:Int = AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_AUTO_SAVING).integerValue()
//
//                var delay:Int
//
//                if index == 0 {
//                    delay = (15 * 60)
//                    // delay = (1 * 30);
//                }
//                else if index == 1 {
//                    delay = (30 * 60)
//                }
//                else if index == 2 {
//                    delay = (45 * 60)
//                }
//                else if index == 3 {
//                    delay = (60 * 60)
//                }
//
//                NSLog("delay :%ld",(delay as! long))
//
//               // [self performSelector:@selector(callAutoSave) withObject:self afterDelay:delay];
//
//            }
//        }
//
//        self.stopRecordingTimer()
//
//        if isEdit {
//
//            NSLog(" <=== COMING ===>")
//
//            self.showRecordTmingAndStatusLabel()
//
//            if self.segmentedControl.selectedSegmentIndex == 1 {
//
//                AppDelegate.sharedInstance().userDefaults.set("INSERT", forKey:K_KEY_IS_SEGMENT_SELECTED_INDEX)
//                AppDelegate.sharedInstance().userDefaults.synchronize()
//
//                isPaused = false
//
//                if !self.audio_Recorder.recording {
//
//                    print(" INSERT ------ TRIMMING 1 ##############")
//
//                   // [self hideWaveForm];
//
//                    // HIDE SEGMENTVIEW
//                    self.hideSegmentView()
//
//                    let newTime:CMTime = CMTimeMake(startPointTime, 1)
//                    self.updateTime(newTime)
//
//                    if self.stringsAreEqual() {
//                        isAppend = true
//                        self.playerButtonsEnable = false
//                        // START RECORDING
//                        self.startRecordingTimer()
//
//                        // HIDE SEGMENT VIEW
//                        self.hideSegmentView()
//
//                        self.initAudioRecorder()
//
//                        // Start recording
//                        self.audio_Recorder.record()
//
//                        self.recordBtn.setImage(K_SETIMAGE("record_pause_btn_normal.png"), forState:UIControlStateNormal)
//                        self.recordBtn.setImage(K_SETIMAGE("record_pause_btn_disable.png"), forState:UIControlStateDisabled)
//
//                        let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//
//                        statusLbl.text = K_RECORDING
//
//                        return
//                    }
//
//                    self.insert(0, button:sender)
//
//                } else {
//
//                    NSLog("INSERT ------ INSERTING  2 ##############")
//
//                    statusLbl.text = K_PAUSED
//
//                    self.audio_Recorder.stop()
//
//                    if isAppend {
//                        isAppend = false
//
//                        self.appendingFile(self.recordBtn)
//
//                        return
//
//                    }
//
//                    self.updateRecordedTiming()
//
//                    self.insert(1, button:sender)
//
//                    self.playerButtonsEnable = true
//
//                    sender.setImage(K_SETIMAGE("record_record_btn_normal.png"), forState:UIControlStateNormal)
//                    sender.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)
//
//                }
//            } else if self.segmentedControl.selectedSegmentIndex == 2 {
//
//                NSLog("=======> self.segmentedControl.selectedSegmentIndex == 2 <=========")
//
//               /* if (startPointTime == 0) {
//
//                    //[self showOverwriteView];
//
//                    UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:@"PTS Dictate" message:@"Overwrite should not be at the beginning " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [saveAlert show];
//
//                    [self didFinishOverwrite];
//                    return;
//                } */
//
//                AppDelegate.sharedInstance().userDefaults.set("OVERWRITE", forKey:K_KEY_IS_SEGMENT_SELECTED_INDEX)
//                AppDelegate.sharedInstance().userDefaults.synchronize()
//
//                // CHECK FOR OVERWRITE -- IF YES , it will be return
//
//                if self.stringsAreEqual() && startPointTime == 0 && endPointTime == 0 {
//
//                    NSLog("stringsAreEqual")
//
//                    let saveAlert:UIAlertView! = UIAlertView(title:K_KEY_APP_TITLE, message:K_KEY_RECORD_OVERWRITE_ALERT, delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:nil)
//                    saveAlert.show()
//
//                    return
//                }
//
//                isPaused = false
//
//                // To Fix PTS-26,32
//                if startPointTime >= endPointTime {
//
//                    let saveAlert:UIAlertView! = UIAlertView(title:"PTS Dictate", message:"End Point should be greater than Start Point", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles: nil)
//                    saveAlert.tag = TAG_END_OVERWRITE_BTN
//                    saveAlert.show()
//
//                    return
//                }
//
//
//                if !self.audio_Recorder.recording {
//
//                    NSLog("OVERWRITE ##############")
//
//                   // [self hideWaveForm];
//
//                    // HIDE SEGMENTVIEW
//                    self.hideSegmentView()
//
//                    var newTime:CMTime
//
//                    if startPointTime == 0 {
//                        newTime = CMTimeMake(startPointTime, 1)
//                    }
//                    //PI-22 Fix Part
//                    /*
//                    else if (startPointTime > 1) {
//                        newTime = CMTimeMake(startPointTime - 1, 1);
//                    }
//                    */
//                    else {
//                        newTime = CMTimeMake(startPointTime, 1)
//                    }
//                    //CMTime newTime = CMTimeMake(startPointTime, 1);
//                    self.updateTime(newTime)
//
//                    self.overwrite(0, button:sender)
//
//                } else {
//
//                    NSLog("OVERWRITE ##############")
//
//                    statusLbl.text = K_PAUSED
//
//                    self.audio_Recorder.stop()
//
//                    self.updateRecordedTiming()
//
//                    self.playerButtonsEnable = true
//
//                    sender.setImage(K_SETIMAGE("record_record_btn_normal.png"), forState:UIControlStateNormal)
//                    sender.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)
//
//                    self.overwrite(1, button:sender)
//
//
//                }
//            }
//            else if self.segmentedControl.selectedSegmentIndex ==  0
//            {
//                AppDelegate.sharedInstance().userDefaults.set("APPENDING", forKey:K_KEY_IS_SEGMENT_SELECTED_INDEX)
//                AppDelegate.sharedInstance().userDefaults.synchronize()
//
//                isPaused = false
//
//                if self.stringsAreEqual() {
//
//                    if !self.audio_Recorder.recording {
//
//                        self.playerButtonsEnable = false
//
//                        sender.setImage(K_SETIMAGE("record_pause_btn_normal.png"), forState:UIControlStateNormal)
//                        sender.setImage(K_SETIMAGE("record_pause_btn_disable.png"), forState:UIControlStateDisabled)
//
//                        // START RECORDING
//                        self.startRecordingTimer()
//
//                        statusLbl.text = K_RECORDING
//
//                        //playerCurrentTime = 0.0;
//                        progressIn = 0.0
//
//                        self.imgSlider.frame = CGRect(self.waveform.frame.origin.x + self.waveform.frame.size.width , self.waveform.frame.origin.y,  self.imgSlider.frame.size.width,  self.imgSlider.frame.size.height)
//
//                        self.waveform.progressSamples = 0
//
//                        NSLog("APPENDING 1ST CONDITION ##############")
//
//                        self.hideWaveForm()
//
//                        // HIDE SEGMENTVIEW
//                        self.hideSegmentView()
//
//                        self.initAudioRecorder()
//
//                        // Start recording
//                        self.audio_Recorder.record()
//
//                    } else {
//
//                        NSLog("APPENDING 2ND CONDITION ##############")
//
//                        statusLbl.text = K_PAUSED
//
//                        self.audio_Recorder.stop()
//
//                        self.updateRecordedTiming()
//
//                        self.appendingFile(sender)
//
//                        self.playerButtonsEnable = true
//
//                        sender.setImage(K_SETIMAGE("record_record_btn_normal.png"), forState:UIControlStateNormal)
//                        sender.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)
//
//                    }
//                } else {
//
//                    let playerItem:AVPlayerItem! = self.thePlayer.currentItem
//                    let currentTime:CMTime = playerItem.currentTime
//                    startPointTime = lroundf(CMTimeGetSeconds(currentTime))
//                    print("startPointTime ==> %d, Total Duration ==> %f", startPointTime, recordedFileDuration)
//
//                    if !self.audio_Recorder.recording {
//
//                        print("OVERWRITE ##############")
//
//                        self.hideWaveForm()
//
//                        // HIDE SEGMENTVIEW
//                        self.hideSegmentView()
//
//                        var newTime:CMTime
//
//                        if startPointTime == 0 {
//                            newTime = CMTimeMake(startPointTime, 1)
//                        }else {
//                            newTime = CMTimeMake(startPointTime, 1)
//                        }
//
//                        //CMTime newTime = CMTimeMake(startPointTime, 1);
//                        self.updateTime(newTime)
//
//                        self.overwrite(0, button:sender)
//
//                    } else {
//
//                        NSLog("OVERWRITE ##############")
//
//                        statusLbl.text = K_PAUSED
//
//                        self.audio_Recorder.stop()
//
//                        self.updateRecordedTiming()
//
//                        //[self overwrite:3 button:sender];
//                        self.overWriteFunction(3, button:sender)
//
//                        self.playerButtonsEnable = true
//
//                        sender.setImage(K_SETIMAGE("record_record_btn_normal.png"), forState:UIControlStateNormal)
//                        sender.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)
//
//                    }
//                    return
//                }
//            }
//            else if self.segmentedControl.selectedSegmentIndex == 3
//            {
//                NSLog("selectedSegmentIndex 3")
//                //[self showPartialDeleteView];
//
//                self.showSegmentView()
//
//                let currentTime:UILabel! = self.view.viewWithTag(TAG_CURRENTTIME_LBL)
//
//                if (currentTime.text == String(format:"%@ | %@", K_START_TIME,K_START_TIME))
//                {
//                    NSLog("COMING THIS SCENARIO ============= 1")
//                    self.playerButtonsEnable = false
//                }
//            }
//
//        } else {
//
//            if self.segmentedControl.selectedSegmentIndex == 3
//            {
//                NSLog("selectedSegmentIndex 3")
//
//                // [self showPartialDeleteView];
//                self.showSegmentView()
//
//                let currentTime:UILabel! = self.view.viewWithTag(TAG_CURRENTTIME_LBL)
//
//                if (currentTime.text == String(format:"%@ | %@", K_START_TIME,K_START_TIME))
//                {
//                    NSLog("COMING THIS SCENARIO ============= 2")
//                    self.playerButtonsEnable = false
//                }
//
//                return
//            }
//
//            if self.segmentedControl.selectedSegmentIndex == 2
//            {
//                // CHECK FOR OVERWRITE
//                if self.stringsAreEqual() && startPointTime == 0 && endPointTime == 0  {
//
//                    NSLog("stringsAreEqual")
//
//                    let saveAlert:UIAlertView! = UIAlertView(title:K_KEY_APP_TITLE, message:K_KEY_RECORD_OVERWRITE_ALERT, delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:nil)
//                    saveAlert.show()
//
//                    self.showSegmentView()
//
//                    return
//                }
//            }
//
//            self.showRecordTmingAndStatusLabel()
//
//            if !self.audio_Recorder.recording {
//
//                NSLog(K_RECORDING)
//                self.playerButtonsEnable = false
//
//                sender.setImage(K_SETIMAGE("record_pause_btn_normal.png"), forState:UIControlStateNormal)
//
//                // START RECORDING
//                self.startRecordingTimer()
//
//                statusLbl.text = K_RECORDING
//
//                self.hideWaveForm()
//
//                // HIDE SEGMENTVIEW
//                self.hideSegmentView()
//
//                self.initAudioRecorder()
//
//                // Start recording
//                self.audio_Recorder.record()
//            }else{
//                statusLbl.text = K_PAUSED
//
//                self.audio_Recorder.stop()
//
//                self.updateRecordedTiming()
//
//                self.showLoading()
//
//                sender.setImage(K_SETIMAGE("record_record_btn_normal.png"), forState:UIControlStateNormal)
//                sender.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)
//
//                if isRecording == FIRSTTIME {
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//
//                        let newFilePath:String! = self.getRecordedFile()
//
//                        var err:NSError!
//
//                        NSFileManager.defaultManager().copyItemAtPath(self.getDocumentDirectory().stringByAppendingPathComponent("MyAudioMemo.m4a"),
//                                                                toPath:newFilePath,
//                                                                 error:&err)
//
//                        dispatch_async(dispatch_get_main_queue(), {
//
//                            self.hideLoading()
//
//                            // STORE FILEDURATION & SETUP AUDIO
//                            self.setupAudioPlayer(newFilePath)
//                            self.stopTempRecorderAndTimer()
//                            self.performSelector(Selector("startTempRecorderAndTimer"), withObject:self, afterDelay:0.1)
//                            isPaused = true
//                        })
//                    })
//
//                    isRecording = SECONDTIME
//
//                    AppDelegate.sharedInstance().userDefaults.set("1", forKey:K_KEY_IS_RECORDING)
//
//                }
//                else if isRecording == SECONDTIME {
//
//                    self.hideLoading()
//
//                    self.appendingFile(sender)
//
//                }
//            }
//        }
    }
    
    func callRecordStopButtonCalled() {
//        self.recordButtonTapped(self.recordBtn, flag:false)
    }

    func recordStopButtonTapped(show : Bool, sender : UIButton) {

    //    [PTSHELPER setFloatingAnimation:self.stopBtn float:0.9f];

//        isVoiceActivation = false
//
//        self.stopTempRecorderAndTimer()
//
//        self.stopRecordingTimer()
//
//        self.segmentedControl.userInteractionEnabled = false
//
//        isRecordStopTapped = true
//
//        AppDelegate.sharedInstance().userDefaults.setBool(true, forKey:K_KEY_IS_RECORD_STOPPED)
//
//        self.recordBtn.setImage(K_SETIMAGE("record_record_btn_normal.png"), forState:UIControlStateNormal)
//        self.recordBtn.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)
//
//        let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//
//        self.recordBtn.enabled = self.stopBtn.enabled = self.eraseBtn.enabled = self.bookmarkBackwardBtn.enabled =  self.bookmarkFordwardBtn.enabled = self.bookmarkBtn.enabled = self.clearIndex.enabled = false
//
//        if !show {
//
//            if sender == self.stopBtn {
//                statusLbl.text = K_STOPPED
//            }
//
//            if self.audio_Recorder.recording || isPausedFromTab {
//
//                // CURRENTLY RECORDING
//
//                isPausedFromTab = false
//
//                if isRecording == FIRSTTIME {
//
//                    NSLog("CURRENTLY RECORDING FIRST TIME")
//
//                    self.audio_Recorder.stop()
//
//                    self.updateRecordedTiming()
//
//                    // FIRST TIME .i.e NOT PAUSED
//
//                    self.showLoading()
//
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//
//                        let newFilePath:String! = self.getRecordedFile()
//
//                        var err:NSError!
//
//                        NSFileManager.defaultManager().copyItemAtPath(self.getDocumentDirectory().stringByAppendingPathComponent("MyAudioMemo.m4a"),
//                                                                toPath:newFilePath,
//                                                                 error:&err)
//
//                        dispatch_async(dispatch_get_main_queue(), {
//
//                            self.hideLoading()
//
//                            let fileManager:NSFileManager! = NSFileManager.defaultManager()
//
//                            if fileManager.fileExistsAtPath(newFilePath)
//                            {
//                                NSLog(" newFilePath fileExistsAtPath ")
//                            }
//
//
//                            isRecording = SECONDTIME
//
//                            self.setupAudioPlayer(newFilePath)
//
//                            if sender == self.stopBtn {
//                                self.showSaveBottomView()
//                            }
//                            else
//                            {
//                                self.segmentedControl.userInteractionEnabled = true
//
//                                self.goToSaveTheAutoSaveFile(newFilePath)
//                            }
//                        })
//                    })
//                }else{
//
//                    // CURRENTLY RECORDING
//                    self.audio_Recorder.stop()
//
//                    if isEdit {
//
//                        if self.segmentedControl.selectedSegmentIndex == 1 {
//                            print(" INSERT ")
//
//                            self.updateRecordedTiming()
//
//                            if isAppend {
//
//                                isAppend = false
//
//                                self.appendingFile(sender)
//
//                                return
//                            }
//
//                            self.insert(1, button:sender)
//                        }else if self.segmentedControl?.selectedSegmentIndex == 2 {
//                            print(" OVERWRITE ")
//                            if !isStopBtnTappedWhileOverwriting
//                                {isStopBtnTappedWhileOverwriting = true}
//                            self.updateRecordedTiming()
//                            self.overwrite(flag: 1, button:sender)
//                        }else if self.segmentedControl?.selectedSegmentIndex == 0 {
//                            print(" APPENDING ")
//
//                            if isAppendWithOverwriting {
//                                print(" APPENDING WITH OVERWRITING ")
//                                self.overWriteFunction(3, button:sender)
//                            } else {
//                                self.appendingFile(sender)
//                            }
//
//                            self.updateRecordedTiming()
//                        }
//                    }else{
//                        print(" APPENDING ELSE ")
//                        self.updateRecordedTiming()
//                        self.appendingFile(sender)
//                    }
//                }
//            }else{ // NOT RECORDING - i.e ALREARDY STOPPED
//
//                print(" ======== NOT RECORDING ========")
//
//                if sender == self.stopBtn {
//                    self.showSaveBottomView()
//                }else{
//                    self.goToSaveTheAutoSaveFile("")
//                }
//                return
//            }
//        }
//        else{
//            print(" ======== NOT RECORDING ========")
//
//            if sender == self.stopBtn {
//                self.showSaveBottomView()
//            }else{
//                self.goToSaveTheAutoSaveFile(filePath: "")
//            }
//
//            return
//        }
    }

    func saveBtnTapped() {
//        let saveAlert:UIAlertView! = UIAlertView(title:K_KEY_APP_TITLE, message:K_SAVE_CURRENT_RECORD_ALERT, delegate:self, cancelButtonTitle:K_YES, otherButtonTitles:K_NO, nil)
//        saveAlert.tag = TAG_SAVE_ALERT_TAG
//        saveAlert.show()
    }
    
    func fastRewindTapped(sender : UIButton) {
//        PTSHELPER.buttonAnimation = sender
//
//        let playerItem:AVPlayerItem! = self.thePlayer?.currentItem
//        let currentTime:CMTime = playerItem.currentTime()
//        let time:Int = lroundf(CMTimeGetSeconds(currentTime))
//        let duration:Int = lroundf(recordedFileDuration)
//        var newTime:CMTime
//
//        if self.stringsAreEqual() {
//            newTime = CMTime(duration - 1, 1)
//            if time == 1 || time == 2 {
//                newTime = CMTime(0, 1)
//            }
//            else {
//                newTime = CMTime(duration - 3, 1)
//            }
//        }else if time > 0 {
//            if time == 1 || time == 2 {
//                newTime = CMTime(0, 1)
//            }else {
//                newTime = CMTime(time - 3, 1)
//            }
//        }else {
//            newTime = CMTime(0, 1)
//        }
//        self.updateTimeLabels(newTime)
    }

    func fastForwardTapped(sender : UIButton) {
//        if self.stringsAreEqual() { return }
//
//        PTSHELPER.buttonAnimation = sender
//
//                let playerItem:AVPlayerItem! = self.thePlayer?.currentItem
//        let currentTime:CMTime = playerItem.currentTime
//                let time:Int = lroundf(Float(CMTimeGetSeconds(currentTime)))
//        let duration:Int = lroundf(recordedFileDuration)
//        var newTime:CMTime
//        if (time == duration - 1) || (time == duration - 2)  {
//            newTime = CMTimeMake(Int64(duration)value: duration, timescale: 1)
//
//        }else{
//            newTime = CMTime(time + 3, 1)
//        }
//
//        if time >= 0  && (time <= recordedFileDuration) {
//            self.updateTime(newTime)
//        }
    }

    func rewindTapped(sender:UIButton) {
//        PTSHELPER.buttonAnimation = sender
//        let playerItem = self.thePlayer?.currentItem
//        let currentTime = playerItem?.currentTime()
//        let time:Int = lroundf(CMTimeGetSeconds(currentTime))
//        let duration:Int = lroundf(recordedFileDuration)
//        var newTime:CMTime
//        if self.stringsAreEqual() {
//            newTime = CMTime(duration - 1, 1)
//        }else if time > 0 {
//            newTime = CMTime(value: time - 1, timescale: 1)
//        }else {
//            newTime = CMTime(value: 0, timescale: 1)
//        }
//        self.updateTimeLabels(newTime: newTime)
    }
    
    func forwardTapped(sender : UIButton) {
//        if self.stringsAreEqual() { return }
//
//        PTSHELPER.buttonAnimation = sender
//
//        let playerItem = self.thePlayer?.currentItem
//        let currentTime = playerItem?.currentTime()
//        let time = lroundf(Float(CMTimeGetSeconds(currentTime)))
//        let newTime = CMTime(time + 1, 1)
//        self.updateTime(newTime: newTime)
    }

    @objc func sliderTapped(gestureRecognizer : UIGestureRecognizer) {
//        let slider = gestureRecognizer.view as! UISlider
//        if slider.isHighlighted { return } // tap on thumb, let slider deal with it
//
//        if (slider != nil) {
//            let pt:CGPoint = gestureRecognizer.location(in: slider)
//            let percentage:CGFloat = pt.x / slider.bounds.size.width
//            let delta:CGFloat = percentage * (slider.maximumValue - slider.minimumValue)
//            let valueSlider:Float = slider.minimumValue + delta
//            let time = lroundf(valueSlider)
//            slider.setValue(time, animated:true)
//            let newTime:CMTime = CMTime(time, 1)
//            self.updateTime(newTime: newTime)
//
//        }
    }

   @objc func handlePanGesture(recognizer : UIPanGestureRecognizer) {
//        let slider = recognizer.view as! UISlider
//        if slider.isHighlighted { return } // tap on thumb, let slider deal with it
//
//        let pt:CGPoint = recognizer.location(in: slider)
//        let percentage:CGFloat = pt.x / slider.bounds.size.width
//        let delta:CGFloat = percentage * (slider.maximumValue - slider.minimumValue)
//        let valueSlider:Float = slider.minimumValue + delta
//
//        let time = lroundf(valueSlider)
//        slider.setValue(time, animated:true)
//        let newTime:CMTime = CMTimeMake(time, 1)
//        self.updateTime(newTime)
    }


    @objc func sliderValueChanged(sender:AnyObject) {
//        let slider:UISlider! = sender
//        if (slider != nil) {
//            let time:Int = lroundf(slider.value)
//            sender.setValue(time, animated:true)
//            let newTime:CMTime = CMTimeMake(time, 1)
//            self.updateTime(newTime)
//        }
    }
    
    // MARK: -
    // MARK: PRIVATE METHODS HELPERS

    // RECORD SETTINGS-
    func initAudioRecorder() {
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .default, options: [.allowBluetooth, .defaultToSpeaker])
            try session.setActive(true)
            try session.overrideOutputAudioPort(.speaker)
        } catch _ {
        }

        // Define the recorder setting
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
        
        
        self.recordingFileUrl = NSURL.fileURL(withPath: self.getDocumentDirectory().appendingPathComponent("MyAudioMemo.m4a").absoluteString)
        
        // Initiate and prepare the recorder
        self.audio_Recorder = try? AVAudioRecorder(url:self.recordingFileUrl!, settings:recorderSetting)
        self.audio_Recorder?.delegate = self
        self.audio_Recorder?.prepareToRecord()
        self.audio_Recorder?.isMeteringEnabled = true
        
        
        
        

        

//        let pathComponentsTemp:[AnyObject]! = [AnyObject].arrayWithObjects(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject(),
//                                       "MyAudioMemo1.m4a",
//                                       nil)
//        let secondUrl:NSURL! = NSURL.fileURLWithPathComponents(pathComponentsTemp)
//
//        self.tempRecorder = AVAudioRecorder(URL:secondUrl, settings:recordSetting, error:nil)
//                self.tempRecorder?.delegate = self
//                self.tempRecorder?.prepareToRecord()
//        self.tempRecorder?.meteringEnabled = true

        checkMicrophoneAccess()

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
    
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    
    func isRecordPermissionGiven() -> Bool {
        var isPermitted:Bool = true
        switch (AVAudioSession.sharedInstance().recordPermission) {
        case .granted:
            isPermitted = true
            break
        case .denied:
            isPermitted = false
            break
        case .undetermined:
            isPermitted = false
            break
        default:
            isPermitted = false
            break
        }
        return isPermitted
    }
    
    func stringsAreEqual() -> Bool {
        let currentTime = self.view.viewWithTag(TAG_CURRENTTIME_LBL) as? UILabel
        let timeArray = currentTime?.text?.components(separatedBy: "|")

        if timeArray?.count ?? 0 > 0 {
            let firstString = timeArray?[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let secondString = timeArray?[1].trimmingCharacters(in: .whitespacesAndNewlines)
            return firstString == secondString
        } else if timeArray?.count == 0 && startPointTime == 0 && endPointTime == 0 {
            return true
        }

        return false
    }
    
    func stopAudioPlayer() {
        self.thePlayer?.seek(to: CMTime(value: Int64(playerCurrentTime), timescale: 1))
        self.thePlayer?.pause()
        self.playerTimer?.invalidate()
        self.playerTimer = nil

        self.bookmarkBtn?.isEnabled = false
        self.playBtn?.setImage(UIImage(named: "existing_controls_play_btn_normal.png"), for: .normal)
        self.playBtn?.setImage(UIImage(named: "existing_controls_play_btn_disable.png"), for: .disabled)
    }

//    func updateTime(newTime:CMTime) {
//            let time:Int = lroundf(Float(CMTimeGetSeconds(newTime)))
//
//       // NSLog(@"updateTime PLAYER TIME ===> %d", time);
//
//            if time >= 0  && (time <= Int(recordedFileDuration)) {
//
//                let new:CMTime = CMTimeMake(value: Int64(time), timescale: 1)
//
//                self.thePlayer?.seek(to: new)
//
//                let currentTimeLabel:UILabel! = self.view.viewWithTag(TAG_CURRENTTIME_LBL) as! UILabel
//
//                playerCurrentTime = Double(time)
//
//            insertingTime = playerCurrentTime
//
//                self.waveformView?.progressTime = CMTimeMakeWithSeconds((Double(time) / recordedFileDuration), preferredTimescale: 10000)
//
//                currentTimeLabel.text = String(format:"%@ | %@", self.timeFormatted(totalSeconds: lroundf(Float(time))),self.timeFormatted(totalSeconds: lroundf(Float(self.recordedFileDuration))))
//
//                self.waveFormSlider?.setValue(Float(time), animated:true)
//        }
//
//        if self.stringsAreEqual() {
//            self.fastForwardBtn?.isEnabled = false
//            self.forwardBtn?.isEnabled = false
//            self.rewindBtn?.isEnabled = true
//            self.fastRewindBtn?.isEnabled = true
//
//        }
//        else
//        {
//            self.fastForwardBtn?.isEnabled = true
//            self.forwardBtn?.isEnabled = true
//            self.rewindBtn?.isEnabled = true
//            self.fastRewindBtn?.isEnabled = true
//        }
//
//        if (self.timeFormatted(lroundf(time)) == K_START_TIME) {
//            self.fastForwardBtn?.isEnabled = true
//            self.forwardBtn?.isEnabled = true
//            self.rewindBtn?.isEnabled = false
//            self.fastRewindBtn?.isEnabled = false
//        }
//
//    }

//    func updateTimeLabels(newTime:CMTime) {
//        self.thePlayer?.seek(to: newTime)
//        let timeUpdated = lroundf(Float(CMTimeGetSeconds(newTime)))
//        let currentTimeLabel = self.view.viewWithTag(TAG_CURRENTTIME_LBL) as? UILabel
//        playerCurrentTime = Double(timeUpdated)
//
//        insertingTime = playerCurrentTime
//
//        self.waveformView.progressTime = CMTimeMakeWithSeconds((timeUpdated / recordedFileDuration), 10000)
//
//        currentTimeLabel.text = String(format:"%@ | %@", self.timeFormatted(timeUpdated),self.timeFormatted(lroundf(self.recordedFileDuration)))
//
//        self.waveFormSlider.setValue(timeUpdated, animated:true)
//
//        if self.stringsAreEqual() {
//            self.fastForwardBtn?.isEnabled = false
//            self.forwardBtn?.isEnabled = false
//            self.rewindBtn?.isEnabled = true
//            self.fastRewindBtn?.isEnabled = true
//        }else{
//            self.fastForwardBtn?.isEnabled = true
//            self.forwardBtn?.isEnabled = true
//            self.rewindBtn?.isEnabled = true
//            self.fastRewindBtn?.isEnabled = true
//        }
//
//        if (self.timeFormatted(lroundf(Float(timeUpdated))) == K_START_TIME) {
//            self.fastForwardBtn?.isEnabled = true
//            self.forwardBtn?.isEnabled = true
//            self.rewindBtn?.isEnabled = false
//            self.fastRewindBtn?.isEnabled = false
//        }
//
//    }

//    func updateTimeForPlayer(p:AVPlayer) {
//
//        let playerItem:AVPlayerItem! = p.currentItem
//
//            let currentTime:CMTime = playerItem.currentTime()
//
//            let time:Int = lroundf(Float(CMTimeGetSeconds(currentTime)))
//
//            let currentTimeLabel:UILabel! = self.view.viewWithTag(TAG_CURRENTTIME_LBL) as! UILabel
//
//            playerCurrentTime = Double(time)
//
//        insertingTime = playerCurrentTime
//
//            self.waveformView?.progressTime = CMTimeMakeWithSeconds((Double(time) / recordedFileDuration), preferredTimescale: 10000)
//
//            currentTimeLabel.text = String(format:"%@ | %@", self.timeFormatted(totalSeconds: time),self.timeFormatted(totalSeconds: lroundf(Float(self.recordedFileDuration))))
//
//        //float x = [self xPositionFromSliderValue:self.waveFormSlider];
//
//       // NSLog(@"PLAYER TIME ===> %d", time);
//
//            self.waveFormSlider?.isContinuous = true
//            self.waveFormSlider?.setValue(Float(time), animated:true)
//
//        //NSLog(@"updateTimeForPlayer ===> %f", self.waveFormSlider.value);
//
//        if self.stringsAreEqual() {
//            self.fastForwardBtn?.isEnabled = false
//            self.forwardBtn?.isEnabled = false
//            self.rewindBtn?.isEnabled = false
//            self.fastRewindBtn?.isEnabled = true
//        }
//        else
//        {
//            self.fastForwardBtn?.isEnabled = true
//            self.forwardBtn?.isEnabled = true
//            self.rewindBtn?.isEnabled = true
//            self.fastRewindBtn?.isEnabled = true
//        }
//
//            if (self.timeFormatted(totalSeconds: lroundf(Float(time))) == K_START_TIME) {
//            self.fastForwardBtn?.isEnabled = true
//            self.forwardBtn?.isEnabled = true
//            self.rewindBtn?.isEnabled = false
//            self.fastRewindBtn?.isEnabled = false
//        }
//
//    }

//    func saveIntoDataBase(isAutoSaveFile:String) {
//        if (isAutoSaveFile == "NO") {
//            AppDelegate.sharedInstance().userDefaults.set(false, forKey:K_KEY_IS_RECORD_STARTED)
//            NotificationCenter.default.removeObserver(self, name:K_NOTICATION_RECORDING, object:nil)
//        }
//
//        var bookmarks:String!
//
//        let result:NSMutableArray! = self.bookMarkArr
//
//        if result.count > 0 {
//
//            bookmarks = ""
//
//            for i in 0..<result.count{
//
//                if i == 0 {
//                    NSLog("[result objectAtIndex:0] == > %@", result.objectAtIndex(0))
//                    bookmarks = result.objectAtIndex(i)
//                } else {
//                    bookmarks = bookmarks.stringByAppendingString(",")
//                    bookmarks = bookmarks.stringByAppendingString(result.objectAtIndex(i))
//                }
//             }
//        }
//        else
//        {
//            bookmarks = ""
//        }
//
//       // NSLog(@"bookmarks ==> %@", bookmarks);
//
//        let uploadArray:NSMutableArray! = NSMutableArray()
//
//        let timing:UILabel! = self.view.viewWithTag(TAG_TIMING_LBL)
//
//
//        if !editRecording {
//
//            if isSaving == FIRSTTIME {
//
//                uploadArray.addObject(AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_LOGIN_USER_ID))
//                uploadArray.addObject(self.fileNameLbl.text)
//                uploadArray.addObject(timing.text)
//                uploadArray.addObject(self.fileSizeLbl.text)
//                uploadArray.addObject("0")
//                uploadArray.addObject("") // COMMENTS
//                uploadArray.addObject(bookmarks) // BOOKMARKS
//
//                if (AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_SWITCH_COMMENTS_SCREEN) == K_SWITCH_ON) {
//
//                    uploadArray.addObject("YES")
//                } else {
//                    uploadArray.addObject("NO")
//                }
//
//                PTSDATAMANAGER.loadIntoUploadLog(uploadArray)
//
//                isSaving = SECONDTIME
//            }
//            else
//            {
//                var rowId:String! = PTSDATAMANAGER.getLastRowId("select id from upload_log ORDER BY id DESC LIMIT 1")
//
//                NSLog("==========> COMING <===========")
//
//                NSLog("==========> rowId <=========== :%@", rowId)
//
//                if rowId.length == 0 {
//                    rowId = "1"
//                }
//
//                uploadArray.addObject("") // COMMENTS
//                uploadArray.addObject(timing.text)
//                uploadArray.addObject(self.fileSizeLbl.text)
//                uploadArray.addObject(bookmarks) // BOOKMARKS
//                uploadArray.addObject(rowId)
//                uploadArray.addObject(AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_LOGIN_USER_ID))
//
//                PTSDATAMANAGER.updateEditRecordDetailsInToUploadFiles(uploadArray)
//            }
//        }else{
//            if (AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_SWITCH_AUTO_SAVING) == K_SWITCH_ON) {
//                isSaving = SECONDTIME
//            }
//
//            //@"update upload_log set description='%@',file_duration='%@',file_size='%@', bookmarks='%@'  where id='%@' and user_id=%@"
//
//            uploadArray.add(self.editDictionary["comments"]) // COMMENTS
//            uploadArray.add(timing.text)
//            uploadArray.add(self.fileSizeLbl?.text)
//            uploadArray.add(bookmarks) // BOOKMARKS
//            uploadArray.add(self.editDictionary["rowId"])
//            uploadArray.add(AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_LOGIN_USER_ID))
//
//            PTSDATAMANAGER.updateEditRecordDetailsInToUploadFiles(uploadArray)
//        }
//
//        self.saveFileToDocuments(isAutoSaveFile: isAutoSaveFile)
//
//    }
    
//    func goToCommentsScreen() {
//        let nextViewController:PTSCommentsViewController! = PTSCommentsViewController()
//        if !editRecording {
//            nextViewController.rowId = PTSDATAMANAGER.getLastRowId("select id from upload_log ORDER BY id DESC LIMIT 1")
//        }
//        else {
//            nextViewController.rowId = self.editDictionary.valueForKey("rowId")
//            nextViewController.commentsStr = self.editDictionary.valueForKey("comments")
//        }
//
//        PTSSCREENNAVIGATION.pushTransitionAnimation = self
//        self.navigationController.pushViewController(nextViewController, animated:false)
//    }

//    func saveFileToDocuments(isAutoSaveFile:String!) {
//        self.showLoading()
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//
//            var newFilePath:String! = self.getExistingFolder().stringByAppendingPathComponent(self.fileNameLbl.text)
//
//            if editRecording {
//                newFilePath = self.getDocumentDirectory().stringByAppendingPathComponent("Existing").stringByAppendingPathComponent(self.fileNameLbl.text)
//            }
//
//            let fileManager:NSFileManager! = NSFileManager.defaultManager()
//            let isFileThere:Bool = NSFileManager.defaultManager().fileExistsAtPath(newFilePath)
//
//
//            if isFileThere {
//                fileManager.removeItemAtPath(newFilePath, error:nil)
//            }
//
//            dispatch_async(dispatch_get_main_queue(), {
//
//                self.saveCurrentRecordedFile(isAutoSaveFile)
//            })
//        })
//    }

//    func goToSaveTheAutoSaveFile(filePath:String!) {
//        self.saveIntoDataBase(isAutoSaveFile: "NO")
//        isRecordStopTapped = false
//    }

//    func saveCurrentRecordedFile(isAutoSaveFile:String) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//
//            var newFilePath:String!
//            newFilePath = self.getExistingFolder().stringByAppendingPathComponent(self.fileNameLbl.text)
//
//            if editRecording {
//                newFilePath = self.getDocumentDirectory().stringByAppendingPathComponent("Existing").stringByAppendingPathComponent(self.fileNameLbl.text)
//            }
//
//            var err:NSError!
//
//            NSFileManager.defaultManager().copyItemAtPath(self.getRecordedFile(),
//                                                    toPath:newFilePath,
//                                                     error:&err)
//
//            dispatch_async(dispatch_get_main_queue(), {
//
//                self.hideLoading()
//
//                    let autoSaveFile:Bool = AppDelegate.sharedInstance().userDefaults.boolForKey(K_KEY_AUTO_SAVE_FILE)
//
//                    if editRecording {
//
//                        if autoSaveFile {
//
//                            PTSHELPER.showTabBar()
//                            APPDELEGATE.tabBar.tabButtonTapped(APPDELEGATE.tabBar.existingTabBtn)
//                        } else {
//                            if isCommentsAvailable {
//
//                                self.goToCommentsScreen()
//                            } else {
//                                PTSHELPER.showTabBar()
//                                APPDELEGATE.tabBar.tabButtonTapped(APPDELEGATE.tabBar.existingTabBtn)
//                            }
//                        }
//                    } else {
//                        if autoSaveFile {
//                            PTSHELPER.showTabBar()
//                            APPDELEGATE.tabBar.tabButtonTapped(APPDELEGATE.tabBar.existingTabBtn)
//                        } else {
//                            if (AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_SWITCH_COMMENTS_SCREEN) == K_SWITCH_ON) {
//
//                                self.goToCommentsScreen()
//                            } else {
//                                PTSHELPER.showTabBar()
//                                APPDELEGATE.tabBar.tabButtonTapped(APPDELEGATE.tabBar.existingTabBtn)
//                            }
//                        }
//                    }
//            })
//        })
//    }
    
    func showRecordTmingAndStatusLabel() {
        let statusLbl = self.view.viewWithTag(TAG_STATUS_LBL) as? UILabel
        let timingLbl = self.view.viewWithTag(TAG_TIMING_LBL) as? UILabel

        if statusLbl?.alpha == 0.0 {
            UIView.animate(withDuration: 0.5, delay: 0) {
                statusLbl?.alpha = 1.0

                var theAnimation : CABasicAnimation!
                theAnimation = CABasicAnimation(keyPath: "opacity")
                theAnimation.duration = 0.5
                theAnimation.repeatCount = 5
                theAnimation.autoreverses = true
                theAnimation.fromValue = NSNumber(value: 1.0)
                theAnimation.toValue = NSNumber(value: 0.0)
                timingLbl?.layer.add(theAnimation, forKey:"animateOpacity")
            }
            
            UIView.animate(withDuration: 1.0, delay: 0) {
                statusLbl?.alpha = 1.0

                var theAnimation : CABasicAnimation!
                theAnimation = CABasicAnimation(keyPath: "opacity")
                theAnimation.duration = 1.0
//                theAnimation.repeatCount = HUGE_VAL
                theAnimation.autoreverses = true
                theAnimation.fromValue = NSNumber(value: 1.0)
                theAnimation.toValue = NSNumber(value: 0.0)
                statusLbl?.layer.add(theAnimation, forKey:"animateOpacity")

                if let frame = timingLbl?.frame{
                    timingLbl?.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height - 20)
                    statusLbl?.frame = CGRect(x: statusLbl?.frame.origin.x ?? 0, y: frame.origin.y + frame.size.height, width: frame.size.width, height: statusLbl?.frame.size.height ?? 0)
                }
            }
        }
    }

    func startTempRecorderAndTimer() {
        if AppDelegate.sharedInstance().userDefaults.value(forKey: K_KEY_SWITCH_VOICE_ACTIVATION) as! String == K_SWITCH_ON{
            if isVoiceActivation {
                self.stopTempRecorderAndTimer()
                self.tempRecorder?.record()
                self.tempTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTempRecording), userInfo: nil, repeats: true)
            }
        }
    }

    func stopTempRecorderAndTimer() {
        // STOP RECORDING
        self.tempRecorder?.stop()
        self.tempTimer?.invalidate()
        self.tempTimer = nil
    }

//    func changeFileNameCount() {
//        let formatter:NSDateFormatter! = NSDateFormatter()
//        formatter.dateFormat = "dd/MM/yy"
//
//        let strCurrentDate:String! = formatter.stringFromDate(NSDate.date())
//        let strEventDate:String! = AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_RECORD_DATE)
//
//        switch (strCurrentDate.compare(strEventDate)){
//
//            case NSOrderedSame:
//                fileCountInt = AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_RECORD_FILE_COUNT).intValue() + 1
//                self.fileCountStr = String(format:"%03d",fileCountInt)
//                break
//            default:
//                AppDelegate.sharedInstance().userDefaults.set(nil, forKey:K_KEY_RECORD_FILE_COUNT)
//                AppDelegate.sharedInstance().userDefaults.set(strCurrentDate, forKey:K_KEY_RECORD_DATE)
//                AppDelegate.sharedInstance().userDefaults.synchronize();;
//                fileCountInt = 1
//                self.fileCountStr = String(format:"%03d",fileCountInt)
//                break
//        }
//
//        let today:NSDate! = NSDate.date()
//        let dateFormatter:NSDateFormatter! = NSDateFormatter()
//
//        let fileFormatStr:String! = AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_FILE_FORMAT)
//
//        if fileFormatStr.length == 0 {
//            dateFormatter.dateFormat = "ddMMyyyy"
//        }else{
//            dateFormatter.dateFormat = AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_FILE_FORMAT)
//        }
//
//        self.fileNameLbl.text = String(format:"%@_%@_File_%@.m4a", AppDelegate.sharedInstance().userDefaults.objectForKey(K_KEY_LOGIN_PROFILE_NAME), dateFormatter.stringFromDate(today),self.fileCountStr)
//    }
    
//    func overwrite(flag:Int, button:UIButton!) {
//        self.showLoading()
//
//        if flag == 0 {
//
//            NSLog("flag == 0")
//
//            self.overWriteFunction(0, button:button)
//
//        } else {
//
//            NSLog("flag == 1")
//
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//
//                let recordedFilePath:String! = self.getDocumentDirectory().stringByAppendingPathComponent("MyAudioMemo.m4a")
//
//                let trimmingFilePath:String! = self.getDocumentDirectory().stringByAppendingPathComponent("Overwrite").stringByAppendingPathComponent("overwrite_0.m4a")
//
//                let playerFilePath:String! = self.getRecordedFile()
//
//                let playerFileAsset:AVURLAsset! = AVURLAsset(URL:NSURL.initFileURLWithPath(playerFilePath), options:nil)
//                let triimmingFileAsset:AVURLAsset! = AVURLAsset(URL:NSURL.initFileURLWithPath(trimmingFilePath), options:nil)
//                let recordedFileAsset:AVURLAsset! = AVURLAsset(URL:NSURL.initFileURLWithPath(recordedFilePath), options:nil)
//
//                let timeDifference:Float = CMTimeGetSeconds(playerFileAsset.duration) - (CMTimeGetSeconds(triimmingFileAsset.duration) + CMTimeGetSeconds(recordedFileAsset.duration))
//
//                NSLog("timeDifference ===> %f", timeDifference)
//
//                if timeDifference > 0 {
//                    self.overWriteFunction(1, button:button)
//                }
//                else {
//                    // ELSE
//
//                    NSLog("ELSE OVERWRITE")
//
//                    self.overWriteFunction(3, button:button)
//
//                }
//            })
//        }
//    }
    
//    func showBookMark(flag:Int) {
//
//        let sliderImage = K_SETIMAGE("slider")
//
//        if flag == 0 {
//            self.bookmarkSlider?.setThumbImage(sliderImage, forState:.normal)
//            self.bookmarkSlider?.setThumbImage(sliderImage, forState:.highlighted)
//            self.clearIndex?.isEnabled = false
//        }
//        else {
//            self.bookmarkSlider?.setThumbImage(UIImage(), forState:.normal)
//            self.bookmarkSlider?.setThumbImage(UIImage(), forState:.highlighted)
//            self.clearIndex?.isEnabled = true
//        }
//
//        let view1 = self.view.viewWithTag(TAG_BOOKMARK_1)
//        let view2 = self.view.viewWithTag(TAG_BOOKMARK_2)
//        let view3 = self.view.viewWithTag(TAG_BOOKMARK_3)
//        let view4 = self.view.viewWithTag(TAG_BOOKMARK_4)
//        let view5 = self.view.viewWithTag(TAG_BOOKMARK_5)
//        let view6 = self.view.viewWithTag(TAG_BOOKMARK_6)
//        let view7 = self.view.viewWithTag(TAG_BOOKMARK_7)
//        let view8 = self.view.viewWithTag(TAG_BOOKMARK_8)
//        let view9 = self.view.viewWithTag(TAG_BOOKMARK_9)
//        let view10 = self.view.viewWithTag(TAG_BOOKMARK_10)
//        let view11 = self.view.viewWithTag(TAG_BOOKMARK_11)
//        let view12 = self.view.viewWithTag(TAG_BOOKMARK_12)
//        let view13 = self.view.viewWithTag(TAG_BOOKMARK_13)
//        let view14 = self.view.viewWithTag(TAG_BOOKMARK_14)
//        let view15 = self.view.viewWithTag(TAG_BOOKMARK_15)
//        let view16 = self.view.viewWithTag(TAG_BOOKMARK_16)
//        let view17 = self.view.viewWithTag(TAG_BOOKMARK_17)
//        let view18 = self.view.viewWithTag(TAG_BOOKMARK_18)
//        let view19 = self.view.viewWithTag(TAG_BOOKMARK_19)
//        let view20 = self.view.viewWithTag(TAG_BOOKMARK_20)
//
//        view1.backgroundColor = view2.backgroundColor =  view3.backgroundColor =  view4.backgroundColor = view5.backgroundColor =  view6.backgroundColor = view7.backgroundColor = view8.backgroundColor = view9.backgroundColor = view10.backgroundColor = view11.backgroundColor = view12.backgroundColor = view13.backgroundColor = view14.backgroundColor = view15.backgroundColor = view16.backgroundColor = view17.backgroundColor = view18.backgroundColor = view19.backgroundColor = view20.backgroundColor = .gray
//
//        switch (flag) {
//
//            case 1:
//                view1.backgroundColor = .red
//                break
//
//            case 2:
//                view2.backgroundColor = .red
//                break
//
//            case 3:
//                view3.backgroundColor = .red
//                break
//
//            case 4:
//                view4.backgroundColor = .red
//                break
//
//            case 5:
//                view5.backgroundColor = .red
//                break
//
//            case 6:
//                view6.backgroundColor = .red
//                break
//
//            case 7:
//                view7.backgroundColor = .red
//                break
//
//            case 8:
//                view8.backgroundColor = .red
//                break
//
//            case 9:
//                view9.backgroundColor = .red
//                break
//
//            case 10:
//                view10.backgroundColor = .red
//                break
//
//            case 11:
//                view11.backgroundColor = .red
//                break
//
//            case 12:
//                view12.backgroundColor = .red
//                break
//
//            case 13:
//                view13.backgroundColor = .red
//                break
//
//            case 14:
//                view14.backgroundColor = .red
//                break
//
//            case 15:
//                view15.backgroundColor = .red
//                break
//
//            case 16:
//                view16?.backgroundColor = .red
//                break
//
//            case 17:
//                view17?.backgroundColor = .red
//                break
//
//            case 18:
//                view18?.backgroundColor = .red
//                break
//
//            case 19:
//                view19?.backgroundColor = .red
//                break
//
//            case 20:
//                view20?.backgroundColor = .red
//                break
//
//            default:
//                break
//        }
//
//        if flag == self.bookMarkArr?.count {
//            self.bookmarkFordwardBtn?.isEnabled = false
//        } else if flag >= 1 {
//            self.bookmarkFordwardBtn?.isEnabled = true
//        }
//
//        if flag == 0{
//            self.bookmarkBackwardBtn?.isEnabled = true
//        }
//    }
    
//    func showSaveBottomView(){
//        let frame:CGRect = APPDELEGATE.tabBar.frame
//
//        APPDELEGATE.tabBar.frame = CGRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
//
//        UIView.animateWithDuration(1.0,
//                              delay:0,
//                            options:UIViewAnimationOptionTransitionFlipFromBottom,
//
//                         animations:{
//
//                             APPDELEGATE.tabBar.frame = CGRect(frame.origin.x, frame.origin.y + frame.size.height + 10, frame.size.width, frame.size.height)
//
//                             if self.bottomView.alpha == 0.0 {
//
//                                 UIView.animateWithDuration(1.0,
//                                                       delay:0,
//                                                     options:UIViewAnimationOptionTransitionFlipFromTop,
//
//                                                  animations:{
//
//                                                      self.bottomView.frame = CGRect(frame.origin.x, frame.origin.y - 64 , frame.size.width, self.bottomView.frame.size.height)
//
//                                                      self.bottomView.alpha = 1.0
//
//                                                      if !isAppendWithOverwriting {
//                                                          self.didFinishOverwrite()
//                                                      }
//
//                                                      self.hideSegmentView()
//
//                                                  },
//                                                  completion:nil)
//                             }
//                         },
//                         completion:nil)
//
//    }

//    func hideSaveBottomView() {
//        UIView.animateWithDuration(1.0,
//                              delay:0,
//                            options:UIViewAnimationOptionTransitionFlipFromBottom,
//
//                         animations:{
//
//                             if self.bottomView.alpha == 1.0 {
//
//                                 UIView.animateWithDuration(1.0,
//                                                       delay:0,
//                                                     options:UIViewAnimationOptionTransitionFlipFromTop,
//
//                                                  animations:{
//
//                                                      self.bottomView.frame = CGRect(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y + 64 , self.bottomView.frame.size.width, self.bottomView.frame.size.height)
//
//                                                      self.bottomView.alpha = 0.0
//
//                                                      PTSHELPER.showTabBar()
//
//                                                      self.stopBtn.enabled = self.eraseBtn.enabled = true
//                                                      self.segmentedControl.userInteractionEnabled = true
//
//
//                                                      if self.segmentBgView.alpha == 0  {
//
//                                                          self.showSegmentView()
//                                                          isEdit = false
//                                                          AppDelegate.sharedInstance().userDefaults.set("0", forKey:K_KEY_IS_EDITING)
//
//                                                      }
//                                                  },
//                                                  completion:nil)
//                             }
//                         },
//                         completion:nil)
//
//    }
    
    
    func updateRecordedTiming() {
        let asset        = AVURLAsset(url:self.recordingFileUrl ?? URL(fileURLWithPath: ""), options:nil)
        let time         = asset.duration
        let durationInSeconds = CMTimeGetSeconds(time)
        let timing = self.view.viewWithTag(TAG_TIMING_LBL) as? UILabel
        print(timing)
//        if isRecording == FIRSTTIME {
//            timing.text = self.timeFormatted(lroundf(durationInSeconds))
//        } else {
//            if self.segmentedControl.selectedSegmentIndex == 0 { // Added condition to fix PTS-128
//                NSLog("Append Option Selected")
//                //timing.text = [self timeFormatted:lroundf(self.audio_Recorder.currentTime)];
//            } else {
//                timing.text = self.timeFormatted((lroundf(durationInSeconds) + lroundf(self.recordedFileDuration)))
//            }
//        }
    }

    func timeFormatted(totalSeconds:Int) -> String{
        let seconds:Int = totalSeconds % 60
        let minutes:Int = (totalSeconds / 60) % 60
        let hours:Int = (totalSeconds / 3600)
        return String(format:"%02d:%02d:%02d",hours, minutes, seconds)
    }

    func convertSecs(string:String) -> NSNumber{
        let components = string.components(separatedBy: ":")
        let hours   = (Int(components[0]) ?? 0) * 60 * 60
        let minutes = (Int(components[1]) ?? 0) * 60
        let seconds = Int(components[2]) ?? 0
        return NSNumber(integerLiteral: hours + minutes + seconds)
    }

//    func timeShorted(string:String!) -> String! {
//        let components:[AnyObject]! = string.componentsSeparatedByString(":")
//
//        let hours:Int = components.objectAtIndex(0).integerValue()
//        let minutes:Int = components.objectAtIndex(1).integerValue()
//        let seconds:Int = components.objectAtIndex(2).integerValue()
//
//        var timeString:String! = ""
//        var formatString:String! = ""
//        if hours > 0 {
//            // formatString=hours==1?@"%d hour":@"%d hours";
//            formatString=hours==1?"%d h":"%d h"
//            timeString = timeString.stringByAppendingString(String(format:formatString,hours))
//        }
//        if minutes > 0 || hours > 0  {
//            // formatString=minutes==1?@" %d minute":@" %d minutes";
//            formatString=minutes==1?" %d m":" %d m"
//            timeString = timeString.stringByAppendingString(String(format:formatString,minutes))
//        }
//        if seconds > 0 || hours > 0 || minutes > 0 {
//            // formatString=seconds==1?@" %d second":@" %d seconds";
//            formatString=seconds==1?" %d s":" %d s"
//            timeString  = timeString.stringByAppendingString(String(format:formatString,seconds))
//        }
//        return timeString
//    }
    
    func startRecordingTimer() {
        // setup timer
        self.currentTimeUpdateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRecording), userInfo: nil, repeats: true)
        if self.customRangeBar?.alpha == 0.0 {
            self.customRangeBar?.alpha = 1.0
            self.waveFormSlider?.alpha = 0.0
        }
    }

    func stopRecordingTimer() {
        self.customRangeBar?.value = -160
        //stop the NSTimer
        self.currentTimeUpdateTimer?.invalidate()
        self.currentTimeUpdateTimer = nil
    }


//    func audioDuration(filePath:String!) -> String{
//        let audioAsset:AVURLAsset! = AVURLAsset(URL:NSURL.initFileURLWithPath(filePath), options:nil)
//        let audioDuration:CMTime = audioAsset.duration
//        return String(format:"%@", self.timeFormatted(lroundf(CMTimeGetSeconds(audioDuration))))
//    }

//    func setAllSettings(filePath:String!) {
//        NSLog("filePath ========>>>>>>>>>>>:%@", filePath)
//
//        // THE AUDIO PLAYER
//        self.thePlayer = AVPlayer(URL:NSURL.initFileURLWithPath(filePath))
//        self.thePlayerItem = self.thePlayer.currentItem()
//
//        let thePlayerduration:Float = CMTimeGetSeconds(self.thePlayerItem.asset.duration)
//
//        let newTime:CMTime = CMTimeMake(0, 1)
//        self.thePlayer.seekToTime(newTime)
//
//        // Setup audio session
//        var setOverrideError:NSError!
//        var setCategoryError:NSError!
//
//        let session:AVAudioSession! = AVAudioSession.sharedInstance()
//        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:&setCategoryError)
//        session.setActive(true, error:&setCategoryError)
//
//        if (setCategoryError != nil) {
//            NSLog("%@", setCategoryError.description())
//        }
//
//        session.overrideOutputAudioPort(AVAudioSessionPortOverrideSpeaker, error:&setOverrideError)
//
//        if (setOverrideError != nil) {
//            NSLog("%@", setOverrideError.description())
//        }
//
//        NSLog("duration AVPlayer ========>>>>>>>>>>>:%@", String(format:"%@", self.timeFormatted(lroundf(thePlayerduration))))
//
//        self.recordedFileDuration = lroundf(thePlayerduration)
//
//        insertingTime = self.recordedFileDuration
//
//        self.waveFormSlider.alpha = 1.0
//
//        self.waveFormSlider.maximumValue = lroundf(thePlayerduration)
//        self.waveformView.progressTime = CMTimeMakeWithSeconds(lroundf(thePlayerduration), 10000)
//        self.waveFormSlider.setValue(lroundf(thePlayerduration), animated:true)
//
//        self.playerButtonsEnable = true
//
//        let currentTime:UILabel! = self.view.viewWithTag(TAG_CURRENTTIME_LBL)
//        currentTime.text = String(format:"%@ | %@", self.timeFormatted(lroundf(thePlayerduration)),self.timeFormatted(lroundf(thePlayerduration)))
//
//        NSLog("AUDIO FILE DURATION 22222 ========>>>>>>>>>>>:%@", self.audioDuration(filePath))
//
//        let timing:UILabel! = self.view.viewWithTag(TAG_TIMING_LBL)
//        timing.text = self.timeFormatted(lroundf(thePlayerduration))
//
//        var error:NSError!
//        let fileDictionary:NSDictionary! = NSFileManager.defaultManager().attributesOfItemAtPath(filePath, error: &error)
//        let size:NSNumber! = fileDictionary.objectForKey(NSFileSize)
//        //Yujin
//        //previousFilelength = [size floatValue];
//        previousFilelength = self.fSize
//        //Yujin
//        //CGFloat fileSizeValue = [size floatValue]/1024.0f/1024.0f;
//        if editDictionary != nil && self.fSize == 0
//        {
//            var sizeStr:String! = editDictionary.objectForKey("filesize")
//            sizeStr = sizeStr.stringByReplacingOccurrencesOfString(" MB", withString:"")
//            NSLog("Edit FileSize:%@",sizeStr)
//
//            self.fSize = sizeStr.floatValue() * 1024.0 * 1024.0
//            previousFilelength = self.fSize
//        }
//
//        let fileSizeValue:CGFloat = self.fSize/1024.0/1024.0
//
//        self.fileSizeLbl.text = String(format:"%.2f",((fileSizeValue >= 79.93) ? 80.0 : fileSizeValue)).stringByAppendingString(" Mb")
//
//
//        self.bookmarkBtn.enabled = false
//
//        self.bookmarkSlider.setValue(0, animated:true)
//        sliderValue = 0
//        self.showBookMark(0)
//
//        self.fastForwardBtn.enabled = self.forwardBtn.enabled = false
//
//        var i:Int
//
//        let temparray:NSMutableArray! = NSMutableArray()
//
//        var isUpdateBookMark:Bool = FALSE
//
//        if self.bookMarkArr.count > 0 {
//            for var i in 0..<bookMarkArr.count{
//
//                // NSLog(@"TIMINGS :%@", [self convertSecs:[self.bookMarkArr objectAtIndex:i]]);
//
//                let duration:Float = recordedFileDuration
//
//                if self.convertSecs(self.bookMarkArr.objectAtIndex(i)).floatValue() > duration {
//                    // [self.bookMarkArr removeObjectAtIndex:i];
//                    isUpdateBookMark = TRUE
//                }
//                else {
//                    temparray.addObject(self.bookMarkArr.objectAtIndex(i))
//                }
//             }
//
//            self.bookMarkArr.removeAllObjects()
//
//            self.bookMarkArr = temparray
//
//
//            if isUpdateBookMark {
//                self.createBookMarKDivider()
//            }
//
//
//            if self.bookMarkArr.count == 0 {
//                self.bookmarkBackwardBtn.enabled = self.bookmarkFordwardBtn.enabled = false
//            }
//            else
//            {
//                self.bookmarkBackwardBtn.enabled =  false
//                self.bookmarkFordwardBtn.enabled = true
//            }
//        }
//
//        if self.stringsAreEqual() {
//            self.fastForwardBtn.enabled = self.forwardBtn.enabled = false
//            self.rewindBtn.enabled = self.fastRewindBtn.enabled = true
//
//        }
//        else
//        {
//            self.fastForwardBtn.enabled = self.forwardBtn.enabled = true
//            self.rewindBtn.enabled = self.fastRewindBtn.enabled = true
//        }
//    }
    
//    func setupAudioPlayer(filePath:String) {
//        self.setAllSettings(filePath: filePath)
//
//        self.updateWaveForm(filePath)
//
//        if self.stringsAreEqual() {
//            self.fastForwardBtn.enabled = self.forwardBtn.enabled = false
//            self.rewindBtn.enabled = self.fastRewindBtn.enabled = true
//        }else{
//            self.fastForwardBtn.enabled = self.forwardBtn.enabled = true
//            self.rewindBtn.enabled = self.fastRewindBtn.enabled = true
//        }
//
//    }

//    func createBookMarKDivider() {
//        bookMarTapCount = (self.bookMarkArr.count() as! int)
//
//        self.bookMarkArr.sortUsingComparator({ (firstObject:AnyObject!,secondObject:AnyObject!) in
//            return firstObject.compare(secondObject)
//        })
//
//        if self.dividerBgView != nil {
//            self.dividerBgView.removeFromSuperview()
//        }
//
//        self.dividerBgView = UIView(frame:CGRect(20, 0, self.view.frame.size.width - 40, 40))
//        self.dividerBgView.backgroundColor = K_COLOR_CLEAR_COLOR
//        self.bookmarkView.addSubview(self.dividerBgView)
//
//        let originX:Float = (self.dividerBgView.frame.size.width * 0.05) + 1.25
//
//        // DIVIDER
//        for var i:Int=0 ; i < self.bookMarkArr.count ; i++ {
//
//            let divider:UIView! = UIView(frame:CGRect(originX * (i), 2, 2, 25))
//            divider.backgroundColor = UIColor.grayColor()
//
//            if i == 0 {
//                divider.tag = TAG_BOOKMARK_1
//            } else if i == 1 {
//                divider.tag = TAG_BOOKMARK_2
//            } else if i == 2 {
//                divider.tag = TAG_BOOKMARK_3
//            } else if i == 3 {
//                divider.tag = TAG_BOOKMARK_4
//            } else if i == 4 {
//                divider.tag = TAG_BOOKMARK_5
//            } else if i == 5 {
//                divider.tag = TAG_BOOKMARK_6
//            } else if i == 6 {
//                divider.tag = TAG_BOOKMARK_7
//            } else if i == 7 {
//                divider.tag = TAG_BOOKMARK_8
//            } else if i == 8 {
//                divider.tag = TAG_BOOKMARK_9
//            } else if i == 9 {
//                divider.tag = TAG_BOOKMARK_10
//            } else if i == 10 {
//                divider.tag = TAG_BOOKMARK_11
//            } else if i == 11 {
//                divider.tag = TAG_BOOKMARK_12
//            } else if i == 12 {
//                divider.tag = TAG_BOOKMARK_13
//            } else if i == 13 {
//                divider.tag = TAG_BOOKMARK_14
//            } else if i == 14 {
//                divider.tag = TAG_BOOKMARK_15
//            } else if i == 15 {
//                divider.tag = TAG_BOOKMARK_16
//            } else if i == 16 {
//                divider.tag = TAG_BOOKMARK_17
//            } else if i == 17 {
//                divider.tag = TAG_BOOKMARK_18
//            } else if i == 18 {
//                divider.tag = TAG_BOOKMARK_19
//            } else if i == 19 {
//                divider.tag = TAG_BOOKMARK_20
//            }
//
//            dividerBgView.addSubview(divider)
//
//            let  origin:Float = divider.frame.origin.x - 15
//
//            let timeLbl:UILabel! = UILabel(frame:CGRect(origin, divider.frame.origin.y + divider.frame.size.height, 30, 15))
//            timeLbl.backgroundColor = K_COLOR_CLEAR_COLOR
//            timeLbl.textColor = K_COLOR_DARK_COLOR
//            timeLbl.tag = i + 21
//            timeLbl.font = UIFont.fontWithName(FONT_NORMAL, size:6)
//            timeLbl.textAlignment = NSTextAlignmentCenter
//            dividerBgView.addSubview(timeLbl)
//            timeLbl.text = self.timeShorted(self.bookMarkArr.objectAtIndex(i))
//
//         }
//
//        self.bookmarkSlider.setValue(0, animated:true)
//        sliderValue = 0
//        self.showBookMark(0)
//
//        if self.bookMarkArr.count == 0 {
//            self.bookmarkBackwardBtn.enabled = self.bookmarkFordwardBtn.enabled = false
//        }
//        else
//        {
//            self.bookmarkFordwardBtn.enabled = true
//            self.bookmarkBackwardBtn.enabled =  false
//        }
//
//        self.clearIndex.enabled = false
//
//    }


   @objc func updateWaveForm(filePath:String!) {
       let overWrite  = self.view.viewWithTag(TAG_OVERWRITE_LBL) as? UILabel
       overWrite?.text = ""
       let asset = AVURLAsset(url: URL(fileURLWithPath: filePath))
       waveformView?.asset = asset
       playerCurrentTime =  0
       self.showWaveForm()
    }

    func getDocumentDirectory() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        }else{
            fatalError("Unable to access document directory")
        }
    }

    func getRecordedFile() -> String {
        let url = self.getDocumentDirectory().appendingPathComponent("Record").appendingPathComponent(String(format:"%@%d%@",RECORDED_FILE,trimCount,".m4a"))
        return url.absoluteString
    }
    
    func getExistingFolder() -> String {
        if !editRecording {
            return self.getDocumentDirectory().appendingPathComponent("Existing").absoluteString
        }
        return  self.getDocumentDirectory().appendingPathComponent("Record").absoluteString
    }

    func getEditRecordFolder() -> String {
        return  self.getDocumentDirectory().appendingPathComponent("EditRecord").absoluteString
    }

    func createFolder(folderName:String) {
        let dataPath = self.getDocumentDirectory().appendingPathComponent(String(format:"%@/", folderName)).absoluteString
        if !FileManager.default.fileExists(atPath: dataPath){
            try? FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false)
        }
    }

    func createFolderInDocuments(folderName:String!) {
        let dataPath = self.getDocumentDirectory().appendingPathComponent(String(format:"%@/", folderName)).absoluteString
        try? FileManager.default.removeItem(atPath: dataPath)
        if !FileManager.default.fileExists(atPath: dataPath){
            try? FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false)
        }
    }

//    func deleteParticularFileInFolder(filepath:String!) {
//        let fileManager = FileManager.default
//        let isFileThere = FileManager.default.fileExists(atPath: dataPath)
//        if isFileThere {
//            fileManager.removeItem(atPath: dataPath)
//        }
//    }

    func playRecordedAudio() {
//        self.playerButtonsEnable = true
        self.thePlayer?.play()
    }

    @objc func updateTempRecording() {
//
//        self.tempRecorder.updateMeters()
//
//        let decibels:Int = self.tempRecorder.peakPowerForChannel(0)
//
//        //NSLog(@"decibels temp :%d",decibels);
//
//        //if (0 > decibels > -50)
//        if decibels >  - 30
//        {
//
//            self.stopTempRecorderAndTimer()
//
//            // Need to put check here as well. Nilesh Patel PTS-7
//            self.recordButtonTapped(self.recordBtn, flag:true)
//        }
    }

    @objc func updateRecording() {

//        self.audio_Recorder.updateMeters()
//
//        let decibels:Int = self.audio_Recorder.peakPowerForChannel(0)
//
//        var value:Int
//
//        if microPhoneSensitivityIndex == 5 {
//            value = 3.5
//        }
//        else if microPhoneSensitivityIndex == 4 {
//            value = 3.4
//        }
//        else if microPhoneSensitivityIndex == 3 {
//            value = 3.3
//        }
//        else if microPhoneSensitivityIndex == 2 {
//            value = 3.2
//        }
//        else if microPhoneSensitivityIndex == 1 {
//            value = 3.1
//        }
//        else if microPhoneSensitivityIndex == 0 {
//            value = 3.0
//        }
//
//        self.customRangeBar.value = (decibels * value)
//
//        let timing:UILabel! = self.view.viewWithTag(TAG_TIMING_LBL)
//        let overWrite:UILabel! = self.view.viewWithTag(TAG_OVERWRITE_LBL)
//        let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//
//        var size:Float
//
//        if isRecording == FIRSTTIME {
//
//            let currentdatalength:Float = previousFilelength + NSData.dataWithContentsOfURL(NSURL.URLWithString(recordingFileUrl.relativeString)).length
//
//            timing.text = self.timeFormatted(lroundf(self.audio_Recorder.currentTime))
//
//    //        self.fileSizeLbl.text = [[NSString stringWithFormat:@"%.2f",((float)[NSData dataWithContentsOfURL:[NSURL URLWithString:recordingFileUrl.relativeString]].length/1024.0f/1024.0f)] stringByAppendingString:@" Mb"];
//
//            let fileName:String! = recordingFileUrl?.relativeString.substringWithRange(NSMakeRange(7, (recordingFileUrl?.relativeString.count ?? 0)-7))
//
//            NSLog("Record File : %@)",fileName)
//
//            var error:NSError!
//            let fileDictionary:NSDictionary! = NSFileManager.defaultManager().attributesOfItemAtPath(fileName, error: &error)
//            let size:NSNumber! = fileDictionary.objectForKey(NSFileSize)
//
//            self.fSize = size.floatValue()
//
//            let fileSizeValue:CGFloat = size.floatValue()/1024.0/1024.0
//
//            self.fileSizeLbl.text = String(format:"%.2f",((fileSizeValue >= 79.93) ? 80.0 : fileSizeValue)).stringByAppendingString(" Mb")
//
//
//        }
//        else
//        {
//
//            let fileName:String! = recordingFileUrl.relativeString.substringWithRange(NSMakeRange(7, recordingFileUrl.relativeString.length()-7))
//
//            NSLog("Record File : %@)",fileName)
//
//            var error:NSError!
//            let fileDictionary:NSDictionary! = NSFileManager.defaultManager().attributesOfItemAtPath(fileName, error: &error)
//            let size:NSNumber! = fileDictionary.objectForKey(NSFileSize)
//
//            let currentdatalength:Float = previousFilelength + size.floatValue()
//            self.fSize = previousFilelength + size.floatValue()
//
//
//            //float currentdatalength= previousFilelength + [NSData dataWithContentsOfURL:[NSURL URLWithString:recordingFileUrl.relativeString]].length;
//
//            //size = [[NSString stringWithFormat:@"%.2f",((float)currentdatalength/1024.0f/1024.0f)] floatValue];
//
//            if playerCurrentTime != 0  && self.segmentedControl.selectedSegmentIndex == 2 {
//                dispatch_async(dispatch_get_main_queue(), {
//                    NSLog("Player Current time : %f",playerCurrentTime)
//                    NSLog("Recorded File Duration : %f",self.recordedFileDuration)
//                    NSLog("Audio Recorder Current Time & Player Current Time : %f",(self.audio_Recorder.currentTime + playerCurrentTime))
//                })
//
//                if self.recordedFileDuration < (self.audio_Recorder.currentTime + playerCurrentTime) {
//
//                    timing.text = self.timeFormatted((lroundf(self.audio_Recorder.currentTime) + lroundf(playerCurrentTime)))
//                    overWrite.text = ""
//                    statusLbl.text = K_RECORDING
//                    self.fileSizeLbl.text=String(format:"%.2f",((currentdatalength as! float)/1024.0/1024.0)).stringByAppendingString(" Mb")
//
//                }
//                else
//                {
//                    overWrite.text = self.timeFormatted((lroundf(self.audio_Recorder.currentTime) + lroundf(playerCurrentTime)))
//                    timing.text = self.timeFormatted(lroundf(self.recordedFileDuration))
//                    statusLbl.text = K_OVERWRITING
//
//                    let overwriteTime:Int = lroundf(self.audio_Recorder.currentTime) + lroundf(playerCurrentTime)
//
//                    //NSLog(@"END POINT TIME ===> %d", endPointTime);
//                    //NSLog(@"OVERWRITE TIMING ===> %d", overwriteTime);
//
//                    if endPointTime <= overwriteTime {
//
//                        self.recordButtonTapped(self.recordBtn, flag:true)
//                    }
//                }
//            }
//
//            else if self.segmentedControl.selectedSegmentIndex == 1 {
//
//                overWrite.text = self.timeFormatted((lroundf(self.audio_Recorder.currentTime) + lroundf(insertingTime)))
//                timing.text = self.timeFormatted((lroundf(self.audio_Recorder.currentTime + self.recordedFileDuration)))
//
//                statusLbl.text = "Inserting"
//
//                self.fileSizeLbl.text=String(format:"%.2f",((currentdatalength as! float)/1024.0/1024.0)).stringByAppendingString(" Mb")
//            }
//            else if self.segmentedControl.selectedSegmentIndex == 0 && isAppendWithOverwriting {
//
//                NSLog("TOTAL TIME ==> %ld   CURRENT TIME ==> %ld", lroundf(self.recordedFileDuration), (lroundf(self.audio_Recorder.currentTime) + lroundf(playerCurrentTime)))
//
//                overWrite.text = self.timeFormatted((lroundf(self.audio_Recorder.currentTime) + lroundf(playerCurrentTime)))
//
//                if (lroundf(self.audio_Recorder.currentTime + lroundf(playerCurrentTime))) >= lroundf(self.recordedFileDuration) {
//                    overWrite.text = ""
//                    timing.text = self.timeFormatted((lroundf(self.audio_Recorder.currentTime) + lroundf(playerCurrentTime)))
//                }
//
//               // timing.text = [self timeFormatted:(lroundf(self.audio_Recorder.currentTime + self.recordedFileDuration))];
//
//                statusLbl.text = "Appending"
//
//                self.fileSizeLbl.text=String(format:"%.2f",((currentdatalength as! float)/1024.0/1024.0)).stringByAppendingString(" Mb")
//            }
//            else
//            {
//                timing.text = self.timeFormatted((lroundf(self.audio_Recorder.currentTime) + lroundf(self.recordedFileDuration)))
//                self.fileSizeLbl.text=String(format:"%.2f",((currentdatalength as! float)/1024.0/1024.0)).stringByAppendingString(" Mb")
//            }
//        }
//
//        if size >= 74.99 {
//            if !isUploadWarning {
//
//                self.audio_Recorder.pause()
//
//                self.stopRecordingTimer()
//                let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//                statusLbl.text = K_PAUSED
//                let alert:UIAlertView! = UIAlertView(title:"Warning", message:"You are approaching your file size upload limit of 80Mb.", delegate:self, cancelButtonTitle:"OK", otherButtonTitles:nil)
//                alert.tag = TAG_WARNING_ALERT_ONE
//                alert.show()
//
//                isUploadWarning = true
//            }else if size >= 79.93 {
//
//                // To fix PTS-138
//                self.fileSizeLbl.text = String(format:"%.2f",80.0).stringByAppendingString(" Mb")
//
//                self.audio_Recorder?.pause()
//                self.stopRecordingTimer()
//                isPausedFromTab = true
//
//                let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//                statusLbl.text = K_PAUSED
//
//                if !isLimitReached {
//                    //need to show new alert
////                        let alert:UIAlertView! = UIAlertView(title:"PTS Dictation", message:"The 80Mb file size limit is reached. Please save the file.",/*@"The 80Mb file size limit is reached. The file is being saved."*/ delegate:self, cancelButtonTitle:"OK", otherButtonTitles:nil)
////                        alert.tag = TAG_WARNING_ALERT_TWO
////                        alert.show()
//
//                    isLimitReached = true
//                }
//            }
//        }
//
//        if (AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_SWITCH_VOICE_ACTIVATION) == K_SWITCH_ON) {
//            if decibels != -160 {
//                if (-30 >  decibels){
//                    self.thirtySecondPauseCounter += 1
//                }else {
//                    self.thirtySecondPauseCounter = 0
//                }
//
//                if self.thirtySecondPauseCounter >= 30 {
//                    isVoiceActivation = true
//                    self.recordButtonTapped(sender: self.recordBtn, flag:true)
//                }
//            }
//        }
    }
    
    
    func pauseAudioPlayer() {
        self.thePlayer?.pause()

        //stop the NSTimer
        self.playerTimer?.invalidate()
        self.playerTimer = nil

        if self.segmentedControl?.selectedSegmentIndex == 3 {
            self.recordBtn?.isEnabled = (self.stopBtn?.isEnabled == false)
        }else {
            if !isRecordStopTapped {
                self.recordBtn?.isEnabled = (self.stopBtn?.isEnabled == true)
            }else{
                self.recordBtn?.isEnabled = (self.stopBtn?.isEnabled == false)
            }
        }

//        self.playBtn.setImage(K_SETIMAGE("existing_controls_play_btn_normal.png"), forState:.normal)
//        self.playBtn.setImage(K_SETIMAGE("existing_controls_play_btn_disable.png"), forState:.disabled)

    }

//    func pauseAudioPlayerForBookmark(currentTime:String!) {
//
//        self.pauseArr?.removeAllObjects()
//        self.pauseArr.addObject(currentTime)
//
//        self.thePlayer?.pause()
//
//        //stop the NSTimer
//        self.playerTimer?.invalidate()
//        self.playerTimer = nil
//
//        self.playBtn.setImage(K_SETIMAGE("existing_controls_play_btn_normal.png"), forState:UIControlStateNormal)
//        self.playBtn.setImage(K_SETIMAGE("existing_controls_play_btn_disable.png"), forState:UIControlStateDisabled)
//
//        self.performSelector(Selector("playAudioPlayerForBookmark"), withObject:nil, afterDelay:2.0)
//
//    }

//    func playAudioPlayerForBookmark() {
//        playBtn.setImage(K_SETIMAGE("existing_controls_pause_btn_normal.png"), forState:UIControlStateNormal)
//        playBtn.setImage(K_SETIMAGE("existing_controls_pause_btn_disable.png"), forState:UIControlStateDisabled)
//
//        self.playRecordedAudio()
//
//        self.playerTimer = Timer.scheduledTimerWithTimeInterval(1.0, target:self, selector:Selector("updatePlayerTiming"), userInfo:self.thePlayer, repeats:true)
//
//    }


    func isPlaying() -> Bool {
        if ((self.thePlayer?.currentItem) != nil) && (self.thePlayer?.rate != 0){
            return true
        }
        return false
    }

//    func playAudioPlayer() {
//
//        // Setup audio session
//        var setOverrideError:NSError!
//        var setCategoryError:NSError!
//
//        let session:AVAudioSession! = AVAudioSession.sharedInstance()
//        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:&setCategoryError)
//        session.setActive(true, error:&setCategoryError)
//
//        session.overrideOutputAudioPort(AVAudioSessionPortOverrideSpeaker, error:&setOverrideError)
//
//        //stop the NSTimer
//        self.playerTimer?.invalidate()
//        self.playerTimer = nil
//
//        self.eraseBtn?.enabled = true
//        self.eraseBtn?.alpha = 1.0
//
//        self.recordBtn?.enabled = self.stopBtn.enabled = false
//
//        playBtn.setImage(K_SETIMAGE("existing_controls_pause_btn_normal.png"), forState:UIControlStateNormal)
//        playBtn.setImage(K_SETIMAGE("existing_controls_pause_btn_disable.png"), forState:UIControlStateDisabled)
//
//        self.performSelector(Selector("playRecordedAudio"), withObject:nil, afterDelay:1.0)
//
//        if lroundf(self.recordedFileDuration) == self.waveFormSlider.value {
//
//            NSLog("LAST VALUE @@@@@@@@@@@")
//
//            self.thePlayer?.seek(to: CMTime(value: 0, timescale: 1))
//        }
//
//        let playerItem = self.thePlayer?.currentItem
//
//        // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
//        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
//
//        //NotificationCenter.default.addObserver(self, selector:Selector("itemDidFinishPlaying:"), name:AVPlayerItemDidPlayToEndTimeNotification, object:playerItem)
//
//        self.playerTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:Selector("updatePlayerTiming"), userInfo:self.thePlayer, repeats:true)
//
//    }

//    @objc func itemDidFinishPlaying(notification:NSNotification) {
//        // Will be called when AVPlayer finishes playing playerItem
//        self.thePlayer?.seek(to: CMTime(value: 0, timescale: 1))
//        self.thePlayer?.pause()
//
//        self.stopAllProcess()
//
//        self.waveformView.progressTime = CMTimeMakeWithSeconds(lroundf(self.recordedFileDuration), 10000)
//
//        if !isRecordStopTapped {
//            self.recordBtn?.enabled = self.stopBtn?.enabled = true
//        }
//        if self.segmentedControl?.selectedSegmentIndex == 2 {
//            self.recordBtn?.enabled = self.stopBtn?.enabled = false
//        }
//
//        let currentTime:UILabel! = self.view.viewWithTag(TAG_CURRENTTIME_LBL)
//        currentTime.text = String(format:"%@ | %@", self.timeFormatted(lroundf(self.recordedFileDuration)),self.timeFormatted(lroundf(self.recordedFileDuration)))
//
//        self.waveFormSlider?.setValue(lroundf(self.recordedFileDuration), animated:true)
//
//        NotificationCenter.default.removeObserver(self, name:AVPlayerItemDidPlayToEndTimeNotification, object:nil)
//
//    }
    
//    func updatePlayerTiming() {
//        let playerItem  = self.thePlayer?.currentItem
//        let currentTime = playerItem?.currentTime
//        let time = CMTimeGetSeconds(currentTime)
//        if !isBookMarkTap {
//            if (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_INDEXING) == K_SWITCH_ON) {
//                let current:String! = self.timeFormatted(lroundf(time))
//                if (self.bookMarkArr?.count ?? 0) > 0 {
//
//                    for var i in 0..<(self.bookMarkArr?.count ?? 0){
//                        switch (i) {
//                            case 0:
//                                if (self.bookMarkArr.objectAtIndex(0) == current) {
//                                    sliderValue = BOOKMARK_1
//                                    self.showBookMark(1)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//                            case 1:
//                                if (self.bookMarkArr.objectAtIndex(1) == current) {
//                                    sliderValue = BOOKMARK_2
//                                    self.showBookMark(2)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//                            case 2:
//                                if (self.bookMarkArr.objectAtIndex(2) == current) {
//                                    sliderValue = BOOKMARK_3
//                                    self.showBookMark(3)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 3:
//                                if (self.bookMarkArr.objectAtIndex(3) == current) {
//                                    sliderValue = BOOKMARK_4
//                                    self.showBookMark(4)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 4:
//                                if (self.bookMarkArr.objectAtIndex(4) == current) {
//                                    sliderValue = BOOKMARK_5
//                                    self.showBookMark(5)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//
//                            case 5:
//
//                                if (self.bookMarkArr.objectAtIndex(5) == current) {
//                                    sliderValue = BOOKMARK_6
//                                    self.showBookMark(6)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 6:
//
//                                if (self.bookMarkArr.objectAtIndex(6) == current) {
//                                    sliderValue = BOOKMARK_7
//                                    self.showBookMark(7)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//                        case 7:
//                                if (self.bookMarkArr.objectAtIndex(7) == current) {
//                                    sliderValue = BOOKMARK_8
//                                    self.showBookMark(8)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 8:
//                                if (self.bookMarkArr.objectAtIndex(8) == current) {
//                                    sliderValue = BOOKMARK_9
//                                    self.showBookMark(9)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 9:
//                                if (self.bookMarkArr.objectAtIndex(9) == current) {
//                                    sliderValue = BOOKMARK_10
//                                    self.showBookMark(10)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 10:
//                                if (self.bookMarkArr.objectAtIndex(10) == current) {
//                                    sliderValue = BOOKMARK_11
//                                    self.showBookMark(11)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 11:
//                                if (self.bookMarkArr.objectAtIndex(11) == current) {
//                                    sliderValue = BOOKMARK_12
//                                    self.showBookMark(12)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 12:
//                                if (self.bookMarkArr.objectAtIndex(12) == current) {
//                                    sliderValue = BOOKMARK_13
//                                    self.showBookMark(13)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                        case 13:
//                                if (self.bookMarkArr.objectAtIndex(13) == current) {
//                                    sliderValue = BOOKMARK_14
//                                    self.showBookMark(14)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 14:
//                                if (self.bookMarkArr.objectAtIndex(14) == current) {
//                                    sliderValue = BOOKMARK_15
//                                    self.showBookMark(15)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 15:
//                                if (self.bookMarkArr.objectAtIndex(15) == current) {
//                                    sliderValue = BOOKMARK_16
//                                    self.showBookMark(16)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 16:
//                                if (self.bookMarkArr.objectAtIndex(16) == current) {
//                                    sliderValue = BOOKMARK_17
//                                    self.showBookMark(17)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 17:
//                                if (self.bookMarkArr.objectAtIndex(17) == current) {
//                                    sliderValue = BOOKMARK_18
//                                    self.showBookMark(18)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 18:
//                                if (self.bookMarkArr.objectAtIndex(18) == current) {
//                                    sliderValue = BOOKMARK_19
//                                    self.showBookMark(19)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            case 19:
//                                if (self.bookMarkArr.objectAtIndex(19) == current) {
//                                    sliderValue = BOOKMARK_20
//                                    self.showBookMark(20)
//                                    if !self.pauseArr.containsObject(current) {
//                                        self.pauseAudioPlayerForBookmark(current)
//                                    }
//                                }
//                                break
//
//                            default:
//                                break
//                        }
//                     }
//                }
//            }
//        }
//        self.updateTimeForPlayer(p: self.thePlayer)
//    }
    
    func stopAllProcess() {
        //stop the NSTimer
        self.playerTimer?.invalidate()
        self.playerTimer = nil
        autoSaveIsOn = false

        // stop the player
        self.stopAudioPlayer()

        playerCurrentTime = 0.0
        progressIn = 0.0

    }

    func showWaveForm() {
        if self.graphView?.alpha == 0 {
            self.graphView?.alpha = 1.0
            if self.customRangeBar?.alpha == 1.0 {
                self.customRangeBar?.alpha = 0.0
            }
        }
    }

    func hideWaveForm() {
        if self.graphView?.alpha == 1.0 {
            self.graphView?.alpha = 0
            self.bookmarkBackwardBtn?.isEnabled = false
            self.bookmarkFordwardBtn?.isEnabled = false
        }
    }

//    func showLoading() {
//        isLoadingShowing = true
//        PTSHELPER.showLoadingIndicatorWithStatus("Processing...", controller:self)
//                APPDELEGATE.tabBar.userInteractionEnabled = false
//                self.navigationController?.navigationBar.isUserInteractionEnabled = false
//                self.view.isUserInteractionEnabled = false
//
//    }

//    func hideLoading() {
//        isLoadingShowing = false
//        PTSHELPER.hideLoadingIndicator(self)
//        APPDELEGATE.tabBar.userInteractionEnabled =  self.navigationController.navigationBar.userInteractionEnabled = self.view.userInteractionEnabled = true
//    }

    func showSegmentView() {
        if self.segmentBgView?.alpha == 0{
            self.segmentBgView?.alpha = 1.0
            let frame = self.segmentBgView?.frame
            self.segmentBgView?.frame = CGRect(x: 0, y: -(frame?.size.height ?? 0), width: self.view.frame.size.width, height: frame?.size.height ?? 0)
            UIView.animate(withDuration: 1.0, delay:0, options:.transitionFlipFromTop, animations:{
                self.segmentBgView?.frame  = CGRect(x: 0, y: -5, width: self.view.frame.size.width, height: frame?.size.height ?? 0)
                self.customRangeBar?.frame = CGRect(x: 10, y: 15, width: self.view.frame.size.width - 20, height: 35)
                self.headerView?.frame     = CGRect(x: 0, y: (frame?.size.height ?? 0) - 20, width: self.headerView?.frame.size.width ?? 0, height: self.headerView?.frame.size.height ?? 0)
            },completion:nil)
        }
    }

    func hideSegmentView() {
        if self.segmentBgView?.alpha == 1.0 {
            let frame = self.segmentBgView?.frame
            self.segmentBgView?.frame = CGRect(x: 0, y: 0, width: frame?.size.width ?? 0, height: frame?.size.height ?? 0)
            UIView.animate(withDuration: 1.0,delay:0,options:.transitionFlipFromBottom, animations:{
                self.segmentBgView?.frame = CGRect(x: 0, y: -(frame?.size.height ?? 0), width: frame?.size.width ?? 0, height: frame?.size.height ?? 0)
                self.segmentBgView?.alpha = 0.0
                self.headerView?.frame = CGRect(x: 0, y: 0, width: self.headerView?.frame.size.width ?? 0, height: self.headerView?.frame.size.height ?? 0)
                self.bookmarkBtn?.isEnabled = true
                if self.bookMarkArr?.count == 20 {
                    self.bookmarkBtn?.isEnabled = false
                }
             }, completion:nil)
        }
    }
    
//    func showPartialDeleteView() {
//        self.didFinishOverwrite()
//
//        UIView.animateWithDuration(1.0, delay:0, options:.transitionFlipFromBottom, animations:{
//
//             self.recordCtrlsView.frame = CGRect(0, self.partialDelView.frame.origin.y + self.partialDelView.frame.size.height, self.pageScrollView.frame.size.width, 80)
//
//             self.playerCtrlsView.frame = CGRect(0, self.recordCtrlsView.frame.size.height + self.recordCtrlsView.frame.origin.y, self.view.frame.size.width, 50)
//
//             self.detailsView.frame = CGRect(0, self.playerCtrlsView.frame.size.height + self.playerCtrlsView.frame.origin.y, self.view.frame.size.width, self.headerView.frame.size.height - (self.playerCtrlsView.frame.size.height + self.playerCtrlsView.frame.origin.y))
//
//             if self.partialDelView.alpha == 0.0 {
//
//                 self.partialDelView.alpha = 1.0
//                 self.bookmarkView.alpha = 0.0
//
//                 self.recordBtn.enabled = self.stopBtn.enabled = false
//                 self.bookmarkBtn.enabled = false
//
//                 if !self.isPlaying() {
//
//                     self.eraseBtn.enabled = false
//
//                     self.eraseBtn.setImage(K_SETIMAGE("start_erase_btn_normal.png"), forState:UIControlStateNormal)
//                     self.eraseBtn.setImage(K_SETIMAGE("start_erase_btn_disable.png"), forState:UIControlStateHighlighted)
//                     self.eraseBtn.setImage(K_SETIMAGE("start_erase_btn_disable.png"), forState:UIControlStateDisabled)
//
//                     isErasing = FIRSTTIME
//                 }
//                 else
//                 {
//                     self.eraseBtn.enabled = true
//
//                     if isErasing == FIRSTTIME {
//                         self.eraseBtn.setImage(K_SETIMAGE("start_erase_btn_normal.png"), forState:UIControlStateNormal)
//                         self.eraseBtn.setImage(K_SETIMAGE("start_erase_btn_disable.png"), forState:UIControlStateHighlighted)
//                         self.eraseBtn.setImage(K_SETIMAGE("start_erase_btn_disable.png"), forState:UIControlStateDisabled)
//                     }
//                     else
//                     {
//                         self.eraseBtn.setImage(K_SETIMAGE("end_erase_btn_normal.png"), forState:UIControlStateNormal)
//                         self.eraseBtn.setImage(K_SETIMAGE("end_erase_btn_disable.png"), forState:UIControlStateHighlighted)
//                         self.eraseBtn.setImage(K_SETIMAGE("start_erase_btn_disable.png"), forState:UIControlStateDisabled)
//                     }
//                 }
//
//                 self.playerButtonsEnable = true
//
//                 if IS_IPHONE_5 {
//                     self.pageScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height)
//                 }
//                 else if IS_IPHONE_4 {
//                     self.pageScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height + 60)
//                 }
//             }
//        },
//        completion:nil)
//
//    }

//    func showOverwriteView() {
//        self.hidePartialDeleteView()
//        let newTime = CMTime(0, 1)
//        self.thePlayer?.seek(to: newTime)
//
//        self.playAudioPlayer()
//
//        UIView.animateWithDuration(1.0, delay:0, options:.transitionFlipFromBottom, animations:{
//
//             customRangeBar.alpha = 0.0
//
//             self.graphView.frame = CGRect(10, customRangeBar.frame.origin.y + customRangeBar.frame.size.height - 20, self.pageScrollView.frame.size.width - 20, 45)
//
//             self.overWriteView.frame = CGRect(0, self.graphView.frame.origin.y + self.graphView.frame.size.height + 20, self.pageScrollView.frame.size.width, 50)
//
//             self.recordCtrlsView.frame = CGRect(0, self.overWriteView.frame.origin.y + self.overWriteView.frame.size.height, self.pageScrollView.frame.size.width, 80)
//
//             self.playerCtrlsView.frame = CGRect(0, self.recordCtrlsView.frame.size.height + self.recordCtrlsView.frame.origin.y, self.view.frame.size.width, 50)
//
//             self.detailsView.frame = CGRect(0, self.playerCtrlsView.frame.size.height + self.playerCtrlsView.frame.origin.y, self.view.frame.size.width, self.headerView.frame.size.height - (self.playerCtrlsView.frame.size.height + self.playerCtrlsView.frame.origin.y))
//
//             if self.overWriteView.alpha == 0.0 {
//
//                 self.overWriteView.alpha = 1.0
//                 self.bookmarkView.alpha = 0.0
//
//                 self.recordBtn.enabled = self.stopBtn.enabled = false
//                 self.bookmarkBtn.enabled = false
//
//                 self.startPointBtn.alpha = 1.0
//                 self.endPointBtn.alpha = 0.0
//                 self.startOverwriteBtn.alpha = 0.0
//
//                 startPointTime = 0
//                 endPointTime = 0
//
//                 if !self.isPlaying() {
//                     isOverwriting = FIRSTTIME
//                 }
//                 self.playerButtonsEnable = true
//             }
//         },
//
//         completion:nil)
//    }
    
//    func hideOverwriteView() {
//            UIView.animateWithDuration(1.0,
//                                  delay:0,
//                                       options:.transitionFlipFromTop,
//
//                             animations:{
//
//                                 if self.overWriteView.alpha == 1.0 {
//                                     self.overWriteView.alpha = 0.0
//                                     self.bookmarkView.alpha = 1.0
//                                 }
//
//                                 if (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_INDEXING) == K_SWITCH_OFF) {
//
//                                     if editMode == 0 || editMode == 3 {
//
//                                         self.graphView.frame = CGRect(10, 10, self.pageScrollView.frame.size.width - 20, 45)
//                                     } else {
//                                         self.graphView.frame = CGRect(10, customRangeBar.frame.origin.y + customRangeBar.frame.size.height + 5, self.pageScrollView.frame.size.width - 20, 45)
//                                     }
//
//                                     self.overWriteView.frame = CGRect(0, self.graphView.frame.origin.y + self.graphView.frame.size.height + 20, self.pageScrollView.frame.size.width, 50)
//
//                                     self.recordCtrlsView.frame = CGRect(0, self.graphView.frame.origin.y + self.graphView.frame.size.height + 20, self.pageScrollView.frame.size.width, 80)
//
//                                     if IS_IPHONE_5 {
//                                         self.pageScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height - 40)
//                                     }
//                                     else if IS_IPHONE_4 {
//                                         self.pageScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height + 40)
//
//                                     }
//                                 }
//                                 else
//                                 {
//                                    // self.graphView.frame = CGRect(10, customRangeBar.frame.origin.y + customRangeBar.frame.size.height + 5, self.pageScrollView.frame.size.width - 20, 45);
//
//                                     if editMode == 0 || editMode == 3 {
//
//                                         self.graphView.frame = CGRect(10, 10, self.pageScrollView.frame.size.width - 20, 45)
//                                     } else {
//                                         self.graphView.frame = CGRect(10, customRangeBar.frame.origin.y + customRangeBar.frame.size.height + 5, self.pageScrollView.frame.size.width - 20, 45)
//                                     }
//
//                                     self.bookmarkView.frame = CGRect(0, self.graphView.frame.origin.y + self.graphView.frame.size.height + 10, self.pageScrollView.frame.size.width, 120)
//
//                                     self.overWriteView.frame = CGRect(0, self.bookmarkView.frame.origin.y + self.bookmarkView.frame.size.height + 20, self.pageScrollView.frame.size.width, 50)
//
//                                     if isFirstTimeInEditing && PTSHelper.isiPad() {
//
//                                         NSLog("RECORD CONTROL FIRST @@@@@@@@@@@@@ %@", NSStringFromCGRect(self.bookmarkView.frame))
//
//                                         self.recordCtrlsView.frame = CGRect(0, self.bookmarkView.frame.origin.y + self.bookmarkView.frame.size.height + 10, self.pageScrollView.frame.size.width, 50)
//
//                                     } else {
//                                         //NSLog(@"RECORD CONTROL SECOND @@@@@@@@@@@@@");
//                                        self.recordCtrlsView.frame = CGRect(0, self.bookmarkView.frame.origin.y + self.bookmarkView.frame.size.height + 10, self.pageScrollView.frame.size.width, 80)
//                                     }
//
//                                     if IS_IPHONE_5 {
//                                         self.pageScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height)
//                                     }
//                                     else if IS_IPHONE_4 {
//                                         self.pageScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height + 105)
//                                     }
//                                 }
//
//                                 self.playerCtrlsView.frame = CGRect(0, self.recordCtrlsView.frame.size.height + self.recordCtrlsView.frame.origin.y, self.view.frame.size.width, 50)
//
//                                 self.detailsView.frame = CGRect(0, self.playerCtrlsView.frame.size.height + self.playerCtrlsView.frame.origin.y, self.view.frame.size.width, self.headerView.frame.size.height - (self.playerCtrlsView.frame.size.height + self.playerCtrlsView.frame.origin.y))
//
//                             },
//                             completion:{ (finished:Bool) in
//
//                                 NSLog("OVERWRITE COMPLETION @@@@@@@@@@@")
//
//                                 if self.isPlaying() {
//                                     self.recordBtn.enabled = self.stopBtn.enabled = false
//                                 }
//                                 else {
//                                     if isRecordStopTapped {
//                                         NSLog("STOP BUTTON HIDDEN ############")
//                                         self.recordBtn.enabled = self.stopBtn.enabled = false
//                                     } else {
//                                         NSLog("STOP BUTTON SHOWING ############")
//                                         self.recordBtn.enabled = self.stopBtn.enabled = true
//                                     }
//
//                                     if !isRecordStarted {
//                                         self.stopBtn.enabled = false
//                                     }
//                                 }
//                                 self.bookmarkBtn.enabled = false
//
//                                 isErasing = FIRSTTIME
//                             })
//
//        }

//        func hidePartialDeleteView() {
//            self.didFinishOverwrite()
//
//            UIView.animateWithDuration(1.0,
//                                  delay:0,
//                                       options:.transitionFlipFromTop,
//
//                             animations:{
//
//                                 if self.partialDelView.alpha == 1.0 {
//                                     self.partialDelView.alpha = 0.0
//                                     self.bookmarkView.alpha = 1.0
//                                 }
//
//
//                                 if (AppDelegate.sharedInstance().userDefaults.string(forKey: K_KEY_SWITCH_INDEXING) == K_SWITCH_OFF) {
//
//                                     self.recordCtrlsView?.frame = CGRect(x: 0, y: (self.graphView?.frame.origin.y ?? 0.0) + (self.graphView?.frame.size.height ?? 0.0)  + 10, width: (self.pageScrollView?.frame.size.width ?? 0.0), height: 80)
//
//                                     if IS_IPHONE_5 {
//                                         self.pageScrollView?.contentSize = CGSize(width: 0, height: self.headerView?.frame.size.height ?? 0.0 - 40)
//                                     }
//                                     else if IS_IPHONE_4 {
//                                         self.pageScrollView?.contentSize = CGSize(width: 0, height: (self.headerView?.frame.size.height ?? 0.0) + 40)
//                                     }
//                                 }
//                                 else
//                                 {
//                                     self.recordBtn?.isEnabled = true
//                                     self.stopBtn?.isEnabled = true
//
//                                     self.recordCtrlsView?.frame = CGRect(x: 0, y: (self.bookmarkView?.frame.origin.y ?? 0.0) + self.bookmarkView.frame.size.height, width: (self.pageScrollView?.frame.size.width ?? 0.0), height: 80)
//
//                                     if IS_IPHONE_5 {
//                                         self.pageScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height)
//                                     }
//                                     else if IS_IPHONE_4 {
//                                         self.pageScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height + 105)
//                                     }
//
//                                     if PTSHelper.isiPad() {
//                                         let btnSize:CGFloat = 55
//                                         let originX:CGFloat = 20
//
//                                         let recordBtnFrame:CGRect = CGRect(originX , self.recordCtrlsView.frame.size.height * 0.5 - btnSize * 0.85, btnSize, btnSize)
//                                         self.recordBtn.frame = recordBtnFrame
//                                         let stopBtnFrame:CGRect = CGRect(self.recordCtrlsView.frame.size.width - originX - btnSize, self.recordCtrlsView.frame.size.height * 0.5 - btnSize * 0.85, btnSize, btnSize)
//                                         self.stopBtn.frame = stopBtnFrame
//
//                                         let timingLbl:UILabel! = self.view.viewWithTag(TAG_TIMING_LBL)
//                                         timingLbl.frame = CGRect((self.recordBtn.frame.origin.x + self.recordBtn.frame.size.width), self.recordBtn.frame.origin.y + 15, self.recordCtrlsView.frame.size.width - ((self.recordBtn.frame.origin.x + self.recordBtn.frame.size.width) + originX + btnSize) , btnSize)
//
//                                         let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//                                         statusLbl.frame = CGRect(timingLbl.frame.origin.x, timingLbl.frame.origin.y + timingLbl.frame.size.height , timingLbl.frame.size.width, 15)
//                                     }
//                                 }
//
//                                 self.playerCtrlsView.frame = CGRect(0, self.recordCtrlsView.frame.size.height + self.recordCtrlsView.frame.origin.y, self.view.frame.size.width, 50)
//
//                                 self.detailsView.frame = CGRect(0, self.playerCtrlsView.frame.size.height + self.playerCtrlsView.frame.origin.y, self.view.frame.size.width, self.headerView.frame.size.height - (self.playerCtrlsView.frame.size.height + self.playerCtrlsView.frame.origin.y))
//
//                             },
//                             completion:{ (finished:Bool) in
//
//                                 if self.isPlaying() {
//                                     self.recordBtn.enabled = self.stopBtn.enabled = false
//                                 }
//                                 else {
//                                     self.recordBtn.enabled = self.stopBtn.enabled = true
//
//                                     if !isRecordStarted {
//                                         self.stopBtn.enabled = false
//                                     }
//                                 }
//                                 self.bookmarkBtn.enabled = false
//
//                                 isErasing = FIRSTTIME
//                             })
//
//        }
    
    func showAutoSaveAlert() {
        //Need to show new alert
//        let saveAlert:UIAlertView! = UIAlertView(title:"PTS Dictate", message:"Auto File Saving has reached. Please save your file.", delegate:self, cancelButtonTitle:"OK", otherButtonTitles:nil)
//        saveAlert.tag = TAG_AUTO_SAVE_ALERT_TAG
//        saveAlert.show()
    }

//    func textTospeech(text:String!) {
//        // Setup audio session
//        var setOverrideError:NSError!
//        var setCategoryError:NSError!
//
//        let session:AVAudioSession! = AVAudioSession.sharedInstance()
//        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:&setCategoryError)
//        session.setActive(true, error:&setCategoryError)
//
//
//        session.overrideOutputAudioPort(AVAudioSessionPortOverrideSpeaker, error:&setOverrideError)
//
//
//        let synthesizer:AVSpeechSynthesizer! = AVSpeechSynthesizer()
//        let utterance:AVSpeechUtterance! = AVSpeechUtterance.speechUtteranceWithString(text)
//
//
//        var adjustedRate:Float = AVSpeechUtteranceDefaultSpeechRate *  0
//
//        if adjustedRate > AVSpeechUtteranceMaximumSpeechRate
//        {
//            adjustedRate = AVSpeechUtteranceMaximumSpeechRate
//        }
//
//        if adjustedRate < AVSpeechUtteranceMinimumSpeechRate
//        {
//            adjustedRate = AVSpeechUtteranceMinimumSpeechRate
//        }
//
//        utterance.rate = adjustedRate
//
//        let pitchMultiplier:Float = 0
//
//        if (pitchMultiplier >= 0.5) && (pitchMultiplier <= 2.0)
//        {
//            utterance.pitchMultiplier = pitchMultiplier
//        }
//
//        synthesizer.speak(utterance)
//    }

//    func callAutoSave() {
//        if ((self.audio_Recorder?.recording) != nil) {
//
//            autoSaveIsOn = true
//
//            let statusLbl = self.view.viewWithTag(TAG_STATUS_LBL)
//            statusLbl.text = "AutoSave"
//
//            isPausedFromTab = true
//
//            self.audio_Recorder?.pause()
//
//            self.stopRecordingTimer()
//
//            let overWrite:UILabel! = self.view.viewWithTag(TAG_OVERWRITE_LBL)
//
//            let timing:UILabel! = self.view.viewWithTag(TAG_TIMING_LBL)
//
//            if isRecording == FIRSTTIME {
//                timing.text = self.timeFormatted(lroundf(self.audio_Recorder?.currentTime))
//            }
//            else{
//
//                if playerCurrentTime != 0  && self.segmentedControl?.selectedSegmentIndex == 2 {
//
//                    if self.recordedFileDuration < (self.audio_Recorder?.currentTime + playerCurrentTime) {
//
//                        timing.text = self.timeFormatted((lroundf(self.audio_Recorder?.currentTime) + lroundf(playerCurrentTime)))
//
//                        overWrite.text = ""
//
//                    }
//                    else
//                    {
//                        overWrite.text = self.timeFormatted((lroundf(self.audio_Recorder?.currentTime) + lroundf(playerCurrentTime)))
//                        timing.text = self.timeFormatted(lroundf(self.recordedFileDuration))
//                    }
//                }
//
//                else if self.segmentedControl?.selectedSegmentIndex == 1 {
//
//                    overWrite.text = self.timeFormatted((lroundf(self.audio_Recorder?.currentTime) + lroundf(insertingTime)))
//                    timing.text = self.timeFormatted((lroundf(self.audio_Recorder?.currentTime + self.recordedFileDuration)))
//                }
//
//                else
//                {
//                    timing.text = self.timeFormatted(totalSeconds: (lroundf(self.audio_Recorder?.currentTime) + lroundf(recordedFileDuration)))
//                }
//            }
//
//            self.showAutoSaveAlert()
//
//            self.textTospeech(text: "Auto File Saving has reached. Please save your file.")
//
//            //[self updateRecordedTiming];
//
//            self.recordBtn.setImage(K_SETIMAGE("record_record_btn_normal.png"), forState:.normal)
//            self.recordBtn.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:.disabled)
//        }
//        else
//        {
//            isFirstTime = !(isFirstTime ?? false)
//        }
//    }
    
    func xPositionFromSliderValue(aSlider:UISlider!) -> Float {
        let sliderRange = Float(aSlider.frame.size.width - (aSlider.currentThumbImage?.size.width ?? 0))
        let sliderOrigin = Float(aSlider.frame.origin.x + ((aSlider.currentThumbImage?.size.width ?? 0) / 2.0))

        let sliderValueToPixels:Float = (((aSlider.value - aSlider.minimumValue)/(aSlider.maximumValue - aSlider.minimumValue)) * sliderRange) + sliderOrigin

        return sliderValueToPixels
    }

//    func didFinishOverwrite() {
//        self.hideOverwriteView()
//        self.startPointView?.removeFromSuperview()
//        self.endPointView?.removeFromSuperview()
//
//        self.startOverwriteBtn?.alpha = 0
//
//        startPointTime = 0
//        endPointTime = 0
//
//        self.lblStartPoint?.removeFromSuperview()
//        self.lblEndPoint?.removeFromSuperview()
//    }

//    func partialDeleteComplete() {
//        self.recordBtn?.enabled = (self.stopBtn?.enabled == false)
//        self.recordBtn?.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:.disabled)
//    }

    // MARK: - NSNOTIFICATION
//    @objc func batteryChanged(notification:NSNotification!) {
//        let device = UIDevice.current
//        if device.batteryLevel * 100 <= 10 {
//            if device.batteryState == .unplugged {
//
//                if ((self.audio_Recorder?.isRecording) != nil){
//                    isPausedFromTab = true
//
//                    self.audio_Recorder?.pause()
//                    self.stopRecordingTimer()
//
//                    let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//                    statusLbl.text = K_PAUSED
//
//                    self.recordBtn.setImage(K_SETIMAGE("record_record_btn_normal.png"), forState:UIControlStateNormal)
//                    self.recordBtn.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)
//
//                    self.setTimingText()
//
//                    NSNotificationCenter.defaultCenter().removeObserver(self, name:UIDeviceBatteryLevelDidChangeNotification, object:nil)
//
//                    //Need to show new alert
////                    let saveAlert:UIAlertView! = UIAlertView(title:K_KEY_APP_TITLE, message:"Your device battery percentage is getting very low. Please save your file first & you can edit later", delegate:self, cancelButtonTitle:"OK", otherButtonTitles: nil)
////                    saveAlert.tag = TAG_ALERT_STOP_RECORD_TAG
////                    saveAlert.show()
//
//                    self.textTospeech(text: "10 percentage battery remaining. Please save your file")
//                }
//                else {
//
//                    if APPDELEGATE.userDefaults.boolForKey(K_KEY_IS_RECORD_STARTED) {
//
//                        if !isLoadingShowing {
//
//                            NSLog("=======> ALREADY PAUSED || STOPPED <========")
//
//                            isPausedFromTab = false
//
//                            NotificationCenter.default.removeObserver(self, name:UIDevice.batteryLevelDidChangeNotification, object:nil)
//
//                            //Need to show new alert
////                            let saveAlert:UIAlertView! = UIAlertView(title:K_KEY_APP_TITLE, message:"Your device battery percentage is getting very low. Please save your file first & you can edit later", delegate:self, cancelButtonTitle:"OK", otherButtonTitles: nil)
////                            saveAlert.tag = TAG_ALERT_ALREADY_PAUSED_TAG
////                            saveAlert.show()
//
//                            self.textTospeech(text: "10 percentage battery remaining. Please save your file")
//
//                        }
//                    }
//                }
//            }
//        }
//    }

                                    

//     @objc func receiveNotification(notification:Notification) {
//
//         if (notification.name == NSNotification.Name.init(K_NOTICATION_RECORDING.rawValue)) {
//            if ((self.audio_Recorder?.isRecording) != nil){
//                isPausedFromTab = true
//
//                self.audio_Recorder?.pause()
//                self.stopRecordingTimer()
//
//                let statusLbl = self.view.viewWithTag(TAG_STATUS_LBL) as? UILabel
//                statusLbl.text = K_PAUSED
//
//                self.recordBtn.setImage(K_SETIMAGE("record_record_btn_normal.png"), forState:UIControlStateNormal)
//                self.recordBtn.setImage(K_SETIMAGE("record_record_btn_disable.png"), forState:UIControlStateDisabled)
//
//                self.setTimingText()
//
//                let saveAlert:UIAlertView! = UIAlertView(title:K_KEY_APP_TITLE, message:K_STOP_CURRENT_RECORD_ALERT, delegate:self, cancelButtonTitle:K_YES, otherButtonTitles:K_NO, nil)
//                saveAlert.tag = TAG_ALERT_STOP_RECORD_TAG
//                saveAlert.show()
//            }
//            else {
//
//                let statusLbl = self.view.viewWithTag(TAG_STATUS_LBL) as? UILabel
//
//                if (statusLbl.text == K_PAUSED) || (statusLbl.text == K_STOPPED) {
//                    isPausedFromTab = false
//
//                    let saveAlert:UIAlertView! = UIAlertView(title:K_KEY_APP_TITLE, message:K_STOP_CURRENT_RECORD_ALERT, delegate:self, cancelButtonTitle:K_YES, otherButtonTitles:K_NO, nil)
//                    saveAlert.tag = TAG_ALERT_ALREADY_PAUSED_TAG
//                    saveAlert.show()
//                }
//            }
//        }
//    }
    
    // MARK: - Gestures Interaction
    
//    func gestureRecognizer(_ gestureRecognizer:UIGestureRecognizer!, shouldRecognizeSimultaneouslyWith otherGestureRecognizer:UIGestureRecognizer!) -> Bool {
//        return true
//    }
//
//    func gestureRecognizer(_ gestureRecognizer:UIGestureRecognizer!, shouldReceive touch:UITouch!) -> Bool {
//        if (touch.view is UIScrollView) {
//            // prevent recognizing touches on the slider
//            return false
//        }
//        return true
//    }

    // MARK: -
    // MARK: UIAlertView Delegate Methods


//    func alertView(alertView:UIAlertView!, clickedButtonAtIndex buttonIndex:Int) {
//
//        if alertView.tag == 0 {
//            isEdit = true
//
//            self.recordProcess(sender: self.recordBtn, flag:false)
//            APPDELEGATE.userDefaults().setObject("1", forKey:K_KEY_IS_EDITING)
//        }
//
//        if alertView.tag == TAG_SAVE_ALERT_TAG {
//
//            if buttonIndex == 0 {
//
//                NSNotificationCenter.defaultCenter().removeObserver(self, name:K_NOTICATION_RECORDING, object:nil)
//
//                if !editRecording {
//
//                    let filecountString:String! = String(format:"%@",fileCountStr)
//                    AppDelegate.sharedInstance().userDefaults.set(filecountString, forKey:K_KEY_RECORD_FILE_COUNT)
//                    AppDelegate.sharedInstance().userDefaults.synchronize()
//                }
//
//                if isAutoSavedFile {
//
//                    let arr:NSMutableArray! = AppDelegate.sharedInstance().userDefaults.objectForKey(K_KEY_AUTO_SAVED_FILE_ARRAY).mutableCopy()
//
//                    NSLog("AUTOSAVED ARRAY ELSE ===> %@  %@", arr, self.fileNameLbl?.text)
//
//                    for var i in 0..<arr.count{
//                        let stringToCheck:String! = arr.objectAtIndex(i)
//                        if (stringToCheck == self.fileNameLbl?.text) {
//                            arr.removeObject(at: i)
//                            NSLog("AUTOSAVED REMOVING ===> %@", arr)
//                        }
//                     }
//
//                    AppDelegate.sharedInstance().userDefaults.set(arr, forKey:K_KEY_AUTO_SAVED_FILE_ARRAY)
//                    AppDelegate.sharedInstance().userDefaults.synchronize()
//                }
//
//                self.saveIntoDataBase(isAutoSaveFile: "NO")
//            }
//        }
//
//        if alertView.tag == TAG_DISCARD_ALERT_TAG {
//
//            if buttonIndex == 0 {
//
//                APPDELEGATE.userDefaults.setBool(false, forKey:K_KEY_IS_RECORD_STARTED)
//
//                NSNotificationCenter.defaultCenter().removeObserver(self, name:K_NOTICATION_RECORDING, object:nil)
//
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//
//                    let dataPath:String! = self.getDocumentDirectory().stringByAppendingPathComponent("/Record")
//
//                    let success:Bool = NSFileManager.defaultManager().removeItemAtPath(dataPath, error:nil)
//
//
//                })
//
//                if !editRecording {
//
//                    if !editRecording {
//
//                        let filePath:String! = self.getExistingFolder().stringByAppendingPathComponent(self.fileNameLbl?.text)
//
//                        self.deleteParticularFileInFolder(filepath: filePath)
//
//                    }
//
//                    if (AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_SWITCH_AUTO_SAVING) == K_SWITCH_ON) {
//
//                        if isSaving == SECONDTIME {
//
//                            let rowId:String! = PTSDATAMANAGER.getLastRowId("select id from upload_log ORDER BY id DESC LIMIT 1")
//
//                            //Deleting file name row from database
//                            PTSDATAMANAGER.deleteFile(rowId)
//
//                            fileCountInt = AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_RECORD_FILE_COUNT).intValue() - 1
//                            self.fileCountStr = String(format:"%03d",fileCountInt)
//
//                            let filecountString:String! = String(format:"%@",fileCountStr)
//                            AppDelegate.sharedInstance().userDefaults.set(filecountString, forKey:K_KEY_RECORD_FILE_COUNT)
//                            AppDelegate.sharedInstance().userDefaults.synchronize()
//                        }
//                    }
//
//                    APPDELEGATE.tabBar.previouslySelectedTabBtn = APPDELEGATE.tabBar.logoutTabBtn
//                    APPDELEGATE.tabBar.tabButtonTapped(APPDELEGATE.tabBar.recordTabBtn)
//
//                    PTSHELPER.showTabBar()
//
//                }
//                else {
//
//                    NSLog("YES 2")
//
//                    if (AppDelegate.sharedInstance().userDefaults.valueForKey(K_KEY_SWITCH_AUTO_SAVING) == K_SWITCH_ON) {
//
//                        if isSaving == SECONDTIME {
//                            self.showLoading()
//                            let filePath = self.getDocumentDirectory().appendingPathComponent("EditRecord").appendingPathComponent(self.fileNameLbl?.text ?? "")
//
//                            let fileDuration = self.audioDuration(filePath: filePath)
//
//                            var error:NSError!
//                            let fileDictionary = FileManager.default.attributesOfItem(atPath: filePath)
//                            let size:NSNumber! = fileDictionary.objectForKey(NSFileSize)
//
//                            let fileSize:String! = String(format:"%.2f",(size.floatValue()/1024.0/1024.0)).stringByAppendingString(" Mb")
//
//                            var bookmarks:String!
//
//                            let result:NSMutableArray! = self.bookMarkArr
//
//                            if result.count > 0 {
//                                bookmarks = ""
//
//                                for var i in 0..<result.count {
//                                    if i == 0 {
//                                        print("[result objectAtIndex:0] == > %@", result.object(at: 0))
//                                        bookmarks = result.object(at: i) as! String
//                                    } else {
//                                        bookmarks = bookmarks.stringByAppendingString(",")
//                                        bookmarks = bookmarks.stringByAppendingString(result.objectAtIndex(i))
//                                    }
//                                }
//                            }else{
//                                bookmarks = ""
//                            }
//
//                            let currentRecordingFilePath = self.getDocumentDirectory().stringByAppendingPathComponent("Existing").stringByAppendingPathComponent(self.fileNameLbl.text)
//
//                            self.deleteParticularFileInFolder(filepath: currentRecordingFilePath)
//
//                            var err:NSError!
//
//                            FileManager.default.copyItemAtPath(filePath,
//                                                                    toPath:currentRecordingFilePath,
//                                                                     error:&err)
//
//
//                            let uploadArray:NSMutableArray! = NSMutableArray()
//
//
//                            uploadArray.add(self.editDictionary.valueForKey("comments")) // COMMENTS
//                            uploadArray.add(fileDuration)
//                            uploadArray.add(fileSize)
//                            uploadArray.add(bookmarks) // BOOKMARKS
//                            uploadArray.add(self.editDictionary.valueForKey("rowId"))
//                            uploadArray.add(APPDELEGATE.userDefaults())
//
//                            PTSDATAMANAGER.updateEditRecordDetailsInToUploadFiles(uploadArray)
//
//                            self.hideLoading()
//                        }
//                    }
//
//                    APPDELEGATE.tabBar.previouslySelectedTabBtn = APPDELEGATE.tabBar.logoutTabBtn
//                    APPDELEGATE.tabBar.tabButtonTapped(APPDELEGATE.tabBar.existingTabBtn)
//
//                    PTSHELPER.showTabBar()
//
//                }
//            }
//        }
//
//        if alertView.tag == TAG_ALERT_STOP_RECORD_TAG {
//
//            if buttonIndex == 0 {
//
//                // NSLog(@"======> YES <=====");
//                isPausedFromTab = true
//                let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//                statusLbl.text = K_STOPPED
//
//                self.recordStopButtonTapped(show: false, button:self.stopBtn)
//            }
//            else
//            {
//                let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//                statusLbl.text = K_RECORDING
//
//                self.recordBtn.setImage(K_SETIMAGE("record_pause_btn_normal.png"), forState:UIControlStateNormal)
//                self.recordBtn.setImage(K_SETIMAGE("record_pause_btn_disable.png"), forState:UIControlStateDisabled)
//
//                //[self initAudioRecorder];
//
//                self.audio_Recorder?.record()
//
//                self.startRecordingTimer()
//            }
//        }
//
//        if alertView.tag == TAG_ALERT_ALREADY_PAUSED_TAG {
//
//            if buttonIndex == 0 {
//
//                isPausedFromTab = false
//
//                let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//                statusLbl.text = K_STOPPED
//                self.recordStopButtonTapped(show: true, button:self.stopBtn)
//            }
//            else
//            {
//                // [self recordStopButtonTapped];
//            }
//        }
//
//        if alertView.tag == TAG_AUTO_SAVE_ALERT_TAG {
//
//            NSLog("TAG_AUTO_SAVE_ALERT_TAG")
//
//            let filecountString:String! = String(format:"%@",fileCountStr)
//            AppDelegate.sharedInstance().userDefaults.set(filecountString, forKey:K_KEY_RECORD_FILE_COUNT)
//            AppDelegate.sharedInstance().userDefaults.synchronize()
//
//            isFirstTime = !isFirstTime
//
//            self.recordStopButtonTapped(show: false, button:self.autoSaveBtn)
//
//            //  [self recordStopButtonTapped:NO];
//        }
//
//        if alertView.tag == TAG_WARNING_ALERT_ONE {
//
//            // Commented to fix PTS-17
//            //[self initAudioRecorder];
//
//            self.audio_Recorder?.record()
//            self.startRecordingTimer()
//            let statusLbl:UILabel! = self.view.viewWithTag(TAG_STATUS_LBL)
//            statusLbl.text = K_RECORDING
//        }
//
//        if alertView.tag == TAG_WARNING_ALERT_TWO {
//            self.recordStopButtonTapped(show: false, button:self.stopBtn)
//        }
//
//        if alertView.tag == TAG_FILE_SAVED_ALERT {
//            self.recordBtn?.enabled = self.stopBtn?.enabled = self.segmentedControl?.userInteractionEnabled = true
//        }
//
//        if alertView.tag == TAG_START_OVERWRITE_BTN || alertView.tag == TAG_EDIT_INSERT || alertView.tag == TAG_EDIT_PARTIAL_DELETE {
//            self.showOverwriteView()
//        }
//
//        if alertView.tag == TAG_EDIT_APPEND {
//           // [self didFinishOverwrite];
//
//            self.customRangeBar?.alpha = 0.0
//            //[self showWaveForm]
//            //[self recordProcess:self.recordBtn flag:YES];
//           // [self recordButtonTapped:self.recordBtn flag:YES];
//        }
//
//        if alertView.tag == TAG_END_OVERWRITE_BTN {
//
//            self.thePlayer?.play()
//        }
//
//        if alertView.tag == TAG_EDIT_OVERWRITE {
//
//            //[self didFinishOverwrite];
//
//            if !isStopBtnTappedWhileOverwriting {
//                self.recordStopButtonTapped(false, button:self.stopBtn)
//            } else {
//                isStopBtnTappedWhileOverwriting = false
//            }
//        }
//
//        if alertView.tag == TAG_EDIT_PARTIAL_DELETE_ALERT {
//            //NSLog(@"TAG_EDIT_PARTIAL_DELETE_ALERT ##########");
//            //[self recordStopButtonTapped:NO button:self.stopBtn];
//        }
//
//        if alertView.tag == 7 {
//            let editing:Bool = AppDelegate.sharedInstance().userDefaults.boolForKey(K_KEY_EDIT_RECORD_FILE)
//            if !editing {
//                print("AUTO SAVE NOT EDITING @@@@@@@@@@@@@")
//                let filecountString:String! = String(format:"%@",fileCountStr)
//                AppDelegate.sharedInstance().userDefaults.set(filecountString, forKey:K_KEY_RECORD_FILE_COUNT)
//                AppDelegate.sharedInstance().userDefaults.synchronize()
//            }
//            AppDelegate.sharedInstance().userDefaults.setBool(true, forKey:K_KEY_AUTO_SAVE_FILE)
//            self.goToSaveTheAutoSaveFile("")
//        }
//    }
    
    // MARK: AVAUDIO RECORDER DELEGATES
    func audioRecorderDidFinishRecording(_ avrecorder:AVAudioRecorder, successfully flag:Bool) {
        // NSLog(@"audioRecorderDidFinishRecording");
//        if avrecorder == self.audio_Recorder {
//            // NSLog(@"NORMAL AUDIO RECORDER COMPLETED");
//            AppDelegate.sharedInstance().userDefaults.setBool(true, forKey:K_KEY_IS_RECORD_STOPPED)
//        }
    }

    func audioRecorderBeginInterruption(_ recorder:AVAudioRecorder) {
//        isPausedFromTab = true
//        NSLog("audioRecorderBeginInterruption")
//        self.recordStopButtonTapped(show: false, button:self.stopBtn)
//        let saveAlert:UIAlertView! = UIAlertView(title:K_KEY_APP_TITLE, message:"Due to some interruption, the recording has been auto saved. Please go back to Existing Dictations screen, and choose Edit/Append to continue recording.", delegate:self, cancelButtonTitle:"OK", otherButtonTitles:nil)
//        saveAlert.tag = 7
//        saveAlert.show()
    }

    // MARK:  AVAUDIOPLAYER DELEGATE
    
//    func audioPlayerDidFinishPlaying(_ player:AVAudioPlayer, successfully flag:Bool) {
//        player.stop()
//        player.prepareToPlay()
//        self.stopAllProcess()
//        self.waveformView?.progressTime = CMTimeMakeWithSeconds(self.recordedFileDuration, preferredTimescale: 10000)
////        self.waveformView?.progressTime = CMTimeMakeWithSeconds(lroundf(self.recordedFileDuration), 10000)
//
//        if !isRecordStopTapped {
//            self.recordBtn?.isEnabled = (self.stopBtn?.isEnabled == true)
//        }
//
//                                let currentTime:UILabel! = self.view.viewWithTag(TAG_CURRENTTIME_LBL)
//                                currentTime.text = String(format:"%@ | %@", self.timeFormatted(lroundf(self.recordedFileDuration)),self.timeFormatted(lroundf(self.recordedFileDuration)))
//
//                                self.waveFormSlider?.setValue(Float(lroundf(self.recordedFileDuration)), animated:true)
//
//    }

}
