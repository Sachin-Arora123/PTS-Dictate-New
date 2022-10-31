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
//    var uploadingQueue: [String]? {
//        // getting the value from exiting view controller's variable
//        get {
//            return (self.tabBarController!.viewControllers![0] as! ExistingVC).uploadingQueue
//        }
//        // assign the new value to this view controller's variable
//        set {
//            (self.tabBarController!.viewControllers![0] as! ExistingVC).uploadingQueue = newValue ?? []
//            self.files = newValue ?? []
//        }
//    }
    
    var files: [String] = []
    
    var currentUploadingFile: Int = 0
    // MARK: View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        files =  ExistingViewModel.shared.uploadingQueue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        setTitleWithImage("Uploads", andImage: UIImage(named: "settings_upload.png") ?? UIImage())
        if files.count > 0 {
            tableView.isHidden = false
            viewNoUpload.isHidden =  true
            uploadFiles()
            self.tableView.reloadData()
        } else {
            tableView.isHidden = true
            viewNoUpload.isHidden = false
        }
    }
    
    fileprivate func uploadFiles() {
        //        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                //        for file in totalFilesSelected {
                //            let completePath = directoryPath.absoluteString + file
                //            let url = URL(string: completePath)
                //            self.existingViewModel.uploadAudio(userName: CoreData.shared.userName, toUser: "pts", emailNotify: false, fileUrl: url!, fileName: file, description: AudioFiles.shared.getAudioComment(name: file))
                //        }
//        if files != nil {
//            while currentUploadingFile != files.count {
                let file = files[currentUploadingFile]
                let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let completePath = directoryPath.absoluteString + file
                let url = URL(string: completePath)
                ExistingViewModel.shared.uploadAudio(userName: CoreData.shared.userName, toUser: "pts", fileUrl: url!, fileName: file, description: AudioFiles.shared.getAudioComment(name: file)) {
                    print("file uploaded")
                    self.currentUploadingFile += 1
                    UpdateAudioFile.isUploaded(true).update(audioName: file)
                } failure: { error in
                    print(error)
                }
//            }
//        }
    }
}

// MARK: Extension for tableView delegate & dataSource methods.
extension UploadProgressVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadListCell", for: indexPath) as! UploadListCell
//        if let uploadingQueue = uploadingQueue {
            let name = files[indexPath.row]
            let audioFiles = AudioFiles.shared.audioFiles
            var isUploaded = false
            let inProgress = indexPath.row == currentUploadingFile ? true : false
            for audioFile in audioFiles where audioFile.name == name{
                isUploaded = audioFile.fileInfo?.isUploaded ?? false
            }
            cell.setData(name: name, isUploaded: isUploaded, inProgress: inProgress)
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

