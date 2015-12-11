//
//  AddendumCViewController.swift
//  Contract
//
//  Created by April on 12/10/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire

class AddendumCViewController: BaseViewController {

    var document : PDFDocument?
    var pdfView  : PDFView?
    var isDownload : Bool?
    var pdfInfo : ContractAddendumC?
    var spinner : UIActivityIndicatorView?
    var progressBar : UIAlertController?
    
    private struct PDFFields{
        
        static let SavedMsg = "Saving to the BA Server"
        static let SavedSuccessMsg = "Saved successfully."
        static let SavedFailMsg = "Saved fail."
        
        
        
        static let CompanyName = "txtCiaNm"
        static let Address = "txtAddress"
        static let CityStateZip = "txtCityStateZip"
        static let TelFax = "txtTelFax"
        static let DateL = "txtDate"
        static let IdNo = "txtIdNumber"
        static let ContractDate = "txtContractDate"
        static let EstimatedCompletion = "txtEstimatedCompletion"
        static let EstamatedClosing = "txtEstamatedClosing"
        static let StageContract = "txtStageContract"
        static let JobAddress = "txtJobAddress"
        static let Buyer = "txtBuyer"
        static let Consultant = "txtConsultant"
        static let SubDivision  = "txtSubDivision"
        static let Price  = "txtPrice"
        
        static let Buyer1Signature = "txtHomebuyer1Sign"
        static let Buyer2Signature = "txtHomebuyer2Sign"
        static let ConsultantSignature = "txtConsultantSign"
        static let ConsultantSignatureDate = "txtConsultantDate"
        static let Buyer1SignatureDate = "txtHomebuyer1Date"
        static let Buyer2SignatureDate = "txtHomebuyer2Date"
        
