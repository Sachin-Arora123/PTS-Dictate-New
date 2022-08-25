//
//  ViewController.swift
//  PTS Dictate
//
//  Created by Sachin on 23/08/22.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    //MARK: - @IBAction
    @IBAction func btnActRemeberMe(_ sender: UIButton) {
        isRemember = !isRemember
        sender.setImage(UIImage(named: isRemember ? "checked_checkbox" : "unchecked_checkbox"), for: .normal)
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        let vc = TabbarVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func remeberMeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}


//MARK: - SetUpUI
extension LoginVC{
    func setUpUI(){
        
        self.title = "PTS Dictate"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.appThemeColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationController?.addCustomBottomLine(color: .black, height: 2.0)
        
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1.0
        
        self.hideKeyboardWhenTappedAround()
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
}
