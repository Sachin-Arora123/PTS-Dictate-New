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
                      "Archive file after upload","   Archived Days",
                      "Upload via WiFi only",
                      "Sleep Mode Override","About","Logout"]
    let iconArray = ["settings_profile","settings_edit","settings_upload","settings_archive","settings_wifi","settings_standby","settings_info","settings_logout"]
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
            cell.btnSwitch.addTarget(self, action: #selector(switchRecordingSection(_:)), for: .valueChanged)
            cell.imgViewArrow.isHidden = true
            
            switch indexPath.row{
            case 0,1:
                //audio quality, microphone senstivity
                cell.btnSwitch.isHidden = true
                cell.imgViewArrow.isHidden = false
            case 2:
                //voice activation auto pause
                cell.btnSwitch.isHidden = false
                cell.btnSwitch.isOn = (CoreData.shared.voiceActivation == 1)
            case 3:
                //disable email notification
                cell.btnSwitch.isHidden = false
                cell.btnSwitch.isOn = (CoreData.shared.disableEmailNotify == 1)
            case 4:
                //comment screen
                cell.btnSwitch.isHidden = false
                cell.btnSwitch.isOn = (CoreData.shared.commentScreen == 1)
            case 5:
                //comment mandatory screen
                if CoreData.shared.commentScreen == 1{
                    cell.btnSwitch.isOn = (CoreData.shared.commentScreenMandatory == 1)
                }else{
                    cell.lblTitle.text = ""
                    cell.imgViewArrow.isHidden = true
                }
            case 6:
                //indexing
                cell.btnSwitch.isHidden = false
                cell.btnSwitch.isOn = (CoreData.shared.indexing == 1)
            case 7:
                //disable editing alerts
                cell.btnSwitch.isHidden = false
                cell.btnSwitch.isOn = (CoreData.shared.disableEditingHelp == 1)
            default:
                cell.imgViewArrow.isHidden = true
                break
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralSettingCell", for: indexPath) as!
            GeneralSettingCell
            cell.lblArchiveValue.isHidden = true
            cell.btnSwitch.tag = indexPath.row
            cell.btnSwitch.addTarget(self, action: #selector(switchGeneralSection(_:)), for: .valueChanged)
            cell.lblTitle.text = dataTitle2[indexPath.row]
            cell.imgViewIcon.image = UIImage(named: iconArray[indexPath.row])
            cell.imgViewIcon.isHidden = false
            
            switch indexPath.row{
            case 0,1:
                //profile, filename format
                cell.imgViewArrow.isHidden = false
                cell.btnSwitch.isHidden =  true
            case 2:
                //archive file after upload
                cell.btnSwitch.isHidden =  false
                cell.imgViewArrow.isHidden = true
                cell.btnSwitch.isOn = CoreData.shared.archiveFile == 1 ? true : false
            case 3:
                //archive days
                cell.btnSwitch.isHidden = true
                if CoreData.shared.archiveFile == 1{
                    cell.lblArchiveValue.isHidden = false
                    cell.lblArchiveValue.text = "\(CoreData.shared.archiveFileDays)"
                    cell.imgViewIcon.isHidden = false
                    cell.imgViewArrow.isHidden = false
                }else{
                    cell.lblArchiveValue.isHidden = true
                    cell.lblTitle.text = ""
                    cell.btnSwitch.isHidden = true
                    cell.imgViewArrow.isHidden = true
                    cell.imgViewIcon.isHidden = true
                }
            case 4:
                //upload via wifi
                cell.btnSwitch.isHidden =  false
                cell.imgViewArrow.isHidden = true
                cell.btnSwitch.isOn = (CoreData.shared.uploadViaWifi == 1)
            case 5:
                //sleep mode ovveride
                cell.btnSwitch.isHidden =  false
                cell.imgViewArrow.isHidden = true
                cell.btnSwitch.isOn = (CoreData.shared.sleepModeOverride == 1)
            case 6:
                //about
                cell.btnSwitch.isHidden = true
                cell.imgViewArrow.isHidden = false
            case 7:
                //logout
                cell.btnSwitch.isHidden = true
                cell.imgViewArrow.isHidden = true
            default:
                cell.btnSwitch.isHidden = false
                cell.imgViewArrow.isHidden = false
                cell.lblArchiveValue.isHidden = false
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
            case 3:
                    let alert = UIAlertController(title: "Enter archive days", message: nil, preferredStyle: .alert)

                    //2. Add the text field. You can configure it however you need.
                    alert.addTextField { (textField) in
                        textField.text = "\(CoreData.shared.archiveFileDays)"
                        textField.keyboardType = .phonePad
                    }
                    

                    // 3. Grab the value from the text field, and print it when the user clicks OK.
                    alert.addAction(UIAlertAction(title: "Cencel", style: .cancel, handler: { [weak alert] (_) in
                        print("Cancel")
                    }))
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                        print("Text field: \(textField?.text ?? "")")
                        let textValue =  ((textField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") as NSString).integerValue
                        if textValue >= 1{
                            CoreData.shared.archiveFileDays = textValue
                            CoreData.shared.dataSave()
                            self.tableView.reloadData()
                        }else{
                            CoreData.shared.archiveFileDays = 1
                            CoreData.shared.dataSave()
                            self.tableView.reloadData()
                        }
                    }))

                    // 4. Present the alert.
                    self.present(alert, animated: true, completion: nil)

            case 6:
                let vc = AboutVC.instantiateFromAppStoryboard(appStoryboard: .Settings)
                self.navigationController?.pushViewController(vc, animated: true)
            case 7:
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
                if CoreData.shared.commentScreen == 1{
                    return UITableView.automaticDimension
                }else{
                    return 0
                }
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 3 :
                if CoreData.shared.archiveFile == 1{
                    return UITableView.automaticDimension
                }else{
                    return 0
                }
            default:
                break
            }
        default:
            break
        }
        return UITableView.automaticDimension
    }
    
    @objc func switchRecordingSection(_ sender: UISwitch){
        switch sender.tag {
        case 2:
            if sender.isOn {
                CoreData.shared.voiceActivation = 1
            }else{
                CoreData.shared.voiceActivation = 0
            }
        case 3:
            if sender.isOn {
                CoreData.shared.disableEmailNotify = 1
            }else{
                CoreData.shared.disableEmailNotify = 0
            }
        case 4:
            if sender.isOn {
                CoreData.shared.commentScreen = 1
//                switchState = true
                let indexPath = IndexPath(row: 5, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
            }else{
                //disbale comment mandatory as well if user is disbling comment screen
                CoreData.shared.commentScreen = 0
                CoreData.shared.commentScreenMandatory = 0
//                switchState = false
                let indexPath = IndexPath(row: 5, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.top)
            }
        case 5:
            CoreData.shared.getdata()
            if CoreData.shared.commentScreen == 1{
                if sender.isOn{
                    CoreData.shared.commentScreenMandatory = 1
                }else{
                    CoreData.shared.commentScreenMandatory = 0
                }
            }
        case 6:
            if sender.isOn {
                CoreData.shared.indexing = 1
            }else{
                CoreData.shared.indexing = 0
            }
        case 7:
            if sender.isOn {
                CoreData.shared.disableEditingHelp = 1
            }else{
                CoreData.shared.disableEditingHelp = 0
            }
//        case 8:
//            if sender.isOn {
//                CoreData.shared.disableEditingHelp = 1
//            }else{
//                CoreData.shared.disableEditingHelp = 0
//            }
        default:
            break
        }
        CoreData.shared.dataSave()
    }
    
    @objc func switchGeneralSection(_ sender: UISwitch){
        switch sender.tag {
        case 2:
            if sender.isOn {
                CoreData.shared.archiveFile = 1
                let indexPath = IndexPath(row: 3, section: 1)
                self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
                
                //1. Create the alert controller.
                let alert = UIAlertController(title: "Enter archive days", message: nil, preferredStyle: .alert)

                //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    textField.text = "\(CoreData.shared.archiveFileDays)"
                    textField.keyboardType = .phonePad
                }
                

                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "Cencel", style: .cancel, handler: { [weak alert] (_) in
                    print("Cancel")
                }))
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                    print("Text field: \(textField?.text ?? "")")
                    let textValue =  ((textField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") as NSString).integerValue
                    if textValue >= 1{
                        CoreData.shared.archiveFileDays = textValue
                        CoreData.shared.dataSave()
                        self.tableView.reloadData()
                    }else{
                        CoreData.shared.archiveFileDays = 1
                        CoreData.shared.dataSave()
                        self.tableView.reloadData()
                    }
                }))

                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            }else{
                CoreData.shared.archiveFile = 0
                let indexPath = IndexPath(row: 3, section: 1)
                self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.top)
            }
        case 4:
            if sender.isOn{
                CoreData.shared.uploadViaWifi = 1
            }else{
                CoreData.shared.uploadViaWifi = 0
            }
        case 5:
            if sender.isOn{
                CoreData.shared.sleepModeOverride = 1
            }else{
                CoreData.shared.sleepModeOverride = 0
            }
        default:
            break
        }
        CoreData.shared.dataSave()
    }
}

