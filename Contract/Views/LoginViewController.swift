//
//  LoginViewController.swift
//  Contract
//
//  Created by April on 11/18/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Foundation

class LoginViewController: BaseViewController, UITextFieldDelegate {

    
    @IBOutlet var btnhowto: UIButton!
    @IBAction func openhowtouse() {
        if let url = URL(string: "http://www.buildersaccess.com/iphone/signcontract.pdf") {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    @IBOutlet var copyrightLbl: UIBarButtonItem!{
        didSet{
            let currentDate = Date()
            let usDateFormat = DateFormatter()
            usDateFormat.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale(identifier: "en-US"))
            
            copyrightLbl.title = "Copyright © " + usDateFormat.string(from: currentDate) + " All Rights Reserved"
        }
    }
    // MARK: - Page constants
    fileprivate struct constants{
        static let PasswordEmptyMsg : String = "Password Required."
        static let EmailEmptyMsg :  String = "Email Required."
        static let WrongEmailOrPwdMsg :  String = "Email or password is incorrect."
        
    }
    
    
    
    // MARK: Outlets
    @IBOutlet weak var emailTxt: UITextField!{
        didSet{
            emailTxt.returnKeyType = .next
            emailTxt.delegate = self
            let userInfo = UserDefaults.standard
            emailTxt.text = userInfo.object(forKey: CConstants.UserInfoEmail) as? String
        }
    }
    @IBOutlet weak var passwordTxt: UITextField!{
        didSet{
            passwordTxt.returnKeyType = .go
            passwordTxt.enablesReturnKeyAutomatically = true
            passwordTxt.delegate = self
            let userInfo = UserDefaults.standard
            if let isRemembered = userInfo.object(forKey: CConstants.UserInfoRememberMe) as? Bool{
                if isRemembered {
                    passwordTxt.text = userInfo.object(forKey: CConstants.UserInfoPwd) as? String
                }
                
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         setSignInBtn()
//        1298.943376
    }
//    func textFieldDidEndEditing(textField: UITextField) {
//        setSignInBtn()
//    }
    
    
    @IBOutlet weak var rememberMeSwitch: UISwitch!{
        didSet {
            rememberMeSwitch.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            let userInfo = UserDefaults.standard
            if let isRemembered = userInfo.object(forKey: CConstants.UserInfoRememberMe) as? Bool{
                rememberMeSwitch.isOn = isRemembered
            }else{
                rememberMeSwitch.isOn = true
            }
        }
    }
    
    @IBOutlet weak var backView: UIView!{
        didSet{
//            backView.backgroundColor = UIColor.whiteColor()
            backView.layer.borderColor = CConstants.BorderColor.cgColor
            backView.layer.borderWidth = 1.0
//            backView.layer.cornerRadius = 8
            backView.layer.shadowColor = UIColor.lightGray.cgColor
            backView.layer.shadowOpacity = 1
            backView.layer.shadowRadius = 8.0
            backView.layer.shadowOffset = CGSize(width: -0.5, height: 0.0)
            
        }
    }
    
    
    @IBOutlet var printDraft: UIButton!{
        didSet{
            printDraft.layer.cornerRadius = 5.0
            printDraft.titleLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
        }
    }
    @IBOutlet weak var signInBtn: UIButton!
        {
        didSet{
            signInBtn.layer.cornerRadius = 5.0
            signInBtn.titleLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
        }
    }
    
    
    // MARK: UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case emailTxt:
            passwordTxt.becomeFirstResponder()
        case passwordTxt:
            Login(signInBtn)
        default:
            break
        }
        return true
    }
    
    @IBAction func textChanaged() {
        setSignInBtn()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        setSignInBtn()
        return true
    }
    
    fileprivate func setSignInBtn(){
        signInBtn.isEnabled = !self.IsNilOrEmpty(passwordTxt.text)
            && !self.IsNilOrEmpty(emailTxt.text)
    }
    
    
    // MARK: Outlet Action
    @IBAction func rememberChanged(_ sender: UISwitch) {
        let userInfo = UserDefaults.standard
        userInfo.set(rememberMeSwitch.isOn, forKey: CConstants.UserInfoRememberMe)
        if !rememberMeSwitch.isOn {
            userInfo.set("", forKey: CConstants.UserInfoPwd)
        }
    }
    
    
    func checkUpate(_ sender: UIButton){
        let version = Bundle.main.infoDictionary?["CFBundleVersion"]
        let parameter = ["version": "\((version == nil ?  "" : version!))"]
        Alamofire.request(
            CConstants.ServerURL + CConstants.CheckUpdateServiceURL, method: .post,
            parameters: parameter).responseJSON{ (response) -> Void in
            if response.result.isSuccess {
                if let rtnValue = response.result.value as? NSNumber{
                    if rtnValue.intValue == 1 {
                        self.disAblePageControl()
                        self.doLogin(sender)
                    }else{
                        if let url = URL(string: CConstants.InstallAppLink){
                            self.toEablePageControl()
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                                // Fallback on earlier versions
                            }
                        }else{
                        }
                    }
                }else{
//                    self.doLogin()
                }
            }else{
//                self.doLogin()
            }
        }
        //     NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    
    @IBAction func PrintDraft(_ sender: UIButton) {
        checkUpate(sender)
    }
    
    @IBAction func Login(_ sender: UIButton) {
        checkUpate(sender)
        
    }
    
    fileprivate func disAblePageControl(){
        
        //        signInBtn.hidden = true
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
//        emailTxt.enabled = false
//        passwordTxt.enabled = false
//        
//        rememberMeSwitch.enabled = false
//        emailTxt.textColor = UIColor.darkGrayColor()
//        passwordTxt.textColor = UIColor.darkGrayColor()
        //        spinner.startAnimating()
//        if (spinner == nil){
//            spinner = UIActivityIndicatorView(frame: CGRect(x: 20, y: 4, width: 50, height: 50))
//            spinner?.hidesWhenStopped = true
//            spinner?.activityIndicatorViewStyle = .Gray
//        }
//        
//        progressBar = UIAlertController(title: nil, message: CConstants.LoginingMsg, preferredStyle: .Alert)
//        progressBar?.view.addSubview(spinner!)
//        spinner?.startAnimating()
//        self.presentViewController(progressBar!, animated: true, completion: nil)
//    self.noticeOnlyText(CConstants.LoginingMsg)
        
    }
    
   
    
    fileprivate func doLogin(_ sender: UIButton){
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        
        let email = emailTxt.text
        let password = passwordTxt.text
//        print(password, MD5(str: password!))
        
        if IsNilOrEmpty(email) {
            self.toEablePageControl()
            self.PopMsgWithJustOK(msg: constants.EmailEmptyMsg, txtField: emailTxt)
        }else{
            if IsNilOrEmpty(password) {
                self.toEablePageControl()
                self.PopMsgWithJustOK(msg: constants.PasswordEmptyMsg, txtField: passwordTxt)
            }else {
                // do login
                
                //                self.view.userInteractionEnabled = false
                
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeAnnularDeterminate;
//                hud.labelText = @"Loading";
//                [self doSomethingInBackgroundWithProgressCallback:^(float progress) {
//                    hud.progress = progress;
//                    } completionCallback:^{
//                    [hud hide:YES];
//                    }];
                
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//                hud.mode = .AnnularDeterminate
                hud?.labelText = CConstants.LoginingMsg
                
                
                let loginUserInfo = LoginUser(email: email!, password: password!, iscontract:  sender.currentTitle!.hasPrefix("Sign") ? "1" : "0")
                
                let a = loginUserInfo.DictionaryFromObject()
                print(a, CConstants.ServerURL + CConstants.LoginServiceURL)
                
                
                
                Alamofire.request(CConstants.ServerURL + CConstants.LoginServiceURL, method: .post, parameters: a).responseJSON{ (response) -> Void in
//                    self.clearNotice()
                    hud?.hide(true)
//                    self.progressBar?.dismissViewControllerAnimated(true){ () -> Void in
//                        self.spinner?.stopAnimating()
                        if response.result.isSuccess {
//                            print(response.result.value)
                            if let rtnValue = response.result.value as? [String: AnyObject]{
                                let rtn = Contract(dicInfo: rtnValue)
                                
                                
                                self.toEablePageControl()
                                
                                if rtn.activeyn == 1{
                                    let userinfo = UserDefaults.standard
                                    userinfo.set(true, forKey: CConstants.UserInfoIsContract)
                                    userinfo.set(rtn.username, forKey: CConstants.UserInfoName)
                                    self.saveEmailAndPwdToDisk(email: email!, password: password!)
                                    self.loginResult = rtn
                                    self.performSegue(withIdentifier:  CConstants.SegueToAddressList, sender: sender)
                                }else{
                                    self.PopMsgValidationWithJustOK(msg: constants.WrongEmailOrPwdMsg, txtField: nil)
                                }
                            }else{
                                self.toEablePageControl()
                                self.PopServerError()
                            }
                        }else{
                            self.toEablePageControl()
                            self.PopNetworkError()
                        }
                    }
                
            }
        }
    }
   fileprivate func toEablePageControl(){
//    self.view.userInteractionEnabled = true
//    self.signInBtn.hidden = false
//    self.emailTxt.enabled = true
//    self.passwordTxt.enabled = true
//    self.rememberMeSwitch.enabled = true
//    self.emailTxt.textColor = UIColor.blackColor()
//    self.passwordTxt.textColor = UIColor.blackColor()
//    self.spinner?.stopAnimating()
    }
    
    func saveEmailAndPwdToDisk(email: String, password: String){
        let userInfo = UserDefaults.standard
        if rememberMeSwitch.isOn {
            userInfo.set(true, forKey: CConstants.UserInfoRememberMe)
        }else{
            userInfo.set(false, forKey: CConstants.UserInfoRememberMe)
        }
        userInfo.set(email, forKey: CConstants.UserInfoEmail)
        userInfo.set(password, forKey: CConstants.UserInfoPwd)
    }
    
    
    // MARK: PrepareForSegue
    fileprivate var loginResult : Contract?{
        didSet{
            if loginResult != nil{
                let userInfo = UserDefaults.standard
                userInfo.set(loginResult!.username, forKey: CConstants.LoggedUserNameKey)
//                 userInfo.setObject("Roberto Test", forKey: CConstants.LoggedUserNameKey)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                case CConstants.SegueToAddressList:
                    if let addressListView = segue.destination as? AddressListViewController{
                        if let a = sender as? UIButton {
                            addressListView.tableTag = a.currentTitle!.hasPrefix("Sign") ? 2 : 1
                        }
                        addressListView.AddressListOrigin = loginResult?.contracts
                    }
                break
            default:
                break
            }
        }
        
    }
    
    
//    func removeHud() {
//        HUDD?.hide(<#T##animated: Bool##Bool#>, afterDelay: <#T##NSTimeInterval#>)
//    }
//    
//    var HUDD : MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(view.frame.size)
//        checkUpate()
        let userInfo = UserDefaults.standard
        if !(userInfo.bool(forKey: "havealerthowtouse") ?? false) {
        if let f = UIFont(name: CConstants.ApplicationBarFontName, size: 22.0) {
            self.btnhowto.titleLabel?.font = f
//            self.btnhowto.titleLabel?.text = "How to use this app"
//            self.btnhowto.font
        }
        
//            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            //                hud.mode = .AnnularDeterminate
//            hud.labelText = "If you have question of how to use this app, \n please click the right bottom corner \nlink 'How to Use'"
//            hud.mode = .Text
////            HUDD = hud
//        hud.hide(true, afterDelay: 2)
//            self.performSelector(#selec, withObject: <#T##AnyObject?#>, afterDelay: <#T##NSTimeInterval#>)
//            self.performSelector(#selector(removeHud), withObject: nil, afterDelay: 1)
//            self.PopMsgWithJustOK(msg: "You can click the bottom right corner link 'How to Use this app' when you have problem with using this app", txtField: nil)
            userInfo.set(true, forKey: "havealerthowtouse")
        }else{
            if let f = UIFont(name: CConstants.ApplicationBarFontName, size: 16.0) {
                self.btnhowto.titleLabel?.font = f
                //            self.btnhowto.titleLabel?.text = "How to use this app"
                //            self.btnhowto.font
            }
        }
        setSignInBtn()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = CConstants.ApplicationColor
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName : UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarFontSize)!
            
        ]
        self.navigationController?.toolbar.barTintColor = CConstants.ApplicationColor
        self.navigationController?.toolbar.barStyle = .black
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
