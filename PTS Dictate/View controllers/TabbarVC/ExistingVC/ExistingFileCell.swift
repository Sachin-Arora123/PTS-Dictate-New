//
//  ExistingFileCell.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 04/09/22.
//

import UIKit

class ExistingFileCell: UITableViewCell {

  // MARK: - @IBOutlets.
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblFileSize: UILabel!
    @IBOutlet weak var lblFileTime: UILabel!
    @IBOutlet weak var lblFileStatus: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
