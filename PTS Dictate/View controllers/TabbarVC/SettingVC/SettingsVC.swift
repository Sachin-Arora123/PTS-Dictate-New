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
    var dataTitle1 = ["Audio Quality","Microphone Sensitivity",
                     "Voice Activation Auto Pause",
                     "Disable Email Notification","Comments Screen",
                     "   Comments Screen - Mandatory","Indexing","Disable Editing Help Screens"]
    let dataTitle2 = ["Profile","File Naming Date Format",
                      "Archive file after upload",
                      "Upload via WiFi only",
                      "Sleep Mode Override","About","Logout"]
    let iconArray = ["settings_profile","settings_edit","settings_upload","settings_wifi","settings_standby","settings_info","settings_logout"]
    var switchState = true
    
    // MARK: - View Life-Cycle.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // setUI
    func setUI(){
        tableView.delegate = self
        tableView.dataSource = self
        setTitleWithImage("Settings", andImage: UIImage(named: "tabbar_settings_highlighted") ?? UIImage())
        tableView.register(UINib(nibName: "RecordingCell", bundle: nil), forCellReuseIdentifier: "RecordingCell")
    }
    // LogOut
    func logOutAlert(){
        CommonFunctions.showAlert(view: self, title: "PTS Dictate", message: "Are you sure you want to Logout?", completion: {
            (result) in
            if result{
                print("Tapped Yes")
                CoreData.shared.deleteProfile()
                AppDelegate.sharedInstance().moveToLoginVC()
            }else{
                print("Tapped No")
            }
        })
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
            cell.btnSwitch.tag = indexPath.row
            cell.lblTitle.text = dataTitle1[indexPath.row]
            cell.btnSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            switch indexPath.row{
            case 0,1:
                cell.btnSwitch.isHidden = true
            case 5:
                cell.imgViewArrow.isHidden = true
                if switchState{
                    
                }else{
                    cell.lblTitle.text = ""
                    cell.btnSwitch.isHidden = true
                    cell.imgViewArrow.isHidden = true
                }
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
                let vc = MicroSensitivityVC.instantiateFromAppStoryboard(appStoryboard: .Settings)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        case 1:
            switch indexPath.row{
            case 0:
                let vc = ProfileVC.instantiateFromAppStoryboard(appStoryboard: .Settings)
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = NamingFormatVC.instantiateFromAppStoryboard(appStoryboard: .Settings)
                self.navigationController?.pushViewController(vc, animated: true)
            case 5:
                let vc = AboutVC.instantiateFromAppStoryboard(appStoryboard: .Settings)
                self.navigationController?.pushViewController(vc, animated: true)
            case 6:
                self.logOutAlert()
            default:
                break
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 5 :
                if switchState{
                    return UITableView.automaticDimension
                }else{
                    return 0
                }
            default:
                break
            }
        case 1:
            break
        default:
            break
        }
        return UITableView.automaticDimension
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch){
        switch sender.tag {
        case 4:
            if sender.isOn {
                switchState = true
                let indexPath = IndexPath(row: 5, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
            }else{
                switchState = false
                let indexPath = IndexPath(row: 5, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.top)
            }
        case 5:
            break
        default:
            break
        }
    }
}

