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

    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    // MARK: -  UISetUp
    func setUpUI(){
        hideLeftButton()
        setTitleWithoutImage("Comments")
        self.navigationController?.navigationItem.hidesBackButton = true
    }
}
