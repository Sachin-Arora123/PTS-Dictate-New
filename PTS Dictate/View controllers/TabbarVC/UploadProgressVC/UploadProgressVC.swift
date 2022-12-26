//
//  UploadProgressVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 27/08/22.
//

import UIKit

class UploadProgressVC: BaseViewController {
    
    // MARK: @IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewNoUpload: UIView!
    
    // MARK: Properties
    
    var files: [String] = []
    var inProgressFiles: [String] = []
    var currentUploadingFile: Int = Int(){
        didSet {
            self.uploadFiles(file: files[currentUploadingFile])
            ExistingViewModel.shared.uploadingInProgress = true
            if currentUploadingFile == files.count - 1 {
                ExistingViewModel.shared.uploadingQueue = []
                ExistingViewModel.shared.uploadingInProgress = false
            }
        }
    }
    // MARK: View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let uploadingInProgress = ExistingViewModel.shared.uploadingInProgress
        if !uploadingInProgress {
            self.startUploading()
        }
    }
    
    func setUpUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        setTitleWithImage("Uploads", andImage: UIImage(named: "settings_upload.png") ?? UIImage())
    }
    
    fileprivate func startUploading() {
        files = ExistingViewModel.shared.uploadingQueue
        if files.count > 0 {
            tableView.isHidden = false
            viewNoUpload.isHidden = true
            for file in files {
                UpdateAudioFile.uploadingInProgress(true).update(audioName: file)
            }
            self.tableView.reloadData()
            let seconds = 1.0
            if files.count == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.currentUploadingFile = 0
                }
            } else {
                self.currentUploadingFile = 0
            }
        } else {
            tableView.isHidden = true
            viewNoUpload.isHidden = false
        }
    }
    
    fileprivate func uploadFiles(file: String) {
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let completePath = directoryPath.absoluteString + file
        let url = URL(string: completePath)
        
        let emailNotify = (CoreData.shared.disableEmailNotify == 0)
        ExistingViewModel.shared.uploadAudio(userName: CoreData.shared.userId, toUser: "pts", emailNotify: emailNotify, fileUrl: url!, fileName: file, description: AudioFiles.shared.getAudioComment(name: file)) {
            print("file uploaded")
            UpdateAudioFile.isUploaded(true).update(audioName: file)
            UpdateAudioFile.uploadingInProgress(false).update(audioName: file)
            let date = Date().getFormattedDateString()
            UpdateAudioFile.uploadedAt(date).update(audioName: file)
            self.tableView.reloadData()
            if self.currentUploadingFile < self.files.count - 1 { self.currentUploadingFile += 1 }
        } failure: { error in
            print(error)
            UpdateAudioFile.isUploaded(false).update(audioName: file)
            if self.currentUploadingFile < self.files.count - 1 { self.currentUploadingFile += 1 }
            CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Can't upload audio files at the moment, Please try again after some time.", btnTitle: "OK")
            self.tableView.reloadData()
        }
    }
    
    func checkFileUploadedOrNot(name: String) -> Bool {
        let audioFiles = AudioFiles.shared.audioFiles
        for audioFile in audioFiles where audioFile.name == name {
            return audioFile.fileInfo?.isUploaded ?? false
        }
        return false
    }
    
    func checkUploadingInProgress(name: String) -> Bool {
        let audioFiles = AudioFiles.shared.audioFiles
        for audioFile in audioFiles where audioFile.name == name {
            return audioFile.fileInfo?.uploadingInProgress ?? false
        }
        return false
    }
    
}

// MARK: Extension for tableView delegate & dataSource methods.
extension UploadProgressVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if files.count > 0 {
            tableView.isHidden = false
            viewNoUpload.isHidden = true
            return files.count
            
        } else {
            tableView.isHidden = true
            viewNoUpload.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if files.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UploadListCell", for: indexPath) as! UploadListCell
            let name = files[indexPath.row]
            let isUploaded = checkFileUploadedOrNot(name: name)
            let inProgress = checkUploadingInProgress(name: name)
            cell.setData(name: name, isUploaded: isUploaded, inProgress: inProgress)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

