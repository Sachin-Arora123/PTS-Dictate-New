//
//  HpRecorder.swift
//  PTS Dictate
//
//  Created by Hero's on 02/11/22.
//
import Foundation
import AVFoundation
import UIKit

public class HPRecorder: NSObject {
    open var partialDeleteAsset : AVAsset?
    open var recordingSession: AVAudioSession!
    open var audioRecorder: AVAudioRecorder!
    open var queuePlayer:      AVQueuePlayer?
    open var articleChunks = [AVURLAsset]()
    open var playerItem: AVPlayerItem?
    open var durationTime: Double = 0.0
//    open var playerItemArray = [AVPlayerItem]()
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
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
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
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
        } catch let error as NSError {
            print(error.description)
        }
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
        let settings =
            [ AVFormatIDKey:             Int(kAudioFormatMPEG4AAC)
              , AVSampleRateKey:           Float(sampleRateKey)
            , AVNumberOfChannelsKey:     2
            , AVEncoderAudioQualityKey:  AVAudioQuality.high.rawValue
            , AVEncoderBitRateKey:       128000
            ] as [String : Any]
        let url = self.createNewRecordingURL(fileName)

        do {

            self.audioRecorder =
                try AVAudioRecorder.init(url: url, settings: settings)
            self.audioRecorder?.record()

        } catch {
            NSLog("Unable to init audio recorder.")
        }
    }
    public func startInsertRecording(sampleRateKey: Float, fileName: String) {
        let settings =
            [ AVFormatIDKey:             Int(kAudioFormatMPEG4AAC)
              , AVSampleRateKey:           Float(sampleRateKey)
            , AVNumberOfChannelsKey:     2
            , AVEncoderAudioQualityKey:  AVAudioQuality.high.rawValue
            , AVEncoderBitRateKey:       128000
            ] as [String : Any]
        let url = self.createNewRecordingURL(fileName)

        do {

            self.audioRecorder =
                try AVAudioRecorder.init(url: url, settings: settings)
            self.audioRecorder?.record(atTime: 2.0, forDuration: 7.0)

        } catch {
            NSLog("Unable to init audio recorder.")
        }
    }

    // End recording
    public func endRecording() {
        audioRecorder?.stop()
        let assetURL = self.audioRecorder!.url
        let assetOpts = [AVURLAssetPreferPreciseDurationAndTimingKey: true]
        let asset     = AVURLAsset(url: assetURL, options: assetOpts)
        self.articleChunks.append(asset)
        tempChunks.append(asset)
        isRecording = false
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
        if partialDeleteAsset != nil{
            print("Audio here")
            let playerItems = AVPlayerItem(asset: (partialDeleteAsset!), automaticallyLoadedAssetKeys: assetKeys)
            self.playerItem = playerItems
            self.queuePlayer = AVQueuePlayer(playerItem: playerItems)//AVQueuePlayer(items: playerItems)
            self.queuePlayer?.actionAtItemEnd = .advance
            self.queuePlayer?.play()
            self.queuePlayerPlaying = true
            var playerItemArray = [AVPlayerItem]()
            playerItemArray.append(playerItem!)
            self.durationTime = self.getTimeDuration(playerItems: playerItemArray)
            return
        }else{
        let playerItems = self.articleChunks.map {
            AVPlayerItem(asset: $0, automaticallyLoadedAssetKeys: assetKeys)
        }
        self.queuePlayer = AVQueuePlayer(items: playerItems)
        self.queuePlayer?.actionAtItemEnd = .advance
        self.playerItem = playerItems.last
        self.queuePlayer?.play()
        self.queuePlayerPlaying = true
        self.durationTime = self.getTimeDuration(playerItems: playerItems)
      }
    }
    
    func getTimeDuration(playerItems: [AVPlayerItem]) -> Double{
        var count: Double = 0.0
        for playerItem in playerItems {
            let duration = playerItem.asset.duration
            let durationSeconds = Double(CMTimeGetSeconds(duration))
            count = count + durationSeconds
        }
        print("durationCount-->>", count)
        return count
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
//
    public func concatChunks(filename: String ,completion: @escaping(_ result: Bool) -> Void) {
        let composition = AVMutableComposition()

        var insertAt = CMTimeRange(start: CMTime.zero, end: CMTime.zero)
        if self.partialDeleteAsset != nil{
            let assetTimeRange = CMTimeRange(
                start: CMTime.zero,
                end: partialDeleteAsset!.duration)

            do {
                try composition.insertTimeRange(assetTimeRange,
                                                of: partialDeleteAsset!,
                                                at: insertAt.end)
            } catch {
                NSLog("Unable to compose asset track.")
            }

            let nextDuration = insertAt.duration + assetTimeRange.duration
            insertAt = CMTimeRange(
                start:    CMTime.zero,
                duration: nextDuration)
        }else{
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
        }

        let exportSession =
            AVAssetExportSession(
                asset:      composition,
                presetName: AVAssetExportPresetAppleM4A)

        exportSession?.outputFileType = AVFileType.m4a
        exportSession?.outputURL = self.createNewRecordingURL(filename)
        print("OP",   exportSession?.outputURL)

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
            case .unknown?:
                completion(false)
                break
            case .waiting?:
                completion(false)
                break
            case .exporting?:
                completion(false)
                break
            case .completed?:
                /* Cleaning up partial recordings
                 */
                print("articleCount-->>",self.articleChunks.count)
                print("article-->>",self.articleChunks)

                for asset in self.articleChunks {
                    try! FileManager.default.removeItem(at: asset.url)
                }

                /* https://stackoverflow.com/questions/26277371/swift-uitableview-reloaddata-in-a-closure
                */
//                DispatchQueue.main.async {
//                    self.listRecordings.tableView.reloadData()
//                }
                completion(true)
                /* Resetting `articleChunks` here, because this function is
                 called asynchronously and calling it from `queueTapped` or
                 `submitTapped` may delete the files prematurely.
                 */
                self.articleChunks = [AVURLAsset]()
                self.partialDeleteAsset = nil
            case .failed?:
                print("error:-->>",exportSession?.error?.localizedDescription ?? "")
                completion(false)
                break
            case .cancelled?:
                completion(false)
                break
            case .none:
                completion(false)
                break
            case .some(_):
                completion(false)
                break
            }
        }
    }
    
    func deleteExportAsset(endTimeOfRange1: Double,startTimeOfRange2: Double , fileName: String, completion: @escaping(_ result: Bool) -> Void)  {
        print("\(#function)")
        // create empty mutable composition
        let composition: AVMutableComposition = AVMutableComposition()
        // copy all of original asset into the mutable composition, effectively creating an editable copy
        for asset in self.articleChunks {
        do {
            try composition.insertTimeRange(CMTimeRangeMake( start: CMTime.zero, duration: asset.duration), of: asset, at: CMTime.zero)
        } catch {
            NSLog("Unable to compose asset track.")
        }
        // now edit as required, e.g. delete a time range
        let startTime = CMTime(seconds: endTimeOfRange1, preferredTimescale: 100)
        let endTime = CMTime(seconds: startTimeOfRange2, preferredTimescale: 100)
        composition.removeTimeRange(CMTimeRangeFromTimeToTime( start: startTime, end: endTime))
    }
       
        // since AVMutableComposition is an AVAsset subclass, it can be exported with AVAssetExportSession (or played with an AVPlayer(Item))
         let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        exportSession?.outputFileType = AVFileType.m4a
        exportSession?.outputURL = self.createNewRecordingURL("fileName")
        print("OP",exportSession?.outputURL)
        exportSession?.canPerformMultiplePassesOverSourceMediaData = true
        
       exportSession?.exportAsynchronously {

           switch exportSession?.status {
           case .unknown?:
               completion(false)
               break
           case .waiting?:
               completion(false)
               break
           case .exporting?:
               completion(false)
               break
           case .completed?:
               /* Cleaning up partial recordings
                */
               for asset in self.articleChunks {
                   try! FileManager.default.removeItem(at: asset.url)
               }

               /* https://stackoverflow.com/questions/26277371/swift-uitableview-reloaddata-in-a-closure
               */
//                DispatchQueue.main.async {
//                    self.listRecordings.tableView.reloadData()
//                }
               completion(true)
               /* Resetting `articleChunks` here, because this function is
                called asynchronously and calling it from `queueTapped` or
                `submitTapped` may delete the files prematurely.
                */
//               self.articleChunks = [AVURLAsset]()
           case .failed?:
               print("error:-->>",exportSession?.error?.localizedDescription ?? "")
               completion(false)
               break
           case .cancelled?:
               completion(false)
               break
           case .none:
               completion(false)
               break
           case .some(_):
               completion(false)
               break
           }
       }
    }
    
    public func deleteAudio(startTime: Double,endTime: Double, completion: @escaping(_ result: Bool) -> Void){
        // create empty mutable composition
        let composition: AVMutableComposition = AVMutableComposition()
        
        // copy all of original asset into the mutable composition, effectively creating an editable copy
        for asset in self.articleChunks.reversed() {
        do{
            try composition.insertTimeRange( CMTimeRangeMake( start: CMTime.zero, duration: asset.duration), of: asset, at: CMTime.zero)
        }catch{
            print("Error")
        }
        }

        // now edit as required, e.g. delete a time range
        let startTime = CMTime(seconds: startTime, preferredTimescale: 100)
        let endTime = CMTime(seconds: endTime, preferredTimescale: 100)
        composition.removeTimeRange( CMTimeRangeFromTimeToTime(start: startTime, end: endTime))

        // since AVMutableComposition is an AVAsset subclass, it can be exported with AVAssetExportSession (or played with an AVPlayer(Item))
        if let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        {
            // configure session and exportAsynchronously as above.
            // You don't have to set the timeRange of the exportSession
            self.partialDeleteAsset = exporter.asset
            print("Here", exporter)
            completion(true)
        }else{
            completion(false)
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
    static let appName = "PTS Dictate"
    static let appendMsg = "When the append function is selected, the cursor will automatically move to the end of the original recording. If you want the Append to start at a different point, move the cursor to a desired point and tap the orange Record button to start the Append function."
    
    static let insertMsg = "To start insert, tap the Start Point button marker whilst listening to the audio. Tap the Start Inserting button to initiate the insert. The insert will end when the orange Stop button is tapped."
    
    static let overwriteMsg = "To start overwrite, tap the Start Point and End Point button markers whilst listening to the audio. The End Point button determines where the overwrite finishes. Tap the Start Overwriting button to initiate the overwrite. The overwrite will end when the End Point marker is reached."
    
    static let partialDeleteMsg = "To start partial delete, tap the Start Point and End Point button markers whilst listening to the audio. The End Point button determines where the partial delete finishes. Tap the Start Deleting button to initiate the partial delete. The partial delete will end when the End Point marker is reached."
    static let pDeleteMsg = "Partial Delete Complete"
}

////  Converted to Swift 5.7 by Swiftify v5.7.28606 - https://swiftify.com/
//// Path of your source audio file
//let strInputFilePath = URL(fileURLWithPath: Bundle.main.resourcePath ?? "").appendingPathComponent("abc.mp3").path
//let audioFileInput = URL(fileURLWithPath: strInputFilePath)
//
//// Path of your destination save audio file
//let paths = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).map(\.path)
//var libraryCachesDirectory = paths[0]
//libraryCachesDirectory = URL(fileURLWithPath: libraryCachesDirectory).appendingPathComponent("Caches").path
//
//let strOutputFilePath = "\(libraryCachesDirectory)\("/abc.mp4")"
//let audioFileOutput = URL(fileURLWithPath: strOutputFilePath)
//
//if audioFileInput == nil || audioFileOutput == nil {
//    return false
//}
//
//try? FileManager.default.removeItem(at: audioFileOutput)
//let asset = AVAsset(url: audioFileInput)
//
//let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
//
//if exportSession == nil {
//    return false
//}
//let startTrimTime: Float = 0
//let endTrimTime: Float = 5
//
//let startTime = CMTimeMake(value: Int64(Int(floor(startTrimTime * 100))), timescale: 100)
//let stopTime = CMTimeMake(value: Int64(Int(ceil(endTrimTime * 100))), timescale: 100)
//let exportTimeRange = CMTimeRangeFromTimeToTime(start: startTime, end: stopTime)
//
//exportSession?.outputURL = audioFileOutput
//exportSession?.outputFileType = .m4a
//exportSession?.timeRange = exportTimeRange
//
//exportSession?.exportAsynchronously(completionHandler: {
//    if .completed == exportSession?.status {
//        print("Success!")
//    } else if .failed == exportSession?.status {
//        print("failed")
//    }
//})
