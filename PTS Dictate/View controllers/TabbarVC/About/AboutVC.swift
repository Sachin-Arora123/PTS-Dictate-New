//
//  AboutVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 03/09/22.
//

import UIKit

class AboutVC: BaseViewController {

    // MARK: - @IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    
    let titleArray = ["App Version","App Last Updated Date","Contact Us"]
    var lastReleaseDate = ""
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        needsUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideLeftButton()
        setTitleWithoutImage("About")
    }
    
    // MARK: - UISetup
    func setUpUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset =  UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0)
    }
    
    func needsUpdate() {
        
//        let infoDictionary = Bundle.main.infoDictionary
//        let appID = infoDictionary?["CFBundleIdentifier"] as? String
//        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(appID ?? "")")
        
        //sending a static url for now as the app id of this project is different than the old one.
        if let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.pts.ptsdictate"){
            
            
            
            
            if let data = try? Data(contentsOf: url){
                let lookup = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable : Any]
                if lookup?["resultCount"] as? Int == 1{
                    if let results = lookup?["results"] as? [Any]{
                        let strReleaseDate = (results.first as? [String : Any])?["currentVersionReleaseDate"]
                        let dateformatter = DateFormatter()
                        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        if let date = dateformatter.date(from: strReleaseDate as! String){
                            dateformatter.dateFormat = "dd/MM/yy"
                            lastReleaseDate = dateformatter.string(from: date)
                            tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Extension for tableView delegate & dataSource methods.
extension AboutVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutInfoCell", for: indexPath) as! AboutInfoCell
        cell.lblTitle.text = titleArray[indexPath.row]
        cell.lblTitleDesc.text = indexPath.row == 0 ? appVersion : lastReleaseDate
        if indexPath.row != 2 {
            cell.imgViewArrow.isHidden = true
        }else {
            cell.lblTitleDesc.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            let VC = ContactUsVC.instantiateFromAppStoryboard(appStoryboard: .Settings)
            self.navigationController?.pushViewController(VC, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

