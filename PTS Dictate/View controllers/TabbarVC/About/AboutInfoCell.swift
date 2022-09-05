//
//  AboutInfoCell.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 03/09/22.
//

import UIKit

class AboutInfoCell: UITableViewCell {

    // MARK: - @IBOutlets.
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitleDesc: UILabel!
    @IBOutlet weak var imgViewArrow: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
