//
//  UploadProgressVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 27/08/22.
//

import UIKit
var isUploading: Bool = false
class UploadProgressVC: BaseViewController {
    
    // MARK: @IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewNoUpload: UIView!
    
    // MARK: Properties
    
    var files: [AudioFile] = []
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
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitleWithImage("Uploads", andImage: UIImage(named: "settings_upload.png") ?? UIImage())
        let uploadingInProgress = ExistingViewModel.shared.uploadingInProgress
        if !uploadingInProgress {
            self.startUploading()
        }
    }
    
    func setUpUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    fileprivate func startUploading() {
        files = ExistingViewModel.shared.uploadingQueue
        if files.count > 0 {
            tableView.isHidden = false
            viewNoUpload.isHidden = true
            for file in files {
                UpdateAudioFile.uploadingInProgress(true).update(audioName: file.name ?? "")
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
    
    fileprivate func uploadFiles(file: AudioFile) {
        isUploading = true
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let completePath  = directoryPath.absoluteString + (file.filePath ?? "")
        let url           = URL(string: completePath)
        
        let emailNotify = (CoreData.shared.disableEmailNotify == 0)
        ExistingViewModel.shared.uploadAudio(userName: CoreData.shared.userName, toUser: "pts", emailNotify: emailNotify, fileUrl: url!, fileName: (file.changedName != "" ? file.changedName : file.name) ?? "", description: AudioFiles.shared.getAudioComment(name: file.name ?? "")) {
            print("file uploaded")
            UpdateAudioFile.isUploaded(true).update(audioName: file.name ?? "")
            UpdateAudioFile.uploadedStatus(true).update(audioName: file.name ?? "")
            UpdateAudioFile.uploadingInProgress(false).update(audioName: file.name ?? "")
            let date = Date().getUTCDateString()
            print(Date().getFormattedDateString())
            UpdateAudioFile.uploadedAt(date).update(audioName: file.name ?? "")
            self.tableView.reloadData()
            if self.currentUploadingFile < self.files.count - 1 { self.currentUploadingFile += 1 }
            if self.files.count - 1 == self.currentUploadingFile{ isUploading = false }
        } failure: { error in
            print("error === \(error.description)")
            CommonFunctions.toster("Upload Error",titleDesc: "Error in upload. Please try again.", true, false)
            UpdateAudioFile.isUploaded(true).update(audioName: file.name ?? "")
            UpdateAudioFile.uploadedStatus(false).update(audioName: file.name ?? "")
            UpdateAudioFile.uploadingInProgress(false).update(audioName: file.name ?? "")
            if self.currentUploadingFile < self.files.count - 1 { self.currentUploadingFile += 1 }
            if self.files.count - 1 == self.currentUploadingFile{ isUploading = false }
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
    
    func checkFileUploadedStatus(name: String) -> Bool {
        let audioFiles = AudioFiles.shared.audioFiles
        for audioFile in audioFiles where audioFile.name == name {
            return audioFile.fileInfo?.uploadedStatus ?? false
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
            let cell       = tableView.dequeueReusableCell(withIdentifier: "UploadListCell", for: indexPath) as! UploadListCell
            let file       = files[indexPath.row]
            let isUploaded = checkFileUploadedOrNot(name: file.name ?? "")
            let inProgress = checkUploadingInProgress(name: file.name ?? "")
            let status     = checkFileUploadedStatus(name: file.name ?? "")
            cell.setData(file: file, isUploaded: isUploaded, inProgress: inProgress, uploadedStatus: status)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

