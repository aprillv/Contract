//
//  SpringDaleOperationsViewController.swift
//  Contract
//
//  Created by April Lv on 3/7/18.
//  Copyright © 2018 HapApp. All rights reserved.
//

import UIKit

protocol SpringDaleOperationsDelegate
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


class SpringDaleOperationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var contractInfo : ContractSpringDaleInfo?
    
    @IBOutlet weak var tableView: UITableView!
    var delegate1 : DoOperationDelegate?
    var showSave : Bool?
    var showStartOver: Bool?
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
    
    
    fileprivate struct constants{
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
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userinfo = UserDefaults.standard
        if showStartOver == nil {
            showStartOver = true
        }
        if userinfo.bool(forKey: CConstants.UserInfoIsContract){
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
//                                    itemList?.append(constants.operationEmailToBuyer)
                                    
                                    //                                    itemList?.append(constants.operationGoToSign)
                                    
                                }else if info.verify_code != "" && info.verify_code2 == ""{
                                    itemList?.append(constants.operationSavetoServer)
                                    itemList?.append(constants.operationStartOver)
                                    itemList?.append(constants.operationSubmitBuyer2)
                                    itemList?.append(constants.operationAttatchPhoto)
                                    itemList?.append(constants.operationChangebuyer1ToIpad)
//                                    itemList?.append(constants.operationEmailToBuyer)
                                    
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
//                                    itemList?.append(constants.operationEmailToBuyer)
                                    
                                    
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
//                                    itemList?.append(constants.operationEmailToBuyer)
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
                                if let i = itemList!.index(of: constants.operationEmailToBuyer){
                                    itemList?.remove(at: i)}
                            }
//                            itemList?.append(constants.operationEmailToBuyer)
                        }
                        
                        
                    }
                }
            }
            
            
        }else{
            if userinfo.integer(forKey: "ClearDraftInfo") == 0 {
                itemList = [constants.operationEmail, constants.operationClearDraftInfo]
            }else {
                itemList = [constants.operationEmail, constants.operationFillDraftInfo]
            }
        }
        if itemList?.contains(constants.operationSubmit) ?? false {
            if let i1 = itemList?.index(of: constants.operationSubmitBuyer1){
                itemList?.remove(at: i1)
            }
            if let i2 = itemList?.index(of: constants.operationSubmitBuyer2){
                itemList?.remove(at: i2)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return constants.rowHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.cellReuseIdentifier, for: indexPath)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.text = itemList![indexPath.row]
        if (cell.textLabel?.text == constants.operationStartOver ) {
            if (!showStartOver!){
                cell.textLabel?.textColor = UIColor.darkGray
            }else{
                cell.textLabel?.textColor = UIColor.black
            }
        }else if(cell.textLabel?.text == constants.operationSavetoServer){
            if (!showSave!){
                cell.textLabel?.textColor = UIColor.darkGray
            }else{
                cell.textLabel?.textColor = UIColor.black
            }
        }
        
        if (cell.textLabel?.text == constants.operationSubmit || cell.textLabel?.text == constants.operationSaveFinish || cell.textLabel?.text == constants.operationSaveEmail) {
            if (!showSubmit!) {
                cell.textLabel?.textColor = UIColor.darkGray
            }else{
                cell.textLabel?.textColor = UIColor.black
            }
        }
        cell.accessoryType = .none
        if cell.textLabel?.text == constants.operationAttatchPhoto{
            if let c = self.hasCheckedPhoto {
                if c == "1" {
                    cell.accessoryView = UIImageView(image: UIImage(named: "check3"))
                }
            }
        }else if cell.textLabel?.text == constants.operationSubmitBuyer1Finished || cell.textLabel?.text == constants.operationSubmitBuyer2Finished{
            //            cell.accessoryView = UIImageView(image: UIImage(named: "check3"))
            cell.textLabel?.textColor = UIColor.darkGray
        }
        
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true){
            if let delegate0 = self.delegate1{
                switch self.itemList![indexPath.row]{
                case constants.operationSavetoServer:
                    if self.showSave! {
                        delegate0.saveToServer()
                    }
                    //                    case constants.operationPrint:
                //                        delegate0.doPrint()
                case constants.operationEmail:
                    let userinfo = UserDefaults.standard
                    if userinfo.bool(forKey: CConstants.UserInfoIsContract){
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
                    if self.showStartOver! {
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


