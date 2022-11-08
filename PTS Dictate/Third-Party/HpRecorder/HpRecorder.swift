//
//  HpRecorder.swift
//  PTS Dictate
//
//  Created by Hero's on 02/11/22.
//
import Foundation
import AVFoundation

public class HPRecorder: NSObject {

    open var recordingSession: AVAudioSession!
    open var audioRecorder: AVAudioRecorder!
    open var queuePlayer:      AVQueuePlayer?
    open var articleChunks = [AVURLAsset]()
    open var queuePlayerPlaying = false
    private var levelTimer = Timer()
    // Time interval to get percent of loudness
    open var timeInterVal: TimeInterval = 0.3
    // File name of audio
    open var audioFilename: URL!
    // Audio input: default speaker, bluetooth
    open var audioInput: AVAudioSessionPortDescription!

    public var isRecording = false

    // Recorder did finish
    open var recorderDidFinish: ((_ recocorder: AVAudioRecorder, _ url: URL, _  success: Bool) -> Void)?
    // Recorder occur error
    open var recorderOccurError: ((_ recocorder: AVAudioRecorder, _ error: Error) -> Void)?
    // Percent of loudness
    open var percentLoudness: ((_ percent: Float) -> Void)?

    open lazy var settings: [String : Any] = {
        return [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }()

    public init(settings: [String : Any], audioFilename: URL, audioInput: AVAudioSessionPortDescription) {
        super.init()
        self.recordingSession = AVAudioSession.sharedInstance()
        self.settings = settings
        self.audioFilename = audioFilename
        self.audioInput = audioInput
    }

    public override init() {
        super.init()
        self.recordingSession = AVAudioSession.sharedInstance()
        self.audioInput = AudioInput().defaultAudioInput()
    }

    // Ask permssion to record audio
    public func askPermission(completion: ((_ allowed: Bool) -> Void)?) {
        if recordingSession.responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) {
            recordingSession.requestRecordPermission({(granted: Bool) -> Void in
                completion?(granted)
            })
        } else {
            completion?(false)
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // Start recording
    public func startRecording(sampleRateKey: Float, fileName: String) {
//        let settings =
//            [ AVFormatIDKey:             Int(kAudioFormatMPEG4AAC)
//              , AVSampleRateKey:           Float(sampleRateKey)
//            , AVNumberOfChannelsKey:     2
//            , AVEncoderAudioQualityKey:  AVAudioQuality.high.rawValue
//            , AVEncoderBitRateKey:       128000
//            ] as [String : Any]
        
//        let settings = [
//            //giving the AVSampleRateKey according to the microphone senstivity value in settings.
//            AVSampleRateKey : sampleRateKey,
//            AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
//            AVNumberOfChannelsKey : NSNumber(value: 2),
//            AVEncoderAudioQualityKey : NSNumber(value: AVAudioQuality.medium.rawValue)
//        ] as [String : Any]
//
//        let url = self.createNewRecordingURL(fileName)

        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .defaultToSpeaker])
            try recordingSession.setPreferredInput(self.audioInput)
            try self.recordingSession.setActive(true)
        } catch {
            print("Couldn't set Audio session category")
        }
        
        do {
            audioRecorder = try AVAudioRecorder(url: self.audioFilename, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.delegate = self
            audioRecorder.record()
            audioRecorder.isMeteringEnabled = true
            
            // TODO: add audio recorder delegate? Interruptions (e.g., calls)
            //       are handled elsewhere anyway

//            self.startRecTimer()

        } catch {
            print("Unable to init audio recorder.")
        }
//        if self.audioFilename == nil {
//            self.audioFilename = self.getDocumentsDirectory().appendingPathComponent("recording.m4a")
//        }
//
        
//
//        do {
//            audioRecorder = try AVAudioRecorder(url: self.audioFilename, settings: settings)
//            audioRecorder.prepareToRecord()
//            audioRecorder.delegate = self
//            audioRecorder.record()
//            audioRecorder.isMeteringEnabled = true
//
//            self.levelTimer = Timer.scheduledTimer(timeInterval: timeInterVal, target: self, selector: #selector(HPRecorder.levelTimerCallback), userInfo: nil, repeats: true)
//            isRecording = true
//
//        } catch {
//            endRecording()
//        }
    }

