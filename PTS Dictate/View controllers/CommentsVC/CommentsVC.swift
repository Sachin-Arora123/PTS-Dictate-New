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
    var comment = ""
    var meteringLevels: [Float] = []
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
        if fromExistingVC && canEditComments {
            txtViewComment.isEditable = true
            txtViewComment.text = comment
            btnSave.isUserInteractionEnabled = true
            btnDiscard.isUserInteractionEnabled = true
        } else if fromExistingVC && !canEditComments{
            txtViewComment.isEditable = false
            txtViewComment.text = comment
            btnSave.isUserInteractionEnabled = false
            btnDiscard.isUserInteractionEnabled = false
        } else {
            txtViewComment.isEditable = true
            txtViewComment.becomeFirstResponder()
            btnSave.isUserInteractionEnabled = true
            btnDiscard.isUserInteractionEnabled = true
        }
        if isCommentsMandotary {
            btnDiscard.isUserInteractionEnabled = false
        } else {
            btnDiscard.isUserInteractionEnabled = true
        }
        btnSave.isHidden = isUploaded
        btnDiscard.isHidden = isUploaded
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    fileprivate func saveComment() {
        if fromExistingVC {
            UpdateAudioFile.comment(txtViewComment.text ?? "").update(audioName: selectedAudio)
        }
        AudioFiles.shared.saveNewAudioFile(name: fileName, comment: txtViewComment.text ?? "", meteringLevels: self.meteringLevels)
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
