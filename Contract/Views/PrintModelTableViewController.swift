//
//  PrintModelTableViewController.swift
//  Contract
//
//  Created by April on 2/18/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
import Alamofire

protocol ToDoPrintDelegate
{
    func GoToPrint(_ modelNm: [String])
}
class PrintModelTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate{
    // MARK: - Constanse
    
    var projectInfo: ContractsItem?
    
    @IBOutlet var printBtn: UIButton!{
        didSet{
            printBtn.layer.cornerRadius = 5.0
            printBtn.isHidden = true
        }
    }
    var delegate : ToDoPrintDelegate?
    
    
    
    @IBAction func dismissSelf(_ sender: UITapGestureRecognizer) {
        //        print(sender)
        //        let point = sender.locationInView(view)
        //        if !CGRectContainsPoint(tableview.frame, point) {
        self.dismiss(animated: true){}
        //        }
        
    }
    @IBOutlet var tableHeight: NSLayoutConstraint!
    
    @IBOutlet var tablex: NSLayoutConstraint!
    @IBOutlet var tabley: NSLayoutConstraint!
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: view)
        return !tableview.frame.contains(point)
    }
    @IBOutlet var tableview: UITableView!{
        didSet{
            tableview.layer.cornerRadius = 8.0
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.title = "Print"
        view.superview?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        //        view.superview?.bounds = CGRect(x: 0, y: 0, width: tableview.frame.width, height: 44 * CGFloat(5))
    }
    
    fileprivate struct constants{
        static let Title : String = "Select"
        static let CellIdentifier : String = "Address Cell Identifier"
        
        static let cellReuseIdentifier = "cellIdentifier"
        static let cellLastReuseIndentifier = "lastCell"
        static let cellFirstReuseIndentifier = "firstCell"
        static let cellHeight: CGFloat = 44.0
        
         static let selectAllTitle = "Select All"
        static let printBtnTitle = "Continue"
        static let cancelBtnTitle = "Cancel"
    }
    var printList: [String] = [
        constants.selectAllTitle
        , CConstants.ActionTitleContract
        , CConstants.ActionTitleThirdPartyFinancingAddendum
        , CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES
        , CConstants.ActionTitleAddendumA
        , CConstants.ActionTitleEXHIBIT_A
        , CConstants.ActionTitleEXHIBIT_B
        , CConstants.ActionTitleEXHIBIT_C
    ]
    
    var selected : [Bool]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        filesNames = [String]()
        
       
        if let c = projectInfo {
//            if c.status == CConstants.EmailSignedStatus || c.status == CConstants.DraftStatus || c.status == "" {
            if c.status ==  CConstants.DraftStatus || c.status == "" {
                canEdit = true
            }
        }
//        canEdit = true
        
        tableview.allowsSelection = canEdit
        let userInfo = UserDefaults.standard
        if userInfo.bool(forKey: CConstants.UserInfoIsContract) {
            printList.append(CConstants.ActionTitleBuyersExpect)
            printList.append(CConstants.ActionTitleAddendumC)
            printList.append(CConstants.ActionTitleAddendumD)
            printList.append(CConstants.ActionTitleAddendumE)
            if let tmp = self.projectInfo?.floodplainyn {
                if tmp == 1 {
                    printList.append(CConstants.ActionTitleFloodPlainAck)
                }
            }
            
            printList.append(CConstants.ActionTitleWarrantyAcknowledgement)
            printList.append(CConstants.ActionTitleDesignCenter)
//            printList.append(CConstants.ActionTitleClosingMemo)
            if let tmp = self.projectInfo?.hoa {
                if tmp == 1 {
                    printList.append(CConstants.ActionTitleHoaChecklist)
                    printList.append(CConstants.ActionTitleAddendumHOA)
                }
            }
            printList.append(CConstants.ActionTitleGoContract)
        }else{
            printList[1] = CConstants.ActionTitleDraftContract
            printList.append(CConstants.ActionTitleBuyersExpect)
            printList.append(CConstants.ActionTitleAddendumD)
            printList.append(CConstants.ActionTitleAddendumE)
            if let tmp = self.projectInfo?.floodplainyn {
                if tmp == 1 {
                    printList.append(CConstants.ActionTitleFloodPlainAck)
                }
            }
            
            printList.append(CConstants.ActionTitleWarrantyAcknowledgement)
            if let tmp = self.projectInfo?.hoa {
                if tmp == 1 {
                    printList.append(CConstants.ActionTitleHoaChecklist)
                    printList.append(CConstants.ActionTitleAddendumHOA)
                }
            }
            printList.append(CConstants.ActionTitleGoDraft)
        }
        
        selected = [Bool]()
//        1	Print Contract
//        2	Third Party Financing Addendum
//        3	Information about Brokerage Services
//        4	Addendum A
//        5	Exhibit A
//        6	Exhibit B
//        7	Exhibit C General
//        8	Buyers Expect
//        9	Addendum C
//        10	Addendum D
//        11	Addendum E
//        12	Floodaplain Acknowledgement
//        13	HOA Checklist
//        14	Warranty Acknowledgement
//        15	Design Center
//        17	Addendum for Property Subject to HOA
        
        for x in printList {
            switch x {
            case CConstants.ActionTitleContract, CConstants.ActionTitleDraftContract:
//                print(projectInfo?.printList?.contains(1))
                selected?.append(projectInfo?.printList?.contains(1) ?? true)
            case CConstants.ActionTitleThirdPartyFinancingAddendum:
                selected?.append(projectInfo?.printList?.contains(2) ?? true)
            case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
                selected?.append(projectInfo?.printList?.contains(3) ?? true)
            case CConstants.ActionTitleAddendumA:
                selected?.append(projectInfo?.printList?.contains(4) ?? true)
            case CConstants.ActionTitleEXHIBIT_A:
                selected?.append(projectInfo?.printList?.contains(5) ?? true)
            case CConstants.ActionTitleEXHIBIT_B:
                selected?.append(projectInfo?.printList?.contains(6) ?? true)
            case CConstants.ActionTitleEXHIBIT_C:
                selected?.append(projectInfo?.printList?.contains(7) ?? true)
            case CConstants.ActionTitleBuyersExpect:
                selected?.append(projectInfo?.printList?.contains(8) ?? true)
            case CConstants.ActionTitleAddendumC:
                selected?.append(projectInfo?.printList?.contains(9) ?? true)
            case CConstants.ActionTitleAddendumD:
                selected?.append(projectInfo?.printList?.contains(10) ?? true)
            case CConstants.ActionTitleAddendumE:
                selected?.append(projectInfo?.printList?.contains(11) ?? true)
            case CConstants.ActionTitleFloodPlainAck:
                selected?.append(projectInfo?.printList?.contains(12) ?? true)
            case CConstants.ActionTitleHoaChecklist:
                selected?.append(projectInfo?.printList?.contains(13) ?? true)
            case CConstants.ActionTitleWarrantyAcknowledgement:
                selected?.append(projectInfo?.printList?.contains(14) ?? true)
            case CConstants.ActionTitleDesignCenter:
                selected?.append(projectInfo?.printList?.contains(15) ?? true)
            case CConstants.ActionTitleAddendumHOA:
                selected?.append(projectInfo?.printList?.contains(17) ?? true)
            default:
                selected?.append(true)
                break
            }
            
            
        }
        
        if selected?.filter({$0}).count != selected?.count {
            selected?[0] = false
        }
        
        
        
        tableHeight.constant = getTableHight()
        tableview.updateConstraintsIfNeeded()
        
    }
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return constants.cellHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.cellFirstReuseIndentifier)
        cell!.textLabel!.text = "Select Form"
        cell?.textLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
        cell?.textLabel?.textColor =  UIColor.white
        cell?.textLabel?.backgroundColor = CConstants.ApplicationColor
        cell!.textLabel!.textAlignment = NSTextAlignment.center
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.cellLastReuseIndentifier) as! AddressListModelLastCell
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.print?.text = constants.printBtnTitle
        
        cell.print?.textAlignment = .center
        cell.print?.textColor = UIColor.white
        cell.print?.backgroundColor = CConstants.ApplicationColor
        cell.print?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
        cell.cancel?.text = constants.cancelBtnTitle
        
        cell.cancel?.textAlignment = .center
        cell.cancel?.textColor = UIColor.white
        cell.cancel?.backgroundColor = CConstants.ApplicationColor
        cell.cancel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
        
        let tab = UITapGestureRecognizer(target: self, action: #selector(PrintModelTableViewController.touched(_:)))
        tab.numberOfTapsRequired = 1
        cell.tag = 0
        cell.addGestureRecognizer(tab)
        let userinfo = UserDefaults.standard
        if let filesNames = userinfo.value(forKey: CConstants.UserInfoPrintModel) as? [String] {
            if filesNames.count == printList.count{
                cell.tag = 1
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return printList.count - 1
    }
    
    fileprivate func isAllCellSelected(){
        var selectedh = 0;
        for i in 1...selected!.count-1 {
//            let index1 = NSIndexPath(forRow: i, inSection: 0)
            if selected![i] {
                selectedh+=1
            }
        }
            let index1 = IndexPath(row: 0, section: 0)
            if let cell = tableview.cellForRow(at: index1) as? PrintModelTableViewCell{
                if selectedh == selected!.count-1 {
                    selected![0] = true
                    cell.imageBtn.image = UIImage(named: CConstants.CheckedImgNm)
                }else{
                    selected![0] = false
                    cell.imageBtn.image = UIImage(named: CConstants.CheckImgNm)
                }
            }
            
        
    }
//    private func isAllCellSelected(){
//        var cnt = 0
//        for i in 0...printList.count-2 {
//            let indexa = NSIndexPath(forRow: i, inSection: 0)
//            if let cell = tableview.cellForRowAtIndexPath(indexa) as? PrintModelTableViewCell {
//                
//                if cell.contentView.tag == 1 {
//                    cnt+=1
//                }
//            }
//        }
//        if cnt == printList.count-1 {
//            let indexa = NSIndexPath(forRow: printList.count-1, inSection: 0)
//            if let cell = tableview.cellForRowAtIndexPath(indexa) as? PrintModelTableViewCell {
//                cell.imageBtn.image =  UIImage(named: CConstants.CheckedImgNm)
//                cell.tag = 1
//            }
//        }else {
//            let indexa = NSIndexPath(forRow: printList.count-1, inSection: 0)
//            if let cell = tableview.cellForRowAtIndexPath(indexa) as? PrintModelTableViewCell {
//                cell.imageBtn.image =  UIImage(named: CConstants.CheckImgNm)
//                cell.tag = 0
//            }
//
//        }
//        
//    }
    
    var canEdit : Bool = false
    
    func touched(_ tap : UITapGestureRecognizer){

        if let cell = tap.view as? AddressListModelLastCell {
            let point = tap.location(in: tap.view)
            if (cell.print.frame.contains(point)){
                var selectedCellArray = [IndexPath]()
                
                for i in 1...printList.count-2 {
                    let index = IndexPath(row: i, section: 0)
                    let c = selected![i]
                    if c {
                        selectedCellArray.append(index)
                    }
                }
                
                if selectedCellArray.count == 0 {
                    return
                }else{
//                    print(NSDate)
                    self.dismiss(animated: false){
                        var filesNames = [String]()
                        for indexPath0 in selectedCellArray {
                            let title = self.printList[indexPath0.row]
                            filesNames.append(title)
                        }
//                        let userinfo = NSUserDefaults.standardUserDefaults()
//                        userinfo.setValue(filesNames, forKey: CConstants.UserInfoPrintModel)
                        
                        if let delegate1 = self.delegate {
                            
                            delegate1.GoToPrint(filesNames)
                            if self.projectInfo?.status ?? "" != "" && self.canEdit {
                                self.UpdatePrintedFileList(filesNames)
                            }
                            
                            
                            
                        }
                    }
                }
            }else if cell.cancel.frame.contains(point){
                self.dismiss(animated: true){}
            
            }
        }
        
//        tap.view!.tag = 1 - tap.view!.tag

        
    }
    
    
    func UpdatePrintedFileList(_ filesNames : [String]){
        var printedList : [String] = [String]()
        for x in filesNames {
            switch x {
            case CConstants.ActionTitleContract, CConstants.ActionTitleDraftContract:
                printedList.append("1")
            case CConstants.ActionTitleThirdPartyFinancingAddendum:
                printedList.append("2")
            case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
                printedList.append("3")
            case CConstants.ActionTitleAddendumA:
                printedList.append("4")
            case CConstants.ActionTitleEXHIBIT_A:
                printedList.append("5")
            case CConstants.ActionTitleEXHIBIT_B:
                printedList.append("6")
            case CConstants.ActionTitleEXHIBIT_C:
                printedList.append("7")
            case CConstants.ActionTitleBuyersExpect:
                printedList.append("8")
            case CConstants.ActionTitleAddendumC:
                printedList.append("9")
            case CConstants.ActionTitleAddendumD:
                printedList.append("10")
            case CConstants.ActionTitleAddendumE:
                printedList.append("11")
            case CConstants.ActionTitleFloodPlainAck:
                printedList.append("12")
            case CConstants.ActionTitleHoaChecklist:
                printedList.append("13")
            case CConstants.ActionTitleWarrantyAcknowledgement:
                printedList.append("14")
            case CConstants.ActionTitleDesignCenter:
                printedList.append("15")
            case CConstants.ActionTitleAddendumHOA:
                printedList.append("17")
            default:
                break
            }
            
            
            
        }
        
        
        if let c = projectInfo {
            let param = ["idcontract1" : c.idnumber ?? "", "idfilelist": printedList.joined(separator: ",")]
//            print(param)
            // april need to change
            
//            Alamofire.request(.POST, CConstants.ServerURL + "bacontract_UpdatePrintedFileList.json", parameters: param).responseJSON{ (response) -> Void in
////                print(response.result.value)
//                if response.result.isSuccess {
//                    //                    contract?.printList = response.result.value as? String
//                    //                    self.performSegue(withIdentifier: CConstants.SegueToPrintModel, sender: contract)
//                    //                    print(response.result.value)
//                }else{
//                    //                    contract?.printList = nil
//                    //                    self.performSegue(withIdentifier: CConstants.SegueToPrintModel, sender: contract)
//                }
//            }
        }
    }
    
//    var filesNames : [String]?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.cellReuseIdentifier, for: indexPath) as! PrintModelTableViewCell
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            cell.contentLbl?.text = printList[indexPath.row]
            cell.textLabel?.textAlignment = .left
            
//            let userinfo = NSUserDefaults.standardUserDefaults()
//            if let filesNames = userinfo.valueForKey(CConstants.UserInfoPrintModel) as? [String] {
//                if filesNames!.contains(printList[indexPath.row]) {
//                    cell.contentView.tag = 1
//                    cell.imageBtn?.image = UIImage(named: CConstants.CheckedImgNm)
//                }else{
//                    cell.contentView.tag = 0
//                    cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
//                }
        
        if let a = selected {
        let c = a[indexPath.row]
            if c {
            cell.imageBtn?.image = UIImage(named: CConstants.CheckedImgNm)
            }else{
            cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
            }
        }else{
            cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
        }
//        if cell.contentView.tag == 1 {
//            cell.imageBtn?.image = UIImage(named: CConstants.CheckedImgNm)
//        }else{
//            cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
//        }
//            }else{
//                cell.contentView.tag = 0
//                cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
//            }

        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath) as? PrintModelTableViewCell
            //            cell?.contentView.tag = 1 - cell!.contentView.tag
            let iv :UIImage?
            let c = selected![indexPath.row]
            if !c {
                iv = UIImage(named: CConstants.CheckedImgNm)
            }else{
                iv = UIImage(named: CConstants.CheckImgNm)
            }
            selected![indexPath.row] = !c
            
            
            
//            iv = UIImage(named: CConstants.CheckedImgNm)
//            selected![indexPath.row] = true
            
//
            cell?.imageBtn?.image = iv
            
            
                for i in 1...(selected!.count-1) {
                    selected![i] = !c
//                    selected![i] = true
                    let indexother = IndexPath(row: i, section: 0)
                    if let cell = tableView.cellForRow(at: indexother) as? PrintModelTableViewCell {
                        cell.imageBtn?.image =  iv
                    }
                }
            
        }else if indexPath.row < (printList.count - 1) {
            let cell = tableView.cellForRow(at: indexPath) as? PrintModelTableViewCell
//            cell?.contentView.tag = 1 - cell!.contentView.tag
            let iv :UIImage?
            let c = selected![indexPath.row]
            if !c {
                iv = UIImage(named: CConstants.CheckedImgNm)
            }else{
                iv = UIImage(named: CConstants.CheckImgNm)
            }
            selected![indexPath.row] = !c
//            iv = UIImage(named: CConstants.CheckedImgNm)
            cell?.imageBtn?.image = iv
            isAllCellSelected()
            
        }else{
            
            var selectedCellArray = [IndexPath]()
            
            for i in 0...printList.count-1 {
//                let index = NSIndexPath(forRow: i, inSection: 0)
//                if let cell = tableView.cellForRowAtIndexPath(index) {
//                    if cell.contentView.tag == 1 {
//                        selectedCellArray.append(index)
//                    }
//                    
//                    
//                }
                let c = selected![i]
                let index = IndexPath(row: i, section: 0)
                if c {
                    selectedCellArray.append(index)
                }
            }
            
            
            if selectedCellArray.count == 0 {
                return
            }else{
                self.dismiss(animated: true){
                    if let delegate1 = self.delegate {
                        var filesNames = [String]()
                        for indexPath0 in selectedCellArray {
                            let title = self.printList[indexPath0.row]
                            filesNames.append(title)
                        }
                        let userinfo = UserDefaults.standard
                        userinfo.setValue(filesNames, forKey: CConstants.UserInfoPrintModel)
                        delegate1.GoToPrint(filesNames)
                    }
                }
            }
            
            
        }
    }
    
    override var preferredContentSize: CGSize {
        
        get {
            return CGSize(width: tableview.frame.width, height:getTableHight())
        }
        set { super.preferredContentSize = newValue }
    }
    
    fileprivate func getTableHight() -> CGFloat{
//        print(constants.cellHeight * CGFloat(printList.count + 1), 680, (min(view.frame.height, view.frame.width) - 40))
//        print(min(CGFloat(constants.cellHeight * CGFloat(printList.count + 1)), 680, (min(view.frame.height, view.frame.width) - 40)))
       return min(CGFloat(constants.cellHeight * CGFloat(printList.count + 1)), 680, (min(view.frame.height, view.frame.width) - 40))
    }
    
    
    
    
}
