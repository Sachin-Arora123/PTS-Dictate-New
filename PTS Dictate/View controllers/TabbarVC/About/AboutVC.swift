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
        setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - UISetup
    func setUpUI(){
        hideLeftButton()
        setTitleWithoutImage("About")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset =  UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0)
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

