//
//  NamingFormatCell.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 30/08/22.
//

import UIKit

protocol NamingFormatCellDelegate : AnyObject{
    func passData(text : String, id : Int)
    func sendTextFieldDidEditing(textField : UITextField, id : Int)
}

class NamingFormatCell: UITableViewCell {

    // MARK: - @IBOutlets.
    @IBOutlet weak var lblNameTitle: UILabel!
    @IBOutlet weak var txtFldDateFormat: UITextField!{
        didSet{
            txtFldDateFormat.delegate = self
        }
    }
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
    
    // MARK: - Variable
    weak var delegate : NamingFormatCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(indexPath : IndexPath, data : String){
//        switch indexPath.row{
//        case 0:
//            self.txtFldDateFormat.text = CoreData.shared.fileName != "" ? CoreData.shared.fileName : "N/A"
//        case 1:
//            self.txtFldDateFormat.text = CoreData.shared.dateFormat != "" ? CoreData.shared.dateFormat : "N/A"
//        default:
//        break
        
//        }
        self.txtFldDateFormat.text = data
    }
}

extension NamingFormatCell: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = currentText.components(separatedBy: cs).joined(separator: "")
        
        if currentText.replacingOccurrences(of: " ", with: "") == filtered{
            self.delegate?.passData(text: currentText, id: self.txtFldDateFormat.tag)
            return true
        }else{
            return false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.delegate?.sendTextFieldDidEditing(textField: textField, id: self.txtFldDateFormat.tag)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.delegate?.passData(text: self.txtFldDateFormat.text ?? "", id: self.txtFldDateFormat.tag)
        }
    }
}
