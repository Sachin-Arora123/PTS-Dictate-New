//
//  AudioQualityVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 28/08/22.
//

import UIKit

class AudioQualityVC: BaseViewController {
  
    // MARK: - @IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    
    // data var
    let titleArray = ["11 kHz","22 kHz","44.1kHz"]
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        setTitle(title: "Audio Quality")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioQualityCell", for: indexPath) as!
        AudioQualityCell
        switch indexPath.section {
        case 0:
            cell.lblTitle.text = "AAC"
        case 1:
            cell.lblTitle.text = titleArray[indexPath.row]
        default:
            break
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        let label = UILabel(frame: CGRect(x: 17, y: 0, width: tableView.frame.size.width, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 20)
        if section == 1{
            label.text = "AUDIO QUALITY"
        }
        label.textColor = UIColor.blackTextColor
        view.addSubview(label)
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
