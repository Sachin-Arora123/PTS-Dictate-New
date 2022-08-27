//
//  SettingsVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 28/08/22.
//

import UIKit

class SettingsVC: BaseViewController {
    
    // MARK: - @IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life-Cycle.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    // setUI
    func setUI(){
        tableView.delegate = self
        tableView.dataSource = self
        setTitleWithImage("Settings", andImage: UIImage(named: "tabbar_settings_highlighted") ?? UIImage())
        tableView.register(UINib(nibName: "RecordingCell", bundle: nil), forCellReuseIdentifier: "RecordingCell")
    }
}

// MARK: - Extension for tableView delegate & dataSource methods.
extension SettingsVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingCell", for: indexPath) as!
            RecordingCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralSettingCell", for: indexPath) as!
            GeneralSettingCell
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

