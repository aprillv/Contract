//
//  PDFPrintViewController.swift
//  Contract
//
//  Created by April on 2/23/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
import Alamofire

class PDFPrintViewController: PDFBaseViewController {
    
    
    var isDownload : Bool?
//    var pdfInfo : ContractAddendumC?{
//        didSet{
//            pdfInfo0 = pdfInfo;
//        }
//    }
    
    
    var add : [PDFWidgetAnnotationView]?{
        didSet{
            
            setPdf()
        }
        
    }
    var addendumApdfInfo : AddendumA?{
        didSet{
        
            setPdf()
        }
        
    }
    
    private func setPdf(){
        if let a = add, let c = addendumApdfInfo{
            let sesss = SetDotValue()
            sesss.setExhibitADots(c, additionViews: a)
        }
    }
    var addendumCpdfInfo : ContractAddendumC?
    var contractPdfInfo : ContractSignature?
    var closingMemoPdfInfo: ContractClosingMemo?
    var designCenterPdfInfo : ContractDesignCenter?
    
    var page2 : Bool?
    
    var filesArray : [String]?
    
    private struct PDFFields{
        
        static let Buyer1Signature = "bottom1"
        static let Buyer2Signature = "bottom2"
        static let Seller1Signature = "bottom3"
        static let Seller2Signature = "bottom4"
        
        static let CompanyName = "sellercompany"
        static let Buyer = "buyer"
        static let Lot = "lot"
        static let Block = "block1"
        static let Section = "block2"
        static let City = "city"
        static let County = "county"
        static let Address_zip = "address_zip"
        static let Address = "address"
        static let SalePrice = "saleprice"
        
        static let CompanyName1 = "cianame"
        static let Buyer1 = "client"
        static let Lot1 = "lot"
        static let Block1 = "block"
        static let Section1 = "section"
        static let City1 = "cityname"
        static let County1 = "county"
        static let Address1 = "nproject"
        static let SalePrice1 = "sold"
        
        static let cashportion  = "3a"
        
        static let financing  = "3b"
        
        static let estimatedclosing_MMdd = "9a1"
        
        static let estimatedclosing_yy = "9a2"
        
        static let tobuyer1 = "tobuyer1"
        
        static let tobuyer2 = "tobuyer2"
        
        static let tobuyer3 = "tobuyer3"
        static let tobuyer4 = "tobuyer4"
        static let tobuyer5 = "tobuyer5"
        static let tobuyer6 = "tobuyer6"
        
        static let tobuyer7 = "tobuyer7"
        static let page7e2 = "page7e2"
        
        static let executeddd = "executeddd"
        
        static let executedmm = "executedmm"
        static let executedyy = "executedyy"
        static let buyer_2 = "buyer_2"
        static let buyer_3 = "buyer_3"
        static let seller_2 = "seller_2"
        //        static let seller_3 = "seller_3"
        static let pdf2211 = "2211"
        static let pdf2212 = "2212"
        
        static let pdf22a1 = "22a1"
        static let pdf22a15 = "22a15"
        static let pdf22a3 = "22a3"
        static let pdf22a10 = "22a10"
        
        static let buyer2Sign = "buyer2Sign"
        static let buyer3Sign = "buyer3Sign"
        static let seller2Sign = "seller2Sign"
        static let seller3Sign = "seller3Sign"
        
        static let p9Broker = "Other Broker Firm"
        static let p9represents = "Buyer only as Buyers agent"
        static let p9AssociatesName = "Associates Name"
        static let p9AssociatesEmailAddress = "Associates Email Address"
        
        // checkbox
        static let chkfinancing = "financing"
        static let chk6c = "6c"
        static let chk10a = "10a"
        static let chk7g = "7g"
        static let chk6e2 = "6e2"
        static let chk6a83 = "6a83"
        static let chk6a8 = "6a8"
        static let chk6a = "6a"
        
        
        
    }
    
