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
    var canEditComments = true
    var fileName = ""
    var comment = ""
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        popToExitingVC()
    }
    
    // MARK: UISetUp
    func setUpUI() {
        hideLeftButton()
        setTitleWithoutImage("Comments")
        if isCommentsMandotary {
            btnDiscard.isUserInteractionEnabled = true
        } else {
            btnDiscard.isUserInteractionEnabled = false
        }
        if canEditComments {
            txtViewComment.isEditable = true
            txtViewComment.becomeFirstResponder()
            btnSave.isUserInteractionEnabled = true
            btnDiscard.isUserInteractionEnabled = true
        } else {
            txtViewComment.isEditable = false
            txtViewComment.text = comment
            btnSave.isUserInteractionEnabled = false
            btnDiscard.isUserInteractionEnabled = false
        }
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    fileprivate func saveComment() {
        var audios = AudioFiles.shared.audioFiles
        audios.append(AudioFile(name: fileName, fileInfo: AudioFileInfo(comment: txtViewComment.text, isUploaded: false, archivedDays: 1, canEdit: false)))
//        Constants.userDefaults.set(audios, forKey: Constants.UserDefaultKeys.audioFiles)
        CoreData.shared.audioFiles = audios
        CoreData.shared.comments[fileName] = txtViewComment.text
        CoreData.shared.dataSave()
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
//                let VCs = tabVC.selectedViewController as! ExistingVC
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
