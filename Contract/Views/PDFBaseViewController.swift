//
//  PDFBaseViewController.swift
//  Contract
//
//  Created by April on 12/21/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

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


class PDFBaseViewController: BaseViewController, DoOperationDelegate, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate, ToSwitchAddressDelegate {
    
    
//    @IBOutlet var view2: UIView!
    var document : PDFDocument?
    var documents : [PDFDocument]?
//    var documentAddedDotArray : [[PDFWidgetAnnotationView]]?
    var pdfView  : PDFView?
//    var AddressList : [ContractsItem]?
    
//    var locked: Bool?
    
    
//    var hoa: NSNumber?
//    var status : String?
//    var approvedate : String?
//    var approveMonthdate : String?
//    var broker : String?
    
    
//    var spinner : UIActivityIndicatorView?
//    var spinner : UIActivityIndicatorView? = UIActivityIndicatorView(frame: CGRect(x: 0, y: 4, width: 50, height: 50)){
//        didSet{
//            
//            spinner!.hidesWhenStopped = true
//            spinner!.activityIndicatorViewStyle = .Gray
//        }
//    }
  
    
    var contractInfo: ContractsItem?
    
    var pdfInfo0 : ContractPDFBaseModel?
    
    var fileName: String?
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func savePDF(_ sender: UIBarButtonItem) {
        
        
    }
    func dismissProgress(){
        self.hud?.hide(true)
    }
    func dismissProgressThenEmail(){
        self.hud?.hide(true)
        self.sendEmail()
    }
    func dismissProgress(_ controller : UIViewController){
        self.hud?.hide(true)
//        self.progressBar?.dismissViewControllerAnimated(true){
            if controller.isKind(of: UIPrintInteractionController.self){
                //            if let c = controller as? UIPrintInteractionController {
                //                c.dismissAnimated(true)
                //            }
            }else{
                controller.dismiss(animated: true, completion: nil)
            }
//        }
        
    }
    
    func initWithData(_ data: Data){
        document = PDFDocument(data: data)
    }
    
    func initWithResource(_ name: String){
        document = PDFDocument(resource: name)
    }
    
    func initWithPath(_ path: String){
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
//        locked = false
        fileName = self.navigationItem.title!
        loadPDFView()
    }
    
    
    
