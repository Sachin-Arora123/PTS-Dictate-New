//
//  NamingFormatVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 30/08/22.
//

import UIKit



class NamingFormatVC: BaseViewController {
    
    // MARK: - @IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblFileNameTitle: UILabel!
    @IBOutlet weak var txtFldHeaderFileName: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewBottomConstant: NSLayoutConstraint!
    
    // MARK: - data var
    let titleArray = ["File Name","Date Format"]
    let pickerViewData : [String] = ["yyyymmdd", "yyyyddmm", "mmyyyydd", "mmddyyyy", "ddyyyymm", "ddmmyyyy"]
    
    var fileName = CoreData.shared.fileName != "" ? CoreData.shared.fileName : CoreData.shared.profileName
    var dateFormat = CoreData.shared.dateFormat
    var currentDateStr = ""
    var selectedTFIndex : Int?
    
    // MARK: - View Life-Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderName()
    }
    
    func setupHeaderName(){
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateStr = dateFormatter.string(from: currentDate)
        let convertedDate = dateFormatter.date(from: currentDateStr) ?? Date()
        
        if self.dateFormat.count == 0 {
            dateFormatter.dateFormat = "ddMMyyyy"
        }else{
            dateFormatter.dateFormat = self.dateFormat.replacingOccurrences(of: "mm", with: "MM")
        }
        
        self.currentDateStr = "\(dateFormatter.string(from: convertedDate))"
        
        
        let nameToShow = (self.fileName.count != 0) ? self.fileName : CoreData.shared.profileName

        txtFldHeaderFileName.text = nameToShow + "_" + self.currentDateStr + "_File_001" + ".m4a"
    }
    
    func changeHeaderName(){
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateStr = dateFormatter.string(from: currentDate)
        let convertedDate = dateFormatter.date(from: currentDateStr) ?? Date()
        dateFormatter.dateFormat = self.dateFormat.replacingOccurrences(of: "mm", with: "MM")
        self.currentDateStr = "\(dateFormatter.string(from: convertedDate))"
        let nameToShow = (self.fileName.count != 0) ? self.fileName : CoreData.shared.profileName
        txtFldHeaderFileName.text = nameToShow + "_" + self.currentDateStr + "_File_001" + ".m4a"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        hideBottomView()
    }
    
    // MARK: - UISetup
    func setUpUI(){
        hideLeftButton()
        setTitleWithoutImage("File Naming Date Format")
        addRightButton(selector: #selector(btnDoneAction))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset =  UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    @IBAction func btnDonePickerViewAction(_ sender: Any) {
        self.hideBottomView()
        self.tableView.reloadData()
    }
    
    @objc func btnDoneAction() {
        self.view.endEditing(true)
        if self.fileName.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster("PTS Dictate", titleDesc: "FileName should not be empty", true, false)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            CoreData.shared.fileName   = self.fileName
            CoreData.shared.dateFormat = self.dateFormat
            CoreData.shared.dataSave()
            CommonFunctions.toster("Updated Successfully", titleDesc: "", false, true)
        })
        
    }
}

// MARK: - Extension for tableView delegate & dataSource methods.
extension NamingFormatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NamingFormatCell", for: indexPath) as! NamingFormatCell
        cell.lblNameTitle.text = titleArray[indexPath.row]
        cell.txtFldDateFormat.tag = indexPath.row
        cell.delegate = self
        if indexPath.row == 0{
            cell.txtFldDateFormat.text = (self.fileName != "") ? self.fileName : CoreData.shared.profileName
        }else{
            cell.txtFldDateFormat.text = (self.dateFormat != "") ? self.dateFormat : "ddmmyyyy"
        }
        if selectedTFIndex != nil{
            if indexPath.row == selectedTFIndex{
                cell.txtFldDateFormat.becomeFirstResponder()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - Delegate Methods
extension NamingFormatVC : NamingFormatCellDelegate{
    func passData(text: String, id: Int) {
        if id == 0{
            self.fileName = text
            txtFldHeaderFileName.text = self.fileName + "_" + self.currentDateStr + "_File_001" + ".m4a"
        }else{
            self.dateFormat = text
        }
    }
    
    func sendTextFieldDidEditing(textField: UITextField, id: Int) {
        if id == 1{
            self.showPickerView()
        }
        selectedTFIndex = id
    }
    
    func showPickerView(){
        //hide keyboard if appeared already
        self.view.endEditing(true)
        //hide tabbar.
        self.changeTabBar(hidden: true, animated: false)
        //show picker
        self.pickerViewBottomConstant.constant = 0
        //animate
        UIView.animate(withDuration: 0.4, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideBottomView(){
        //hide picker
        self.pickerViewBottomConstant.constant = -900
        //show tabbar
        self.changeTabBar(hidden: false, animated: false)
        //animate
        UIView.animate(withDuration: 0.4, delay: 0.1) { self.view.layoutIfNeeded() }
    }
    
    func changeTabBar(hidden:Bool, animated: Bool){
        if let tabBar = self.tabBarController?.tabBar{
            let offset = (hidden ? UIScreen.main.bounds.size.height + 40 : UIScreen.main.bounds.size.height - (tabBar.frame.size.height) )
            if offset == tabBar.frame.origin.y {return}
            let duration:TimeInterval = (animated ? 0.2 : 0.0)
            UIView.animate(withDuration: duration,animations: {tabBar.frame.origin.y = offset})
        }
    }
}

//MARK: - PickerView Delegate Methods
extension NamingFormatVC: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.dateFormat = pickerViewData[row]
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! NamingFormatCell
        cell.txtFldDateFormat.text = pickerViewData[row]
        changeHeaderName()
    }
}
