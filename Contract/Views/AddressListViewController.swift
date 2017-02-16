//
//  AdressListViewController.swift
//  Contract
//
//  Created by April on 11/19/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AddressListViewController: UITableViewController, UISearchBarDelegate, ToDoPrintDelegate, FilterViewDelegate{
    @IBOutlet var viewHeight: NSLayoutConstraint!{
        didSet{
            viewHeight.constant = 1.0 / UIScreen.mainScreen().scale
        }
    }
    
    var tableTag: NSInteger?
    
    
    @IBOutlet var txtField: UITextField!{
        didSet{
            txtField.layer.cornerRadius = 5.0
            txtField.placeholder = "Search"
            txtField.clearButtonMode = .WhileEditing
            txtField.leftViewMode = .Always
            txtField.leftView = UIImageView(image: UIImage(named: "search"))
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddressListViewController.textFieldDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: txtField)
        }
        
    }
    
    func textFieldDidChange(notifications : NSNotification){
        if let txt = txtField.text?.lowercaseString{
            if txt.isEmpty{
                self.showAllInCurrentFilter()
            }else{
                AddressList = AddressList?.filter(){
                    if tableView.tag == 2 {
                        return $0.cianame!.lowercaseString.containsString(txt)
                            || $0.assignsales1name!.lowercaseString.containsString(txt)
                            || $0.nproject!.lowercaseString.containsString(txt)
                            || $0.client!.lowercaseString.containsString(txt)
                    }else{
                        return $0.cianame!.lowercaseString.containsString(txt)
                            || $0.nproject!.lowercaseString.containsString(txt)
                    }
                    
                }
            }
        }else{
            self.showAllInCurrentFilter()
//            AddressList = AddressListOrigin
        }
    }
//    var lastSelectedIndexPath : NSIndexPath?
   
    @IBOutlet var backItem: UIBarButtonItem!
    @IBOutlet var switchItem: UIBarButtonItem!
//    @IBOutlet var searchBar: UISearchBar!
    @IBAction func doLogout(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    var head : AddressListViewHeadView?
    var AddressListOrigin : [ContractsItem]?{
        didSet{
            
            if tableTag != 2 {
                self.AddressList = self.AddressListOrigin
                //                self.showAll()
            }else{
                self.showAllInCurrentFilter()
            }
        }
    }
    
    private func showAllInCurrentFilter(){
        if tableView.tag == 2 {
            let userinfo = NSUserDefaults.standardUserDefaults()
            let a = userinfo.integerForKey(CConstants.ShowFilter)
            if a == 1 {
                showHomeOwnerSign()
                //                self.AddressList = self.AddressListOrigin?.filter(){
                //                    return $0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign")}
            }else if a == 2 {
                showSalesSign()
                //                self.AddressList = self.AddressListOrigin?.filter(){
                //                    return !($0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign"))}
            }else if a == 3 {
                showReCreate()
            }else{
                showAll()
                
            }
        }else{
            AddressList = AddressListOrigin
        }
        
    }
    
    var AddressListOrigin2 : [ContractsItem]?
    
    
    private var filesNms : [String]?
    private var AddressList : [ContractsItem]? {
        didSet{
            AddressList?.sortInPlace(){$0.idcia < $1.idcia}
//            AddressList?
            
            if AddressList != nil{
                CiaNmArray = [String : [ContractsItem]]()
                var citems = [ContractsItem]()
                CiaNm = [String]()
                if let first = AddressList?.first{
                    var thetmp = first
                    for item in AddressList!{
                        
                        if thetmp.idcia != item.idcia {
                            CiaNmArray![thetmp.idcia!] = citems
                            CiaNm?.append(thetmp.idcia!)
                            thetmp = item
                            citems = [ContractsItem]()
                        }
                        citems.append(item)
                    }
                    
                    if citems.count > 0 {
                        CiaNmArray![thetmp.idcia!] = citems
                        CiaNm?.append(thetmp.idcia!)
                    }
                }
            }else{
                CiaNmArray = nil
                CiaNm = nil
            }
            
            self.tableView?.reloadData()
        }
    }
    private var CiaNm : [String]?
    private var CiaNmArray : [String : [ContractsItem]]?
    
    
    @IBOutlet weak var LoginUserName: UIBarButtonItem!{
        didSet{
            let userInfo = NSUserDefaults.standardUserDefaults()
            LoginUserName.title = userInfo.objectForKey(CConstants.LoggedUserNameKey) as? String
        }
    }
    // MARK: - Constanse
    private struct constants{
        static let Title : String = "Address List"
        static let CellIdentifier : String = "Address Cell Identifier"
        static let DraftCellIdentifier : String = "AddressDraft Cell Identifier"
       
    }
    
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tag = tableTag ?? 2
        self.navigationItem.hidesBackButton = true
        self.title = constants.Title
        if tableTag != 2 {
            salesBtn.hidden = true
        }
        
        
        self.tableView.reloadData()
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    

    
    // MARK: - Search Bar Deleagte
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
       
        
    }

    // MARK: - Table view data source
    override func tableView(tableView1: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView.tag == 2 {
            let  heada = AddressListViewHeadView(frame: CGRect(x: 0, y: 0, width: tableView1.frame.width, height: 44))
            let ddd = CiaNmArray?[CiaNm?[section] ?? ""]
            heada.CiaNmLbl.text = ddd?.first?.cianame ?? ""
            return heada
        }else{
            return nil
        }
       
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 1 {
            let ddd = CiaNmArray?[CiaNm?[section] ?? ""]
            return ddd?.first?.cianame ?? ""
        }else{
            return nil
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CiaNm?.count ?? 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CiaNmArray?[CiaNm?[section] ?? ""]!.count ?? 0
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.tag == 2 ? 66 : 30
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell;
        if tableView.tag == 2{
             cell = tableView.dequeueReusableCellWithIdentifier(constants.CellIdentifier, forIndexPath: indexPath)
//            cell.separatorInset = UIEdgeInsetsZero
//            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            if let cellitem = cell as? AddressListViewCell {
                let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
                cellitem.contractInfo = ddd![indexPath.row]
                
            }
            
            
            
            
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier(constants.DraftCellIdentifier, forIndexPath: indexPath)
//            cell.separatorInset = UIEdgeInsetsZero
//            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            if let cellitem = cell as? AddressDraftListViewCell {
                let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
                cellitem.contractInfo = ddd![indexPath.row]
            }
        }
