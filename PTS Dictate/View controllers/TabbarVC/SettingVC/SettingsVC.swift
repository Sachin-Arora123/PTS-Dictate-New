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
    
    // data var
    let sectionTitle = ["RECORDING","GENERAL"]
    let dataTitle1 = ["Audio Quality","Microphone Sensitivity",
                     "Voice Activation Auto Pause",
                     "Disable Email Notification","Comments Screen",
                     "Indexing","Disable Editing Help Screens"]
    let dataTitle2 = ["Profile","File Naming Date Format",
                      "Archive file after upload",
                      "Upload via WiFi only",
                      "Sleep Mode Override","About","Logout"]
    let iconArray = ["settings_profile","settings_edit","settings_upload","settings_wifi","settings_standby","settings_info","settings_logout"]
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
            return dataTitle1.count
        }else{
            return dataTitle2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingCell", for: indexPath) as!
            RecordingCell
            cell.lblTitle.text = dataTitle1[indexPath.row]
            switch indexPath.row{
            case 0,1:
                cell.btnSwitch.isHidden = true
            
            default:
                cell.imgViewArrow.isHidden = true
                break
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralSettingCell", for: indexPath) as!
            GeneralSettingCell
            cell.lblTitle.text = dataTitle2[indexPath.row]
            cell.imgViewIcon.image = UIImage(named: iconArray[indexPath.row])
            switch indexPath.row{
            case 0,1,5:
                cell.btnSwitch.isHidden = true
            case 2,3,4:
                cell.imgViewArrow.isHidden = true
            case 6:
                cell.btnSwitch.isHidden = true
                cell.imgViewArrow.isHidden = true
            default:
                break
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let label = UILabel(frame: CGRect(x: 17, y: 0, width: tableView.frame.size.width, height: 50))
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = sectionTitle[section]
        label.textColor = UIColor.blackTextColor
        view.addSubview(label)
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            switch indexPath.row {
            case 0:
                let vc = AudioQualityVC.instantiateFromAppStoryboard(appStoryboard: .Main)
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                break
            default:
                break
            }
        case 1:
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

