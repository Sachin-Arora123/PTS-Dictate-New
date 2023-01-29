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
    

    func setData(indexPath : IndexPath){
        switch indexPath.row{
        case 0:
            self.lblTitleValue.text = CoreData.shared.userName
        case 1:
            self.lblTitleValue.text = CoreData.shared.welcomeName != "" ? CoreData.shared.welcomeName : "N/A"
        case 2:
            self.lblTitleValue.text = CoreData.shared.email != "" ? CoreData.shared.email : "N/A"
        default:
        break
        }
    }
}
