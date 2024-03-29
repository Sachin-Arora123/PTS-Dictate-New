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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Double(sender.value)
        print("->>", currentValue )
        CoreData.shared.microSensitivityValue = currentValue
        CoreData.shared.dataSave()
    }
    
    // MARK: - UISetup
    func setUpUI(){
        hideLeftButton()
        setTitleWithoutImage("Microphone Sensitivity")
        self.slider.value = Float(CoreData.shared.microSensitivityValue)
    }


}