        static let Buyer1SignatureLbl = "txtHomebuyer1Signlbl"
        static let Buyer2SignatureLbl = "txtHomebuyer2Signlbl"
        static let ConsultantSignatureLbl = "txtConsultantSignlbl"
        static let ConsultantSignatureDateLbl = "txtConsultantSignDatelbl"
        static let Buyer1SignatureDateLbl = "txtHomebuyer1SignDatelbl"
        static let Buyer2SignatureDateLbl = "txtHomebuyer2SignDatelbl"
        
    }
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func BuyerSign(sender: UIBarButtonItem) {
        
//        for sign0 in pdfView!.pdfWidgetAnnotationViews {
//            if let sign = sign0 as? SignatureView{
//                if (    sender.tag == 1 && sign.sname.hasSuffix(PDFFields.Buyer1Signature))
//                    || (sender.tag == 2 && sign.sname.hasSuffix(PDFFields.Buyer2Signature))
//                    || (sender.tag == 3 && sign.sname.hasSuffix(PDFFields.Seller1Signature))
//                    || (sender.tag == 4 && sign.sname.hasSuffix(PDFFields.Seller2Signature)){
//                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
//                            sign.toSignautre()
//                            return
//                        }
//                }
//                
//            }
//        }
//        for sign0 in pdfView!.pdfWidgetAnnotationViews {
//            if let sign = sign0 as? SignatureView{
//                if (    sender.tag == 1 && sign.sname == PDFFields.buyer2Sign)
//                    || (sender.tag == 2 && sign.sname == PDFFields.buyer3Sign)
//                    || (sender.tag == 3 && sign.sname == PDFFields.seller2Sign)
//                    || (sender.tag == 4 && sign.sname == PDFFields.seller3Sign){
//                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
//                            sign.toSignautre()
//                            return
//                        }
//                }
//                
//            }
//        }
    }
    @IBAction func savePDF(sender: UIBarButtonItem) {
        return
        let savedPdfData = document?.savedStaticPDFData()
        let fileBase64String = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        let parame : [String : String] = ["idcia" : pdfInfo!.idcia!
            , "idproject" : pdfInfo!.idproject!
            , "username" : NSUserDefaults.standardUserDefaults().valueForKey(CConstants.LoggedUserNameKey) as? String ?? ""
            , "code" : pdfInfo!.code!
            , "file" : fileBase64String!]
        print(parame)
        if (spinner == nil){
            spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 4, width: 50, height: 50))
            spinner?.hidesWhenStopped = true
            spinner?.activityIndicatorViewStyle = .Gray
        }
        
        progressBar = UIAlertController(title: nil, message: PDFFields.SavedMsg, preferredStyle: .Alert)
        progressBar?.view.addSubview(spinner!)
        
        spinner?.startAnimating()
        self.presentViewController(progressBar!, animated: true, completion: nil)
        
        Alamofire.request(.POST,
            CConstants.ServerURL + CConstants.ContractUploadPdfURL,
            parameters: parame).responseJSON{ (response) -> Void in
                self.spinner?.stopAnimating()
                self.spinner?.removeFromSuperview()
                if response.result.isSuccess {
                    if let rtnValue = response.result.value as? [String: String]{
                        if rtnValue["status"] == "success" {
                            self.progressBar?.message = PDFFields.SavedSuccessMsg
                        }else{
                            self.progressBar?.message = PDFFields.SavedFailMsg
                        }
                    }else{
                        self.progressBar?.message = CConstants.MsgServerError
                    }
                }else{
                    self.progressBar?.message = CConstants.MsgNetworkError
                }
                self.performSelector("dismissProgress", withObject: nil, afterDelay: 0.5)
        }
        
    }
    func dismissProgress(){
        self.progressBar?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initWithData(data: NSData){
        isDownload = true
        document = PDFDocument(data: data)
    }
    
    func initWithResource(name: String){
        isDownload = false
        document = PDFDocument(resource: name)
    }
    
    func initWithPath(path: String){
        isDownload = false
        document = PDFDocument(resource: path)
    }
    
    func reload(){
        document?.refresh()
        pdfView?.removeFromSuperview()
        pdfView = nil
        loadPDFView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        loadPDFView()
    }
    
    private func addEntitiesToDictionary(fromDic fromDic: [String: String], toDic: [String: String]?) -> [String: String]{
        var rtnDic = toDic ?? [String: String]()
        for one in fromDic {
            rtnDic[one.0] = one.1
        }
        return rtnDic
    }
    
    private func getFileName() -> String{
        return "contract1pdf_" + self.pdfInfo!.idcity! + "_" + self.pdfInfo!.idcia!
    }
    
    private func loadPDFView(){
        let pass = document?.documentPath ?? document?.documentData
        let margins = getMargins()
        var additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y) as? [PDFWidgetAnnotationView]
        
        
        
        
        
        var aPrice : PDFWidgetAnnotationView?
        var aCiaName : PDFWidgetAnnotationView?
        
        for pv : PDFWidgetAnnotationView in additionViews!{
            print(pv.xname, pv.frame)
            
                
                switch pv.xname {
                case PDFFields.CompanyName:
                    aCiaName = pv
                    pv.value = pdfInfo?.cianame!
                case PDFFields.Address:
                    pv.value = pdfInfo?.ciaaddress!
                case PDFFields.CityStateZip:
                    pv.value = pdfInfo?.ciacityzip!
                case PDFFields.TelFax:
                    pv.value = pdfInfo?.ciatelfax!
                case PDFFields.IdNo:
                    pv.value = pdfInfo?.addendumNo!
                case PDFFields.DateL:
                    pv.value = pdfInfo?.addendumDate!
                case PDFFields.ContractDate:
                    pv.value = pdfInfo?.contractdate!
                case PDFFields.EstimatedCompletion:
                    pv.value = pdfInfo?.estimatedcompletion!
                case PDFFields.EstamatedClosing:
                    pv.value = pdfInfo?.estimatedclosing!
                case PDFFields.StageContract:
                    pv.value = pdfInfo?.stage!
                case PDFFields.JobAddress:
                    pv.value = pdfInfo?.jobaddress!
                case PDFFields.Buyer:
                    pv.value = pdfInfo?.buyer!
                case PDFFields.Consultant:
                    pv.value = pdfInfo?.consultant!
                case PDFFields.SubDivision:
                    pv.value = pdfInfo?.subdivision!
                case PDFFields.Price:
                    aPrice = pv
                    pv.value = pdfInfo?.price!
//                case PDFFields.Buyer1SignatureDate:
//                    pv.value = "fasfadfdfaffasfasdfafdasfd"
//                    pv.frame = CGRectMake(508, 500, 190, 28)
//                case PDFFields.ConsultantSignatureDate:
//                    pv.value = "fasfasdfafdasfd"
//                    pv.frame = CGRectMake(508, 300, 190, 28)
                default:
                    break
                }
           
        }
        if let price = aPrice {
            var pf : PDFFormTextField?
            var y : CGFloat = price.frame.origin.y + price.frame.size.height + 37
            if let list = pdfInfo?.itemlist {
                for items in list {
                    pf = PDFFormTextField(frame: CGRect(x: aCiaName!.frame.origin.x, y: y, width: 600, height: price.frame.size.height), multiline: false, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true)
                    pf?.xname = "april"
                    y = y + price.frame.size.height + 8
                    pf?.value = items.xitem! + "    " +  items.xdescription!
                    additionViews?.append(pf!)
                    //                pf = PDFFormTextField()
                    //               (391 273; 200 15)
                    //                (521 363; 266 20)
                }
            }
        }
        
        pdfView = PDFView(frame: view.bounds, dataOrPath: pass, additionViews: additionViews)
        view.addSubview(pdfView!)
        
    }
    
    
    private struct PDFMargin{
        static let PDFLandscapePadWMargin: CGFloat = 13.0
        static let PDFLandscapePadHMargin: CGFloat = 7.25
        static let PDFPortraitPadWMargin: CGFloat = 9.0
        static let PDFPortraitPadHMargin: CGFloat = 6.10
        static let PDFPortraitPhoneWMargin: CGFloat = 3.5
        static let PDFPortraitPhoneHMargin: CGFloat = 6.7
        static let PDFLandscapePhoneWMargin: CGFloat = 6.8
        static let PDFLandscapePhoneHMargin: CGFloat = 6.5
        
    }
    private func getMargins() -> CGPoint {
        let currentOrientation = UIApplication.sharedApplication().statusBarOrientation
        switch (UI_USER_INTERFACE_IDIOM()){
        case .Pad:
            if UIInterfaceOrientationIsPortrait(currentOrientation) {
                return CGPoint(x:PDFMargin.PDFPortraitPadWMargin, y:PDFMargin.PDFPortraitPadHMargin)
            }else{
                return CGPoint(x:PDFMargin.PDFLandscapePadWMargin, y:PDFMargin.PDFLandscapePadHMargin)
            }
            
        default:
            if UIInterfaceOrientationIsPortrait(currentOrientation) {
                return CGPoint(x:PDFMargin.PDFPortraitPhoneWMargin, y:PDFMargin.PDFPortraitPhoneHMargin)
            }else{
                return CGPoint(x:PDFMargin.PDFLandscapePhoneWMargin, y:PDFMargin.PDFLandscapePhoneHMargin)
            }
        }
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

//    @IBAction func savePDF(sender: UIBarButtonItem) {
//        
//        let savedPdfData = toPDF([cianame])
//        let s = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
//        let parame = ["username": "April for test", "code": "655443546", "file": s!,"idcia": "9999", "idproject": "100005"]
//        print(parame)
//        Alamofire.request(.POST,
//            CConstants.ServerURL + CConstants.ContractUploadPdfURL,
//            parameters: parame).responseJSON{ (response) -> Void in
////                self.spinner?.stopAnimating()
////                self.spinner?.removeFromSuperview()
//                if response.result.isSuccess {
//                    if let rtnValue = response.result.value as? [String: String]{
//                        if rtnValue["status"] == "success" {
//                            print("aaa")
////                            self.progressBar?.message = PDFFields.SavedSuccessMsg
//                        }else{
////                            self.progressBar?.message = PDFFields.SavedFailMsg
//                        }
//                    }else{
////                        self.progressBar?.message = CConstants.MsgServerError
//                    }
//                }else{
////                    self.progressBar?.message = CConstants.MsgNetworkError
//                }
////                self.performSelector("dismissProgress", withObject: nil, afterDelay: 0.5)
//        }
//        
//    }

    
}