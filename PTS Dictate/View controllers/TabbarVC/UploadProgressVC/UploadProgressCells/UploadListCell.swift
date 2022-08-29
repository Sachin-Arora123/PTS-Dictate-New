//
//  UploadListCell.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 27/08/22.
//

import UIKit

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

}
