//
//  UploadListCell.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 27/08/22.
//

import UIKit
import AVFoundation

class UploadListCell: UITableViewCell {

    // MARK: - @IBOutlets.
    @IBOutlet weak var imgViewIcon: UIImageView!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var viewUploadProgress: UIView!
    @IBOutlet weak var lblUploadProgress: UILabel!
    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var lblDataLimit: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var lblUploadStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(name: String, isUploaded: Bool, inProgress: Bool) {
        lblFileName.text = name
        if inProgress {
            detailStackView.isHidden = true
            viewUploadProgress.isHidden = false
            viewUploadProgress.backgroundColor = UIColor.appThemeColor
            lblUploadProgress.text = "Uploading Progress: 99%"
        } else if isUploaded {
            detailStackView.isHidden = false
            viewUploadProgress.isHidden = true
            let time = getTimeDuration(filePath: name)
            let size = fileSize(itemName: name)
            lblTiming.text = time
            lblDataLimit.text = size
        }
//        else {
//            detailStackView.isHidden = true
//            viewUploadProgress.isHidden = false
//            viewUploadProgress.backgroundColor = .systemGray
//            lblUploadProgress.text = "Uploading Progress: 0%"
//        }
    }
    
    func getTimeDuration(filePath: String) -> String{
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let completePath = directoryPath.absoluteString + filePath
        let completePathURL = URL(string: completePath)
        let audioAsset = AVURLAsset.init(url: completePathURL!, options: nil)
        let duration = audioAsset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        let min = Int(durationInSeconds / 60)
        let sec = Int(durationInSeconds.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d",min, sec)
        return totalTimeString
    }
    
    func fileSize(itemName: String) -> String? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return ""
        }
        let filePath = "\(dirPath)/\(itemName)"
        guard let size = try? FileManager.default.attributesOfItem(atPath: filePath)[FileAttributeKey.size],
              let fileSize = size as? UInt64 else {
            return nil
        }
        
        // bytes
        if fileSize < 1023 {
            return String(format: "%lu bytes", CUnsignedLong(fileSize))
        }
        // KB
        var floatSize = Float(fileSize / 1024)
        if floatSize < 1023 {
            return String(format: "%.1f KB", floatSize)
        }
        // MB
        floatSize = floatSize / 1024
        if floatSize < 1023 {
            return String(format: "%.1f MB", floatSize)
        }
        // GB
        floatSize = floatSize / 1024
        return String(format: "%.1f GB", floatSize)
    }
}
