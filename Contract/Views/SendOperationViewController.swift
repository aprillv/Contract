//
//  SendOperationViewController.swift
//  Contract
//
//  Created by April on 12/22/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

protocol DoOperationDelegate
{
    func saveToServer()
    func doPrint()
    func sendEmail()
    func sendEmail2()
    func clearDraftInfo()
    func fillDraftInfo()
    func save_Email()
    func startover()
    func submit()
    func saveFinish()
    func saveEmail()
    func attachPhoto()
    func viewAttachPhoto()
    func emailContractToBuyer()
    
    func submitBuyer1Sign()
    func submitBuyer2Sign()
    
    func changeBuyre1ToIPadSign()
    func changeBuyre2ToIPadSign()
    
    func gotoBuyer1Sign()
    func gotoBuyer2Sign()
    func gotoSellerSign()
}


class SendOperationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var contractInfo : ContractSignature?
//        {
//        didSet{
//        print(contractInfo?.verify_code, contractInfo?.verify_code2, contractInfo?.buyer1SignFinishedyn, contractInfo?.buyer2SignFinishedyn)
//        }
//    }
    
    @IBOutlet weak var tableView: UITableView!
    var delegate1 : DoOperationDelegate?
    var showSave : Bool?
    var FromWebSide : Bool?
    var showSubmit : Bool?
    var isapproved : Bool?
    var justShowEmail : Bool?
    var hasCheckedPhoto : String?
    
    var showBuyer1GoToSign: Bool = false
    var showBuyer2GoToSign : Bool = false
    var showSellerGoToSign : Bool = false
    
    var itemList : [String]?{
        didSet{
            if let _ = itemList{
                tableView.reloadData()
            }
        }
    }
    
    
    private struct constants{
        static let cellReuseIdentifier = "operationCellIdentifier"
        static let rowHeight : CGFloat = 44
        static let operationSavetoServer = "Save Contract"
        static let operationSubmit = "Submit for Approve"
        static let operationStartOver = "Start Over"
        static let operationSaveFinish = "Save & Finish"
        static let operationSaveEmail = "Save & Email"
        static let operationEmail = "Email"
//        static let operationSaveEmail = "Save & Email"
        static let operationClearDraftInfo = "Clear Buyer's Fields"
        static let operationFillDraftInfo = "Fill Buyer's Fields"
        static let operationAttatchPhoto = "Attach Photo Check"
        static let operationViewAttatchPhoto = "View Photo Check"
        
        static let operationEmailToBuyer = "Email Contract to Buyers"
        
        static let operationSubmitBuyer1 = "Submit Buyer1's sign"
        static let operationSubmitBuyer1Finished = "Buyer1's sign Submitted"
        static let operationSubmitBuyer2 = "Submit Buyer2's sign"
        static let operationSubmitBuyer2Finished = "Buyer2's sign Submitted"
        
        static let operationChangebuyer1ToIpad = "Change Buyer1 to iPad Sign"
        static let operationChangebuyer2ToIpad = "Change Buyer2 to iPad Sign"
        
//        static let operationBuyerGoToSign = "Buyer Go To Sign"
//        static let operationBuyer1GoToSign = "Buyer1 Go To Sign"
//        static let operationBuyer2GoToSign = "Buyer2 Go To Sign"
//        static let operationSellerGoToSign = "Seller Go To Sign"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userinfo = NSUserDefaults.standardUserDefaults()
        if userinfo.boolForKey(CConstants.UserInfoIsContract){
            if justShowEmail! {
//            itemList = [constants.operationEmail, constants.operationViewAttatchPhoto]
                
                itemList = [constants.operationEmail]
            }else{
                if FromWebSide ?? false {
//                    itemList = [constants.operationSubmit, constants.operationAttatchPhoto]
                    if let info = self.contractInfo {
                        if info.buyer1SignFinishedyn == 1 && info.buyer2SignFinishedyn == 1 {
                            itemList = [constants.operationSubmit, constants.operationAttatchPhoto]
                            return
                        }
                        
                        if info.client2 == "" {
                            if info.ipadsignyn == 1 || info.buyer1SignFinishedyn == 1 {
                                itemList = [constants.operationSubmit, constants.operationAttatchPhoto]
                                return
                            }else{
                                itemList = [constants.operationChangebuyer1ToIpad, constants.operationAttatchPhoto]
                                return
                                
                            }
                        }else {
                            itemList = [String]()
                            if info.buyer1SignFinishedyn == 0 && info.buyer2SignFinishedyn == 0{
                                if info.verify_code != "" && info.verify_code2 != ""{
                                   itemList?.append(constants.operationChangebuyer1ToIpad)
                                    itemList?.append(constants.operationChangebuyer2ToIpad)
                                }else if info.verify_code == "" && info.verify_code2 != ""{
                                    itemList?.append(constants.operationSavetoServer)
                                    itemList?.append(constants.operationStartOver)
                                    itemList?.append(constants.operationSubmitBuyer1)
                                    itemList?.append(constants.operationAttatchPhoto)
                                    itemList?.append(constants.operationChangebuyer2ToIpad)
                                    itemList?.append(constants.operationEmailToBuyer)
                                    
//                                    itemList?.append(constants.operationGoToSign)
                                    
                                }else if info.verify_code != "" && info.verify_code2 == ""{
                                    itemList?.append(constants.operationSavetoServer)
                                    itemList?.append(constants.operationStartOver)
                                    itemList?.append(constants.operationSubmitBuyer2)
                                    itemList?.append(constants.operationAttatchPhoto)
                                    itemList?.append(constants.operationChangebuyer1ToIpad)
                                    itemList?.append(constants.operationEmailToBuyer)
                                    
//                                    itemList?.append(constants.operationGoToSign)
                                }
                                
                            }else if info.buyer1SignFinishedyn == 0 && info.buyer2SignFinishedyn == 1{
                                if info.verify_code != "" && info.verify_code2 != ""{
                                    itemList?.append(constants.operationSubmitBuyer2Finished)
                                    itemList?.append(constants.operationChangebuyer1ToIpad)
                                    
                                }else if info.verify_code == "" && info.verify_code2 != ""{
                                    itemList?.append(constants.operationSavetoServer)
                                    itemList?.append(constants.operationStartOver)
                                    itemList?.append(constants.operationSubmitBuyer1)
                                    itemList?.append(constants.operationSubmitBuyer2Finished)
                                    itemList?.append(constants.operationSubmit)
                                    itemList?.append(constants.operationAttatchPhoto)
                                    itemList?.append(constants.operationEmailToBuyer)
                                    
                                    
//                                    itemList?.append(constants.operationGoToSign)
                                    
                                }else if info.verify_code != "" && info.verify_code2 == ""{
                                    itemList?.append(constants.operationSubmitBuyer2Finished)
                                    itemList?.append(constants.operationChangebuyer1ToIpad)
                                }else if info.verify_code == "" && info.verify_code2 == ""{
                                    itemList?.append(constants.operationSavetoServer)
                                    itemList?.append(constants.operationStartOver)
//                                    itemList?.append(constants.operationSubmitBuyer1)
                                    itemList?.append(constants.operationSubmitBuyer2Finished)
                                    itemList?.append(constants.operationSubmit)
                                    itemList?.append(constants.operationAttatchPhoto)
                                    itemList?.append(constants.operationEmailToBuyer)
                                }
                            
                            }else if info.buyer1SignFinishedyn == 1 && info.buyer2SignFinishedyn == 0{
                                if info.verify_code != "" && info.verify_code2 != ""{
                                    itemList?.append(constants.operationSubmitBuyer1Finished)
                                    itemList?.append(constants.operationChangebuyer2ToIpad)
                                    
                                    
                                }else if info.verify_code == "" && info.verify_code2 != ""{
                                    itemList?.append(constants.operationSubmitBuyer1Finished)
                                    itemList?.append(constants.operationChangebuyer2ToIpad)
                                }else if info.verify_code != "" && info.verify_code2 == ""{
                                    
                                    itemList?.append(constants.operationSavetoServer)
                                    itemList?.append(constants.operationStartOver)
                                    itemList?.append(constants.operationSubmitBuyer1Finished)
                                    itemList?.append(constants.operationSubmitBuyer2)
                                    itemList?.append(constants.operationSubmit)
                                    itemList?.append(constants.operationAttatchPhoto)
                                    
//                                    itemList?.append(constants.operationGoToSign)
                                }else if info.verify_code == "" && info.verify_code2 == ""{
                                    
                                    itemList?.append(constants.operationSavetoServer)
                                    itemList?.append(constants.operationStartOver)
                                    itemList?.append(constants.operationSubmitBuyer1Finished)
//                                    itemList?.append(constants.operationSubmitBuyer2)
                                    itemList?.append(constants.operationSubmit)
                                    itemList?.append(constants.operationAttatchPhoto)
                                }
                            
                            }
                        }
                    
                    }
                }else{
                    if isapproved! {
//                        print(self.contractInfo?.approvedate)
                        if self.contractInfo?.approvedate == "" || (self.contractInfo?.approvedate ?? "1980").hasPrefix("1980"){
                            itemList = nil
                        }else{
                            itemList = [constants.operationSaveFinish, constants.operationSaveEmail, constants.operationStartOver]
                            
//                            itemList?.append(constants.operationGoToSign)
                        }
                        
                    }else{
                        if self.contractInfo?.buyer1SignFinishedyn == 1 && self.contractInfo?.buyer2SignFinishedyn == 1 {
                            itemList = [constants.operationSubmit]
                        }else{
                            itemList = [constants.operationSavetoServer, constants.operationSubmit, constants.operationEmailToBuyer]
                            
                        }
                        
                        var isshow = false
                        if let info = self.contractInfo {
                            if info.client2 != "" {
                                if self.contractInfo?.buyer1SignFinishedyn != 1 || self.contractInfo?.buyer2SignFinishedyn != 1 {
                                    isshow = true
                                    itemList?.append(constants.operationStartOver)
                                }
                            }else {
                                if self.contractInfo?.buyer1SignFinishedyn != 1{
                                    isshow = true
                                    itemList?.append(constants.operationStartOver)
                                }
                            }
                        }
                        
                        itemList?.append(constants.operationAttatchPhoto)
                        if isshow {
                            if self.contractInfo?.buyer1SignFinishedyn == 1 {
                                itemList?.append(constants.operationSubmitBuyer1Finished)
                            }else{
                                itemList?.append(constants.operationSubmitBuyer1)
                            }
                            if self.contractInfo?.buyer2SignFinishedyn == 1 {
                                itemList?.append(constants.operationSubmitBuyer2Finished)
                            }else{
                                itemList?.append(constants.operationSubmitBuyer2)
                            }
                            
                            if itemList!.contains(constants.operationEmailToBuyer){
                                if let i = itemList!.indexOf(constants.operationEmailToBuyer){
                                    itemList?.removeAtIndex(i)}
                            }
                            itemList?.append(constants.operationEmailToBuyer)
                        }
                        
//                        if (itemList ?? [String]()).contains(constants.operationSavetoServer) {
//                            
//                            itemList?.append(constants.operationGoToSign)
//                        }
                        
                        
                    }
                }
                
//                itemList?.append(constants.operationEmailToBuyer)
            }
            
            
//            if showBuyer1GoToSign {
//                if contractInfo?.client2 == "" {
//                    itemList?.append(constants.operationBuyerGoToSign)
//                }else{
//                    itemList?.append(constants.operationBuyer1GoToSign)
//                }
//            }
//            if showBuyer2GoToSign{
//                itemList?.append(constants.operationBuyer2GoToSign)
//            }
//            if showSellerGoToSign {
//                itemList?.append(constants.operationSellerGoToSign)
//            }
//            let user = (NSUserDefaults.standardUserDefaults().stringForKey(CConstants.UserInfoEmail) ?? "").lowercaseString
//            if !(user == CConstants.Administrator || user == "cindyl@lovetthomes.com") {
//                if let list = itemList {
//                    let nass = [constants.operationEmailToBuyer,
//                                constants.operationSubmitBuyer1 ,
//                                constants.operationSubmitBuyer1Finished,
//                                constants.operationSubmitBuyer2 ,
//                                constants.operationSubmitBuyer2Finished,
//                                constants.operationChangebuyer1ToIpad ,
//                                constants.operationChangebuyer2ToIpad ]
//                    var h = [String]()
//                    for i in list {
//                        if !nass.contains(i) {
//                            h.append(i)
//                        }
//                    }
//                    itemList = h 
//                }
//            }
            
            
        }else{
            if userinfo.integerForKey("ClearDraftInfo") == 0 {
                itemList = [constants.operationEmail, constants.operationClearDraftInfo]
            }else {
                itemList = [constants.operationEmail, constants.operationFillDraftInfo]
            }
        }
        if itemList?.contains(constants.operationSubmit) ?? false {
            if let i1 = itemList?.indexOf(constants.operationSubmitBuyer1){
                itemList?.removeAtIndex(i1)
            }
            if let i2 = itemList?.indexOf(constants.operationSubmitBuyer2){
                itemList?.removeAtIndex(i2)
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return constants.rowHeight
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellReuseIdentifier, forIndexPath: indexPath)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.text = itemList![indexPath.row]
        if (cell.textLabel?.text == constants.operationStartOver || cell.textLabel?.text == constants.operationSavetoServer) {
            if (!showSave!){
                cell.textLabel?.textColor = UIColor.darkGrayColor()
            }else{
                cell.textLabel?.textColor = UIColor.blackColor()
            }
        }
        
        if (cell.textLabel?.text == constants.operationSubmit || cell.textLabel?.text == constants.operationSaveFinish || cell.textLabel?.text == constants.operationSaveEmail) {
            if (!showSubmit!) {
                cell.textLabel?.textColor = UIColor.darkGrayColor()
            }else{
                cell.textLabel?.textColor = UIColor.blackColor()
            }
        }
        cell.accessoryType = .None
        if cell.textLabel?.text == constants.operationAttatchPhoto{
            if let c = self.hasCheckedPhoto {
                if c == "1" {
                    cell.accessoryView = UIImageView(image: UIImage(named: "check3"))
                }
            }
        }else if cell.textLabel?.text == constants.operationSubmitBuyer1Finished || cell.textLabel?.text == constants.operationSubmitBuyer2Finished{
//            cell.accessoryView = UIImageView(image: UIImage(named: "check3"))
            cell.textLabel?.textColor = UIColor.darkGrayColor()
        }
        
        cell.textLabel?.textAlignment = .Center
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true){
            if let delegate0 = self.delegate1{
                switch self.itemList![indexPath.row]{
                    case constants.operationSavetoServer:
                        if self.showSave! {
                            delegate0.saveToServer()
                        }
//                    case constants.operationPrint:
//                        delegate0.doPrint()
                    case constants.operationEmail:
                        let userinfo = NSUserDefaults.standardUserDefaults()
                        if userinfo.boolForKey(CConstants.UserInfoIsContract){
                            delegate0.sendEmail2()
                        }else{
                            delegate0.sendEmail()
                        }
                    
                case constants.operationFillDraftInfo:
                    delegate0.fillDraftInfo()
//                case constants.operationBuyerGoToSign,
//                     constants.operationBuyer1GoToSign:
//                    delegate0.gotoBuyer1Sign()
//                case constants.operationBuyer2GoToSign:
//                    delegate0.gotoBuyer2Sign()
//                case constants.operationSellerGoToSign:
//                    delegate0.gotoSellerSign()
                    
                case constants.operationClearDraftInfo:
                    delegate0.clearDraftInfo()
                case constants.operationStartOver:
                    if self.showSave! {
                        delegate0.startover()
                    }
                case constants.operationSubmit:
                    if self.showSubmit! {
                        delegate0.submit()
                    }
                case constants.operationSaveFinish:
                    if self.showSubmit! {
                        delegate0.saveFinish()
                    }
                case constants.operationSaveEmail:
                    if self.showSubmit! {
                        delegate0.saveEmail()
                    }
                case constants.operationAttatchPhoto:
                    delegate0.attachPhoto()
                case constants.operationViewAttatchPhoto:
                    delegate0.viewAttachPhoto()
                    
                  
                case constants.operationEmailToBuyer:
                    delegate0.emailContractToBuyer()
                case constants.operationSubmitBuyer1:
                    delegate0.submitBuyer1Sign()
                case constants.operationSubmitBuyer2:
                    delegate0.submitBuyer2Sign()
                case constants.operationChangebuyer1ToIpad:
                    delegate0.changeBuyre1ToIPadSign()
                case constants.operationChangebuyer2ToIpad:
                    delegate0.changeBuyre2ToIPadSign()
                    default:
                        break
                }
                
                
            }
        }
        
        
    }
    
    override var preferredContentSize: CGSize {
        get {
//            print(tableView.frame.width)
            return CGSize(width: tableView.frame.width
                , height: constants.rowHeight * CGFloat(itemList?.count ?? 1))
        }
        set { super.preferredContentSize = newValue }
    }
    
}