    @IBAction func BuyerSign(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        for sign0 in self.pdfView!.pdfWidgetAnnotationViews {
            if let sign = sign0 as? SignatureView{
                if (    sender.tag == 1 && sign.sname.hasSuffix(PDFFields.Buyer1Signature))
                    || (sender.tag == 2 && sign.sname.hasSuffix(PDFFields.Buyer2Signature))
                    || (sender.tag == 3 && sign.sname.hasSuffix(PDFFields.Seller1Signature))
                    || (sender.tag == 4 && sign.sname.hasSuffix(PDFFields.Seller2Signature)){
                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                            sign.toSignautre()
                            return
                        }
                }
                
            }
        }
        for sign0 in self.pdfView!.pdfWidgetAnnotationViews {
            if let sign = sign0 as? SignatureView{
                if (    sender.tag == 1 && sign.sname == PDFFields.buyer2Sign)
                    || (sender.tag == 2 && sign.sname == PDFFields.buyer3Sign)
                    || (sender.tag == 3 && sign.sname == PDFFields.seller2Sign)
                    || (sender.tag == 4 && sign.sname == PDFFields.seller3Sign){
                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                            sign.toSignautre()
                            return
                        }
                }
                
            }
        }
        
    }
    
    
    
    
    
    private func getFileName() -> String{
        return "contract1pdf_" + self.pdfInfo0!.idcity! + "_" + self.pdfInfo0!.idcia!
    }
    
    override func loadPDFView(){
        
        var filesNames = [String]()
        let param = ContractRequestItem(contractInfo: nil).DictionaryFromBasePdf(self.pdfInfo0!)
        for title in filesArray! {
            self.callService(title, param: param)
            switch title {
            case CConstants.ActionTitleContract:
                filesNames.append(CConstants.PdfFileNameContract)
            case CConstants.ActionTitleThirdPartyFinancingAddendum:
                filesNames.append(CConstants.PdfFileNameThirdPartyFinancingAddendum)
            case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
                filesNames.append(CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES)
            case CConstants.ActionTitleAddendumA:
                filesNames.append(CConstants.PdfFileNameAddendumA)
            case CConstants.ActionTitleAddendumC:
                filesNames.append(CConstants.PdfFileNameAddendumC)
            case CConstants.ActionTitleEXHIBIT_A:
                filesNames.append(CConstants.PdfFileNameEXHIBIT_A)
            case CConstants.ActionTitleEXHIBIT_B:
                filesNames.append(CConstants.PdfFileNameEXHIBIT_B)
            case CConstants.ActionTitleEXHIBIT_C:
                filesNames.append(CConstants.PdfFileNameEXHIBIT_C)
            case CConstants.ActionTitleClosingMemo:
                filesNames.append(CConstants.PdfFileNameClosingMemo)
            case CConstants.ActionTitleDesignCenter:
                filesNames.append(CConstants.PdfFileNameDesignCenter)
            default:
                break
                
            }
        }
        
        let margins = getMargins()
        documents = [PDFDocument]()
        for t in filesNames {
            documents?.append(PDFDocument.init(resource: t))
        }
        
        var additionViews = documents![0].forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y) as? [PDFWidgetAnnotationView]
        
        var f : CGFloat = 976.688235
        if let a  = NSUserDefaults.standardUserDefaults().valueForKey("pageHMargin") as? String{
            if let n = NSNumberFormatter().numberFromString(a) {
                 f = CGFloat(n)
               
            }
        }
        
        let additionViews2 = documents![1].forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y + f*9) as? [PDFWidgetAnnotationView]
        
        add = additionViews2
        additionViews?.appendContentsOf(add!)
        if let filedsFromTxt = readContractFieldsFromTxt(getFileName()) {
            
            
            let na = filedsFromTxt.keys
            for pv : PDFWidgetAnnotationView in additionViews!{
                if na.contains(pv.xname){
                    pv.value = filedsFromTxt[pv.xname]
                }
                
            }
            
        }
        
