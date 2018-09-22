//
//  SpringDalePDFViewController.swift
//  Contract
//
//  Created by April Lv on 3/5/18.
//  Copyright © 2018 HapApp. All rights reserved.
//
import UIKit
import Alamofire
import MessageUI
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class SpringDalePDFViewController: PDFBaseViewController
, UIScrollViewDelegate
, SubmitForApproveViewControllerDelegate
, SaveAndEmailViewControllerDelegate
, UIImagePickerControllerDelegate
, UINavigationControllerDelegate
, GoToFileDelegate
, EmailContractToBuyerViewControllerDelegate
{
    @IBOutlet var copyrightlbl: UIBarButtonItem!{
        didSet{
            let currentDate = Date()
            let usDateFormat = DateFormatter()
            usDateFormat.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale(identifier: "en-US"))
            
            copyrightlbl.title = "Copyright © " + usDateFormat.string(from: currentDate) + " All Rights Reserved"
        }
    }
    fileprivate struct constants{
        static let operationMsg = "Are you sure you want to take photo of the check again?"
        static let segueToSendEmailAfterApproved = "showSendEmail"
        static let segueToEmailContractToBuyer = "springdalechangetoemail"
        
        static let operationBuyerGoToSign = "Buyer Go To Sign"
        static let operationBuyer1GoToSign = "Buyer1 Go To Sign"
        static let operationBuyer2GoToSign = "Buyer2 Go To Sign"
        static let operationSellerGoToSign = "Seller Go To Sign"
        
    }
    @IBAction func skiptoNext(_ sender: UIBarButtonItem) {
        if let xt = sender.title {
            if xt == "" {
                return;
            }
            if let info = contractPdfInfo {
                if info.status == CConstants.ApprovedStatus && xt == "Next"{
                    self.gotoSellerSign()
                }else{
                    
                    if xt == "Next B-1" {
                        self.gotoBuyer1Sign()
                    }else if xt == "Next B-2" {
                        self.gotoBuyer2Sign()
                    }
                }
            }
        }
    }
    var isDownload : Bool?
    @IBOutlet var view2: UIView!
    
    
    var contractPdfInfo : ContractSpringDaleInfo?{
        didSet{
            if let info = contractPdfInfo {
                setSendItema()
                contractInfo?.status = info.status
                contractInfo?.signfinishdate = info.signfinishdate
                contractInfo?.approvedate = info.approvedate
//                contractInfo?.approveMonthdate = info.approveMonthdate
                setBuyer2()
                if let c = info.status {
                    if c ==  CConstants.ApprovedStatus {
                        //                        info.approvedate = "01/01/1980"
                        if (info.approvedate ?? "").hasSuffix("1980") {
                            self.PopMsgWithJustOK(msg: "Approved Date of Contract Cannot to be 1980 or emprty.")
                            
                            info.approvedate = ""
                        }
                    }
                }
                
                
                //                print(info.ipadsignyn)
                let b = Bool(info.ipadsignyn ?? 0)
                if b && (info.status == CConstants.DisApprovedStatus) {
                    self.PopMsgWithJustOK(msg: CConstants.GoToBAMsg, txtField: nil)
                }
                setSendItema()
                
//                let sv =  SetDotValue()
                
                
                if let fDD = fileDotsDic {
                    
                    for (_, dots) in fDD {
//                       sv.setCloingMemoDots(info.closingMemo!, additionViews: dots, pdfview: self.pdfView!)
                        for n in dots {
//                             print(n.xname);
                            
                            switch n.xname {
                            case "address":
                                n.value = info.nproject ?? ""
                            case "CompanyName":
                                n.value = info.cianame ?? ""
                            case "buyer1_signdate", "seller_signdate":
                                if CConstants.ApprovedStatus == (info.status ?? ""){
                                    n.value = info.approvedate ?? ""
                                    
                                }
//                            case :
//                                if CConstants.ApprovedStatus == (info.status ?? "")
//                                n.value = info.approvedate ?? ""
                            case "buyer2_signdate":
                                if ((CConstants.ApprovedStatus == (info.status ?? "")) && ((self.contractPdfInfo?.client2 ?? "") != "")){
                                    n.value = info.approvedate ?? ""
                                }
                            case "titleyear":
                                n.value = info.approveyear!
                            case "titleday":
                                n.value = info.approveday!
                            case "titlemonth":
                                n.value = info.approvemonth!
                            case "buyer1":
                                n.value = self.contractPdfInfo?.client ?? ""
                            case "buyer2":
                                n.value = self.contractPdfInfo?.client2 ?? ""
                            case "buyer1phone":
                                n.value = self.contractPdfInfo?.boffice1 ?? ""
                            case "buyer2phone":
                                n.value = self.contractPdfInfo?.boffice2 ?? ""
                            case "buyer1fax":
                                n.value = self.contractPdfInfo?.bfax1 ?? ""
                            case "buyer2fax":
                                n.value = self.contractPdfInfo?.bfax2 ?? ""
                            case "buyer1cell":
                                n.value = self.contractPdfInfo?.bmobile1 ?? ""
                            case "buyer2cell":
                                n.value = self.contractPdfInfo?.bmobile2 ?? ""
                            case "buyer1email":
                                n.value = self.contractPdfInfo?.bemail1 ?? ""
                            case "buyer2email":
                                n.value = self.contractPdfInfo?.bemail2 ?? ""
                            case "otherbroker":
                                n.value = self.contractPdfInfo?.otherbroker ?? "";
                            case "otherbrokerpercentage":
                                n.value = self.contractPdfInfo?.otherbrokerpercentage ?? "";
                            case "sellerbrokerlicenseno":
                                n.value = self.contractPdfInfo?.sellerbrokerlicenseno ?? "";
                            case "sellerbroker":
                                n.value = self.contractPdfInfo?.sellerbroker ?? ""
                            case "buyerbrokercheck":
                                if (self.contractPdfInfo?.otherbroker ?? "") != "" {
                                    if let radio = n as? PDFFormButtonField {
                                        radio.setValue2("1")
                                    }
                                }
                                
                            case "sellerbrokercheck":
                                if let radio = n as? PDFFormButtonField {
                                    if radio.exportValue == "2" {
                                        radio.setValue2("1")
                                    }
                                }
                            case "purchasemethod":
                                if self.contractPdfInfo!.methodofpurchasecash! == 1 {
                                    if let radio = n as? PDFFormButtonField {
                                        if radio.exportValue == "1" {
                                            radio.setValue2("1")
                                        }else{
                                            radio.setValue2("0")
                                        }
                                    }
                                }else{
                                    if let radio = n as? PDFFormButtonField {
                                        if radio.exportValue == "1" {
                                            radio.setValue2("0")
                                        }else{
                                            radio.setValue2("1")
                                        }
                                    }
                                }
                                break;
                            case "owneroccupied":
                                if let radio = n as? PDFFormButtonField {
                                    radio.setValue2(self.contractPdfInfo!.unitclassificationowneroccupied! == 1 ? "1" : "0")
                                }
                                break;
                            case "investment":
                                if let radio = n as? PDFFormButtonField {
                                    radio.setValue2(self.contractPdfInfo!.unitclassificationownerinvestment! == 1 ? "1" : "0")
                                }
                                break;
                            case "titleday":
                                break;
                            case "titlemonth":
                                break;
                            case "titleyear":
                                break;
                            case "titlecompany":
                                break;
                            case "otherbrokerlicenseno":
                                n.value = self.contractPdfInfo?.otherbrokerlicenseno ?? ""
                            case "otherassociatename":
                                n.value = self.contractPdfInfo?.otherassociatename ?? ""
                            case "otherassociatetelephone":
                                n.value = self.contractPdfInfo?.otherassociatetel ?? ""
                            case "otherbrokeraddress1":
                                n.value = self.contractPdfInfo?.otherbrokeradd1 ?? ""
                            case "otherbrokeraddress2":
                                n.value = self.contractPdfInfo?.otherbrokeradd2 ?? ""
                            case "otherbrokeremail":
                                n.value = self.contractPdfInfo?.otherbrokeremail ?? ""
                            case "sellerassociatename":
                                n.value = self.contractPdfInfo?.sellerassociatename ?? ""
                            case "sellerassociatetelephone":
                                n.value = self.contractPdfInfo?.sellerassociatetel ?? ""
                            case "sellerbrokeraddress1":
                                n.value = self.contractPdfInfo?.sellerbrokeradd1
                            case "sellerbrokeraddress2":
                                n.value = self.contractPdfInfo?.sellerbrokeradd2
                            case "sellerbrokeremail":
                                n.value = self.contractPdfInfo?.sellerbrokeremail
                            case "buyers":
                                n.value = self.contractPdfInfo?.client ?? ""
                                if let x = self.contractPdfInfo?.client2 {
                                    if x != "" {
                                        n.value = n.value + " / " + x
                                    }
                                }
                            case "buyersphone":
                                n.value = self.contractPdfInfo?.bmobile1 ?? ""
                                if let x = self.contractPdfInfo?.bmobile2 {
                                    if x != "" {
                                        n.value = n.value + " / " + x
                                    }
                                }
                            case "unitno":
                                n.value = self.contractPdfInfo?.unitnumber ?? ""
                            case "seller":
                                n.value = self.contractPdfInfo?.sales ?? ""
                            case "siteselection":
                                n.value = self.contractPdfInfo?.siteselectionpremium ?? ""
                            case "houseprice":
                                n.value = self.contractPdfInfo?.houseprice ?? ""
                            case "line1":
                                n.value = self.contractPdfInfo?.attachline1 ?? ""
                            case "line2":
                                n.value = self.contractPdfInfo?.attachline2 ?? ""
                            case "line3":
                                n.value = self.contractPdfInfo?.attachline3 ?? ""
                            case "line4":
                                n.value = self.contractPdfInfo?.attachline4 ?? ""
                            case "line5":
                                n.value = self.contractPdfInfo?.attachline5 ?? ""
                            case "line6":
                                n.value = self.contractPdfInfo?.attachline6 ?? ""
                            case "line7":
                                n.value = self.contractPdfInfo?.attachline7 ?? ""
                            case "line8":
                                n.value = self.contractPdfInfo?.attachline8 ?? ""
                            case "line9":
                                n.value = self.contractPdfInfo?.attachline9 ?? ""
                            case "line10":
                                n.value = self.contractPdfInfo?.attachline10 ?? ""
                            case "line11":
                                n.value = self.contractPdfInfo?.attachline11 ?? ""
                            case "line12":
                                n.value = self.contractPdfInfo?.attachline12 ?? ""
                            case "line13":
                                n.value = self.contractPdfInfo?.attachline13 ?? ""
                            case "mline1":
                                n.value = self.contractPdfInfo?.attachline1m ?? ""
                            case "mline2":
                                n.value = self.contractPdfInfo?.attachline2m ?? ""
                            case "mline3":
                                n.value = self.contractPdfInfo?.attachline3m ?? ""
                            case "mline4":
                                n.value = self.contractPdfInfo?.attachline4m ?? ""
                            case "mline5":
                                n.value = self.contractPdfInfo?.attachline5m ?? ""
                            case "mline6":
                                n.value = self.contractPdfInfo?.attachline6m ?? ""
                            case "mline7":
                                n.value = self.contractPdfInfo?.attachline7m ?? ""
                            case "mline8":
                                n.value = self.contractPdfInfo?.attachline8m ?? ""
                            case "mline9":
                                n.value = self.contractPdfInfo?.attachline9m ?? ""
                            case "mline10":
                                n.value = self.contractPdfInfo?.attachline10m ?? ""
                            case "mline11":
                                n.value = self.contractPdfInfo?.attachline11m ?? ""
                            case "mline12":
                                n.value = self.contractPdfInfo?.attachline12m ?? ""
                            case "mline13":
                                n.value = self.contractPdfInfo?.attachline13m ?? ""
                            case "SpecialProvision1":
                                n.value = self.contractPdfInfo?.SpecialProvision1 ?? "";
                            case "SpecialProvision2":
                                n.value = self.contractPdfInfo?.SpecialProvision2 ?? "";
                            case "SpecialProvision3":
                                n.value = self.contractPdfInfo?.SpecialProvision3 ?? "";
                            case "SpecialProvision5":
                                n.value = self.contractPdfInfo?.SpecialProvision5 ?? "";
                            case "SpecialProvision6":
                                n.value = self.contractPdfInfo?.SpecialProvision6 ?? "";
                            case "SpecialProvision4":
                                n.value = self.contractPdfInfo?.SpecialProvision4 ?? "";
                            case "totalpayment":
                                n.value = self.contractPdfInfo?.totalpayment ?? "";
                            case "etotal":
                                n.value = self.contractPdfInfo?.exbitetotalpayment ?? "";
                            case "deposit":
                                n.value = self.contractPdfInfo?.totaldeposit ?? "";
                            case "totalpurchaseprice":
                                n.value = self.contractPdfInfo?.totalpurchaseprice ?? ""
                            default:
                                break;
                            }
                        }
                    }
                }
                
            }
            
        }
        
    }
    
    
    
  
    
    var filesArray : [String]?
    var fileDotsDic : [String : [PDFWidgetAnnotationView]]?
    
    fileprivate func getFileName() -> String{
        return "contract1pdf_" + self.pdfInfo0!.idcity! + "_" + self.pdfInfo0!.idcia!
    }
    
    override func loadPDFView(){
        
        var filesNames = [String]()
        let param = ContractRequestItem(contractInfo: nil).DictionaryFromBasePdf(self.pdfInfo0!)
        //print(param)
        
        let margins = getMargins()
        
        documents = [PDFDocument]()
        fileDotsDic = [String : [PDFWidgetAnnotationView]]()
        var allAdditionViews = [PDFWidgetAnnotationView]()
        
       
        
       self.callService(param: param)
        
        let str : String = "springdale"
        
     
        
        
       
        
        filesNames.append(str)
        
        let document = PDFDocument.init(resource: str)
        document?.pdfName = "springdale"
        documents?.append(document!)
        
        //            print(CGFloat(lastheight))
        
        if let additionViews = document?.forms.createWidgetAnnotationViewsForSuperview(withWidth: view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin: 0) as? [PDFWidgetAnnotationView]{
            
            
            fileDotsDic!["springdale"] = additionViews
            
            
            allAdditionViews.append( contentsOf: additionViews)
        }
        
        
        
        pdfView = PDFView(frame: view2.bounds, dataOrPathArray: ["springdale"], additionViews: allAdditionViews)
        
        
        view2.addSubview(pdfView!)
        getSignature()
        
        getAllSignature()
        
        
        
    }
    
    
    fileprivate func setSendItema(){
        self.showSkipToNext()
        if let _ = self.contractPdfInfo {
            seller2Item.title = ""
            if contractPdfInfo!.status == CConstants.ForApproveStatus {
                sendItem.image = nil
                seller2Item.title = "Status: \(CConstants.ForApproveStatus)"
            }else if contractPdfInfo!.status == CConstants.DisApprovedStatus {
                sendItem.image = nil
                seller2Item.title = "Status: \(CConstants.DisApprovedStatus)"
            }else if contractPdfInfo!.status == CConstants.ApprovedStatus {
                if let ds = self.contractPdfInfo?.signfinishdate {
                    if  ds != "01/01/1980"{
                        sendItem.image = nil
                        seller2Item.title = "Status: Finished"
                        let userInfo = UserDefaults.standard
                        if (userInfo.string(forKey: CConstants.UserInfoEmail) ?? "").lowercased() == CConstants.Administrator {
                            seller2Item.title = "Re-Create PDF"
                            sendItem.image = UIImage(named: "send.png")
                        }else{
                            sendItem.image = UIImage(named: "send.png")
                        }
                        
                    }else{
                        if let fs = self.contractPdfInfo?.approvedate {
                            if fs == "" || fs.hasSuffix("1980"){
                                seller2Item.title = nil
                                sendItem.image = nil
                            }else{
                                seller2Item.title = nil
                                sendItem.image = UIImage(named: "send.png")
                            }
                        }else{
                            seller2Item.title = nil
                            sendItem.image = nil
                        }
                        
                    }
                }
            }else{
                if let info = contractPdfInfo {
                    if info.status == CConstants.EmailSignedStatus {
                        if info.ipadsignyn != 1 {
                            if info.client2 == "" {
                                if info.verify_code != "" && info.buyer1SignFinishedyn != 1 {
                                    seller2Item.title = "Waiting for Email Sign"
                                    sendItem.image = UIImage(named: "send.png")
                                }else{
                                    seller2Item.title = nil
                                    sendItem.image = UIImage(named: "send.png")
                                }
                            }else{
                                if info.verify_code != "" && info.buyer1SignFinishedyn != 1 || info.verify_code2 != "" && info.buyer2SignFinishedyn != 1{
                                    seller2Item.title = "Waiting for Email Sign"
                                    sendItem.image = UIImage(named: "send.png")
                                }else{
                                    seller2Item.title = nil
                                    sendItem.image = UIImage(named: "send.png")
                                }
                            }
                        }else{
                            seller2Item.title = nil
                            sendItem.image = UIImage(named: "send.png")
                        }
                    }else{
                        seller2Item.title = nil
                        sendItem.image = UIImage(named: "send.png")
                    }
                    
                    
                }
                
            }
        }else{
            seller2Item.title = nil
            sendItem.image = nil
        }
        
    }
    
    
    fileprivate func showSkipToNext(){
        if let list = self.navigationItem.leftBarButtonItems {
            if list.count >= 3 {
                let b1 = list[1]
                let b2 = list[2]
                
//                let tp = toolpdf()
                if let _ = contractPdfInfo {
                    if  contractPdfInfo?.status == CConstants.ApprovedStatus && contractPdfInfo?.signfinishdate ?? "" == "01/01/1980" {
                        //                let (n3, _) = tp.CheckSellerFinish(self.fileDotsDic, documents: self.documents)
                        //                tvc.showSellerGoToSign = !n3
                        b2.title = ""
                        b1.title = "Next"
                        //                        print(contractPdfInfo?.approvedate?.hasSuffix("1980"))
                        if let a = contractPdfInfo?.approvedate {
                            if a.hasSuffix("1980") || a == "" {
                                b2.title = ""
                                b1.title = ""
                            }
                        }
                    }else if  contractPdfInfo?.status == CConstants.ForApproveStatus || contractPdfInfo?.status == CConstants.DisApprovedStatus{
                        b2.title = ""
                        b1.title = ""
                        
                    }else{
                        if self.contractPdfInfo?.buyer1SignFinishedyn == 1
                            || self.contractPdfInfo?.verify_code != ""{
                            b1.title = ""
                        }else{
                            let (n, _) = CheckBuyerFinish( isbuyer1: true)
                            b1.title = !n ? "Next B-1" : ""
                        }
                        
                        if self.contractPdfInfo?.client2 == ""
                            || self.contractPdfInfo?.buyer2SignFinishedyn == 1
                            || self.contractPdfInfo?.verify_code2 != ""
                        {
                            b2.title = ""
                        }else{
                            let (n1, _) = CheckBuyerFinish(isbuyer1: false)
                            b2.title = !n1 ? "Next B-2" : ""
                        }
                        
                    }
                }else{
                    b1.title = ""
                    b2.title = ""
                }
            }
        }
    }
    
    func CheckBuyerFinish(isbuyer1: Bool) -> (Bool, SignatureView?) {
        
        let tp = toolpdf()
        let tmpa = isbuyer1 ? tp.pdfSpringDaleBuyer1SignatureFields: tp.pdfSpringDaleBuyer2SignatureFields
        
        let alldots = self.fileDotsDic!["springdale"]

        for tmp in tmpa {
            for c in alldots! {
                if let a = c as? SignatureView {
                    if tmp == a.xname {
                        if !(a.lineArray != nil && a.lineArray.count > 0 && a.lineWidth != 0.0){
                            return (false, a)
                        }
                    }
                }
            }
        }
        
        return (true, nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSendItema()
        
        let userinfo = UserDefaults.standard
        userinfo.set(0, forKey: "ClearDraftInfo")
        if userinfo.bool(forKey: CConstants.UserInfoIsContract) {
            self.navigationItem.title = "Contract"
            
            
        }else{
            self.navigationItem.title = "Draft"
        }
        
        
        self.title = self.contractInfo?.nproject ?? "PDF"
        
        
    }
    
    
    // MARK: Request Data
    fileprivate func callService(param: [String: String]){
//                print(param)
        let serviceUrl = "bacontract_springdaleInfo1.json";
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.labelText = CConstants.RequestMsg
        Alamofire.request((CConstants.ServerURL + serviceUrl),
                          method: .post,
                          parameters: param).responseJSON{ (response) -> Void in
                            hud?.hide(true)
                            if response.result.isSuccess {
                                if let rtnValue = response.result.value as? [String: AnyObject]{
//                                    print(response.result.value)
                                    if let msg = rtnValue["message"] as? String{
                                        if msg.isEmpty{
                                            self.contractPdfInfo = ContractSpringDaleInfo(dicInfo: rtnValue)
                                            if let cl = rtnValue["closingMemo"] as? [String: AnyObject] {
                                                self.contractPdfInfo?.closingMemo = ContractClosingMemo(dicInfo: cl)
                                                let sv =  SetDotValue()
                                                
                                                
                                                if let fDD = self.fileDotsDic {
                                                    
                                                    for (_, dots) in fDD {
                                                        
                                                    sv.setCloingMemoDots(self.contractPdfInfo?.closingMemo!, additionViews: dots, pdfview: self.pdfView!)
                                                        
                                                    }
                                                    
                                                }
                                            }
                                            
                                        }else{
                                            self.PopMsgWithJustOK(msg: msg)
                                        }
                                    }else{
                                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                    }
                                }else{
                                    self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                }
                            }else{
                                //                            self.spinner?.stopAnimating()
                                self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                            }
        }
        
    }
    
    @IBOutlet var sendItem: UIBarButtonItem!
    
    
    var senderItem : UIBarButtonItem?
    
    @IBAction func BuyerSign(_ sender: UIBarButtonItem) {
        return
    }
    
    func afterGotofield(){
        if let sender = senderItem {
            
            
            if fileDotsDic != nil {
                for (_, v) in fileDotsDic! {
                    for a in v {
                        if let sign = a as? SignatureView {
                            
                            //                        print(b.tag, b.superview)
                            if !sign.superview!.bounds.intersects(sign.frame) {
                                continue
                            }
                            
                            if sender.tag==3 && sign.xname == "seller2Sign"
                                || sender.tag==4 && sign.xname == "seller3Sign" {
                                sign.toSignautre()
                                return
                            }
                            //                          print(sign.xname)
                            if sender.tag == 1 && sign.xname.hasSuffix("bottom1")
                                || sender.tag == 2 && sign.xname.hasSuffix("bottom2")
                                || sender.tag == 3 && sign.xname.hasSuffix("bottom3"){
//                                || sender.tag == 4 && sign.xname.hasSuffix("bottom4"){
                                //buyer1
                                sign.toSignautre()
                                return
                            }
                            if sender.tag == 1 && sign.xname == ("buyer2Sign")
                                || sender.tag == 2  && sender.title != "Date1" && sign.xname == ("buyer3Sign")
                                || sender.tag == 2  && sender.title == "Date1" && sign.xname.hasSuffix("buyer2DateSign")
                                || sender.tag == 4 && sign.xname == ("Exhibitbp1seller3Sign"){
                                sign.toSignautre()
                                return
                            }
                            
                            if self.title == CConstants.ActionTitleAddendumHOA {
                                continue
                            }
                        }
                        
                    }
                }
            }
        }
        
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //        print(scrollView.contentOffset.y / scrollView.bounds.size.height)
    }
    
    
    @IBAction func  SellerSign(_ sender: UIBarButtonItem) {
        //        BuyerSign(sender)
        if sender.title != "" && (sender.title ?? "").hasPrefix("Re") {
            self.saveToServer1(2)
        }
    }
    @IBOutlet var seller2Item: UIBarButtonItem!
    func setBuyer2(){
        var showBuyer2 = false;
        var showBuyer1 = true
        if let contract = self.contractPdfInfo {
            if contract.client2! != "" {
                showBuyer2 = true;
            }
            if contract.verify_code2 != "" {
                showBuyer2 = false
            }
            
            if contract.verify_code != "" {
                showBuyer1 = false
            }
            if contract.buyer1SignFinishedyn == 1 {
                showBuyer1 = false
            }
            
            if contract.buyer2SignFinishedyn == 1 {
                showBuyer2 = false
            }
        }
        
        var alldots = [PDFWidgetAnnotationView]()
        if let fileDotsDic1 = fileDotsDic{
            for (_,allAdditionViews) in fileDotsDic1 {
                alldots.append(contentsOf: allAdditionViews)
            }
        }
        for doc in documents!{
            if let a = doc.addedviewss as? [PDFWidgetAnnotationView]{
                alldots.append(contentsOf: a)
            }
        }
        
      
        for sign in alldots {
            if sign.isKind(of: SignatureView.self) {
                if let si = sign as? SignatureView {
                    if contractInfo?.status != CConstants.ApprovedStatus {
                        if si.xname.contains("seller")
                            || si.xname.contains("bottom3"){
                            continue
                        }
                        
                    }else{
                       if (si.xname.contains("buyer")
                            || si.xname.contains("bottom1")
                            || si.xname.contains("bottom2")){
                            continue
                        }
                    }
                    //
                    // remove seller2's signature
                    
                    if !showBuyer2{
                        if si.xname.hasSuffix("bottom2")
                            || si.xname.hasSuffix("buyer2Sign")
                            
                        {
                            if si.menubtn != nil {
                                si.menubtn.removeFromSuperview()
                                si.menubtn = nil
                            }
                            continue
                        }
                    }
                    
                    if !showBuyer1 {
                        if (isBuyer1Sign(si)){
                            if si.menubtn != nil {
                                si.menubtn.removeFromSuperview()
                                si.menubtn = nil
                            }
                            continue
                        }
                    }
                    
                    si.pdfViewsssss = pdfView!
                    if contractPdfInfo?.status ?? "" == CConstants.DraftStatus
                        || contractPdfInfo?.status ?? "" == "Email Sign"
                        || (contractPdfInfo?.status ?? "" == CConstants.ApprovedStatus
                            && contractPdfInfo?.signfinishdate ?? "" == "01/01/1980"
                            && !(contractPdfInfo?.approvedate?.hasSuffix("1980") ?? true)) {
                        si.addSignautre(pdfView!.pdfView!.scrollView)
                    }
                }
            }
        }
    }
    func isBuyer1Sign(_ sign : SignatureView) -> Bool{
         let tlpdf = toolpdf()
        if tlpdf.pdfSpringDaleBuyer1SignatureFields.contains(sign.xname) {
            return true
        }
        return false
    }
    
    func isBuyer2Sign(_ sign : SignatureView) -> Bool{
        let tlpdf = toolpdf()
        if tlpdf.pdfSpringDaleBuyer2SignatureFields.contains(sign.xname) {
            return true
        }
        return false
        
    }
    
//    func isSellerSign(_ sign : SignatureView) -> Bool{
//        let tlpdf = toolpdf()
//        if tlpdf.pdfSpringDaleSeller1SignatureFields.contains(sign.xname) {
//            return true
//        }
//        return false
//    }
    
    
    var selfSignatureViews: [SignatureView]?
    func getAllSignature(){
        if selfSignatureViews == nil {
            selfSignatureViews = [SignatureView]()
        }else {
            return
        }
        if let dots = pdfView?.pdfWidgetAnnotationViews {
            for d in dots{
                if let sign = d as? SignatureView {
                    selfSignatureViews?.append(sign)
                }
            }
        }
        for doc in documents! {
            if let dd = doc.addedviewss {
                for d in dd{
                    if let sign = d as? SignatureView {
                        selfSignatureViews?.append(sign)
                    }
                }
            }
        }
        if selfSignatureViews?.count > 0 {
            selfSignatureViews?.sort(){
                if $1.frame.origin.y != $0.frame.origin.y {
                    return $1.frame.origin.y > $0.frame.origin.y
                }else{
                    return $1.frame.origin.x > $0.frame.origin.x
                }
            }
        }
        
        
        
        
        
    }
    
    
    override func startover() {
        let msg : String
        if self.contractPdfInfo?.status == CConstants.ApprovedStatus {
            msg = "Are you sure you want to Start Over?"
        }else{
            if self.contractPdfInfo?.buyer1SignFinishedyn == 1 {
                msg = "Buyer1's Sign have submitted, this operation will just clean buyer2's sign. Are you sure you want to Start Over?"
            }else if self.contractPdfInfo?.buyer2SignFinishedyn == 1 {
                msg = "Buyer2's Sign have submitted, this operation will just clean buyer1's sign. Are you sure you want to Start Over?"
            }else if self.contractPdfInfo?.verify_code2 != "" {
                msg = "This operation will just clean buyer1's sign. Are you sure you want to Start Over?"
            }else if self.contractPdfInfo?.verify_code != "" {
                msg = "This operation will just clean buyer2's sign. Are you sure you want to Start Over?"
            }else{
                msg = "Are you sure you want to Start Over?"
            }
        }
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg, preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            //Do some stufrf
            
            
            for doc in self.documents! {
                if let dd = doc.addedviewss {
                    for d in dd{
                        if let sign = d as? SignatureView {
                            if self.contractPdfInfo?.status != CConstants.ApprovedStatus {
                                if self.contractPdfInfo?.buyer2SignFinishedyn == 1 || self.contractPdfInfo?.verify_code2 != ""{
                                    if !self.isBuyer2Sign(sign) {
                                        
                                        //                                        print(sign.xname)
                                        self.clearSignature(sign)
                                    }
                                }else if self.contractPdfInfo?.buyer1SignFinishedyn == 1 || self.contractPdfInfo?.verify_code != "" {
                                    if !self.isBuyer1Sign(sign) {
                                        self.clearSignature(sign)
                                    }
                                }else{
                                    self.clearSignature(sign)
                                }
                            }else{
                                self.clearSignature(sign)
                            }
                            
                        }
                    }
                }
                
                
            }
            if let fDD = self.fileDotsDic {
                
                
                for (_, dots) in fDD {
                    
                    for si in dots {
                        if let sign = si as? SignatureView{
                            if self.contractPdfInfo?.status != CConstants.ApprovedStatus {
                                if self.contractPdfInfo?.buyer2SignFinishedyn == 1 || self.contractPdfInfo?.verify_code2 != ""{
                                    if !self.isBuyer2Sign(sign) {
                                        self.clearSignature(sign)
                                    }
                                }else if self.contractPdfInfo?.buyer1SignFinishedyn == 1 || self.contractPdfInfo?.verify_code != ""{
                                    if !self.isBuyer1Sign(sign) {
                                        self.clearSignature(sign)
                                    }
                                }else{
                                    self.clearSignature(sign)
                                }
                            }else{
                                self.clearSignature(sign)
                            }
                            
                        }
                    }
                }
            }
            if self.contractInfo!.status! == CConstants.ApprovedStatus {
                self.initial_s1 = nil
                self.initial_s1yn = nil
                self.signature_s1yn = nil
                self.signature_s1 = nil
            }else{
                if self.contractPdfInfo?.buyer2SignFinishedyn == 1 {
                    self.initial_b1 = nil
                    self.initial_s1 = nil
                    self.initial_b1yn = nil
                    self.initial_s1yn = nil
                    self.signature_b1yn = nil
                    self.signature_s1yn = nil
                    self.signature_b1 = nil
                    self.signature_s1 = nil
                    self.initial_index = nil
                }else if self.contractPdfInfo?.buyer1SignFinishedyn == 1 {
                    self.initial_b2 = nil
                    self.initial_b2yn = nil
                    self.signature_b1yn = nil
                    self.signature_b2yn = nil
                    self.initial_s1 = nil
                    self.initial_s1yn = nil
                    self.signature_s1yn = nil
                    self.signature_s1 = nil
                    self.signature_b2 = nil
                }else{
                    self.initial_b1 = nil
                    self.initial_b2 = nil
                    self.initial_s1 = nil
                    self.initial_b1yn = nil
                    self.initial_b2yn = nil
                    self.initial_s1yn = nil
                    self.signature_b1yn = nil
                    self.signature_b2yn = nil
                    self.signature_s1yn = nil
                    self.signature_b1 = nil
                    self.signature_b2 = nil
                    self.signature_s1 = nil
                    self.initial_index = nil
                }
                
                
            }
            
        }
        alert.addAction(oKAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    fileprivate func clearSignature(_ sign : SignatureView){
        if self.contractInfo!.status! == CConstants.ApprovedStatus {
            if sign.xname.hasSuffix("bottom3") || sign.xname.hasSuffix("seller1Sign") {
                if (sign.lineArray != nil){
                    sign.lineArray = nil
                    sign.lineWidth = 0.0
                    sign.showornot = true
                    if sign.menubtn != nil {
                        sign.superview?.addSubview(sign.menubtn)
                    }else{
                        sign.addSignautre(self.pdfView!.pdfView!.scrollView)
                    }
                    
                }
            }
        }else{
            if (sign.lineArray != nil){
                sign.lineArray = nil
                sign.lineWidth = 0.0
                sign.showornot = true
                if sign.menubtn != nil {
                    sign.superview?.addSubview(sign.menubtn)
                }else{
                    sign.addSignautre(self.pdfView!.pdfView!.scrollView)
                }
                
            }
            
        }
    }
    
    
    
    override func clearDraftInfo() {
        let userInfo = UserDefaults.standard
        userInfo.set(1, forKey: "ClearDraftInfo")
        
        
        if self.contractPdfInfo != nil {
            let bmobile = self.contractPdfInfo?.bmobile1!
            let bemail = self.contractPdfInfo?.bemail1
            let client = self.contractPdfInfo?.client
            let client2 = self.contractPdfInfo?.client2
//            let tobuyer2 = self.contractPdfInfo?.tobuyer2
            
            self.contractPdfInfo?.bmobile1 = ""
            self.contractPdfInfo?.bemail1 = ""
            self.contractPdfInfo?.client2 = ""
            self.contractPdfInfo?.client = ""
//            self.contractPdfInfo?.tobuyer2 = ""
            self.contractPdfInfo = self.contractPdfInfo!
            self.contractPdfInfo?.bmobile1 = bmobile
            self.contractPdfInfo?.bemail1 = bemail
            self.contractPdfInfo?.client2 = client2
            self.contractPdfInfo?.client = client
//            self.contractPdfInfo?.tobuyer2 = tobuyer2
        }
        
    }
    
    override func fillDraftInfo() {
        let userInfo = UserDefaults.standard
        userInfo.set(0, forKey: "ClearDraftInfo")
        
      
        if self.contractPdfInfo != nil {
            self.contractPdfInfo = self.contractPdfInfo!
        }
        
    }
    
    let hoapage1fields = ["p1Hhoa1Sign3",
                          "p1Hhoa2Sign3",
                          "p1Hhoa3Sign3",
                          "p1Hhoa3aSign3",
                          "p1Hhoa3bSign3",
                          "p1Hhoa4Sign3",
                          "p1Hhoa4aSign3",
                          "p1Hhoa4bSign3",
                          "p1Hhoa4cSign3",
                          "p1Hhoa4dSign3",
                          "p1Hhoa4eSign3",
                          "p1Hhoa5Sign3",
                          "p1Hhoa6Sign3",
                          "p1Hhoa6aSign3"]
    let hoapage2fields = ["p2Hhoa6bSign3",
                          "p2Hhoa6cSign3",
                          "p2Hhoa6dSign3",
                          "p2Hhoa6eSign3",
                          "p2Hhoa6fSign3",
                          "p2Hhoa6gSign3",
                          "p2Hhoa6hSign3",
                          "p2Hhoa6iSign3",
                          "p2Hhoa7Sign3",
                          "p2Hhoa8Sign3",
                          "p2Hhoa9Sign3",
                          "p2Hhoa10Sign3",
                          "p2Hhoa11Sign3"]
    let hoapage3fields = ["p3Hhoa12Sign3",
                          "p3Hhoa12aSign3",
                          "p3Hhoa12bSign3",
                          "p3Hhoa13Sign3",
                          "p3Hhoa14Sign3",
                          "p3Hhoa15Sign3",
                          "p3Hhoa16Sign3"]
    
    fileprivate func getPDFSignaturePrefix() -> [[String]]{
        let contractP = ["p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9"]
        let thirdParty = ["p1T3", "p2T3"]
        let InforBroker = ["p1I", "p2I"]
        var addendumA : [String] = [String]()
        for i in 1...6 {
            addendumA.append("p\(i)A")
        }
        let EA = ["p1EA"]
        let EB = ["p1EB"]
        let EC = ["p1EC", "p2EC", "p3EC"]
        var BuyerE : [String] = [String]()
        for i in 1...5 {
            BuyerE.append("p\(i)B")
        }
        let AC = ["p1AC", "p2AC"]
        let AD = ["p1AD", "p2AD"]
        let AE = ["p1AE", "p2AE"]
        let Flood = ["p1F", "p2F"]
        let Warraty = ["p1W", "p2W"]
        let Desgin = ["p1D"]
        let HOAC = ["p1H", "p2H", "p3H"]
        let AH = ["p1AH", "p2AH"]
        
        var nameArray = [[String]]()
        nameArray.append(contractP)
        nameArray.append(thirdParty)
        nameArray.append(InforBroker)
        nameArray.append(addendumA)
        nameArray.append(EA)
        nameArray.append(EB)
        nameArray.append(EC)
        nameArray.append(BuyerE)
        nameArray.append(AC)
        nameArray.append(AD)
        nameArray.append(AE)
        nameArray.append(Flood)
        nameArray.append(Warraty)
        nameArray.append(Desgin)
        nameArray.append(HOAC)
        nameArray.append(AH)
        return nameArray
    }
    override func saveToServer() {
        
        saveToServer1(0)
    }
    func saveToServer1(_ xtype: Int8) {
        
        var b1i : [[String]]?
        var b2i : [[String]]?
        var b1s : [[String]]?
        var b2s : [[String]]?
        var s1i : [[String]]?
        var s1s : [[String]]?
        
        var param = [String: String]()
        param["idcontract1"] = contractInfo?.idnumber
        
        var alldots = [PDFWidgetAnnotationView]()
        //                            if let a = self.pdfView?.pdfWidgetAnnotationViews as? [PDFWidgetAnnotationView]{
        //                                alldots.appendContentsOf(a)
        //                            }
        
        for (_,allAdditionViews) in self.fileDotsDic!{
            alldots.append(contentsOf: allAdditionViews)
        }
       
        for d in alldots{
            if let sign = d as? SignatureView {
                if sign.xname.hasSuffix("bottom1") {
                    if sign.lineArray != nil && sign.lineArray.count > 0 && sign.lineWidth > 0{
                        b1i = sign.lineArray as? [[String]]
                         break;
                        
                    }
                }
            }
        }
        for d in alldots{
            if let sign = d as? SignatureView {
                if sign.xname.hasSuffix("bottom2") {
                    if sign.lineArray != nil && sign.lineArray.count > 0 && sign.lineWidth > 0{
                        b2i = sign.lineArray as? [[String]]
                        break;
                    }
                    
                }
            }
        }
        for d in alldots{
            if let sign = d as? SignatureView {
                if sign.xname.hasSuffix("bottom3") {
                    if sign.lineArray != nil && sign.lineArray.count > 0 && sign.lineWidth > 0{
                        s1i = sign.lineArray as? [[String]]
                        break;
                    }
                    
                }
            }
        }
        for d in alldots{
            if let sign = d as? SignatureView {
                if sign.xname.hasSuffix("buyer1Sign") {
                    if sign.lineArray != nil && sign.lineArray.count > 0 && sign.lineWidth > 0{
                        b1s = sign.lineArray as? [[String]]
                        break;
                    }
                }
            }
        }
        for d in alldots{
            if let sign = d as? SignatureView {
                if sign.xname.hasSuffix("sellerSign")  {
                    if sign.lineArray != nil && sign.lineArray.count > 0 && sign.lineWidth > 0{
                        s1s = sign.lineArray as? [[String]]
                        break;
                    }
                
                }
            }
        }
        for d in alldots{
            if let sign = d as? SignatureView {
                if sign.xname.hasSuffix("buyer2Sign") {
                    
                    if sign.lineArray != nil && sign.lineArray.count > 0 && sign.lineWidth > 0{
                        b2s = sign.lineArray as? [[String]]
                        break;
                    }
                }
            }
        }
        
        
        if contractInfo!.status! == CConstants.ApprovedStatus {
            
            param["initial_b1"] = " "
            //        print(getStr(b1i))
            param["initial_b2"] = " "
            param["signature_b1"] = " "
            param["signature_b2"] = " "
            param["initial_s1"] = getStr(s1i)
            param["signature_s1"] = getStr(s1s)
            param["whichBuyer"] = "3"
        }else{
            
            param["initial_b1"] = getStr(b1i)
            param["initial_b2"] = getStr(b2i)
            param["signature_b1"] = getStr(b1s)
            param["signature_b2"] = getStr(b2s)
            param["initial_s1"] = " "
            param["signature_s1"] = " "
            if self.contractPdfInfo?.verify_code != "" {
                param["whichBuyer"] = "2"
            }else if contractPdfInfo?.verify_code2 != "" {
                param["whichBuyer"] = "1"
            }else{
                param["whichBuyer"] = "0"
            }
        }
        param["checked_photo"] = " "
        let reurl : String = "bacontract_save_springnalesign.json"
        
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud?.labelText = CConstants.SavedMsg
        
//        print(param)
        
        Alamofire.request(CConstants.ServerURL + reurl,
                          method: .post,
                          parameters: param).responseJSON{ (response) -> Void in
                            //                self.hud?.hide(true)
                            //                print(response.result.value)
                            if response.result.isSuccess {
                                if let rtnValue = response.result.value as? Bool{
                                    //                        print(rtnValue)
                                    if rtnValue {
                                        if xtype == 1 {
                                            self.submitStep0()
                                            self.hud?.mode = .text
                                            self.hud?.labelText = "Submitting for approve..."
                                            return
                                        }else if xtype == 2 || xtype == 3{
                                            self.saveAndFinish2(xtype)
                                            return
                                        }else if xtype == 4 {
                                            self.hud?.mode = .text
                                            self.hud?.labelText = "Submitting to Sever..."
                                            // submit buyer1's sign finishe.
                                            self.submitBuyerSignStep2(true)
                                        }else if xtype == 5 {
                                            self.hud?.mode = .text
                                            self.hud?.labelText = "Submitting to Sever..."
                                            // submit buyer2's sign finishe.
                                            self.submitBuyerSignStep2(false)
                                        }else{
                                            self.hud?.mode = .customView
                                            let image = UIImage(named: CConstants.SuccessImageNm)
                                            self.hud?.customView = UIImageView(image: image)
                                            
                                            self.hud?.labelText = CConstants.SavedSuccessMsg
                                        }
                                        
                                    }else{
                                        self.hud?.mode = .text
                                        self.hud?.labelText = CConstants.SavedFailMsg
                                    }
                                }else{
                                    self.hud?.mode = .text
                                    self.hud?.labelText = CConstants.MsgServerError
                                }
                            }else{
                                self.hud?.mode = .text
                                self.hud?.labelText = CConstants.MsgNetworkError
                            }
                            self.perform(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), with: nil, afterDelay: 0.5)
                            
        }
        
    }
    
    fileprivate func isCanSignature( sign: SignatureView
        , ynarr: [[String]]?, inarr: String?) {
       self.setShowSignature(sign, signs: inarr!, idcator: "1")
    }
    
    fileprivate func getStr(_ h : [[String]]?) -> String {
        if let a = h {
            var s : [String] = [String]()
            for n in a {
                s.append(n.joined(separator: "|"))
            }
            return s.joined(separator: ";")
        }else{
            return " "
        }
    }
    
    fileprivate func getArr(_ str: String) -> [[String]] {
        
        return (str.replacingOccurrences(of: " ", with: "")).components(separatedBy: ";").map(){$0.components(separatedBy: "|")}
    }
    
    var initial_b1yn : [[String]]?
    var initial_b2yn : [[String]]?
    var signature_b1yn : [[String]]?
    var signature_b2yn : [[String]]?
    
    var initial_s1yn : [[String]]?
    var signature_s1yn : [[String]]?
    
    var initial_index : [[String]]?
    
    var initial_b1 : String?
    var initial_b2 : String?
    var signature_b1 : String?
    var signature_b2 : String?
    
    var initial_s1 : String?
    var signature_s1 : String?
    
    
    func getSignature(){
        //        print(["idcontract1" : self.contractInfo!.idnumber!])
        
        
        var serviceURL = "bacontract_GetSpringnaleSignedContract.json"
        
        
        Alamofire.request(CConstants.ServerURL + serviceURL, method: .post,
                          parameters: ["idcontract1" : self.contractInfo!.idnumber!]).responseJSON{ (response) -> Void in
                            //                hud.hide(true)
                            if response.result.isSuccess {
                                //                    print(response.result.value)
                                if let rtnValue = response.result.value as? [String: AnyObject]{
                                    
                                    let rtn = SignatrureFields(dicInfo: rtnValue)
                                    self.initial_b1 = rtn.initial_b1
                                    //                            print(self.initial_b1!)
                                    self.initial_b2 = rtn.initial_b2
                                    self.signature_b1 = rtn.signature_b1
                                    self.signature_b2 = rtn.signature_b2
                                    self.initial_s1 = rtn.initial_s1
                                    self.signature_s1 = rtn.signature_s1
                                    var alldots = [PDFWidgetAnnotationView]()
                                    //                            if let a = self.pdfView?.pdfWidgetAnnotationViews as? [PDFWidgetAnnotationView]{
                                    //                                alldots.appendContentsOf(a)
                                    //                            }
                                    
                                    for (_,allAdditionViews) in self.fileDotsDic!{
                                        alldots.append(contentsOf: allAdditionViews)
                                    }
                                    
                                    var showseller = true
                                    if let ss = self.contractInfo?.status {
                                        showseller =  ss == CConstants.ApprovedStatus
                                    }
//                                    let tp = toolpdf()
                                    for d in alldots{
                                        if let sign = d as? SignatureView {
                                            if sign.xname.hasSuffix("bottom1") || sign.xname.contains("Sign3") {
                                                self.isCanSignature(sign: sign, ynarr: self.initial_b1yn, inarr: self.initial_b1)
                                            }else if sign.xname.hasSuffix("bottom2") {
                                                //                                        print(sign.xname)
                                                if self.contractInfo!.client2! != "" {
                                                    self.isCanSignature(sign: sign, ynarr: self.initial_b2yn, inarr: self.initial_b2)
                                                }
                                            }else if sign.xname.hasSuffix("bottom3") && showseller {
                                                self.isCanSignature(sign: sign, ynarr: self.initial_s1yn, inarr: self.initial_s1)
                                                
                                            }else if sign.xname.hasSuffix("buyer1Sign") {
                                                self.isCanSignature(sign: sign, ynarr: self.signature_b1yn, inarr: self.signature_b1)
                                            }else if sign.xname.hasSuffix("sellerSign") && showseller {
                                                self.isCanSignature(sign: sign, ynarr: self.signature_s1yn, inarr: self.signature_s1)
                                            }else if sign.xname.hasSuffix("buyer2Sign") {
                                                
                                                if self.contractInfo!.client2! != "" {
                                                    self.isCanSignature(sign: sign, ynarr: self.signature_b2yn, inarr: self.signature_b2)
                                                }
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                   
                                    
                                }else{
                                    self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                }
                            }else{
                                self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                            }
        }
        
    }
    
    fileprivate func setShowSignature(_ si: SignatureView, signs signsx: String, idcator : String) {
        
        //        if si.xname == "p1EBbottom2" {
        //        print(signsx)
        //        }
        let signs = signsx
        if signs == "" {
            return
        }
        //        let signa = signs.components(separatedBy: ";").map(){$0.components(separatedBy: "|")}
        let n = NSMutableArray();
        for a in signs.components(separatedBy: ";") {
            let n1 = NSMutableArray();
            for b in a.components(separatedBy: "|") {
                n1.add(b)
            }
            n.add(n1)
        }
        
        //        print(signa)
        si.frame = si.frame
        //         print(si.frame)
        let ct = si.frame
        var ct2 = ct
        ct2.origin.x = 0.0
        ct2.origin.y = 0.0
        si.frame = ct2
        si.frame = ct
        si.lineArray = si.getNewOriginLine(n)
        si.lineArray = si.getNewOriginLine(si.lineArray as NSMutableArray)
        //        if si.xname == "p1EBbottom2" {
        //            print(si.lineArray)
        //        }
        let ct3 = si.getOriginFrame()
        //        ct3 = si.getOriginFrame()
        
        si.originWidth = Float(ct3.width)
        si.originHeight = Float(ct3.height)
        
        if idcator == "1" {
            si.lineWidth = 5.0
        }else{
            si.lineWidth = 0.0
        }
        
        
        
    }
    
    
    override func submit() {
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: "Do you want to submit for approval?", preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            //save signature to sever
            //            self.locked = true
            self.saveToServer1(1)
            
        }
        alert.addAction(oKAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    var SubmitRtn : [String : AnyObject]?
    
    func submitStep0() {
        // do submit for approve
        let userInfo = UserDefaults.standard
        
        //        print(["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? ""])
        
        
        
        Alamofire.request(CConstants.ServerURL + "bacontract_getSubmitForApproveEmail.json", method: .post,
                          parameters: ["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.string(forKey: CConstants.UserInfoEmail) ?? ""]).responseJSON{ (response) -> Void in
                            self.hud!.hide(true)
                            if response.result.isSuccess {
                                if let rtnValue = response.result.value as? [String: AnyObject]{
                                    //                        print(rtnValue)
                                    if rtnValue["result"] as? String ?? "-1" == "-1" {
                                        self.PopErrorMsgWithJustOK(msg: rtnValue["message"] as? String ?? "Server Error"){ action -> Void in
                                            
                                        }
                                    }else{
                                        self.SubmitRtn = rtnValue
                                        if self.contractInfo!.flood! == 1 {
                                            
                                            let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: "This requires flood acknowledgement signed.", preferredStyle: .alert)
                                            
                                            //Create and add the OK action
                                            let oKAction: UIAlertAction = UIAlertAction(title: "Continue", style: .default) { action -> Void in
                                                self.submitStep2()
                                            }
                                            alert.addAction(oKAction)
                                            
                                            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                            alert.addAction(cancelAction)
                                            
                                            //Present the AlertController
                                            self.present(alert, animated: true, completion: nil)
                                        }else{
                                            self.submitStep2()
                                        }
                                    }
                                    
                                }else{
                                    self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                }
                            }else{
                                //                            self.spinner?.stopAnimating()
                                self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                            }
        }
    }
    func submitStep2() {
        if self.contractInfo!.environment! == 1 {
            let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: "This requires environment acknowledgement signed.", preferredStyle: .alert)
            
            //Create and add the OK action
            let oKAction: UIAlertAction = UIAlertAction(title: "Continue", style: .default) { action -> Void in
                self.submitStep3()
                
                
                
            }
            alert.addAction(oKAction)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            //Present the AlertController
            self.present(alert, animated: true, completion: nil)
            
            
        }else{
            self.submitStep3()
        }
    }
    func submitStep3() {
        
        if let rtn = self.SubmitRtn {
            self.performSegue(withIdentifier: "showSubmit", sender: rtn)
        }
        //            "Please approve the following Contract."
        
        
        
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case CConstants.SegueToOperationsPopover:
            if self.seller2Item.title == "Status: Email Sign" {
                return false
            }
            if self.contractPdfInfo?.status == CConstants.ApprovedStatus {
                if let fs = self.contractPdfInfo?.approvedate {
                    if fs == "" || fs.hasSuffix("1980"){
                        return false
                    }
                }else{
                    return false
                }
            }
            
            
            return contractInfo!.status != CConstants.ForApproveStatus
        default:
            return true
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == constants.segueToSendEmailAfterApproved {
                if let con = segue.destination as? EmailAfterApprovedViewController {
                    con.contractInfo = self.contractInfo
                }
            }else if identifier == constants.segueToEmailContractToBuyer {
                if let con = segue.destination as? EmailContractToBuyerViewController {
                    con.contractInfo = self.contractPdfInfo
                    con.delegate = self
                }
                
            }else if identifier == "showSubmit" {
                if let controller = segue.destination as? SubmitForApproveViewController {
                    if let contrat = self.contractInfo, let rtn = sender as? [String: AnyObject] {
                        controller.delegate = self
                        controller.xtitle = "Contract - \(contrat.idnumber ?? "")"
                        controller.xtitle2 = "Project # \(contrat.idproject ?? "") ~ \(contrat.nproject ?? "" )"
                        controller.xemailList = rtn["list"] as? [String]
                        
                        controller.xdes = "Please approve the following Contract."
                    }
                }
            }else if identifier == "springfilelist" {
                self.dismiss(animated: true, completion: nil)
                if let controller = segue.destination as? GoToFileViewController {
                    controller.delegate = self
                    controller.printList = [
                        "First Page",
                    "BASIC TERMS",
                    "AGREEMENT OF SALE AND PURCHASE",
                    "TITLE COMPANY RECEIPT",
                    "EXHIBIT A",
                    "EXHIBIT B",
                    "EXHIBIT C",
                    "EXHIBIT D",
                    "ATTACHMENT 1",
                    "EXHIBIT E",
                    "EXHIBIT F",
                    "EXHIBIT G",
                    "EXHIBIT H",
                    "EXHIBIT I",
                    "EXHIBIT J",
                    "EXHIBIT K",
                    "EXHIBIT L",
                    "Closing Procedure",
                    "Indoor Air",
                    "HOA Checklist",
                    "Buyers constructions expectations"
                    ]
                }
            }else if identifier == "showAttachPhoto" {
                if let controller = segue.destination as? BigPictureViewController{
                    controller.imageUrl = URL(string: CConstants.ServerURL + "bacontract_photoCheck.json?ContractID=" + (self.contractInfo?.idnumber ?? ""))
//                    controller.contractPdfInfo = self.contractPdfInfo
                }
                
            }else if identifier == "showEmail" {
                if let controller = segue.destination as? SaveAndEmailViewController {
                    if let contrat = self.contractInfo {
                        controller.delegate = self
                        controller.xtitle = "Send Email"
                        controller.xtitle2 = "Project # \(contrat.idproject ?? "") ~ \(contrat.nproject ?? "" )"
                        var emailList : [String] = [String]()
                        if let email1 = contrat.buyer1email {
                            emailList.append(email1)
                        }
                        if let email1 = contrat.buyer2email {
                            emailList.append(email1)
                        }
//                        emailList.append("phalycak@kirbytitle.com")
//                        emailList.append("heatherb@kirbytitle.com")
                        if let realtorEmail = self.contractPdfInfo?.otherbrokeremail {
                            if realtorEmail != "" {
                                emailList.append(realtorEmail)
                            }
                        }
                        
                        
                        let userInfo = UserDefaults.standard
                        let email = userInfo.value(forKey: CConstants.UserInfoEmail) as? String
                        emailList.append(email ?? "")
                        controller.xemailList = emailList
                        controller.xemailcc = email ?? ""
                        controller.xdes = "This is the contract of your new house."
                    }
                }
            }else{
                if let identifier = segue.identifier {
                    switch identifier {
                    case "showoperations":
                        
                        self.dismiss(animated: true, completion: nil)
                        if let tvc = segue.destination as? SpringDaleOperationsViewController {
                            if let ppc = tvc.popoverPresentationController {
                                var showSave = false
                                var showSubmit = true
                                var isapproved = false
                                var fromWeb = false
                                var justShowEmail = false
                                
                                if let c = contractPdfInfo?.status {
                                    if c == CConstants.ApprovedStatus {
                                        isapproved = true
                                        
                                        if let ds = self.contractInfo?.signfinishdate {
                                            if  ds != "01/01/1980"  {
                                                justShowEmail = true
                                            }
                                        }
                                        
                                    }else if c == CConstants.EmailSignedStatus{
                                        fromWeb = true
                                    }else if c == CConstants.DraftStatus {
                                        var isHasFinish = CheckBuyerFinish(isbuyer1: true).0
                                        if (self.contractPdfInfo?.client2 ?? "") != "" {
                                            isHasFinish = isHasFinish &&  CheckBuyerFinish(isbuyer1: false).0
                                        }
                                        if isHasFinish{
                                            showSave = true
                                            showSubmit = true
                                        }else{
                                            showSave = false
                                            showSubmit = false
                                        }
                                    }
                                }
                                tvc.showStartOver = true
                                tvc.contractInfo = self.contractPdfInfo
                                tvc.justShowEmail = justShowEmail
                                tvc.isapproved = isapproved
                                tvc.FromWebSide = fromWeb
                                tvc.hasCheckedPhoto = contractPdfInfo?.hasCheckedPhoto ?? "0"
                                tvc.showSave = showSave
                                tvc.showSubmit = showSubmit
                                ppc.delegate = self
                                tvc.delegate1 = self
                            }
                        }
//                    case CConstants.SegueToPrintModelPopover:
//                        self.dismiss(animated: true, completion: nil)
//                        if let tvc = segue.destination as? PrintModelTableViewController {
//                            if let ppc = tvc.popoverPresentationController {
//                                ppc.delegate = self
//                                tvc.delegate = self
//                            }
//                        }
                    case CConstants.SegueToAddressModelPopover:
                        self.dismiss(animated: true, completion: nil)
                        if let tvc = segue.destination as? AddressListModelViewController {
                            if let ppc = tvc.popoverPresentationController {
                                ppc.delegate = self
                                tvc.delegate = self
                            }
                        }
                    default: break
                    }
                }
            }
        }
    }
    
    func GoToSubmit(_ email: String, emailcc: String, msg: String) {
        
        let userInfo = UserDefaults.standard
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        }
        hud?.labelText = "Submitting..."
        //
        
        var a =  ["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.string(forKey: CConstants.UserInfoEmail) ?? "", "emailto" : email, "emailcc": emailcc, "msg": msg]
        
        if (self.contractInfo!.idcia! == "9999") {
            a =  ["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.string(forKey: CConstants.UserInfoEmail) ?? "", "emailto" : "April Lv (April@buildersaccess.com)", "emailcc": "xiujun_85@163.com", "msg": msg]
        }
        
        
        Alamofire.request(CConstants.ServerURL + "bacontract_submitForApprove.json", method: .post,
                          parameters:a).responseJSON{ (response) -> Void in
                            //                hud.hide(true)
                            
                            if response.result.isSuccess {
                                if let rtnValue = response.result.value as? [String: AnyObject]{
                                    //                        print(rtnValue)
                                    if rtnValue["result"] as? String ?? "-1" == "-1" {
                                        self.hud?.hide(true)
                                        self.PopErrorMsgWithJustOK(msg: rtnValue["message"] as? String ?? "Sever Error") {
                                            (action : UIAlertAction) -> Void in
                                            
                                        }
                                    }else{
                                        self.contractInfo?.status = CConstants.ForApproveStatus
                                        self.contractPdfInfo?.status = CConstants.ForApproveStatus
                                        self.setSendItema()
                                        
                                        self.hud?.mode = .customView
                                        let image = UIImage(named: CConstants.SuccessImageNm)
                                        self.hud?.customView = UIImageView(image: image)
                                        
                                        self.hud?.labelText = "Submit successfully."
                                        self.perform(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), with: nil, afterDelay: 0.5)
                                    }
                                }else{
                                    self.hud?.mode = .text
                                    self.hud?.labelText = CConstants.SavedFailMsg
                                }
                            }else{
                                self.hud?.mode = .text
                                self.hud?.labelText = CConstants.MsgServerError
                            }
                            self.perform(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), with: nil, afterDelay: 0.5)
        }
    }
    
    override func saveFinish() {
        let (t, sign) =  self.CheckSellerFinish(self.fileDotsDic, documents: self.documents)
        if !t {
            self.PopMsgWithJustOK(msg: "Please finish all the required signature.", action1: { (_) in
                if let cg0 = sign?.center {
                    var cg = cg0
                    cg.x = 0
                    cg.y = cg.y - self.view.frame.height/2
                    if cg.y ?? 0 > 0 {
                        self.pdfView?.pdfView.scrollView.setContentOffset(cg, animated: false)
                    }
                }
            })
            return;
        }
        self.saveToServer1(2)
    }
    
    //    @IBOutlet var LaterWeb: UIWebView!
    func saveAndFinish2(_ xtype: Int8){
        //        self.savePDFToServer(fileName!, nextFunc: nil)
        
        //        func savePDFToServer(xname: String, nextFunc: String?){
        
        var parame : [String : String] = ["idcia" : pdfInfo0!.idcia!
            , "idproject" : pdfInfo0!.idproject!
            , "code" : pdfInfo0!.code!
            , "idcontract" : pdfInfo0!.idnumber ?? ""
            ,"filetype" : pdfInfo0?.nproject ?? "" + "_\(fileName!)_FromApp"]
        
        var savedPdfData: Data?
        print(self.documents)
//        savedPdfData = PDFDocument.mergedData(withDocuments: self.documents)
////        if self.documents != nil && self.documents?.count > 0 {
////
////        }else{
            if let added = pdfView?.addedAnnotationViews{
                //            print(added)
                savedPdfData = self.documents![0].savedStaticPDFData(added)
            }else{
                savedPdfData = self.documents![0].savedStaticPDFData()
            }
////        }
        
        let fileBase64String = savedPdfData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        //        print(fileBase64String)
        parame["username"] = UserDefaults.standard.value(forKey: CConstants.LoggedUserNameKey) as? String ?? ""
        //        print(parame)
        parame["file"] = fileBase64String
        
        if hud == nil {
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        hud?.labelText = CConstants.SavedMsg
        //                    print(parame)
        
        //        print(CConstants.ServerURL + CConstants.ContractUploadPdfURL)
        Alamofire.request(CConstants.ServerURL + CConstants.ContractUploadPdfURL, method: .post,
                          parameters: parame).responseJSON{ (response) -> Void in
                            //                                                print(response.result.value)
                            if response.result.isSuccess {
                                if let rtnValue = response.result.value as? [String: String]{
                                    if rtnValue["status"] == "success" {
                                        self.contractPdfInfo?.signfinishdate = "04/28/2016"
                                        self.contractInfo?.signfinishdate = "04/28/2016"
                                        self.setSendItema()
                                        self.hud?.mode = .customView
                                        let image = UIImage(named: CConstants.SuccessImageNm)
                                        self.hud?.customView = UIImageView(image: image)
                                        self.hud?.labelText = "Saved successfully and We have send an email to Kirbytitle company to sign."
                                        
                                        
                                        //                                self.pdfView?.removeFromSuperview()
                                        //                                self.view2.hidden = true
                                        //                                self.LaterWeb.hidden = false
                                        //                                self.LaterWeb.scalesPageToFit = true
                                        //                                self.LaterWeb.scrollView.bouncesZoom = false
                                        //
                                        ////                                _pdfView.scalesPageToFit = YES;
                                        ////                                _pdfView.scrollView.delegate = self;
                                        ////                                _pdfView.scrollView.bouncesZoom = NO;
                                        ////                                _pdfView.delegate = self;
                                        //                                self.LaterWeb.backgroundColor = UIColor.whiteColor()
                                        ////                                NSString *url = @"http://google.com?get=something&...";
                                        ////                                NSURL *nsUrl = [NSURL URLWithString:url];
                                        ////                                NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
                                        //
                                        //                                let url = "https://contractssl.buildersaccess.com/bacontract_contractDocument2?idcia=9999&idproject=100005"
                                        ////                                let blank = "about:blank"
                                        //                                if let nsurl = NSURL(string: url){
                                        //                                    let request = NSURLRequest(URL: nsurl)
                                        //                                    self.LaterWeb.loadRequest(request)
                                        //                                }
                                        
                                        
                                        
                                        if xtype == 3 {
                                            self.saveEmail2(fileBase64String!)
                                        }
                                    }else{
                                        self.hud?.mode = .text
                                        self.hud?.labelText = CConstants.SavedFailMsg
                                    }
                                }else{
                                    self.hud?.mode = .text
                                    self.hud?.labelText = CConstants.MsgServerError
                                }
                            }else{
                                self.hud?.mode = .text
                                self.hud?.labelText = CConstants.MsgNetworkError
                            }
                            //                    if let _ = nextFunc {
                            //                        self.performSelector(#selector(PDFBaseViewController.dismissProgressThenEmail as (PDFBaseViewController) -> () -> ()), withObject: nextFunc, afterDelay: 0.5)
                            //
                            //                    }else{
                            self.perform(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), with: nil, afterDelay: 0.5)
                            //                    }
        }
        
    }
    
    override  func saveEmail() {
        let (t, sign) =  self.CheckSellerFinish(self.fileDotsDic, documents: self.documents)
        if !t {
            self.PopMsgWithJustOK(msg: "Please finish all the required signature.", action1: { (_) in
                if let cg0 = sign?.center {
                    var cg = cg0
                    cg.x = 0
                    cg.y = cg.y - self.view.frame.height/2
                    if cg.y ?? 0 > 0 {
                        self.pdfView?.pdfView.scrollView.setContentOffset(cg, animated: false)
                    }
                }
            })
            return;
        }
        saveToServer1(3)
    }
    
    //    var emailData : String?
    func saveEmail2(_ savedPdfData: String) {
        self.performSegue(withIdentifier: "showEmail", sender: nil)
        //        emailData = savedPdfData
    }
    
    func GoToEmailSubmit(_ email: String, emailcc: String, msg: String) {
        //        let userInfo = NSUserDefaults.standardUserDefaults()
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.labelText = "Sending Email..."
        
        //        let a =  ["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? "", "emailto" : email, "emailcc": emailcc, "msg": msg]
        
        
        
        var email1 = email.replacingOccurrences(of: " ", with: "")
        email1 = email1.replacingOccurrences(of: "\n", with: "")
        if email1.hasSuffix(",") {
            email1 = email1.replacingOccurrences(of: ",", with: "")
        }
        var emailcc1 = emailcc.replacingOccurrences(of: " ", with: "")
        if emailcc1.hasSuffix(",") {
            emailcc1 = emailcc1.replacingOccurrences(of: ",", with: "")
        }
        let userInfo = UserDefaults.standard
        var a = ["idcontract":contractInfo?.idnumber ?? "","EmailTo":email,"EmailCc":emailcc,"Subject":"\(contractInfo!.nproject!)'s Contract","Body":msg,"idcia":contractInfo?.idcia ?? "","idproject":contractInfo?.idproject ?? "", "salesemail": userInfo.string(forKey: CConstants.UserInfoEmail) ?? "", "salesname": userInfo.string(forKey: CConstants.UserInfoName) ?? ""]
        if contractInfo?.idcia == "9999" {
            a = ["idcontract":contractInfo?.idnumber ?? ""
                , "EmailTo": "april@buildersaccess.com"
                , "EmailCc": "xiujun_85@163.com"
                , "Subject":"\(contractInfo!.nproject!)'s Contract"
                , "Body":msg
                , "idcia":contractInfo?.idcia ?? ""
                , "idproject":contractInfo?.idproject ?? ""
                , "salesemail": userInfo.string(forKey: CConstants.UserInfoEmail) ?? ""
                , "salesname": userInfo.string(forKey: CConstants.UserInfoName) ?? ""]
        }
        
        Alamofire.request(CConstants.ServerURL + "bacontract_SendEmail2.json", method: .post,
                          parameters:a).responseJSON{ (response) -> Void in
                            //                self.emailData = nil
                            //                 print(response.result.value)
                            //                print(rtnValue)
                            if response.result.isSuccess {
                                if let rtnValue = response.result.value as? Bool{
                                    
                                    if !rtnValue {
                                        self.hud?.hide(true)
                                        self.PopErrorMsgWithJustOK(msg: "Email sent failed.") {
                                            (action : UIAlertAction) -> Void in
                                            
                                        }
                                    }else{
                                        
                                        self.hud?.mode = .customView
                                        let image = UIImage(named: CConstants.SuccessImageNm)
                                        self.hud?.customView = UIImageView(image: image)
                                        
                                        self.hud?.labelText = "Email sent successfully."
                                        self.perform(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), with: nil, afterDelay: 0.5)
                                    }
                                }else{
                                    self.hud?.mode = .text
                                    self.hud?.labelText = CConstants.SavedFailMsg
                                }
                            }else{
                                self.hud?.mode = .text
                                self.hud?.labelText = CConstants.MsgServerError
                            }
                            self.perform(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), with: nil, afterDelay: 0.5)
        }
    }
    
    func ClearEmailData(){
        //        emailData = nil
    }
    
    var imagePicker: UIImagePickerController?
    
    override func attachPhoto() {
        self.performSegue(withIdentifier: "showAttachPhoto", sender: nil)
        return
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker?.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let c = self.contractPdfInfo?.hasCheckedPhoto {
                if c == "1" {
                    let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: constants.operationMsg, preferredStyle: .alert)
                    
                    //Create and add the OK action
                    let oKAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
                        self.uploadAttachedPhoto(image)
                    }
                    alert.addAction(oKAction)
                    
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    
                    //Present the AlertController
                    self.present(alert, animated: true, completion: nil)
                }else{
                    uploadAttachedPhoto(image)
                }
            }else{
                uploadAttachedPhoto(image)
            }
        }
        
        
        
        
        
    }
    
    fileprivate func uploadAttachedPhoto(_ image : UIImage){
        let imageData = UIImageJPEGRepresentation(image, 0.65)
        let string = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        self.hud?.labelText = "Uploading photo to BA Server..."
        let param = ["idcontract1" : contractInfo?.idnumber ?? "0" , "checked_photo" : string]
        
        Alamofire.request(CConstants.ServerURL + CConstants.UploadCheckedPhotoURL, method: .post,
                          parameters: param).responseJSON{ (response) -> Void in
                            //                hud.hide(true)
                            //                print(param, serviceUrl, response.result.value)
                            if response.result.isSuccess {
                                
                                if let rtnValue = response.result.value as? Bool{
                                    
                                    if rtnValue{
                                        self.contractPdfInfo?.hasCheckedPhoto = "1"
                                        self.hud?.mode = .customView
                                        let image = UIImage(named: CConstants.SuccessImageNm)
                                        self.hud?.customView = UIImageView(image: image)
                                        
                                        self.hud?.labelText = "Saved successfully."
                                        
                                    }else{
                                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                    }
                                }else{
                                    self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                }
                            }else{
                                //                            self.spinner?.stopAnimating()
                                self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                            }
                            self.perform(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), with: nil, afterDelay: 0.5)
        }
    }
    
    func sumOf(_ numbers: [Int]) -> Int {
        var sum = 0
        for number in numbers {
            sum += number
        }
        return sum
    }
    
    func skipToFile(_ filenm: String) {
        
        var t = 1;
        switch filenm {
//        case "RECEIPT OF CONDOMINIUM INFORMATION STATEMENT":
        case "First Page":
            t = 1
        case "BASIC TERMS":
            t = 2
        case "AGREEMENT OF SALE AND PURCHASE":
            t = 4
        case "TITLE COMPANY RECEIPT":
            t = 22
        case "EXHIBIT A":
            t = 23
        case "EXHIBIT B":
            t = 24
        case "EXHIBIT C":
            t = 25
        case "EXHIBIT D":
            t = 26
        case  "ATTACHMENT 1":
            t = 28
        case "EXHIBIT E":
            t = 29
        case "EXHIBIT F":
            t = 30
        case "EXHIBIT G":
            t = 31
        case "EXHIBIT H":
            t = 33
        case "EXHIBIT I":
            t = 36
        case "EXHIBIT J":
            t = 37
        case "EXHIBIT K":
            t = 38
        case "EXHIBIT L":
            t = 39
        case "Closing Procedure":
            t = 40
        case "Indoor Air":
            t = 41
        case "HOA Checklist":
            t = 43
        case "Buyers constructions expectations":
            t = 46
        default:
            break;
        }
        
        let h = (self.pdfView?.pdfView.scrollView.contentSize.height ?? 0) - getMargins2()
        if h > 0 {
            let ch = (h / CGFloat(50)) * CGFloat(t - 1)
            self.pdfView?.pdfView.scrollView.setContentOffset(CGPoint(x: 0.0, y: Double(ch)), animated: false)
        }
    }
    
    func getMargins2() -> CGFloat {
        let currentOrientation = UIApplication.shared.statusBarOrientation
        if UIInterfaceOrientationIsPortrait(currentOrientation) {
            return 6.1
        }else{
            if max(self.view.frame.size.height, self.view.frame.size.width) > 1024 {
                return 2.5
            }else{
                return 7.5
            }
        }
    }
    
    override func sendEmail2() {
        self.performSegue(withIdentifier: constants.segueToSendEmailAfterApproved, sender: nil)
    }
    
    override func emailContractToBuyer() {
        self.performSegue(withIdentifier: constants.segueToEmailContractToBuyer, sender: nil)
        
    }
    
    override func viewAttachPhoto(){
        self.performSegue(withIdentifier: "showAttachPhoto", sender: nil)
    }
    
    
    
    
    func GoToSendEmailToBuyer(msg: String, hasbuyer1: Bool, hasbuyer2: Bool) {
        if hasbuyer1 || hasbuyer2 {
            
            var b1:String
            var b1email : String
            var b2: String
            var b2email: String
            if hasbuyer1 {
                b1email = contractPdfInfo?.bemail1 ?? " "
                b1 = contractPdfInfo?.client ?? " "
            }else{
                b1email = " "
                b1 = " "
            }
            
            if hasbuyer2 {
                b2email = contractPdfInfo?.bemail2 ?? " "
                b2 = contractPdfInfo?.client2 ?? " "
            }else{
                b2email = " "
                b2 = " "
            }
            let userInfo = UserDefaults.standard
            var param = ["idcontract":"\(self.contractInfo?.idnumber ?? "")","buyer1email":"\(b1email)", "buyer2email":"\(b2email)","idcity":"\(self.contractInfo?.idcity ?? "")","idcia":"\(self.contractInfo?.idcia ?? "")","emailcc":" ","buyer1name":"\(b1)","buyer2name":"\(b2)","emailbody":"\(msg)","emailsubject":"Sign contract online", "salesemail": userInfo.string(forKey: CConstants.UserInfoEmail) ?? "", "salesname": userInfo.string(forKey: CConstants.UserInfoName) ?? ""]
            if (self.contractPdfInfo?.idcia ?? "") == "9999" {
                if(b2email == " ") {
                    param = ["idcontract":"\(self.contractInfo?.idnumber ?? "")","buyer1email":"april@buildersaccess.com", "buyer2email":" ","idcity":"\(self.contractInfo?.idcity ?? "")","idcia":"\(self.contractInfo?.idcia ?? "")","emailcc":" ","buyer1name":"\(b1)","buyer2name":" ","emailbody":"\(msg)","emailsubject":"Sign contract online", "salesemail": userInfo.string(forKey: CConstants.UserInfoEmail) ?? "", "salesname": userInfo.string(forKey: CConstants.UserInfoName) ?? ""]
                }else{
                    param = ["idcontract":"\(self.contractInfo?.idnumber ?? "")","buyer1email":"aprillv@yahoo.com", "buyer2email":"april@buildersaccess.com","idcity":"\(self.contractInfo?.idcity ?? "")","idcia":"\(self.contractInfo?.idcia ?? "")","emailcc":" ","buyer1name":"\(b1)","buyer2name":"\(b2)","emailbody":"\(msg)","emailsubject":"Sign contract online", "salesemail": userInfo.string(forKey: CConstants.UserInfoEmail) ?? "", "salesname": userInfo.string(forKey: CConstants.UserInfoName) ?? ""]
                }
                
            }
            
            print(param)
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            //                hud.mode = .AnnularDeterminate
            hud?.labelText = "Sending Email..."
            
            
            //            print(CConstants.ServerURL + "bacontract_SendContractToBuyer.json")
            Alamofire.request(CConstants.ServerURL + "bacontract_SendContractToBuyer.json",
                              method: .post,
                              parameters: param).responseJSON{ (response) -> Void in
                                hud?.hide(true)
                                //                print(param)
                                if response.result.isSuccess {
                                    //                    print(response.result.value)
                                    
                                    if let a = response.result.value as? Bool {
                                        if a {
                                            
                                            self.contractPdfInfo?.status = "Email Sign"
                                            if hasbuyer1 {
                                                self.contractPdfInfo?.verify_code = "1"
                                            }
                                            if hasbuyer2 {
                                                self.contractPdfInfo?.verify_code2 = "1"
                                            }
                                            self.setSendItema()
                                            self.setBuyer2()
                                            self.PopMsgWithJustOK(msg: "Email Contract to Buyer successfully.")
                                            
                                        }else{
                                            self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                        }
                                    }else{
                                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                    }
                                }else{
                                    //                            self.spinner?.stopAnimating()
                                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                                }
            }
        }
        
    }
    
    
    func checkBuyer1() -> (Bool, SignatureView?) {
        let tl = toolpdf()
        var tmpa = [String]()
        for (_, tmp) in tl.pdfBuyer1SignatureFields {
            tmpa.append(contentsOf: tmp)
        }
        
        var alldots = [PDFWidgetAnnotationView]()
        
        for (_,allAdditionViews) in self.fileDotsDic!{
            alldots.append(contentsOf: allAdditionViews)
        }
        
        for doc in self.documents!{
            if let a = doc.addedviewss as? [PDFWidgetAnnotationView]{
                alldots.append(contentsOf: a)
            }
        }
        
        for c in alldots {
            if let a = c as? SignatureView {
                if tmpa.contains(a.xname) {
                    if !(a.lineArray != nil && a.lineArray.count > 0 && a.lineWidth != 0.0){
                        //                        print(a.xname)
                        return (false, a)
                    }
                }
            }
        }
        return (true, nil)
    }
    
    func checkBuyer2() -> Bool {
        let tl = toolpdf()
        var tmpa = [String]()
        for (_, tmp) in tl.pdfBuyer2SignatureFields {
            tmpa.append(contentsOf: tmp)
        }
        
        var alldots = [PDFWidgetAnnotationView]()
        
        for (_,allAdditionViews) in self.fileDotsDic!{
            alldots.append(contentsOf: allAdditionViews)
        }
        
        for doc in self.documents!{
            if let a = doc.addedviewss as? [PDFWidgetAnnotationView]{
                alldots.append(contentsOf: a)
            }
        }
        
        for c in alldots {
            if let a = c as? SignatureView {
                if tmpa.contains(a.xname) {
                    if !(a.lineArray != nil && a.lineArray.count > 0 && a.lineWidth != 0.0){
                        //                        print(a.xname)
                        return false
                    }
                    
                }
            }
        }
        return true
    }
    
    
    override func submitBuyer1Sign(){
        
        
        submitBuyerSignStep1(true)
    }
    
    fileprivate func submitBuyerSignStep1(_ isbuyer1: Bool){
       
        let (finishYN, sign) = CheckBuyerFinish(isbuyer1: isbuyer1)
        //        print(sign?.xname)
        if finishYN {
            var msg : String
            if isbuyer1 {
                msg = "Are you sure you want to submit buyer1's Sign?"
            }else{
                msg = "Are you sure you want to submit buyer2's Sign?"
            }
            let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg, preferredStyle: .alert)
            
            //Create and add the OK action
            let oKAction: UIAlertAction = UIAlertAction(title: "YES", style: .default)  { Void in
                self.saveToServer1(isbuyer1 ? 4 : 5)
                
            }
            alert.addAction(oKAction)
            
            let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel){ Void in
                
            }
            alert.addAction(cancel)
            
            
            
            //Present the AlertController
            self.present(alert, animated: true, completion: nil)
        }else{
            
            let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: "There is a filed need to be signed. Go to that field?", preferredStyle: .alert)
            
            //Create and add the OK action
            let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .default)  { Void in
                
                if let cg0 = sign?.center {
                    var cg = cg0
                    cg.x = 0
                    cg.y = cg.y - self.view.frame.height/2
                    if cg.y ?? 0 > 0 {
                        self.pdfView?.pdfView.scrollView.setContentOffset(cg, animated: false)
                    }
                }
                
                
            }
            alert.addAction(oKAction)
            
            let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel){ Void in
                
            }
            alert.addAction(cancel)
            
            
            
            //Present the AlertController
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func submitBuyerSignStep2(_ isbuyer1: Bool){
        let param = ["idcontract":self.contractPdfInfo?.idnumber ?? ""
            ,"buyer1yn": (isbuyer1 ? "1" : "0")
            ,"buyer2yn":(isbuyer1 ? "0" : "1")]
        
        Alamofire.request(
            CConstants.ServerURL + "bacontract_SubmitBuyerSignFinshed.json",method: .post,
            parameters: param).responseJSON{ (response) -> Void in
                self.hud?.hide(true)
                //                print(param, serviceUrl)
                if response.result.isSuccess {
                    
                    if let rtnValue = response.result.value as? Bool{
                        
                        if rtnValue{
                            if isbuyer1 {
                                self.contractPdfInfo?.buyer1SignFinishedyn = 1
                            }else{
                                self.contractPdfInfo?.buyer2SignFinishedyn = 1
                            }
                            self.PopMsgWithJustOK(msg: "Submit successfully.")
                        }else{
                            self.PopMsgWithJustOK(msg: "Error happened when submit, please try it again later.")
                        }
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    //                            self.spinner?.stopAnimating()
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
    }
    override func submitBuyer2Sign(){
        submitBuyerSignStep1(false)
    }
    
    
    override func changeBuyre1ToIPadSign(){
        changeBuyreToIPadSign(true)
    }
    override func changeBuyre2ToIPadSign(){
        changeBuyreToIPadSign(false)
        
    }
    
    fileprivate func changeBuyreToIPadSign(_ isbuyer1 : Bool) {
        var msg : String
        if isbuyer1 {
            if self.contractPdfInfo?.client2 == "" {
                msg = "If you change buyer to ipad sign, buyer will cannot sign online. Are you sure you want to submit?"
            }else{
                msg = "If you change buyer1 to ipad sign, buyer1 will cannot sign online. Are you sure you want to submit?"
            }
            
        }else{
            msg = "If you change buyer2 to ipad sign, buyer2 will cannot sign online. Are you sure you want to submit?"
        }
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg, preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: "YES", style: .default)  { Void in
            self.changeBuyreToIPadSignStep2(isbuyer1)
            
        }
        alert.addAction(oKAction)
        
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel){ Void in
            
        }
        alert.addAction(cancel)
        
        
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func changeBuyreToIPadSignStep2(_ isbuyer1 : Bool) {
        let param = ["idcontract":self.contractPdfInfo?.idnumber ?? "","buyer1yn": (isbuyer1 ? "1" : "0") ,"buyer2yn":(isbuyer1 ? "0" : "1")]
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        hud?.labelText = CConstants.SubmitMsg
        
        
        Alamofire.request(
            CConstants.ServerURL + "bacontract_ChangeEmailSignToIpadSign.json",method: .post,
            parameters: param).responseJSON{ (response) -> Void in
                hud?.hide(true)
                //                print(param, serviceUrl)
                if response.result.isSuccess {
                    
                    if let rtnValue = response.result.value as? Bool{
                        
                        if rtnValue{
                            
                            if isbuyer1 {
                                self.contractPdfInfo?.verify_code = ""
                                if self.contractPdfInfo?.verify_code2 == "" {
                                    self.contractPdfInfo?.status = "iPad Sign"
                                }
                            }else {
                                self.contractPdfInfo?.verify_code2 = ""
                                if self.contractPdfInfo?.verify_code == "" {
                                    self.contractPdfInfo?.status = "iPad Sign"
                                }
                            }
                            self.setBuyer2()
                            self.setSendItema()
                            self.PopMsgWithJustOK(msg: "Submit successfully.")
                        }else{
                            self.PopMsgWithJustOK(msg: "Error happened when submit, please try it again later.")
                        }
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    //                            self.spinner?.stopAnimating()
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
    }
    
    override func gotoBuyer1Sign() {
        self.gotoBuyerSign(true)
    }
    override func gotoBuyer2Sign() {
        self.gotoBuyerSign(false)
    }
    override func gotoSellerSign() {
        let (t, sign) =  self.CheckSellerFinish(self.fileDotsDic, documents: self.documents)
        if !t {
            if let cg0 = sign?.center {
                var cg = cg0
                cg.x = 0
                cg.y = cg.y - self.view.frame.height/2
                if cg.y ?? 0 > 0 {
                    self.pdfView?.pdfView.scrollView.setContentOffset(cg, animated: false)
                }
            }
        }else{
            self.PopMsgWithJustOK(msg: "You have signed all fields.")
        }
    }
    
    private func CheckSellerFinish( _ fileDotsDic : [String : [PDFWidgetAnnotationView]]?, documents : [PDFDocument]?) -> (Bool, SignatureView?) {
        
        let tp = toolpdf()
        let tmpa = tp.pdfSpringDaleSeller1SignatureFields
        
        let alldots = self.fileDotsDic!["springdale"]
        
        for tmp in tmpa {
            for c in alldots! {
                if let a = c as? SignatureView {
                    if tmp == a.xname {
                        if !(a.lineArray != nil && a.lineArray.count > 0 && a.lineWidth != 0.0){
                            return (false, a)
                        }
                    }
                }
            }
        }
        
        return (true, nil)
        
    }
    
    func gotoBuyerSign(_ isbuyer: Bool) {
        let (t, sign) =  CheckBuyerFinish(isbuyer1: isbuyer)
        if !t {
            if let cg0 = sign?.center {
                var cg = cg0
                cg.x = 0
                cg.y = cg.y - self.view.frame.height/2
                if cg.y ?? 0 > 0 {
                    self.pdfView?.pdfView.scrollView.setContentOffset(cg, animated: false)
                }
            }
        }else{
            self.PopMsgWithJustOK(msg: "You have signed all fields.")
        }
    }
}



