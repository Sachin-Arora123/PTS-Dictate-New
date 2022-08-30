//
//  ProfileCell.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 30/08/22.
//

import UIKit

class ProfileCell: UITableViewCell {

    // MARK: - @IBOutlets.
    @IBOutlet weak var lblTitleName: UILabel!
    @IBOutlet weak var lblTitleValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
