//
//  ExistingVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 29/08/22.
//

import UIKit
import AVFoundation
import FDWaveformView

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
    @IBOutlet weak var mediaProgressView: FDWaveformView!
    @IBOutlet weak var tableView: UITableView!
    
    var audioRecorder:AVAudioRecorder?
    var audioPlayer = AVAudioPlayer()
    var totalFiles = [String]()
    var totalFilesSelected : [String] = []
    var playingCellIndex = -1
    // wave form var
    fileprivate var startRendering = Date()
    fileprivate var endRendering = Date()
    fileprivate var startLoading = Date()
    fileprivate var endLoading = Date()
    fileprivate var profileResult = ""
    // MARK: - View Life-Cycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaProgressView.delegate = self
        mediaProgressView.progressColor = #colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.937254902, alpha: 1)
        mediaProgressView.backgroundColor = #colorLiteral(red: 0.6509803922, green: 0.8235294118, blue: 0.9529411765, alpha: 1)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.newFileSaved(notification:)), name: Notification.Name("FileSaved"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: Notification.Name("FileSaved"), object: nil)
    }
    
    // MARK: - UISetup
    func setUpUI(){
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.delegate = self
        tableView.dataSource = self
        hideLeftButton()
        setTitleWithImage("Existing Dictations", andImage: UIImage(named: "tabbar_existing_dictations_highlighted.png") ?? UIImage())
        tableView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
//        totalFiles = self.findFilesWith(fileExtension: "m4a")
        totalFiles = self.getSortedAudioList()
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
                sender.setBackgroundImage(UIImage(named: "existing_play_btn"), for: .normal)
                self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            }else{
                self.playingCellIndex = index
                audioPlayer = try AVAudioPlayer(contentsOf: completePathURL!)
                audioPlayer.delegate = self
                audioPlayer.play()
                self.mediaProgressView.audioURL = completePathURL!
                sender.setBackgroundImage(UIImage(named: "existing_pause_btn"), for: .normal)
                self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_pause_btn_normal"), for: .normal)
            }
            
        } catch _ {
            print("catch")
        }
    }
    
    // MARK: - @IBActions.
    @IBAction func onTapUpload(_ sender: UIButton) {
        
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
                    self.totalFiles = self.getSortedAudioList()
                    self.tableView.reloadData()
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
    
    @IBAction func onTapPlay(_ sender: UIButton){
        do {
            var playingMediaIndex = 0
            for (index, value) in self.totalFiles.enumerated() {
                if value as? String == self.lblFileName.text!  {
                    print("Finding Index-->>",index)
                    playingMediaIndex = index
                }
            }
            let cell  = tableView.cellForRow(at: IndexPath(row: playingMediaIndex, section: 0)) as? ExistingFileCell
            let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let completePath = directoryPath.absoluteString +  self.lblFileName.text!
            let completePathURL = URL(string: completePath)
            audioPlayer.numberOfLoops = 0 // loop count, set -1 for infinite
            audioPlayer.volume = 1
            audioPlayer.prepareToPlay()
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            if audioPlayer.isPlaying{
                audioPlayer.pause()
                cell?.btnPlay.setBackgroundImage(UIImage(named: "existing_play_btn"), for: .normal)
                self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            }else{
                audioPlayer = try AVAudioPlayer(contentsOf: completePathURL!)
                audioPlayer.delegate = self
                audioPlayer.play()
                cell?.btnPlay.setBackgroundImage(UIImage(named: "existing_pause_btn"), for: .normal)
                self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_pause_btn_normal"), for: .normal)
            }
        } catch _ {
            print("catch")
        }
    }
    
    @IBAction func onTapFTrim(_ sender: UIButton){
        
    }
    @IBAction func onTapFTrimEnd(_ sender: UIButton){
        
    }
    @IBAction func onTapBTrim(_ sender: UIButton){
        
    }
    @IBAction func onTapBTrimEnd(_ sender: UIButton){
        
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
        if self.totalFilesSelected.contains((self.totalFiles[indexPath.row] as? String) ?? ""){
            cell.btnSelection.setImage(UIImage(named: "checked_checkbox"), for: .normal)
        }else{
            cell.btnSelection.setImage(UIImage(named: "unchecked_checkbox"), for: .normal)
        }
        var fileSize = sizeForLocalFilePath(itemName: self.totalFiles[indexPath.row])
        cell.lblFileSize.text = self.covertToFileString(with: fileSize)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Objective C Methods
extension ExistingVC{
    
    @objc func openCommentVC(){
        //        let VC = CommentsVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        //            self.setPushTransitionAnimation(VC)
        //        VC.hidesBottomBarWhenPushed = true
        //        self.navigationController?.pushViewController(VC, animated: false)
    }
    
    @objc func openRenameFileVc(){
        //        let VC = RenameFileVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        //            self.setPushTransitionAnimation(VC)
        //        VC.hidesBottomBarWhenPushed = true
        //        self.navigationController?.pushViewController(VC, animated: false)
    }
    
    @objc func btnActCheckBox(_ sender : UIButton){
        if self.totalFilesSelected.contains((self.totalFiles[sender.tag] as? String) ?? ""){
            if let ind = self.totalFilesSelected.firstIndex(of: (self.totalFiles[sender.tag] as? String) ?? ""){
                self.totalFilesSelected.remove(at: ind)
            }
        }else{
            self.totalFilesSelected.append((self.totalFiles[sender.tag] as? String) ?? "")
        }
        self.tableView.reloadData()
    }
    // file size
    func sizeForLocalFilePath(itemName: String) -> UInt64 {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return 0
        }
        let filePath = "\(dirPath)/\(itemName)"
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
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
            self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            print("Playing Completed")
        }
    }
}

// MARK: - Extension for FDWaveformViewDelegate

extension ExistingVC: FDWaveformViewDelegate {
    func waveformViewWillRender(_ waveformView: FDWaveformView) {
        startRendering = Date()
    }
    
    func waveformViewDidRender(_ waveformView: FDWaveformView) {
        endRendering = Date()
        NSLog("FDWaveformView rendering done, took %0.3f seconds", endRendering.timeIntervalSince(startRendering))
        profileResult.append(String(format: " render %0.3f ", endRendering.timeIntervalSince(startRendering)))
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            waveformView.alpha = 1.0
        })
    }
    
    func waveformViewWillLoad(_ waveformView: FDWaveformView) {
        startLoading = Date()
    }
    
    func waveformViewDidLoad(_ waveformView: FDWaveformView) {
        endLoading = Date()
        NSLog("FDWaveformView loading done, took %0.3f seconds", endLoading.timeIntervalSince(startLoading))
        profileResult.append(String(format: " load %0.3f ", endLoading.timeIntervalSince(startLoading)))
    }
}

extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
    func containsObject(_ object: Any) -> Bool {
            let anObject = object as AnyObject
            for obj in self {
                let anObj = obj as AnyObject
                return anObj.isEqual(anObject)
            }
            return false
        }
}
