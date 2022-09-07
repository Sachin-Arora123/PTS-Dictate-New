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


    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    // MARK: -  UISetUp
    func setUpUI(){
        hideLeftButton()
        setTitleWithoutImage("Rename The File")
        addRightButton(selector: #selector(btnDoneAction))
    }
    
    @objc func btnDoneAction() {
        
    }
}
