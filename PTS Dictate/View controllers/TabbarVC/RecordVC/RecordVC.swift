//
//  RecordVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 04/09/22.
//

import UIKit

class RecordVC: BaseViewController {
    
    // MARK: - @IBOutlets.
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnForwardTrim: UIButton!
    @IBOutlet weak var btnForwardTrimEnd: UIButton!
    @IBOutlet weak var btnBackwardTrim: UIButton!
    @IBOutlet weak var btnBackwardTrimEnd: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFName: UILabel!
    @IBOutlet weak var lblFNameValue: UILabel!
    @IBOutlet weak var lblFSize: UILabel!
    @IBOutlet weak var lblFSizeValue: UILabel!
    @IBOutlet weak var lblMaxFSize: UILabel!
    @IBOutlet weak var lblMaxFSizeValue: UILabel!
    @IBOutlet weak var viewBottomButton: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDiscard: UIButton!

    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
    }
    // MARK: - UISetup
    func setUpUI(){
        hideLeftButton()
        setTitleWithImage("Record", andImage: UIImage(named: "title_record_normal.png") ?? UIImage())
    }

    // MARK: - @IBActions.
    @IBAction func onTapRecord(_ sender: UIButton) {
        
    }
    
    @IBAction func onTapStop(_ sender: UIButton) {
        
    }
    
    @IBAction func onTapPlay(_ sender: UIButton) {
        
    }
    @IBAction func onTapForwardTrim(_ sender: UIButton) {
        
    }
    @IBAction func onTapForwardTrimEnd(_ sender: UIButton) {
        
    }
    
    @IBAction func onTapBackwardTrim(_ sender: UIButton) {
        
    }
    
    @IBAction func onTapBackwardTrimEnd(_ sender: UIButton) {
        
    }
    @IBAction func onTapSave(_ sender: UIButton) {
        
    }
    @IBAction func onTapEdit(_ sender: UIButton) {
        
    }
    @IBAction func onTapDiscard(_ sender: UIButton) {
        
    }
}
