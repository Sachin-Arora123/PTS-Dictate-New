//
//  RenameFileVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 04/09/22.
//

import UIKit

class RenameFileVC: BaseViewController {
   
    // MARK: - @IBOutlets.
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var imgViewRename: UIImageView!
    @IBOutlet weak var txtFldReName: UITextField!

    var fileName = ""
    var updatedFileNameCallback : ((String) -> Void)?
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
    var alreadyPresentNames : [String]?
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldReName.becomeFirstResponder()
        txtFldReName.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    // MARK: -  UISetUp
    func setUpUI(){
        setTitleWithoutImage("Rename The File")
        addRightButton(selector: #selector(btnDoneAction))
        
        lblFileName.text = fileName
    }
    
    @objc func btnDoneAction() {
        //check if name is empty or not.
        if txtFldReName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Name should not be empty", btnTitle: "OK", completion: nil)
            return
        }
        
        //User enter a file name.
        //send callaback with updated filename and update it in the core data as well.
        if let names = self.alreadyPresentNames{
            if names.contains(self.fileName + ".m4a"){
                CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Already name present", btnTitle: "OK", completion: nil)
                return
            }
        }
        
        updatedFileNameCallback?(self.fileName)
        self.navigationController?.popViewController(animated: true)
    }
}

extension RenameFileVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = currentText.components(separatedBy: cs).joined(separator: "")
        
        if currentText.replacingOccurrences(of: " ", with: "") == filtered && currentText.count <= 100{
            self.fileName = currentText
            return true
        }else{
            return false
        }
    }
}
