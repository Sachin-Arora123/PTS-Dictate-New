//
//  CommentsVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 04/09/22.
//

import UIKit

class CommentsVC: BaseViewController {
    
    // MARK: - @IBOutlets.
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgViewComment: UIImageView!
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDiscard: UIButton!
    
    // MARK: Properties
    var isCommentsMandotary = false
    var canEditComments = false
    var fromExistingVC = false
    var isUploaded = false
    var selectedAudio = ""
    var fileName = ""
    var filePath = ""
    var comment = ""
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
//    var meteringLevels: [Float] = []
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        txtViewComment.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    // MARK: IBActions
    @IBAction func saveTapped(_ sender:UIButton) {
        saveComment()
    }
    
    @IBAction func discardTapped(_ sender:UIButton) {
        if (txtViewComment.text.trimmingCharacters(in: .whitespacesAndNewlines) == "") && isCommentsMandotary{
            CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Mandatory Comment Entry required", btnTitle: "OK", completion: nil)
            return
        }
        if !fromExistingVC {
            AudioFiles.shared.saveNewAudioFile(fileName: self.fileName, filePath: self.filePath, comment: txtViewComment.text, autoSaved: false)

        }else{
            UpdateAudioFile.autoSaved(false).update(audioName: selectedAudio)
            if txtViewComment.text.isEmpty == true && txtViewComment.text == comment {
                UpdateAudioFile.comment(comment).update(audioName: selectedAudio)
            }
            
        }

        popToExitingVC()
    }
    
    // MARK: UISetUp
    func setUpUI() {
        hideLeftButton()
        setTitleWithoutImage("Comments")
        if fromExistingVC && canEditComments {
            txtViewComment.isEditable = true
            txtViewComment.text = comment
            btnSave.isUserInteractionEnabled = true
            btnDiscard.isUserInteractionEnabled = true
            lblTitle.text = "Edit Comments"
        } else if fromExistingVC && !canEditComments{
            txtViewComment.isEditable = false
            txtViewComment.text = comment
            btnSave.isHidden = true
            btnDiscard.isHidden = true
            lblTitle.text = "Edit Comments"
        } else {
            txtViewComment.isEditable = true
            txtViewComment.becomeFirstResponder()
            btnSave.isUserInteractionEnabled = true
            btnDiscard.isUserInteractionEnabled = true
            lblTitle.text = "Enter Comments"
        }
        
//        if isCommentsMandotary {
//            btnDiscard.isUserInteractionEnabled = false
//        } else {
//            btnDiscard.isUserInteractionEnabled = true
//        }
        txtViewComment.becomeFirstResponder()
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    fileprivate func saveComment() {
        if (txtViewComment.text.trimmingCharacters(in: .whitespacesAndNewlines) == "") && isCommentsMandotary{
            CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Mandatory Comment Entry required", btnTitle: "OK", completion: nil)
            return
        }
        
        
        
        if fromExistingVC {
            UpdateAudioFile.comment(txtViewComment.text ?? "").update(audioName: selectedAudio)
            UpdateAudioFile.autoSaved(false).update(audioName: selectedAudio)
            
            popToExitingVC()
            return
        }else{
            AudioFiles.shared.saveNewAudioFile(fileName: self.fileName, filePath: self.filePath, comment: txtViewComment.text, autoSaved: false)
        }
        
        let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
        self.setPushTransitionAnimation(VC)
        popToExitingVC()
    }
    
    fileprivate func popToExitingVC() {
        guard let viewControllers = self.navigationController?.viewControllers else {return }
        for controller in viewControllers {
            if controller.isKind(of: TabbarVC.self) {
                let tabVC = controller as! TabbarVC
                    tabVC.selectedIndex = 0 //no need of this line if you want to access same tab where you have started your navigation
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

extension CommentsVC : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = text.components(separatedBy: cs).joined(separator: "")
        return (text.replacingOccurrences(of: " ", with: "") == filtered)
    }
}
