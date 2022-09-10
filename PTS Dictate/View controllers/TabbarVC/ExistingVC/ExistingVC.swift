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
    var totalFiles = [Any]()
     // wave form var
      fileprivate var startRendering = Date()
       fileprivate var endRendering = Date()
       fileprivate var startLoading = Date()
       fileprivate var endLoading = Date()
       fileprivate var profileResult = ""
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        mediaProgressView.delegate = self
        mediaProgressView.progressColor = #colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.937254902, alpha: 1)
        mediaProgressView.backgroundColor = #colorLiteral(red: 0.6509803922, green: 0.8235294118, blue: 0.9529411765, alpha: 1)
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        self.viewNoRecordedFile.isHidden = true
        hideLeftButton()
        setTitleWithImage("Existing Dictations", andImage: UIImage(named: "tabbar_existing_dictations_highlighted.png") ?? UIImage())
        tableView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        totalFiles = self.findFilesWith(fileExtension: "m4a")
    }
    
    @objc func newFileSaved(notification: Notification) {
        totalFiles = self.findFilesWith(fileExtension: "m4a")
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
                self.lblFileName.text = (self.totalFiles[index] as! String)
//                let file = Bundle.main.url(forResource: "file_name", withExtension: "mp3")!
                let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let completePath = directoryPath.absoluteString + (self.totalFiles[index] as! String)
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
                    audioPlayer = try AVAudioPlayer(contentsOf: completePathURL!)
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
        
    }
    
    @IBAction func onTapPlay(_ sender: UIButton){
        do {
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
//                cell.btnPlay.setBackgroundImage(UIImage(named: "existing_play_btn"), for: .normal)
                self.btnPlay.setBackgroundImage(UIImage(named: "existing_controls_play_btn_normal"), for: .normal)
            }else{
                audioPlayer = try AVAudioPlayer(contentsOf: completePathURL!)
                audioPlayer.play()
//                cell.btnPlay.setBackgroundImage(UIImage(named: "existing_pause_btn"), for: .normal)
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
        cell.lblFileName.text = self.totalFiles[indexPath.row] as? String
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
  }

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