//        if let indexa = tableView.indexPathForSelectedRow{
//            if indexa == indexPath{
//                cell.contentView.backgroundColor = CConstants.SearchBarBackColor
//            }else{
//                cell.contentView.backgroundColor = UIColor.whiteColor()
//            }
//        }
        
        return cell
        
    }
    
    private func getLongString(originStr : String) -> String{
        if originStr.characters.count < 16 {
            let tmp = "                "
            return originStr.stringByAppendingString(tmp.substringFromIndex(originStr.endIndex))
        }else{
            return originStr
        }
    }
    
    @IBOutlet var copyrightlbl: UIBarButtonItem!{
        didSet{
            let currentDate = NSDate()
            let usDateFormat = NSDateFormatter()
            usDateFormat.dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy", options: 0, locale: NSLocale(localeIdentifier: "en-US"))
            
            copyrightlbl.title = "Copyright © " + usDateFormat.stringFromDate(currentDate) + " All Rights Reserved"
        }
    }
    func GoToPrint(modelNm: [String]) {
         self.filesNms = modelNm
//        self.filesNms = ["Addendum C"]
//        if modelNm.count == 1 {
//            callService(modelNm)
//        }else{
            if modelNm.contains(CConstants.ActionTitleAddendumC){
                callService(modelNm)
            }else{
                self.performSegueWithIdentifier(CConstants.SegueToPrintPdf, sender: modelNm)
            }
//        }
        
        

    }
    
    @IBOutlet var filterItem: UIBarButtonItem!
    
    private func callService(printModelNms: [String]){
        var serviceUrl: String?
        var printModelNm : String
        if printModelNms.count == 1 {
            printModelNm = printModelNms[0]
        }else{
            printModelNm = CConstants.ActionTitleAddendumC
        }
        switch printModelNm{
        case CConstants.ActionTitleAddendumC:
            serviceUrl = CConstants.AddendumCServiceURL
        default:
            serviceUrl = CConstants.AddendumAServiceURL
        }
        
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let ddd = self.CiaNmArray?[self.CiaNm?[indexPath.section] ?? ""]
            let item: ContractsItem = ddd![indexPath.row]
            
//            print(ContractRequestItem(contractInfo: item).DictionaryFromObject())
            let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
            //                hud.mode = .AnnularDeterminate
            hud.labelText = CConstants.RequestMsg
            Alamofire.request(.POST,
                CConstants.ServerURL + serviceUrl!,
                parameters: ContractRequestItem(contractInfo: item).DictionaryFromObject()).responseJSON{ (response) -> Void in
                    hud.hide(true)
//                    print(ContractRequestItem(contractInfo: item).DictionaryFromObject())
                        if response.result.isSuccess {
                            
                            if let rtnValue = response.result.value as? [String: AnyObject]{
                                if let msg = rtnValue["message"] as? String{
                                    if msg.isEmpty{
                                        switch printModelNm {
                                        case CConstants.ActionTitleAddendumC:
//                                            if printModelNms.count == 1 {
//                                                let rtn = ContractAddendumC(dicInfo: rtnValue)
//                                                self.performSegueWithIdentifier(CConstants.SegueToAddendumC, sender: rtn)
//                                            }else{
//                                            print(response.result.value)
                                                let rtn = ContractAddendumC(dicInfo: rtnValue)
                                                self.performSegueWithIdentifier(CConstants.SegueToPrintPdf, sender: rtn)
//                                            }
                                        default:
                                            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                                        }
                                        
                                        
                                    }else{
                                        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                                        self.PopMsgWithJustOK(msg: msg)
                                    }
                                }else{
                                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                                    self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                }
                            }else{
                                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                                self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                            }
                        }else{
                            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//                            self.spinner?.stopAnimating()
                            self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                        }
                    }
            
            
        }
    }
    
    
