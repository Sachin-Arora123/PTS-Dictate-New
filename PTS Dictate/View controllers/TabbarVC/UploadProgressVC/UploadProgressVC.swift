//
//  UploadProgressVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 27/08/22.
//

import UIKit

class UploadProgressVC: BaseViewController {
    
    // MARK: - @IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewNoUpload: UIView!
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        setTitleWithImage("Uploads", andImage: UIImage(named: "settings_upload.png") ?? UIImage())
        self.viewNoUpload.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
}

// MARK: - Extension for tableView delegate & dataSource methods.
extension UploadProgressVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadListCell", for: indexPath) as! UploadListCell
        if indexPath.row == 0{
            cell.viewUploadProgress.isHidden = true
        }else{
            cell.detailStackView.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