    // End recording
    public func endRecording() {
        audioRecorder?.stop()
        let assetURL = self.audioRecorder!.url
        let assetOpts = [AVURLAssetPreferPreciseDurationAndTimingKey: true]
        let asset     = AVURLAsset(url: assetURL, options: assetOpts)
        self.articleChunks.append(asset)
        isRecording = false
//        audioFilename = nil
        audioRecorder = nil
        self.levelTimer.invalidate()
    }

    // Pause recorinding
    public func pauseRecording() {
//        if audioRecorder.isRecording {
//            audioRecorder.pause()
//            isRecording = false
//        }
        if self.audioRecorder?.isRecording == true {
            self.endRecording()
            isRecording = false
        } else {
            self.queuePlayer?.pause()
        }
    }
    // Start player
    public func startPlayer() {
        let assetKeys = ["playable"]
        let playerItems = self.articleChunks.map {
            AVPlayerItem(asset: $0, automaticallyLoadedAssetKeys: assetKeys)
        }

        //        playerItem.addObserver(
        //            self,
        //            forKeyPath: #keyPath(AVPlayerItem.status),
        //            options:    [.old, .new],
        //            context:    &RecordViewController.playerItemContext)

        self.queuePlayer = AVQueuePlayer(items: playerItems)
        self.queuePlayer?.actionAtItemEnd = .advance

        self.queuePlayer?.play()
        self.queuePlayerPlaying = true

//        self.updateControlsAndStatus(
//            activeControls: [.stop],
//            controlStatus:  nil)
    }
    // Stop player
    public  func stopPlayer() {
        self.queuePlayer?.pause()
//        self.queuePlayer = nil
        self.queuePlayerPlaying = false
    }
    
    // Creates URL relative to apps Document directory
   public func createNewRecordingURL(_ filename: String = "") -> URL {
       
                let fileURL = filename + ".m4a"
       
                return Constants.documentDir.appendingPathComponent(fileURL)
//        let now = Constants.dateString(Date())
//
//        let fileURL = filename + "_" + now + ".m4a"
//
//        return Constants.documentDir.appendingPathComponent(fileURL)
    }
    public func createInitialRecordingURL(_ filename: String = "") -> URL {


         let fileURL = filename + ".m4a"

         return Constants.documentDir.appendingPathComponent(fileURL)
     }
    
    public func concatChunks(filename: String) {
        let composition = AVMutableComposition()

        var insertAt = CMTimeRange(start: CMTime.zero, end: CMTime.zero)

        for asset in self.articleChunks {
            let assetTimeRange = CMTimeRange(
                start: CMTime.zero,
                end:   asset.duration)

            do {
                try composition.insertTimeRange(assetTimeRange,
                                                of: asset,
                                                at: insertAt.end)
            } catch {
                NSLog("Unable to compose asset track.")
            }

            let nextDuration = insertAt.duration + assetTimeRange.duration
            insertAt = CMTimeRange(
                start:    CMTime.zero,
                duration: nextDuration)
        }

        let exportSession =
            AVAssetExportSession(
                asset:      composition,
                presetName: AVAssetExportPresetAppleM4A)

//        let filename =
//              "1"
//            + "-"
//            + "2"

        exportSession?.outputFileType = AVFileType.m4a
        exportSession?.outputURL = self.createNewRecordingURL(filename)
        

     // Leaving here for debugging purposes.
     // exportSession?.outputURL = self.createNewRecordingURL("exported-")

     // TODO: #36
     // exportSession?.metadata = ...

        exportSession?.canPerformMultiplePassesOverSourceMediaData = true
        /* TODO? According to the docs, if multiple passes are enabled and
         "When the value of this property is nil, the export session
         will choose a suitable location when writing temporary files."
         */
        // exportSession?.directoryForTemporaryFiles = ...

        /* TODO?
         Listing all cases for completeness sake, but may just use `.completed`
         and ignore the rest with a `default` clause.
         OR
         because the completion handler is run async, KVO would be more appropriate
         */
        exportSession?.exportAsynchronously {

            switch exportSession?.status {
            case .unknown?: break
            case .waiting?: break
            case .exporting?: break
            case .completed?:
                /* Cleaning up partial recordings
                 */
                for asset in self.articleChunks {
                    try! FileManager.default.removeItem(at: asset.url)
                }

                /* https://stackoverflow.com/questions/26277371/swift-uitableview-reloaddata-in-a-closure
                */
                DispatchQueue.main.async {
//                    self.listRecordings.tableView.reloadData()
                    self.articleChunks = [AVURLAsset]()
                }

                /* Resetting `articleChunks` here, because this function is
                 called asynchronously and calling it from `queueTapped` or
                 `submitTapped` may delete the files prematurely.
                 */
//                self.articleChunks = [AVURLAsset]()
            case .failed?: break
            case .cancelled?: break
            case .none: break
            }
        }
    }
    
