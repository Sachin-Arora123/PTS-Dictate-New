//
//  NamingFormatCell.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 30/08/22.
//

import UIKit

class NamingFormatCell: UITableViewCell {

    // MARK: - @IBOutlets.
    @IBOutlet weak var lblNameTitle: UILabel!
    @IBOutlet weak var txtFldDateFormat: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