//        var tobuyer3 : String
//        var tobuyer4 : String
//        if let b = pdfInfo!.bmobile1 == "" ? pdfInfo?.boffice1! : pdfInfo?.bmobile1! {
//            let a = b.componentsSeparatedByString("-")
//            if a.count > 2 {
//                tobuyer3 = a[0]
//                if tobuyer3.characters.count != 3 {
//                    tobuyer3 = ""
//                    tobuyer4 = b
//                }else{
//                    let index1 = b.startIndex.advancedBy(4)
//                    tobuyer4 = b.substringFromIndex(index1)
//                }
//                
//                
//            }else{
//                tobuyer3 = ""
//                tobuyer4 = ""
//            }
//        }else{
//            tobuyer3 = ""
//            tobuyer4 = ""
//        }
//        
//        
//        var tobuyer5 : String
//        var tobuyer6 : String
//        if let b = pdfInfo!.bfax1 {
//            let a = b.componentsSeparatedByString("-")
//            if a.count > 2 {
//                tobuyer5 = a[0]
//                let index1 = b.startIndex.advancedBy(4)
//                tobuyer6 = b.substringFromIndex(index1)
//            }else{
//                tobuyer5 = ""
//                tobuyer6 = ""
//            }
//        }else{
//            tobuyer5 = ""
//            tobuyer6 = ""
//        }
//        
//        
//        var overrideFields : [String: String]
//        overrideFields = [PDFFields.CompanyName : PDFFields.CompanyName1
//            , PDFFields.Buyer : PDFFields.Buyer1
//            , PDFFields.Lot: PDFFields.Lot1
//            , PDFFields.Block : PDFFields.Block1
//            , PDFFields.Section : PDFFields.Section1
//            , PDFFields.City : PDFFields.City1
//            , PDFFields.County : PDFFields.County1
//            , PDFFields.Address : PDFFields.Address1
//            , PDFFields.Address_zip : PDFFields.Address1
//            , PDFFields.SalePrice : PDFFields.SalePrice1]
        
        //        pdfInfo?.section = "MEADOWS AT TRINITY CROSSING PHASE 2-B-1 AMENDED PL"
        
        
        
        pdfView = PDFView(frame: view.bounds, dataOrPathArray: filesNames, additionViews: additionViews)
        
//        for pv : PDFWidgetAnnotationView in add!{
//            pv.value = "fasdff";
//        }
        
