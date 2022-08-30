//
//  MicroSensitivityVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 29/08/22.
//

import UIKit

class MicroSensitivityVC: BaseViewController {
   
    // MARK: - @IBOutlets.
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lblInfoTitle: UILabel!
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    // MARK: - UISetup
    func setUpUI(){
        hideLeftButton()
        setTitleWithoutImage("Microphone Sensitivity")
    }


}