//    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
//        removebackFromCell()
//        if let cell  = tableView.cellForRowAtIndexPath(indexPath) {
//        cell.contentView.backgroundColor = CConstants.SearchBarBackColor
//        }
//        
//    }
//    
//    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
//        if let cell  = tableView.cellForRowAtIndexPath(indexPath) {
//            lastSelectedIndexPath = indexPath
//            cell.contentView.backgroundColor = .clearColor()
//        }
//        
//    }

//    private func removebackFromCell(){
//        if let _ = lastSelectedIndexPath {
//            if let cell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath!){
//                cell.contentView.backgroundColor = .clearColor()
//            }
//        }
//    }
    
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        removebackFromCell()
//    }
   
    var selectRowIndex : NSIndexPath?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

       self.txtField.resignFirstResponder()
        var contract : ContractsItem?
        if tableView.tag == 2{
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? AddressListViewCell {
                contract = cell.contractInfo
            }
        }else{
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? AddressDraftListViewCell {
                contract = cell.contractInfo
            }
        }
        selectRowIndex = indexPath
        let userInfo = NSUserDefaults.standardUserDefaults()
        
        userInfo.setBool(self.tableView.tag == 2, forKey: CConstants.UserInfoIsContract)
        if self.tableView.tag == 2 {
            if (contract?.status ?? "") == CConstants.ApprovedStatus && !(contract?.signfinishdate ?? "").containsString("1980"){
                if (userInfo.stringForKey(CConstants.UserInfoEmail) ?? "").lowercaseString == CConstants.Administrator {
                    GetPrintedFileList(contract)
                }else{
                    self.performSegueWithIdentifier("showSendEmailAfterAprroved1", sender: contract)
                }
                
            }else{
                GetPrintedFileList(contract)
            }
            
        }else{
            contract?.printList = nil
            self.performSegueWithIdentifier(CConstants.SegueToPrintModel, sender: contract)
        }
    }
    
    func GetPrintedFileList(contract : ContractsItem?){
        if let c = contract {
            let param = ["idcontract1" : c.idnumber ?? ""]
//            print(param,  CConstants.ServerURL + "bacontract_GetPrintedFileList.json")
            Alamofire.request(.POST, CConstants.ServerURL + "bacontract_GetPrintedFileList.json", parameters: param).responseJSON{ (response) -> Void in
//                print(response.result.value)
                if response.result.isSuccess {
                    contract?.printList = response.result.value as? [Int]
                    self.performSegueWithIdentifier(CConstants.SegueToPrintModel, sender: contract)
//                    print(response.result.value)
                }else{
                    contract?.printList = nil
                    self.performSegueWithIdentifier(CConstants.SegueToPrintModel, sender: contract)
                }
            }
        }
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showSendEmailAfterAprroved1":
                if let con = segue.destinationViewController as? EmailAfterApprovedViewController {
                    con.contractInfo = sender as? ContractsItem
                }
            case CConstants.SegueToPrintModel:
                
                if let controller = segue.destinationViewController as? PrintModelTableViewController {
                   controller.delegate = self
                    controller.projectInfo = sender as? ContractsItem
                }
                break
            case "showFilter":
//                self.detailsPopover = [[self storyboard] instantiateViewControllerWithIdentifier:@"identifierName"];
//                
//                //... config code for the popover
//                
//                UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:detailsPopover];
//                
//                //... store popover view controller in an ivar
//                
//                [self.annotationPopoverController presentPopoverFromRect:selectedAnnotationView.bounds inView:selectedAnnotationView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
                
//                let p = UIStoryboard(name: "Main").instantiateViewControllerWithIdentifier(identifier: "FilterViewController")
//                
//                let pc = UIPopoverController(contentViewController: p)
//                self.navigationController?.presentViewController(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
                
                if let controller = segue.destinationViewController as? FilterViewController {
                    controller.delegate1 = self
//                    self.popoverPresentationController?.sourceView = salesBtn;
//                    self.popoverPresentationController?.sourceRect = salesBtn.bounds;
                    
                }
                break
            case CConstants.SegueToPrintPdf:
                if let controller = segue.destinationViewController as? PDFPrintViewController {
                    if let indexPath = (tableView.indexPathForSelectedRow ?? selectRowIndex){
                        let ddd = self.CiaNmArray?[self.CiaNm?[indexPath.section] ?? ""]
                        let item: ContractsItem = ddd![indexPath.row]
                        item.approvedate = "01/01/1980"
                        item.approveMonthdate = "01 Jun 80"
                        if let info = sender as? ContractAddendumC {
                            controller.pdfInfo0 = info
                            controller.addendumCpdfInfo = info
//                            controller.AddressList = self.AddressListOrigin
//                            print(self.filesNms!)
                            controller.filesArray = self.filesNms!
//                            print(controller.filesArray)
                            controller.contractInfo = item
                            var itemList = [[String]]()
                            var i = 0
                            if let list = info.itemlist {
                                for items in list {
                                    
                                    var itemList1 = [String]()
                                    let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 657.941, height: 13.2353))
                                    textView.scrollEnabled = false
                                    textView.font = UIFont(name: "Verdana", size: 11.0)
                                    textView.text = items.xdescription!
                                    textView.sizeToFit()
                                    textView.layoutManager.enumerateLineFragmentsForGlyphRange(NSMakeRange(0, items.xdescription!.characters.count), usingBlock: { (rect, usedRect, textContainer, glyphRange, _) -> Void in
                                        if  let a : NSString = items.xdescription! as NSString {
                                            
                                            i += 1
                                            itemList1.append(a.substringWithRange(glyphRange))
                                        }
                                    })
                                    //                            itemList1.append("april test")
                                    itemList.append(itemList1)
                                }
                            }
                            controller.addendumCpdfInfo!.itemlistStr = itemList
                            
                            //                        let pass = i > 19 ? CConstants.PdfFileNameAddendumC2 : CConstants.PdfFileNameAddendumC
                            
                            controller.page2 = i > 19
                            //                        controller.initWithResource(pass)
                            
                        }else{
                            
                            
                            let info = ContractPDFBaseModel(dicInfo: nil)
                            info.code = item.code
                            info.idcia = item.idcia
                            info.idproject = item.idproject
                            info.idnumber = item.idnumber
                            info.idcity = item.idcity
                            info.nproject = item.nproject
                            controller.contractInfo = item
                            controller.pdfInfo0 = info
//                            controller.AddressList = self.AddressListOrigin
                            controller.filesArray = self.filesNms
                            controller.page2 = false
                        }
                        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    }
                    
                }
            
            default:
                break;
            }
        }
    }

    @IBAction func refreshAddressList(sender: UIRefreshControl) {
        
        self.getAddressListFromServer(sender)
    }
    
    private func getAddressListFromServer(sender: UIRefreshControl?){
//        print("getAddressListFromServer......")
        let userInfo = NSUserDefaults.standardUserDefaults()
        let email = userInfo.valueForKey(CConstants.UserInfoEmail) as? String
        let password = userInfo.valueForKey(CConstants.UserInfoPwd) as? String
        
        
        let loginUserInfo = LoginUser(email: email!, password: password!, iscontract:  (self.tableView.tag == 2 ? "1" : "0"))
        
        let a = loginUserInfo.DictionaryFromObject()
        var hud : MBProgressHUD?
        if sender == nil {
            hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud?.labelText = CConstants.RequestMsg
        }
//       print(a)
        Alamofire.request(.POST, CConstants.ServerURL + CConstants.LoginServiceURL, parameters: a).responseJSON{ (response) -> Void in
            if response.result.isSuccess {
//                print(response.result.value)
                if let rtnValue = response.result.value as? [String: AnyObject]{
                    let rtn = Contract(dicInfo: rtnValue)
                    
                    if rtn.activeyn == 1{
                        if (self.tableView.tag == 2 && userInfo.boolForKey(CConstants.UserInfoIsContract)) || (self.tableView.tag == 1 && !userInfo.boolForKey(CConstants.UserInfoIsContract) ){
                            self.AddressListOrigin = rtn.contracts
                        }
                    }
                }
            }
            hud?.hide(true)
            sender?.endRefreshing()
            self.switchItem.enabled = true
        }
        
    }
    
    private func PopMsgWithJustOK(msg msg1: String){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg1, preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .Cancel) { Void in
            
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.txtField.resignFirstResponder()
    }
    @IBAction func toSwitch(sender: UIBarButtonItem){
        self.navigationController?.popToRootViewControllerAnimated(true)
        return
//        self.view.backgroundColor = UIColor.whiteColor()
        //to print draft
        sender.enabled = false
        if sender.tag == 2 {
            sender.tag = 1
            self.tableView.tag = 1
            sender.title = "Print Contract"
            self.backItem.image =  nil
//            self.backItem.title = "s"
//                        self.backItem.width = 0.01
        }else{
            sender.tag = 2
            self.tableView.tag = 2
            sender.title = "Print Draft"
            self.backItem.image = UIImage(named: "back")
            self.backItem.width = 0
//            self.backItem.title = "s"
        }
        let tmp = AddressListOrigin2
        AddressListOrigin2 = AddressListOrigin
        AddressListOrigin = tmp
        self.refreshControl?.endRefreshing()
        NSUserDefaults.standardUserDefaults().setBool(self.tableView.tag == 2, forKey: CConstants.UserInfoIsContract)
        UIView.transitionFromView(tableView, toView: tableView, duration: 0.8, options: [self.tableView.tag == 2 ? .TransitionFlipFromRight : .TransitionFlipFromLeft, .ShowHideTransitionViews], completion: { (_) -> Void in
            //                self.getTrackList()
            
            self.tableView.reloadData()
            if tmp == nil {
//                self.tableView.setContentOffset(CGPoint(x: 0, y: -self.refreshControl!.frame.height*2), animated: true)
            
                self.getAddressListFromServer(nil)
            }else{
                sender.enabled = true
            }
            
        })
        
    }
    
    
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.hidesBarsOnSwipe = true
        let userinfo = NSUserDefaults.standardUserDefaults()
        userinfo.setValue(nil, forKey: CConstants.UserInfoPrintModel)
        kCFDateFormatterDoesRelativeDateFormattingKey
        
        self.refreshControl?.beginRefreshing()
        self.getAddressListFromServer(self.refreshControl)
        
