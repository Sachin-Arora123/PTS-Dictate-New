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
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
        needsUpdate()
        print(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
    }
    
    // MARK: - UISetup
    func setUpUI(){
        hideLeftButton()
        setTitleWithoutImage("About")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset =  UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0)
    }
    
    func needsUpdate() {
        
//        let urlToDocumentsFolder: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
//         let installDate = try? FileManager.default.attributesOfItem(atPath: (urlToDocumentsFolder?.path)!)[.creationDate] as? Date
//         print("Install Date of app is \(installDate)")
        
        
        let infoDictionary = Bundle.main.infoDictionary
        let appID = infoDictionary?["CFBundleIdentifier"] as? String
        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(appID ?? "")")
        var data: Data? = nil
        if let url {
            data = try? Data(contentsOf: url)
        }
        var lookup: [AnyHashable : Any]? = nil
        do {
            if let data {
                lookup = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable : Any]
            }
        } catch {
        }

//        if (lookup?["resultCount"] as? NSNumber)?.intValue ?? 0 == 1 {
//            let appStoreVersion = lookup?["results"][0]["version"] as? String
//            let strReleaseDate = lookup?["results"][0]["currentVersionReleaseDate"] as? String
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            let date = dateFormatter.date(from: strReleaseDate ?? "")
//            dateFormatter.dateFormat = "dd/MM/yy"
//            if let date {
//                currentReleaseDate = dateFormatter.string(from: date)
//            }
//
//            let currentVersion = infoDictionary?["CFBundleShortVersionString"] as? String
//            if appStoreVersion != currentVersion {
//                print("Need to update [\(appStoreVersion ?? "") != \(currentVersion ?? "")]")
//            }
//        }
//        myTblView.reloadData()

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
//        cell.lblTitleDesc.text =
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

