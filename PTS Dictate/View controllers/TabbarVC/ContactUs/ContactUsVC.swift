//
//  ContactUsVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 03/09/22.
//

import UIKit
import CoreTelephony
import MessageUI

class ContactUsVC: BaseViewController {
    
    // MARK: - @IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    
    // data var
    let titleArray = ["1300 768 476 (AUS)","0800 884 323 (NZ)","ptshelpdesk@outlook.com","info@etranscriptions.com.au"]
    let imageArray = [#imageLiteral(resourceName: "settings_phone.png"),#imageLiteral(resourceName: "settings_phone.png"),#imageLiteral(resourceName: "settings_mail.png"),#imageLiteral(resourceName: "settings_mail.png")]
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset =  UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    // MARK: - UISetup
    func setUpUI(){
        hideLeftButton()
        setTitleWithoutImage("Contact Us")
    }
    
    func makeCall(_ tag:Int){
        if let callUrl = tag == 0 ? URL(string: "telprompt://1300768476") : URL(string: "telprompt://0800884323"){
            if canDevicePlaceAPhoneCall(){
                if UIApplication.shared.canOpenURL(callUrl){
                    UIApplication.shared.open(callUrl)
                }
            }else{
                //show alert
                CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Device does not support phone calls.", btnTitle: "OK", completion: nil)
            }
        }
    }
    
    func canDevicePlaceAPhoneCall() -> Bool{
        if let url = URL(string: "tel://") {
            if UIApplication.shared.canOpenURL(url) {
                // Device supports phone calls, lets confirm it can place one right now
                let netInfo = CTTelephonyNetworkInfo()
                let carrier = netInfo.subscriberCellularProvider
                let mnc = carrier?.mobileNetworkCode
                if ((mnc?.count ?? 0) == 0) || (mnc == "65535") {
                    // Device cannot place a call at this time.  SIM might be removed.
                    return false
                } else {
                    // Device can place a phone call
                    return true
                }
            } else {
                // Device does not support phone calls
                return false
            }
        }else {
            // Device does not support phone calls
            return false
        }
    }
    
    func openEmailView(_ tag:Int){
        if MFMailComposeViewController.canSendMail(){
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            if tag == 3 {
                composeViewController.setToRecipients(["info@etranscriptions.com.au"])
            } else {
                composeViewController.setToRecipients(["ptshelpdesk@outlook.com"])
            }
            present(composeViewController, animated: true)
            composeViewController.viewControllers.last?.navigationItem.title = "Compose mail"
        }else{
            //show alert
            CommonFunctions.alertMessage(view: self, title: "No mail account", msg: "Please set up a mail account in order to send a mail.", btnTitle: "OK", completion: nil)
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0,1:
            makeCall(indexPath.row)
        case 2,3:
            openEmailView(indexPath.row)
        default:
            print("nothing")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ContactUsVC: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            dismiss(animated: true)
        case MFMailComposeResult.saved:
            dismiss(animated: true)
        case MFMailComposeResult.sent:
            CommonFunctions.alertMessage(view: self, title: "PTS Dictate", msg: "Mail sent successfully.", btnTitle: "OK", completion: nil)
        case MFMailComposeResult.failed:
            dismiss(animated: true)
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
    }
}