    public  func reset(){
        self.audioRecorder = nil
        self.queuePlayer   = nil
    }
    
    // Resume recording
    public func resumeRecording() {
        if !audioRecorder.isRecording {
            audioRecorder.record()
            isRecording = true
        }
    }

    @objc func levelTimerCallback() {
        audioRecorder.updateMeters()
        let averagePower = audioRecorder.averagePower(forChannel: 0)
        let percentage = self.getIntensityFromPower(decibels: averagePower)
        self.percentLoudness?(percentage*100)
    }

    // Will return a value between 0.0 ... 1.0, based on the decibels
    func getIntensityFromPower(decibels: Float) -> Float {
        let minDecibels: Float = -160
        let maxDecibels: Float = 0

        // Clamp the decibels value
        if decibels < minDecibels {
            return 0
        }
        if decibels >= maxDecibels {
            return 1
        }

        // This value can be adjusted to affect the curve of the intensity
        let root: Float = 2

        let minAmp = powf(10, 0.05 * minDecibels)
        let inverseAmpRange: Float = 1.0 / (1.0 - minAmp)
        let amp: Float = powf(10, 0.05 * decibels)
        let adjAmp = (amp - minAmp) * inverseAmpRange

        return powf(adjAmp, 1.0 / root)
    }
    // MARK: - seek Backward
    public func seekBackwards(timeInterval: Int) {
            let seconds : Int64 = Int64(timeInterval)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
            let newCurrentTime = (self.queuePlayer?.currentTime())! - targetTime
            
        self.queuePlayer?.seek(to: newCurrentTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { result in
                print("finished seeking")
            })
        }
        
    // MARK: - seek Forward
        public func seekForward(timeInterval: Int) {
            let seconds : Int64 = Int64(timeInterval)
            let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
            let newCurrentTime = (self.queuePlayer?.currentTime())! + targetTime
            
            self.queuePlayer?.seek(to: newCurrentTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { result in
                print("finished seeking")
            })
        }
}

extension HPRecorder: AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            endRecording()
            self.recorderDidFinish?(recorder, recorder.url, false)
        } else {
            self.recorderDidFinish?(recorder, recorder.url, true)
        }
    }

    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            self.recorderOccurError?(recorder, error)
        }
    }
}

struct Constants {
    static var documentDir: URL {
        get {
            let documentURLs = FileManager.default.urls(
                for: .documentDirectory,
                in:  .userDomainMask
            )
            return documentURLs.first!
        }
    }
    static func dateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"

        return dateFormatter.string(from: date)
    }
    static let appendMsg = "When the append function is selected, the cursor will automatically move to the end of the original recording. If you want the Append to start at a different point, move the cursor to a desired point and tap the orange Record button to start the Append function."
    
    static let insertMsg = "To start insert, tap the Start Point button marker whilst listening to the audio. Tap the Start Inserting button to initiate the insert. The insert will end when the orange Stop button is tapped."
    
    static let overwriteMsg = "To start overwrite, tap the Start Point and End Point button markers whilst listening to the audio. The End Point button determines where the overwrite finishes. Tap the Start Overwriting button to initiate the overwrite. The overwrite will end when the End Point marker is reached."
    
    static let partialDeleteMsg = "To start partial delete, tap the Start Point and End Point button markers whilst listening to the audio. The End Point button determines where the partial delete finishes. Tap the Start Deleting button to initiate the partial delete. The partial delete will end when the End Point marker is reached."
}