//        let na = overrideFields.keys
//        for pv : PDFWidgetAnnotationView in additionViews!{
//            if na.contains(pv.xname){
//                if PDFFields.Address_zip == pv.xname{
//
//                    if pdfInfo!.zipcode! != "" {
//                        pv.value = "\(pdfInfo!.nproject!)/\(pdfInfo!.zipcode!)"
//                    }else{
//                        pv.value = pdfInfo!.nproject!
//                    }
//                }else if PDFFields.Address == pv.xname{
//                    pv.value = pdfInfo!.nproject
//                }else if(PDFFields.Buyer == pv.xname){
//                    if (pdfInfo!.client2 != ""){
//                        pv.value = pdfInfo!.client! + " and " + pdfInfo!.client2!
//                    }else{
//                        pv.value = pdfInfo!.client!
//                    }
//                    
//                }else{
//                    if let a = overrideFields[pv.xname!]{
//                        pv.value = pdfInfo!.valueForKey(a) as! String
//                    }
//                    
//                }
//            }else {
//                
//                switch pv.xname {
//                case PDFFields.cashportion:
//                    //                    pv.value = pdfInfo!.cashportion! == "" ? "0.00" : pdfInfo!.cashportion!
//                    pv.value = pdfInfo!.cashportion!
//                case PDFFields.financing:
//                    pv.value = pdfInfo!.financing!
//                case PDFFields.estimatedclosing_MMdd:
//                    pv.value = pdfInfo!.estimatedclosing_MMdd!
//                case PDFFields.estimatedclosing_yy:
//                    pv.value = pdfInfo!.estimatedclosing_yy!
//                case PDFFields.tobuyer1:
//                    pv.value = pdfInfo!.client!
//                case PDFFields.tobuyer2:
//                    pv.value = pdfInfo!.tobuyer2!
//                case PDFFields.tobuyer3:
//                    pv.value = tobuyer3
//                case PDFFields.tobuyer4:
//                    pv.value = tobuyer4
//                case PDFFields.tobuyer5:
//                    pv.value = tobuyer5
//                case PDFFields.tobuyer6:
//                    pv.value = tobuyer6
//                case PDFFields.tobuyer7:
//                    pv.value = pdfInfo!.bemail1!
//                case PDFFields.executeddd:
//                    pv.value = pdfInfo!.executeddd!
//                case PDFFields.executedmm:
//                    pv.value = pdfInfo!.executedmm!
//                case PDFFields.executedyy:
//                    pv.value = pdfInfo!.executedyy!
//                case PDFFields.buyer_2:
//                    pv.value = pdfInfo!.client!
//                case PDFFields.buyer_3:
//                    pv.value = pdfInfo!.client2!
//                case PDFFields.seller_2:
//                    pv.value = pdfInfo!.cianame!
//                case PDFFields.pdf2211:
//                    pv.value = pdfInfo!.trec1!
//                case PDFFields.pdf2212:
//                    pv.value = pdfInfo!.trec2!
//                case PDFFields.pdf22a1:
//                    if let radio = pv as? PDFFormButtonField {
//                        radio .setValue2(pdfInfo!.page7ThirdPartyFinacingAddendum!)
//                    }
//                case PDFFields.pdf22a15:
//                    if let radio = pv as? PDFFormButtonField {
//                        radio .setValue2(pdfInfo!.other!)
//                    }
//                case PDFFields.pdf22a3:
//                    if let radio = pv as? PDFFormButtonField {
//                        radio .setValue2(pdfInfo!.hoa!)
//                    }
//                case PDFFields.pdf22a10:
//                    if let radio = pv as? PDFFormButtonField {
//                        radio.setValue2(pdfInfo!.environment!)
//                    }
//                case PDFFields.page7e2:
//                    pv.value = pdfInfo!.page7e2!
//                    //                case "buyer_2", "buyer_3", "seller_2", "seller_3":
//                    //                case "buyer_2":
//                    
//                case PDFFields.p9Broker:
//                    pv.value = pdfInfo!.page9OtherBrokerFirm
//                case PDFFields.p9represents:
//                    if let radio = pv as? PDFFormButtonField {
//                        radio .setValue2(pdfInfo!.page9BuyeronlyasBuyersagent!)
//                    }
//                case PDFFields.p9AssociatesName:
//                    pv.value = pdfInfo!.page9AssociatesName
//                case PDFFields.p9AssociatesEmailAddress:
//                    pv.value = pdfInfo!.page9AssociatesEmailAddress
//                    //                    static let chkfinancing = "financing"
//                    //                    static let chk6c = "6c"
//                    //                    static let chkcer2 = "cer2"
//                    //                    static let chkcer1 = "cer1"
//                    //                    static let chk23a = "23a"
//                    //                    static let chk10a = "10a"
//                    //                    static let chk7g = "7g"
//                    //                    static let chk6e2 = "6e2"
//                    //                    static let chk6a83 = "6a83"
//                    //                    static let chk6a8 = "6a8"
//                    //                    static let chk6a = "6a"
//                case PDFFields.chkfinancing:
//                    if let radio = pv as? PDFFormButtonField {
//                        if radio.exportValue == "4a" {
//                            radio.setValue2("1")
//                        }
//                    }
//                case PDFFields.chk6c:
//                    if let radio = pv as? PDFFormButtonField {
//                        if radio.exportValue == "6c2" {
//                            radio.setValue2("1")
//                        }
//                    }
//                case PDFFields.chk10a:
//                    if let radio = pv as? PDFFormButtonField {
//                        if radio.exportValue == "10a1" {
//                            radio.setValue2("1")
//                        }
//                    }
//                case PDFFields.chk7g:
//                    if let radio = pv as? PDFFormButtonField {
//                        if radio.exportValue == "7g2" {
//                            radio.setValue2("1")
//                        }
//                    }
//                case PDFFields.chk6e2:
//                    if let radio = pv as? PDFFormButtonField {
//                        if radio.exportValue == "6e2" {
//                            radio.setValue2("1")
//                        }
//                    }
//                case PDFFields.chk6a83:
//                    if let radio = pv as? PDFFormButtonField {
//                        if radio.exportValue == "6a831" {
//                            radio.setValue2("1")
//                        }
//                    }
//                case PDFFields.chk6a8:
//                    if let radio = pv as? PDFFormButtonField {
//                        if radio.exportValue == "6a82" {
//                            radio.setValue2("1")
//                        }
//                    }
//                case PDFFields.chk6a:
//                    if let radio = pv as? PDFFormButtonField {
//                        if radio.exportValue == "6a2" {
//                            radio.setValue2("1")
//                        }
//                    }
//                default:
//                    break
//                }
//            }
//            if let sign = pv as? SignatureView{
//                sign.pdfViewsssss = pdfView
//            }
//        }
        
        
        view.addSubview(pdfView!)
        
    }
    
    
    
    
    
    private func readContractFieldsFromTxt(fileName: String) ->[String: String]? {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt") {
            var fieldsDic = [String : String]()
            do {
                let fieldsStr = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                let n = fieldsStr.componentsSeparatedByString("\n")
                
                for one in n{
                    let s = one.componentsSeparatedByString(":")
                    if s.count != 2 {
                        print(one)
                    }else{
                        fieldsDic[s.first!] = s.last!
                    }
                }
            }
            catch {/* error handling here */}
            return fieldsDic
        }
        
        return nil
    }
    
    private func callService(printModelNm: String, param: [String: String]){
        var serviceUrl: String?
        switch printModelNm{
        case CConstants.ActionTitleDesignCenter:
            serviceUrl = CConstants.DesignCenterServiceURL
        case CConstants.ActionTitleAddendumC:
            return
            serviceUrl = CConstants.AddendumCServiceURL
        case CConstants.ActionTitleClosingMemo:
            serviceUrl = CConstants.ClosingMemoServiceURL
        case CConstants.ActionTitleContract:
            serviceUrl = CConstants.ContractServiceURL
        case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
//            self.performSegueWithIdentifier(CConstants.SegueToInformationAboutBrokerageServices, sender: nil)
            return
        default:
            serviceUrl = CConstants.AddendumAServiceURL
        }
        self.noticeOnlyText(CConstants.RequestMsg)
        Alamofire.request(.POST,
            CConstants.ServerURL + serviceUrl!,
            parameters: param).responseJSON{ (response) -> Void in
                self.clearNotice()
                if response.result.isSuccess {
                    
                    if let rtnValue = response.result.value as? [String: AnyObject]{
                        if let msg = rtnValue["message"] as? String{
                            if msg.isEmpty{
                                var vc : PDFBaseViewController?
                                switch printModelNm {
                                case CConstants.ActionTitleAddendumC:
                                    vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameAddendumC) as? PDFBaseViewController
                                    if let controller = vc as? AddendumCViewController{
                                        controller.pdfInfo = ContractAddendumC(dicInfo: rtnValue)
                                        
                                        var itemList = [[String]]()
                                        var i = 0
                                        if let list = controller.pdfInfo?.itemlist {
                                            for items in list {
                                                
                                                var itemList1 = [String]()
                                                let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 657.941, height: 13.2353))
                                                textView.scrollEnabled = false
                                                textView.font = UIFont(name: "Verdana", size: 11.0)
                                                textView.text = items.xdescription!
                                                textView.sizeToFit()
                                                textView.layoutManager.enumerateLineFragmentsForGlyphRange(NSMakeRange(0, items.xdescription!.characters.count), usingBlock: { (rect, usedRect, textContainer, glyphRange, _) -> Void in
                                                    if  let a : NSString = items.xdescription! as NSString {
                                                        
                                                        i++
                                                        itemList1.append(a.substringWithRange(glyphRange))
                                                    }
                                                })
                                                //                            itemList1.append("april test")
                                                itemList.append(itemList1)
                                            }
                                        }
                                        controller.pdfInfo!.itemlistStr = itemList
                                        
                                        
                                        let pass = i > 19 ? CConstants.PdfFileNameAddendumC2 : CConstants.PdfFileNameAddendumC
                                        
                                        controller.initWithResource(pass)
                                        
                                    }
                                case CConstants.ActionTitleClosingMemo:
                                    self.closingMemoPdfInfo = ContractClosingMemo(dicInfo: rtnValue)
                                case CConstants.ActionTitleDesignCenter:
                                    self.designCenterPdfInfo = ContractDesignCenter(dicInfo: rtnValue)
                                case CConstants.ActionTitleContract:
                                    self.contractPdfInfo = ContractSignature(dicInfo: rtnValue)
                                
                                default:
                                    print(rtnValue)
                                    self.addendumApdfInfo = AddendumA(dicInfo: rtnValue)
                                }
                                if let vcc = vc {
                                    vcc.AddressList = self.AddressList
                                    var na = self.navigationController?.viewControllers
                                    na?.removeLast()
                                    na?.append(vcc)
                                    self.navigationController?.viewControllers = na!
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
    
}
