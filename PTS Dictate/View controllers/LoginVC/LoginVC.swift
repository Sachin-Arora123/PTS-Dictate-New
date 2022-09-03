//
//  ViewController.swift
//  PTS Dictate
//
//  Created by Sachin on 23/08/22.
//

import UIKit
import iProgressHUD

class LoginVC: UIViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tfUserName: UITextField!{
        didSet{
            tfUserName.delegate = self
        }
    }
    @IBOutlet weak var tfPassword: UITextField!{
        didSet{
            tfPassword.delegate = self
        }
    }
    @IBOutlet weak var btnRememberMe: UIButton!
    
    
    //MARK: - Varaiables
    var isRemember = false
    let loginViewModel = LoginViewModel.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setViewWillAppearData()
    }
    
    //MARK: - @IBAction
    @IBAction func btnActRemeberMe(_ sender: UIButton) {
//        isRemember = !isRemember
//        sender.setImage(UIImage(named: isRemember ? "checked_checkbox" : "unchecked_checkbox"), for: .normal)
        self.setRemeberMeButton()
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        let userName = tfUserName.text ?? ""
        let tfPassword = tfPassword.text ?? ""
        if userName.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            CommonFunctions.toster("PTS Dictate", titleDesc: "User name should not be empty")
            tfUserName.shake()
        }else if tfPassword.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster("PTS Dictate", titleDesc: "Password should not be empty")
            self.tfPassword.shake()
        }else {
            loginViewModel.LoginApiHit(userName: userName, password: tfPassword)
        }
    }
    
    @IBAction func remeberMeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}


//MARK: - SetUpUI
extension LoginVC{
    
    func setViewWillAppearData(){
        self.tfPassword.isSecureTextEntry = true
        CoreData.shared.getdata()
        if CoreData.shared.isRemeberMe{
            self.setRemeberMeButton()
            self.tfPassword.text = CoreData.shared.password
            self.tfUserName.text = CoreData.shared.userName
        }
            
        self.setCrossBtn(tfs: [self.tfPassword, self.tfUserName])

    }
    
    func setCrossBtn(tfs : [UITextField]){
        for tf in tfs{
            if let clearButton = tf.value(forKeyPath: "_clearButton") as? UIButton {
                clearButton.setImage(UIImage(named:"multiply.circle.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    func setUpUI(){
        
        self.title = "PTS Dictate"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.appThemeColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationController?.addCustomBottomLine(color: .black, height: 2.0)
        
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1.0
        
        self.hideKeyboardWhenTappedAround()
        
        self.loginViewModel.loginViewController = self
    }
    
    func setRemeberMeButton(){
        isRemember = !isRemember
        btnRememberMe.setImage(UIImage(named: isRemember ? "checked_checkbox" : "unchecked_checkbox"), for: .normal)
    }
}

//MARK: - UITextField Delegete Methods
extension LoginVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case tfUserName:
            tfPassword.becomeFirstResponder()
        case tfPassword:
            tfPassword.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField{
        case tfPassword:
            self.tfPassword.text = ""
        case tfUserName:
            self.tfUserName.text = ""
        default:
            break
        }
        return true
    }
}