    func loadPDFView(){
        
        
    }
    
    
    fileprivate struct PDFMargin{
        static let PDFLandscapePadWMargin: CGFloat = 13.0
        static let PDFLandscapePadHMargin: CGFloat = 7.25
        static let PDFPortraitPadWMargin: CGFloat = 9.0
        static let PDFPortraitPadHMargin: CGFloat = 6.10
        static let PDFPortraitPhoneWMargin: CGFloat = 3.5
        static let PDFPortraitPhoneHMargin: CGFloat = 6.7
        static let PDFLandscapePhoneWMargin: CGFloat = 6.8
        static let PDFLandscapePhoneHMargin: CGFloat = 6.5
        
    }
    func getMargins() -> CGPoint {
        let currentOrientation = UIApplication.shared.statusBarOrientation
        switch (UI_USER_INTERFACE_IDIOM()){
        case .pad:
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
    
    var hud : MBProgressHUD?
    func savePDFToServer(_ xname: String, nextFunc: String?){
        
//        var parame : [String : String] = ["idcia" : pdfInfo0!.idcia!
//            , "idproject" : pdfInfo0!.idproject!
//            , "code" : pdfInfo0!.code!
//            , "idcontract" : pdfInfo0!.idnumber ?? ""
//            ,"filetype" : pdfInfo0?.nproject ?? "" + "_\(xname)_FromApp"]
//        
//        var savedPdfData: NSData?
//        
//        if self.documents != nil && self.documents?.count > 0 {
//            savedPdfData = PDFDocument.mergedDataWithDocuments(self.documents)
//        }else{
//            if let added = pdfView?.addedAnnotationViews{
//                //            print(added)
//                savedPdfData = document?.savedStaticPDFData(added)
//            }else{
//                savedPdfData = document?.savedStaticPDFData()
//            }
//        }
//        
//        let fileBase64String = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
//        parame["file"] = fileBase64String
//        parame["username"] = NSUserDefaults.standardUserDefaults().valueForKey(CConstants.LoggedUserNameKey) as? String ?? ""
//       
////        let t = self.hud
////        if hud != nil {
////            self.hud?.hide(false)
////        }
//        if hud == nil {
//            hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        }
//        
//        //                hud.mode = .AnnularDeterminate
//        hud?.labelText = CConstants.SavedMsg
//        
//      
////        print(parame)
//        Alamofire.request(.POST,
//            CConstants.ServerURL + CConstants.ContractUploadPdfURL,
//            parameters: parame).responseJSON{ (response) -> Void in
////                self.hud?.hide(true)
////                print(response.result.value)
//                if response.result.isSuccess {
//                    if let rtnValue = response.result.value as? [String: String]{
//                        if rtnValue["status"] == "success" {
//                            self.hud?.mode = .CustomView
//                            let image = UIImage(named: CConstants.SuccessImageNm)
//                            self.hud?.customView = UIImageView(image: image)
//                            
//                            self.hud?.labelText = CConstants.SavedSuccessMsg
//                        }else{
//                            self.hud?.mode = .Text
//                            self.hud?.labelText = CConstants.SavedFailMsg
//                        }
//                    }else{
//                        self.hud?.mode = .Text
//                        self.hud?.labelText = CConstants.MsgServerError
//                    }
//                }else{
//                    self.hud?.mode = .Text
//                    self.hud?.labelText = CConstants.MsgNetworkError
//                }
//                if let _ = nextFunc {
//                    self.performSelector(#selector(PDFBaseViewController.dismissProgressThenEmail as (PDFBaseViewController) -> () -> ()), withObject: nextFunc, afterDelay: 0.5)
//                    
//                }else{
//                    self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
//                }
//        }
    }
    
    
   
    
    
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func saveToServer() {
//        IQKeyboardManager.sharedManager().enable = true
        
       
        
//        savePDFToServer(fileName!, nextFunc: nil)
    }
    
    func doPrint() {
        var savedPdfData: Data?
        
        if self.documents != nil && self.documents?.count > 0 {
            savedPdfData = PDFDocument.mergedData(withDocuments: self.documents)
        }else{
            if let added = pdfView?.addedAnnotationViews{
                //            print(added)
                savedPdfData = document?.savedStaticPDFData(added)
            }else{
                savedPdfData = document?.savedStaticPDFData()
            }
        }
        if UIPrintInteractionController.canPrint(savedPdfData!) {
            
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = fileName!
            printInfo.outputType = .photo
            
            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = false
            
            printController.printingItem = savedPdfData!
            
            printController.present(animated: true, completionHandler: nil)
            printController.delegate = self
        }
    }
    func printInteractionControllerParentViewController(_ printInteractionController: UIPrintInteractionController) -> UIViewController? {
        return self.navigationController!
    }
    func printInteractionControllerWillPresentPrinterOptions(_ printInteractionController: UIPrintInteractionController) {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0, green: 164/255.0, blue: 236/255.0, alpha: 1)
        self.navigationController?.topViewController?.navigationController?.navigationBar.tintColor = UIColor(red: 0, green: 164/255.0, blue: 236/255.0, alpha: 1)
    }
    
    fileprivate func getFileName() -> String{
//        print(pdfInfo0?.nproject)
//        print(fileName)
//        return pdfInfo0!.nproject! + "_\(fileName!)_FromApp"
        return "Online Contract"
    }
    func sendEmail() {
//        print(contractInfo?.buyer1email ?? "")
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            
            var savedPdfData: Data?
            
            if self.documents != nil && self.documents?.count > 0 {
                savedPdfData = PDFDocument.mergedData(withDocuments: self.documents)
            }else{
                if let added = pdfView?.addedAnnotationViews{
                    //            print(added)
                    savedPdfData = document?.savedStaticPDFData(added)
                }else{
                    savedPdfData = document?.savedStaticPDFData()
                }
            }
            mailComposeViewController.addAttachmentData(savedPdfData!, mimeType: "application/pdf", fileName: getFileName())
            mailComposeViewController.navigationBar.barStyle = .black
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func sendEmail2() {
    }
    
    func viewAttachPhoto(){}
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
//        print(contractInfo?.buyer1email ?? "")
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        let userInfo = UserDefaults.standard
        let userEmail = userInfo.object(forKey: CConstants.UserInfoEmail) as? String
        
        var mails : [String] = [String]()
        if let bemail1 = contractInfo?.buyer1email{
        mails.append(bemail1)
        }
        if let bemail2 = contractInfo?.buyer2email{
            mails.append(bemail2)
        }
        mailComposerVC.setToRecipients(mails)
       mailComposerVC.setCcRecipients([userEmail ?? ""])
        
        mailComposerVC.setSubject(getFileName())
        mailComposerVC.setMessageBody("This is the \(pdfInfo0!.nproject!)'s contract document", isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismissViewControllerAnimated(true, completion: nil)
    
        if let error1 = error{
            self.PopMsgWithJustOK(msg: error1.localizedDescription){ (action) -> Void in
                controller.dismiss(animated: true, completion: nil)
            }
        }else if result.rawValue == 2 {
            controller.dismiss(animated: true){
                if self.hud == nil {
                    self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                }
                self.hud?.mode = .customView
                let image = UIImage(named: CConstants.SuccessImageNm)
                self.hud?.customView = UIImageView(image: image)
                
                self.hud?.labelText = CConstants.SendEmailSuccessfullMsg
                self.perform(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), with: nil, afterDelay: 0.5)
            }
//         }else if result.rawValue == 0 {
//            
//            controller.dismissViewControllerAnimated(true, completion: {
////                self.PopMsgWithJustOK(msg: "dfasdfasdf")
//            })
            
//            controller.dismissViewControllerAnimated(true, completion: nil)
        }else {
//            self.dismissViewControllerAnimated(true, completion: {
//                
//            })
//            controller.dismissViewControllerAnimated(true, completion: {
//                self.PopMsgWithJustOK(msg: "\(result.rawValue)")
//            })
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func GoToPrint(_ modelNmA: [String], _ line1: String, _ line2: String) {

            if modelNmA.contains(CConstants.ActionTitleAddendumC) {
                callService(modelNmA, param: ContractRequestItem(contractInfo: nil).DictionaryFromBasePdf(self.pdfInfo0!))
            }else{
                let vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewController(withIdentifier: CConstants.ControllerNamePrint) as? PDFBaseViewController
                if let controller = vc as? PDFPrintViewController{
                    controller.pdfInfo0 = self.pdfInfo0
                    controller.filesArray = modelNmA
                    controller.initWithResource(CConstants.PdfFileNameAddendumC2)
                    controller.page2 = false
                    var na = self.navigationController?.viewControllers
                    na?.removeLast()
                    na?.append(controller)
                    self.navigationController?.viewControllers = na!
                }
            }
        
        
        
    }
    
    fileprivate func callService(_ printModelNms: [String], param: [String: String]){
        var serviceUrl: String?
        var printModelNm: String
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
        if self.hud == nil {
            self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        self.hud?.mode = .indeterminate
        self.hud?.labelText = CConstants.RequestMsg

        Alamofire.request("\(CConstants.ServerURL)\(serviceUrl!)",
            method: .post,
            parameters: param).responseJSON{ (response) -> Void in
                self.hud?.hide(true)
                if response.result.isSuccess {
                    
                    if let rtnValue = response.result.value as? [String: AnyObject]{
                        if let msg = rtnValue["message"] as? String{
                            if msg.isEmpty{
                                var vc : PDFBaseViewController?
                                switch printModelNm {
                                case CConstants.ActionTitleAddendumC:
                                    var itemList = [[String]]()
                                    var i = 0
                                    if let list = ContractAddendumC(dicInfo: rtnValue).itemlist {
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
                                    
//                                    if printModelNms.count == 1 {
//                                        vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameAddendumC) as? PDFBaseViewController
//                                        if let controller = vc as? AddendumCViewController{
//                                            controller.pdfInfo = ContractAddendumC(dicInfo: rtnValue)
//                                            
//                                            
//                                            controller.pdfInfo!.itemlistStr = itemList
//                                            
//                                            
//                                            let pass = i > 19 ? CConstants.PdfFileNameAddendumC2 : CConstants.PdfFileNameAddendumC
//                                            
//                                            controller.initWithResource(pass)
//                                        }
//                                    }else{
                                        vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewController(withIdentifier: CConstants.ControllerNamePrint) as? PDFBaseViewController
                                        if let controller = vc as? PDFPrintViewController{
                                            controller.pdfInfo0 = ContractAddendumC(dicInfo: rtnValue)
                                            
                                            controller.addendumCpdfInfo = ContractAddendumC(dicInfo: rtnValue)
                                            controller.addendumCpdfInfo!.itemlistStr = itemList
//                                            let pass = i > 19 ? CConstants.PdfFileNameAddendumC2 : CConstants.PdfFileNameAddendumC
                                            controller.filesArray = printModelNms
                                            controller.page2 = i > 19
//                                            controller.initWithResource(pass)
                                        }
//                                    }
                                    
                                
                                default:
                                    break;
                                }
//                                if let vcc = vc {
//                                    vcc.AddressList = self.AddressList
//                                    var na = self.navigationController?.viewControllers
//                                    na?.removeLast()
//                                    na?.append(vcc)
//                                    self.navigationController?.viewControllers = na!
//                                }
                                
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
    
    func GoToAddress(_ item : ContractsItem) {
//        if self.navigationItem.title! == CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES {
//            if let vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameINFORMATION_ABOUT_BROKERAGE_SERVICES) as? PDFBaseViewController{
//                
//                vc.pdfInfo0 = self.pdfInfo0
//                vc.pdfInfo0?.nproject = item.nproject
//                vc.pdfInfo0?.idcia = item.idcia
//                vc.pdfInfo0?.idcity = item.idcity
//                vc.pdfInfo0?.idnumber = item.idnumber
//                vc.pdfInfo0?.idproject = item.idproject
//                vc.pdfInfo0?.code = item.code
//                vc.initWithResource(CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES)
//                
//                vc.AddressList = self.AddressList
//                var na = self.navigationController?.viewControllers
//                na?.removeLast()
//                na?.append(vc)
//                self.navigationController?.viewControllers = na!
//            }
//            
//            return
//        }
        if self.isKind(of: PDFPrintViewController.self) {
            if let printViewController = self as? PDFPrintViewController {
                if printViewController.filesArray!.contains(CConstants.ActionTitleAddendumC) {
                    self.callService(printViewController.filesArray!, param: ContractRequestItem(contractInfo: item).DictionaryFromObject())
                }else{
                    let vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewController(withIdentifier: CConstants.ControllerNamePrint) as? PDFBaseViewController
                    if let controller = vc as? PDFPrintViewController{
                        controller.pdfInfo0 = self.pdfInfo0
                        controller.pdfInfo0?.nproject = item.nproject
                        controller.pdfInfo0?.idcia = item.idcia
                        controller.pdfInfo0?.idcity = item.idcity
                        controller.pdfInfo0?.idnumber = item.idnumber
                        controller.pdfInfo0?.idproject = item.idproject
                        controller.pdfInfo0?.code = item.code
                        controller.filesArray = printViewController.filesArray
//                        controller.initWithResource(CConstants.PdfFileNameAddendumC2)
                        controller.page2 = false
//                        controller.AddressList = self.AddressList
                        var na = self.navigationController?.viewControllers
                        na?.removeLast()
                        na?.append(controller)
                        self.navigationController?.viewControllers = na!
                    }
                }
            }
        }else{
            self.callService([self.navigationItem.title!], param: ContractRequestItem(contractInfo: item).DictionaryFromObject())
        }
        
    }
    
    func fillDraftInfo() {
       
    }
    
    func clearDraftInfo() {
        
    }
    
    func save_Email() {
        savePDFToServer(fileName!, nextFunc: "sendemail")
    }
    
    func startover(){
   
    }
    
    func submit() {
        
    }
    
    func saveFinish() {
        
    }
    
    func saveEmail() {
        
    }
    
    func attachPhoto() {
        
    }
    
    func emailContractToBuyer() {
        
    }
    func submitBuyer1Sign(){
        
    }
    func submitBuyer2Sign(){
        
    }
    
    func changeBuyre1ToIPadSign(){}
    func changeBuyre2ToIPadSign(){}
    
    func gotoBuyer1Sign() {}
    func gotoBuyer2Sign() {}
    func gotoSellerSign() {}
    
}
