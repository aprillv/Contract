//
//  SubmitForApproveViewController.swift
//  Contract
//
//  Created by April on 4/27/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
protocol SubmitForApproveViewControllerDelegate
{
    func GoToSubmit(email: String, emailcc: String, msg: String)
}
class SubmitForApproveViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    
    var delegate : SubmitForApproveViewControllerDelegate?
    
    var xtitle: String?
    var xtitle2: String?
    var xto: String?
    var xemailList: [String]?
    
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
    @IBOutlet var xtitlelbl2: UILabel!
    @IBOutlet var toEmail: UITextField!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xtitlelbl.text = xtitle ?? ""
        xtitlelbl2.text = xtitle2 ?? ""
        desView.text = xdes ?? ""
        
        var h: String = ""
        if let x = xemailList?.first {
            if x.containsString(";") {
                let a = x.componentsSeparatedByString(";")
//                toEmail.text = a[0]
                h = a[0]
//                btnEmail.setTitle(a[0], forState: UIControlState.Normal)
                emailccs = a[1]
            }else{
//                toEmail.text = xemailList![0]
                h = x
                
                emailccs = ""
            }
        }
        btnEmail.setTitle("   \(h)", forState: UIControlState.Normal)
        xemailList![0] = h
//        xemailList?.append("April(xiujun_85@163.com)")
        emailListTbView.reloadData()
        
        
    }
    
    @IBOutlet var btnEmail: UIButton!
    @IBAction func showDropList(sender: AnyObject) {
        if self.desView.isFirstResponder() {
        self.desView.resignFirstResponder()
            self.performSelector(#selector(showDrowlist2), withObject: nil, afterDelay: 0.2)
        }else{
            showDrowlist2()
        }
    
        
        
        
    }
    
    func showDrowlist2()  {
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
        self.dismissViewControllerAnimated(true) {
            if self.delegate != nil {
                if let x = self.btnEmail.currentTitle {
                 self.delegate?.GoToSubmit(x, emailcc: self.emailccs!, msg: self.desView.text ?? "")
                }
                
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
        
        btnEmail.setTitle(xemailList![indexPath.row], forState: UIControlState.Normal)
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
         let ct = emailListTbView.frame
        UIView.animateWithDuration(0.4, animations: {
            self.emailListTbView.frame = CGRect(x: ct.origin.x, y: ct.origin.y, width: ct.width, height: 0)
        }) { (_) in
            self.emailListTbView.hidden = true
            self.emailListTbView.frame = ct
        }
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
    
    
    
}