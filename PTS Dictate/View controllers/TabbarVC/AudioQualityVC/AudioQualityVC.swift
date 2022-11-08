//
//  AudioQualityVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 28/08/22.
//

import UIKit
enum AudioQuality : Int {
    case one = 0
    case two = 1
    case three = 2
}

func savedAudioQuality(audioQuality : AudioQuality) -> Double {
    switch audioQuality {
    case .one:
        return 11025.0
    case .two:
        return 22050.0
    case .three:
        return 44100.0
    }
}
//print(checkPoint(compass: CompassPoint(rawValue: 3)!))
class AudioQualityVC: BaseViewController {
    
    // MARK: - @IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - data var
    let titleArray = ["11 kHz","22 kHz","44.1 kHz"]
    var selectedData = 0
    
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpUI()
    }
    
    @objc func btncActBack(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - SetUpUI
extension AudioQualityVC{
    func setUpUI(){
        hideLeftButton()
        setTitleWithoutImage("Audio Quality")
        tableView.delegate = self
        tableView.dataSource = self
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
    }
}

// MARK: - Extension for tableView delegate & dataSource methods.
extension AudioQualityVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return titleArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
//            self.selectedData = "AAC"
            break
        case 1:
//            self.selectedData = titleArray[indexPath.row]
            self.selectedData = indexPath.row
            CoreData.shared.audioQuality = self.selectedData
        default:
            break
        }
        CoreData.shared.dataSave()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioQualityCell", for: indexPath) as!
        AudioQualityCell
        switch indexPath.section {
        case 0:
            cell.lblTitle.text = "AAC"
            self.tableView.separatorStyle = .none
            cell.isUserInteractionEnabled = false
            cell.imgViewTick.isHidden = true
        case 1:
            cell.isUserInteractionEnabled = true
            self.tableView.separatorStyle = .singleLine
            cell.lblTitle.text = titleArray[indexPath.row]
            if CoreData.shared.audioQuality == indexPath.row {
                cell.imgViewTick.isHidden = false
            }else{
                cell.imgViewTick.isHidden = true
            }
        default:
            break
        }
//        if cell.lblTitle.text == self.selectedData{
//            cell.imgViewTick.isHidden = false
//        }else{
//            cell.imgViewTick.isHidden = true
//        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else{
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 38))
            let label = UILabel()
            label.frame = CGRect.init(x: 16, y: -6, width: headerView.frame.width-10, height: headerView.frame.height)
            label.text = "AUDIO QUALITY"
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = UIColor.blackTextColor
            if #available(iOS 13.0, *) {
                headerView.backgroundColor = UIColor.systemGroupedBackground
            } else {
                headerView.backgroundColor = .lightGray
                // Fallback on earlier versions
            }
            headerView.addSubview(label)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 38
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
