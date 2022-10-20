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
        
    }
    
    // MARK: UISetUp
    func setUpUI() {
        hideLeftButton()
        setTitleWithoutImage("Comments")
        if canEditComments {
            txtViewComment.isEditable = true
            txtViewComment.becomeFirstResponder()
        }

//        txtViewComment.returnKeyType = .next
        btnDiscard.isUserInteractionEnabled = !isCommentsMandotary
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    fileprivate func saveComment() {
        CoreData.shared.comments[fileName] = txtViewComment.text
        CoreData.shared.dataSave()
        let VC = ExistingVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
        self.setPushTransitionAnimation(VC)
        self.navigationController?.popViewController(animated: false)
        self.tabBarController?.selectedIndex = 2
    }
}
