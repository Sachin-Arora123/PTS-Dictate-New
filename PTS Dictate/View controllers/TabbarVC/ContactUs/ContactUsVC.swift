//
//  ContactUsVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 03/09/22.
//

import UIKit

class ContactUsVC: BaseViewController {
    
    // MARK: - @IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    
    // data var
    let titleArray = ["1300 768 476 (AUS)","0800 884 323 (NZ)","ptshelpdesk@outlook.com","info@etranscriptions.com.au"]
    let imageArray = [#imageLiteral(resourceName: "settings_phone.png"),#imageLiteral(resourceName: "settings_phone.png"),#imageLiteral(resourceName: "settings_mail.png"),#imageLiteral(resourceName: "settings_mail.png")]
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    // MARK: - UISetup
    func setUpUI(){
        hideLeftButton()
//        setTitleWithoutImage("Contact Us")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset =  UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - Extension for tableView delegate & dataSource methods.
extension ContactUsVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsCell", for: indexPath) as! ContactUsCell
        cell.lblTitle.text = titleArray[indexPath.row]
        cell.imgViewIcon.image = imageArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
