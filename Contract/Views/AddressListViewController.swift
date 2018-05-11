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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


class AddressListViewController: UITableViewController, UISearchBarDelegate, ToDoPrintDelegate, FilterViewDelegate{
    @IBOutlet var viewHeight: NSLayoutConstraint!{
        didSet{
            viewHeight.constant = 1.0 / UIScreen.main.scale
        }
    }
    
    var tableTag: NSInteger?
    
    
    @IBOutlet var txtField: UITextField!{
        didSet{
            txtField.layer.cornerRadius = 5.0
            txtField.placeholder = "Search"
            txtField.clearButtonMode = .whileEditing
            txtField.leftViewMode = .always
            txtField.leftView = UIImageView(image: UIImage(named: "search"))
            NotificationCenter.default.addObserver(self, selector: #selector(AddressListViewController.textFieldDidChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: txtField)
        }
        
    }
    
    func textFieldDidChange(_ notifications : Notification){
        if let txt = txtField.text?.lowercased(){
            if txt.isEmpty{
                self.showAllInCurrentFilter()
            }else{
                AddressList = AddressList?.filter(){
                    if tableView.tag == 2 {
                        return $0.cianame!.lowercased().contains(txt)
                            || $0.assignsales1name!.lowercased().contains(txt)
                            || $0.nproject!.lowercased().contains(txt)
                            || $0.client!.lowercased().contains(txt)
                    }else{
                        return $0.cianame!.lowercased().contains(txt)
                            || $0.nproject!.lowercased().contains(txt)
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
    @IBAction func doLogout(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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
    
    fileprivate func showAllInCurrentFilter(){
        if tableView.tag == 2 {
            let userinfo = UserDefaults.standard
            let a = userinfo.integer(forKey: CConstants.ShowFilter)
            if a == 1 {
                showHomeOwnerSign()
            }else if a == 2 {
                showSalesSign()
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
    
    
    fileprivate var filesNms : [String]?
    fileprivate var AddressList : [ContractsItem]? {
        didSet{
            AddressList?.sort(){$0.idcia < $1.idcia}
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
    fileprivate var CiaNm : [String]?
    fileprivate var CiaNmArray : [String : [ContractsItem]]?
    
    
    @IBOutlet weak var LoginUserName: UIBarButtonItem!{
        didSet{
            let userInfo = UserDefaults.standard
            LoginUserName.title = userInfo.object(forKey: CConstants.LoggedUserNameKey) as? String
        }
    }
    // MARK: - Constanse
    fileprivate struct constants{
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
            salesBtn.isHidden = true
        }
        
        
        self.tableView.reloadData()
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    
    
    
    // MARK: - Search Bar Deleagte
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView1: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView.tag == 2 {
            let  heada = AddressListViewHeadView(frame: CGRect(x: 0, y: 0, width: tableView1.frame.width, height: 44))
            let ddd = CiaNmArray?[CiaNm?[section] ?? ""]
            heada.CiaNmLbl.text = ddd?.first?.cianame ?? ""
            return heada
        }else{
            return nil
        }
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 1 {
            let ddd = CiaNmArray?[CiaNm?[section] ?? ""]
            return ddd?.first?.cianame ?? ""
        }else{
            return nil
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return CiaNm?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CiaNmArray?[CiaNm?[section] ?? ""]!.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.tag == 2 ? 66 : 30
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell;
        if tableView.tag == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: constants.CellIdentifier, for: indexPath)
            //            cell.separatorInset = UIEdgeInsetsZero
            //            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            if let cellitem = cell as? AddressListViewCell {
                let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
                cellitem.contractInfo = ddd![indexPath.row]
                
            }
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: constants.DraftCellIdentifier, for: indexPath)
            //            cell.separatorInset = UIEdgeInsetsZero
            //            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            if let cellitem = cell as? AddressDraftListViewCell {
                let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
                cellitem.contractInfo = ddd![indexPath.row]
            }
        }
        
        return cell
        
    }
    
    fileprivate func getLongString(_ originStr : String) -> String{
        if originStr.characters.count < 16 {
            let tmp = "                "
            return originStr + tmp.substring(from: originStr.endIndex)
        }else{
            return originStr
        }
    }
    
    @IBOutlet var copyrightlbl: UIBarButtonItem!{
        didSet{
            let currentDate = Date()
            let usDateFormat = DateFormatter()
            usDateFormat.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale(identifier: "en-US"))
            
            copyrightlbl.title = "Copyright © " + usDateFormat.string(from: currentDate) + " All Rights Reserved"
        }
    }
    
    
    var xline1: String?;
    var xline2: String?;
    func GoToPrint(_ modelNm: [String], _ line1: String, _ line2: String) {
       
         self.filesNms = modelNm
        xline1 = line1;
        xline2 = line2;
        if modelNm.contains(CConstants.ActionTitleAddendumC){
            callService(modelNm)
        }else{
            

            self.performSegue(withIdentifier: CConstants.SegueToPrintPdf, sender: modelNm)
        }
        
        
        
    }
    
    @IBOutlet var filterItem: UIBarButtonItem!
    
    fileprivate func callService(_ printModelNms: [String]){
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
            let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
            //                hud.mode = .AnnularDeterminate
            hud?.labelText = CConstants.RequestMsg
            
            Alamofire.request(
                              CConstants.ServerURL + serviceUrl!, method: .post,
                              parameters: ContractRequestItem(contractInfo: item).DictionaryFromObject()).responseJSON{ (response) -> Void in
                                hud?.hide(true)
                                //                    print(ContractRequestItem(contractInfo: item).DictionaryFromObject())
                                if response.result.isSuccess {
                                    
                                    if let rtnValue = response.result.value as? [String: AnyObject]{
                                        if let msg = rtnValue["message"] as? String{
                                            if msg.isEmpty{
                                                switch printModelNm {
                                                case CConstants.ActionTitleAddendumC:
                                                    //                                            if printModelNms.count == 1 {
                                                    //                                                let rtn = ContractAddendumC(dicInfo: rtnValue)
                                                    //                                                self.performSegue(withIdentifier: CConstants.SegueToAddendumC, sender: rtn)
                                                    //                                            }else{
                                                    //                                            print(response.result.value)
                                                    let rtn = ContractAddendumC(dicInfo: rtnValue)
                                                    self.performSegue(withIdentifier:CConstants.SegueToPrintPdf, sender: rtn)
                                                //                                            }
                                                default:
                                                    self.tableView.deselectRow(at: indexPath, animated: true)
                                                }
                                                
                                                
                                            }else{
                                                self.tableView.deselectRow(at: indexPath, animated: true)
                                                self.PopMsgWithJustOK(msg: msg)
                                            }
                                        }else{
                                            self.tableView.deselectRow(at: indexPath, animated: true)
                                            self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                        }
                                    }else{
                                        self.tableView.deselectRow(at: indexPath, animated: true)
                                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                    }
                                }else{
                                    self.tableView.deselectRow(at: indexPath, animated: true)
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
    
    var selectRowIndex : IndexPath?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.txtField.resignFirstResponder()
        var contract : ContractsItem?
        if tableView.tag == 2{
            if let cell = tableView.cellForRow(at: indexPath) as? AddressListViewCell {
                contract = cell.contractInfo
            }
        }else{
            if let cell = tableView.cellForRow(at: indexPath) as? AddressDraftListViewCell {
                contract = cell.contractInfo
            }
        }
        selectRowIndex = indexPath
        let userInfo = UserDefaults.standard
        
        userInfo.set(self.tableView.tag == 2, forKey: CConstants.UserInfoIsContract)
        if self.tableView.tag == 2 {
            let ddd = self.CiaNmArray?[self.CiaNm?[indexPath.section] ?? ""]
            let item: ContractsItem = ddd![indexPath.row]
//            if true {item.idcia == "9999" || 
            if item.idcia == "386" && item.idproject!.hasPrefix("201") {
                self.performSegue(withIdentifier: "springdale", sender: item)
                self.tableView.deselectRow(at: indexPath, animated: true)
            }else {
                if (contract?.status ?? "") == CConstants.ApprovedStatus && !(contract?.signfinishdate ?? "").contains("1980"){
                    if (userInfo.string(forKey: CConstants.UserInfoEmail) ?? "").lowercased() == CConstants.Administrator {
                        GetPrintedFileList(contract)
                    }else{
                        self.performSegue(withIdentifier: "showSendEmailAfterAprroved1", sender: contract)
                    }
                    
                }else{
                    GetPrintedFileList(contract)
                }
            }
            
            
            
        }else{
            //            springdale
            
            
            contract?.printList = nil
            self.performSegue(withIdentifier: CConstants.SegueToPrintModel, sender: contract)
        }
    }
    
    func GetPrintedFileList(_ contract : ContractsItem?){
        if let c = contract {
            let param = ["idcontract1" : c.idnumber ?? ""]
            //            print(param,  CConstants.ServerURL + "bacontract_GetPrintedFileList.json")

            Alamofire.request(CConstants.ServerURL + "bacontract_GetPrintedFileList.json", method: .post, parameters: param).responseJSON{ (response) -> Void in
                //                print(response.result.value)
                if response.result.isSuccess {
                    contract?.printList = response.result.value as? [Int]
                    self.performSegue(withIdentifier: CConstants.SegueToPrintModel, sender: contract)
                    //                    print(response.result.value)
                }else{
                    contract?.printList = nil
                    self.performSegue(withIdentifier: CConstants.SegueToPrintModel, sender: contract)
                }
            }
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showSendEmailAfterAprroved1":
                if let con = segue.destination as? EmailAfterApprovedViewController {
                    con.contractInfo = sender as? ContractsItem
                }
            case CConstants.SegueToPrintModel:
                
                if let controller = segue.destination as? PrintModelTableViewController {
                    controller.delegate = self
                    controller.projectInfo = sender as? ContractsItem
                }
                break
            case "showFilter":
               
                
                if let controller = segue.destination as? FilterViewController {
                    controller.delegate1 = self
                    //                    self.popoverPresentationController?.sourceView = salesBtn;
                    //                    self.popoverPresentationController?.sourceRect = salesBtn.bounds;
                    
                }
                break
            case "springdale":
                if let controller = segue.destination as? SpringDalePDFViewController {
                    if let item = sender as? ContractsItem {
                        item.approvedate = "01/01/1980"
                        item.approveMonthdate = "01 Jun 80"
                        let info = ContractPDFBaseModel(dicInfo: nil);
                        info.idcia = item.idcia;
                        info.idcity = item.idcity;
                        info.idnumber = item.idnumber;
                        info.idproject = item.idproject;
                        info.nproject = item.nproject;
                        info.code = item.code;
                        controller.pdfInfo0 = info
                        controller.filesArray = ["springdale"]
                        controller.contractInfo = item
                    }
                    
                }
            case CConstants.SegueToPrintPdf:
//                SpringDalePDFViewController
                if let controller = segue.destination as? PDFPrintViewController {
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
                                    textView.isScrollEnabled = false
                                    textView.font = UIFont(name: "Verdana", size: 11.0)
                                    textView.text = items.xdescription!
                                    textView.sizeToFit()
                                    textView.layoutManager.enumerateLineFragments(forGlyphRange: NSMakeRange(0, items.xdescription!.characters.count), using: { (rect, usedRect, textContainer, glyphRange, _) -> Void in
                                        if  let a : NSString = items.xdescription! as NSString {
                                            
                                            i += 1
                                            itemList1.append(a.substring(with: glyphRange))
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
                            controller.xline1 = self.xline1;
                            controller.xline2 = self.xline2;
                            //                            controller.AddressList = self.AddressListOrigin
                            controller.filesArray = self.filesNms
                            controller.page2 = false
                        }
                        self.tableView.deselectRow(at: indexPath, animated: true)
                    }
                    
                }
                
            default:
                break;
            }
        }
    }
    
    @IBAction func refreshAddressList(_ sender: UIRefreshControl) {
        
        self.getAddressListFromServer(sender)
    }
    
    fileprivate func getAddressListFromServer(_ sender: UIRefreshControl?){
        //        print("getAddressListFromServer......")
        let userInfo = UserDefaults.standard
        let email = userInfo.value(forKey: CConstants.UserInfoEmail) as? String
        let password = userInfo.value(forKey: CConstants.UserInfoPwd) as? String
        
        
        let loginUserInfo = LoginUser(email: email!, password: password!, iscontract:  (self.tableView.tag == 2 ? "1" : "0"))
        
        let a = loginUserInfo.DictionaryFromObject()
        var hud : MBProgressHUD?
        if sender == nil {
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.labelText = CConstants.RequestMsg
        }
               print(a)
        // april need to change
        Alamofire.request(CConstants.ServerURL + CConstants.LoginServiceURL, method: .post, parameters: a).responseJSON{ (response) -> Void in
            if response.result.isSuccess {
//                                print(response.result.value)
                if let rtnValue = response.result.value as? [String: AnyObject]{
                    let rtn = Contract(dicInfo: rtnValue)
                    
                    if rtn.activeyn == 1{
                        if (self.tableView.tag == 2 && userInfo.bool(forKey: CConstants.UserInfoIsContract)) || (self.tableView.tag == 1 && !userInfo.bool(forKey: CConstants.UserInfoIsContract) ){
                            self.AddressListOrigin = rtn.contracts
                        }
                    }
                }
            }
            hud?.hide(true)
            sender?.endRefreshing()
            self.switchItem.isEnabled = true
        }
        
    }
    
    fileprivate func PopMsgWithJustOK(msg msg1: String){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg1, preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .cancel) { Void in
            
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.txtField.resignFirstResponder()
    }
    @IBAction func toSwitch(_ sender: UIBarButtonItem){
        self.navigationController?.popToRootViewController(animated: true)
        return
            //        self.view.backgroundColor = UIColor.whiteColor()
            //to print draft
            sender.isEnabled = false
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
        UserDefaults.standard.set(self.tableView.tag == 2, forKey: CConstants.UserInfoIsContract)
        UIView.transition(from: tableView, to: tableView, duration: 0.8, options: [self.tableView.tag == 2 ? .transitionFlipFromRight : .transitionFlipFromLeft, .showHideTransitionViews], completion: { (_) -> Void in
            //                self.getTrackList()
            
            self.tableView.reloadData()
            if tmp == nil {
                //                self.tableView.setContentOffset(CGPoint(x: 0, y: -self.refreshControl!.frame.height*2), animated: true)
                
                self.getAddressListFromServer(nil)
            }else{
                sender.isEnabled = true
            }
            
        })
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.navigationController?.hidesBarsOnSwipe = true
        let userinfo = UserDefaults.standard
        userinfo.setValue(nil, forKey: CConstants.UserInfoPrintModel)
        CFDateFormatterKey.doesRelativeDateFormattingKey
        
        self.refreshControl?.beginRefreshing()
        self.getAddressListFromServer(self.refreshControl)
        
        //        self.extendedLayoutIncludesOpaqueBars = true
        //        self.edgesForExtendedLayout = .None
        //        self.automaticallyAdjustsScrollViewInsets = true
        
    }
    
    func showAll() {
        let userInfo = UserDefaults.standard
        if tableView.tag == 2{
            if (userInfo.string(forKey: CConstants.UserInfoEmail) ?? "").lowercased() == CConstants.Administrator {
                AddressList = AddressListOrigin?.filter(){
                    return !((!($0.status!.contains("iPad Sign") || $0.status!.contains("Email Sign"))) && (!($0.signfinishdate ?? "1980").contains("1980")))
                }
                salesBtn.setTitle("Filter", for: UIControlState())
            }else{
                //            AddressList = AddressListOrigin
                AddressList = AddressListOrigin?.filter(){
                    return !((!($0.status!.contains("iPad Sign") || $0.status!.contains("Email Sign"))) && (!($0.signfinishdate ?? "1980").contains("1980")))
                }
                salesBtn.setTitle("Filter", for: UIControlState())
            }
        }else{
            AddressList = AddressListOrigin
        }
        
        
    }
    func showHomeOwnerSign() {
        AddressList = AddressListOrigin?.filter(){
            return $0.status!.contains("iPad Sign") || $0.status!.contains("Email Sign")
        }
        salesBtn.setTitle("Homeowner Sign", for: UIControlState())
    }
    
    @IBOutlet var salesBtn: UIButton!
    func showSalesSign() {
        
        AddressList = AddressListOrigin?.filter(){
            return (!($0.status!.contains("iPad Sign") || $0.status!.contains("Email Sign"))) && (($0.signfinishdate ?? "1980").contains("1980"))
        }
        salesBtn.setTitle("Sales Sign", for: UIControlState())
        
    }
    
    func showReCreate() {
        AddressList = AddressListOrigin?.filter(){
            return (!($0.status!.contains("iPad Sign") || $0.status!.contains("Email Sign"))) && (!($0.signfinishdate ?? "1980").contains("1980"))
        }
        let userInfo = UserDefaults.standard
        if (userInfo.string(forKey: CConstants.UserInfoEmail) ?? "").lowercased() == CConstants.Administrator {
            
            salesBtn.setTitle("Re-Create", for: UIControlState())
        }else{
            salesBtn.setTitle("Finished", for: UIControlState())
        }
        
    }
    
}
