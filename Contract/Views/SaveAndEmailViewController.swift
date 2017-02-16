//
//  SaveAndEmailViewController.swift
//  Contract
//
//  Created by April on 5/5/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
protocol SaveAndEmailViewControllerDelegate
{
    func GoToEmailSubmit(email: String, emailcc: String, msg: String)
    func ClearEmailData()
}
class SaveAndEmailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    
    @IBOutlet var txtEmailcc: UITextField!
    var delegate : SaveAndEmailViewControllerDelegate?
    
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
    @IBOutlet var toEmail: UITextView!
    @IBOutlet var xtitlelbl2: UILabel!
    @IBOutlet var toCC: UITextField!
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
        
        xtitlelbl.text = xtitle ?? ""
        xtitlelbl2.text = xtitle2 ?? ""
        desView.text = xdes ?? ""
        
        var h: String = ""
        if xemailList!.count > 0 {
            h = xemailList!.filter({$0 != ""}).joinWithSeparator(", ")
        }
//        toEmail.number
        toEmail.text = h
//        txtEmailcc.text = xemailcc ?? ""
        txtEmailcc.text = ""
        
        
//        btnEmail.setTitle("   \(h)", forState: UIControlState.Normal)
        xemailList![0] = h
        //        xemailList?.append("April(xiujun_85@163.com)")
//        emailListTbView.reloadData()
        
        
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
            if let d = self.delegate {
                d.ClearEmailData()
            }
        }
    }
    @IBAction func doSubmit(sender: UIButton) {
        self.dismissViewControllerAnimated(true) {
            if self.delegate != nil {
                if let x = self.toEmail.text {
                    self.delegate?.GoToEmailSubmit(x, emailcc: self.txtEmailcc.text ?? " ", msg: self.desView.text ?? " ")
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
    
    
    
}