//        self.extendedLayoutIncludesOpaqueBars = true
//        self.edgesForExtendedLayout = .None
//        self.automaticallyAdjustsScrollViewInsets = true
        
    }
    
    func showAll() {
        let userInfo = NSUserDefaults.standardUserDefaults()
        if tableView.tag == 2{
            if (userInfo.stringForKey(CConstants.UserInfoEmail) ?? "").lowercaseString == CConstants.Administrator {
                AddressList = AddressListOrigin?.filter(){
                    return !((!($0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign"))) && (!($0.signfinishdate ?? "1980").containsString("1980")))
                }
                salesBtn.setTitle("Filter", forState: .Normal)
            }else{
                //            AddressList = AddressListOrigin
                AddressList = AddressListOrigin?.filter(){
                    return !((!($0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign"))) && (!($0.signfinishdate ?? "1980").containsString("1980")))
                }
                salesBtn.setTitle("Filter", forState: .Normal)
            }
        }else{
            AddressList = AddressListOrigin
        }
        
        
    }
    func showHomeOwnerSign() {
        AddressList = AddressListOrigin?.filter(){
             return $0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign")
        }
        salesBtn.setTitle("Homeowner Sign", forState: .Normal)
    }
    
    @IBOutlet var salesBtn: UIButton!
    func showSalesSign() {
        
            AddressList = AddressListOrigin?.filter(){
                return (!($0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign"))) && (($0.signfinishdate ?? "1980").containsString("1980"))
            }
            salesBtn.setTitle("Sales Sign", forState: .Normal)
        
    }
    
    func showReCreate() {
        AddressList = AddressListOrigin?.filter(){
            return (!($0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign"))) && (!($0.signfinishdate ?? "1980").containsString("1980"))
        }
        let userInfo = NSUserDefaults.standardUserDefaults()
        if (userInfo.stringForKey(CConstants.UserInfoEmail) ?? "").lowercaseString == CConstants.Administrator {
            
            salesBtn.setTitle("Re-Create", forState: .Normal)
        }else{
            salesBtn.setTitle("Finished", forState: .Normal)
        }
        
    }
    
}
