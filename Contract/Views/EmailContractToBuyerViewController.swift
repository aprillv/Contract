//
//  EmailContractToBuyerViewController.swift
//  Contract
//
//  Created by April on 6/18/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
    protocol EmailContractToBuyerViewControllerDelegate
    {
        func GoToSendEmailToBuyer(msg msg: String, hasbuyer1: Bool, hasbuyer2: Bool)
        
    }


    class EmailContractToBuyerViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
        
        var contractInfo : ContractSignature?
        @IBOutlet var buyer1Btn: UIButton!
        @IBOutlet var buyer2Btn: UIButton!
        @IBOutlet var buyer1Email: UILabel!
        @IBOutlet var buyer2Email: UILabel!
        
        
        
       var delegate : EmailContractToBuyerViewControllerDelegate?
        
        var xtitle: String?
        var xtitle2: String?
        var xto: String?
        var xemailList: [String]?
        var xemailcc: String?
        var emailccs: String?
        var xdes : String?
        
        @IBOutlet var b1: UIView!{
            didSet{
                b1.layer.cornerRadius = 5.0
                //            bview.layer.borderWidth = 1.0
                //            bview.layer.borderColor = UIColor.lightGrayColor().CGColor
            }
        }
        @IBOutlet var bview: UIView!{
            didSet{
                bview.layer.cornerRadius = 5.0
                //            bview.layer.borderWidth = 1.0
                //            bview.layer.borderColor = UIColor.lightGrayColor().CGColor
            }
        }
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            self.title = "Print"
            view.superview?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            //        view.superview?.bounds = CGRect(x: 0, y: 0, width: tableview.frame.width, height: 44 * CGFloat(5))
        }
        @IBOutlet var xtitlelbl: UILabel!{
            didSet{
                xtitlelbl.textColor = UIColor.whiteColor()
            }
        }
       
        //    @IBOutlet var toEmail: UITextField!
        @IBOutlet var desView: UITextView!{
            didSet{
                desView.delegate = self
                desView.layer.cornerRadius = 5.0
                desView.layer.borderWidth = 1.0/(UIScreen().scale)
                desView.layer.borderColor = UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1).CGColor
            }
        }
        @IBOutlet var submitBtn: UIButton!{
            didSet{
                submitBtn.layer.cornerRadius = 5.0
                //            submitBtn.layer.borderWidth = 1.0
                //            desView.layer.borderColor = UIColor.lightGrayColor().CGColor
            }
        }
        @IBOutlet var lineHeight: NSLayoutConstraint!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if let info = self.contractInfo {
//                print(info.bemail1, info.bemail2)
                self.buyer1Email.text = (info.client ?? "") + " (" + (info.bemail1 ?? "") + ")"
                if info.client2 ?? "" != "" {
                    if info.buyer1SignFinishedyn != 1 && info.buyer2SignFinishedyn != 1 && (info.verify_code == "" && info.verify_code2 == "") {
                        if info.bemail2 != "" {
                            self.buyer2Email.text = (info.client2 ?? "") + " (" + (info.bemail2 ?? "") + ")"
                        }else{
                            self.buyer2Email.text = (info.client2 ?? "") + " (" + (info.bemail1 ?? "") + ")"
                        }
                    }else if (info.buyer1SignFinishedyn == 1 || info.verify_code != "") {
                        if info.bemail2 != "" {
                            self.buyer1Email.text = (info.client2 ?? "") + " (" + (info.bemail2 ?? "") + ")"
                        }else{
                            self.buyer1Email.text = (info.client2 ?? "") + " (" + (info.bemail1 ?? "") + ")"
                        }
                        self.topDistance.constant = 11
                        self.buyer2Email.hidden  = true
                        self.buyer2Btn.hidden = true
                        self.view.updateConstraints()
                    }else if (info.buyer2SignFinishedyn == 1 || info.verify_code2 != ""){
                        self.topDistance.constant = 11
                        self.buyer2Email.hidden  = true
                        self.buyer2Btn.hidden = true
                        self.view.updateConstraints()
                    }
                    
                    
                }else{
                self.topDistance.constant = 11
                    self.buyer2Email.hidden  = true
                    self.buyer2Btn.hidden = true
                    self.view.updateConstraints()
                }
                
                desView.text = "Your online contract is ready!"
                
            }
           
            
            
            
            
            
            lineHeight.constant = 1.0 / (UIScreen().scale)
            view.updateConstraintsIfNeeded()
            
        }
        
        
        @IBAction func showDropList(sender: AnyObject) {
            self.desView.resignFirstResponder()
            let ct = emailListTbView.frame
            //        var ct2 = emailListTbView.frame
            //        ct2.height = 0.0
            emailListTbView.frame = CGRect(x: ct.origin.x, y: ct.origin.y, width: ct.width, height: 0)
            emailListTbView.hidden = false
            
            UIView.animateWithDuration(0.4, animations: {
                self.emailListTbView.frame = CGRect(x: ct.origin.x, y: ct.origin.y, width: ct.width, height: CGFloat(33 * (self.xemailList?.count ?? 0)))
            }) { (_) in
                
            }
            
            
        }
        
        @IBOutlet var emailListTbView: UITableView!{
            didSet{
                emailListTbView.layer.cornerRadius = 5.0
                emailListTbView.layer.borderWidth = 1.0/(UIScreen().scale)
                emailListTbView.layer.borderColor = UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1).CGColor
                
            }
        }
        
        @IBAction func close(sender: UIButton) {
            self.dismissViewControllerAnimated(true) {
                
            }
        }
        @IBAction func doSubmit(sender: UIButton) {
//            print(self.buyer1Email.text, self.buyer2Email.text)
//            return
            var a = self.buyer1Btn.tag == 1
            var b = self.buyer2Btn.tag == 1
            
            if self.buyer1Email.text!.hasPrefix((self.contractInfo?.client ?? "  ") + " (") {
                if self.contractInfo?.client2 == nil || self.contractInfo?.client2 == "" || self.contractInfo?.buyer2SignFinishedyn == 1 {
                    b = false
                }
//                if (self.contractInfo?.buyer1SignFinishedyn == 1){
//                    b = a
//                    a = false
//                }
                if self.buyer2Btn.hidden {
                    b = false
                }
            }else {
                b = a
                a = false
                
            }
//            print(self.buyer1Btn.hidden, self.buyer2Btn.hidden)
//            if (self.contractInfo?.buyer1SignFinishedyn == 1 || self.contractInfo?.verify_code2 != ""){
//                b = a
//                a = false
//            }
            
//            var a = !self.buyer1Btn.hidden
//            var b = !self.buyer2Btn.hidden
//            print(self.buyer1Btn.hidden, self.buyer2Btn.hidden)
            
            
            if !a && !b {
                return
            }
            
            self.dismissViewControllerAnimated(true) {
                if self.delegate != nil {
                    
                    
                    self.delegate?.GoToSendEmailToBuyer(msg: self.desView.text, hasbuyer1: a, hasbuyer2: b)
                    
                }
            }
            
        }
        
        override var preferredContentSize: CGSize {
            
            get {
                return CGSize(width: 500, height: 340)
            }
            set { super.preferredContentSize = newValue }
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return xemailList?.count ?? 0
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("emailCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = xemailList![indexPath.row]
            
            //        cell.textLabel?.textColor = UIColor.blackColor()
            
            return cell
        }
        
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 33
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            let ct = emailListTbView.frame
            
            UIView.animateWithDuration(0.4, animations: {
                self.emailListTbView.frame = CGRect(x: ct.origin.x, y: ct.origin.y, width: ct.width, height: 0)
            }) { (_) in
                self.emailListTbView.hidden = true
                self.emailListTbView.frame = ct
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
            
            //        btnEmail.setTitle("   \(xemailList![indexPath.row])", forState: UIControlState.Normal)
        }
        
        @IBOutlet var hightConstraints: NSLayoutConstraint!
        
        
        @IBOutlet var hight2: NSLayoutConstraint!{
            didSet{
                hight2.active = false
            }
        }
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            //        [[NSNotificationCenter defaultCenter] addObserver:self
            //            selector:@selector(myKeyboardWillHideHandler:)
            //        name:UIKeyboardWillHideNotification
            //        object:nil];
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(myKeyboardWillHideHandler(_:)), name: UIKeyboardWillHideNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(myKeyboardWillShowHandler(_:)), name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrientationchangedHandler(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
        }
        
        override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
            //        [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
            
        }
        func OrientationchangedHandler(orientation : UIInterfaceOrientation)  {
            
            self.changeHeight()
            
            
        }
        
        private func changeHeight(){
            if desView.isFirstResponder() {
                //        print(max(self.view.frame.size.width, self.view.frame.size.height))
                //        if max(self.view.frame.size.width, self.view.frame.size.height) <= 1024 {
                let orientation = UIApplication.sharedApplication().statusBarOrientation
                if orientation == .LandscapeLeft || orientation == .LandscapeRight{
                    hightConstraints.active = false
                    hight2?.active = true
                    self.view.updateConstraintsIfNeeded()
                }else{
                    hightConstraints.active = true
                    hight2?.active = false
                    self.view.updateConstraintsIfNeeded()
                }
                //        }
            }
            
            
        }
        func myKeyboardWillShowHandler(noti : NSNotification) {
            changeHeight()
        }
        func myKeyboardWillHideHandler(noti : NSNotification) {
            hightConstraints.active = true
            hight2?.active = false
            self.view.updateConstraintsIfNeeded()
        }
        func textViewDidBeginEditing(textView: UITextView) {
            changeHeight()
        }
        
        @IBOutlet var topDistance: NSLayoutConstraint!
        @IBAction func buyer1Changed(sender: UIButton) {
            if sender.tag == 0 {
                sender.setImage(UIImage(named: "checked"), forState: .Normal)
            }else{
                sender.setImage(UIImage(named: "check"), forState: .Normal)
            }
            sender.tag = 1 - sender.tag
            
//            if !buyer2Btn.hidden && sender.tag == 1 {
//                if sender != buyer1Btn {
//                    buyer1Btn.tag = 0
//                    buyer1Btn.setImage(UIImage(named: "check"), forState: .Normal)
//                }else if sender != buyer2Btn {
//                    buyer2Btn.tag = 0
//                    buyer2Btn.setImage(UIImage(named: "check"), forState: .Normal)
//                }
//            }
            
        }
                
}
