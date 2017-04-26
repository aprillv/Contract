//
//  EmailAfterApprovedViewController.swift
//  Contract
//
//  Created by April on 6/14/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD


class EmailAfterApprovedViewController: BaseViewController, UIWebViewDelegate, SaveAndEmailViewControllerDelegate, GoToFileDelegate{

    @IBAction func reloadPDF(_ sender: AnyObject?) {
        errorLbl.isHidden = true
        reloadBtn.isHidden = true
        
        let url = "https://contractssl.buildersaccess.com/bacontract_contractDocument2?idcia=" + (contractInfo?.idcia ?? "") + "&idproject=" + (contractInfo?.idproject ?? "")
        
        //        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)[NSURL fileURLWithPath:@"your path"]);
        //        int pageCount = CGPDFDocumentGetNumberOfPages(pdf);
        
        
        
        if let nsurl = URL(string: url) {
            ////            CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)url);
            ////            self.pdfPageCount = (int)CGPDFDocumentGetNumberOfPages(pdf);
            //
            //            let pdf  =
            
            let request = URLRequest(url: nsurl)
            webview.loadRequest(request)
            spinner.startAnimating()
        }
        
    }
    @IBOutlet var errorLbl: UILabel!
    @IBOutlet var reloadBtn: UIButton!
    @IBOutlet var webview: UIWebView!{
        didSet{
        webview.scrollView.bouncesZoom = false
            webview.scrollView.zoomScale = 1
            webview.scrollView.backgroundColor = UIColor.white
        }
    }
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    fileprivate struct constants {
        static let segueToEmail = "showSendEmailBox"
    }
    @IBAction func SendEmail(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: constants.segueToEmail, sender: nil)
    }
    
    var contractInfo: ContractsItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webview.isOpaque = false
        
        self.view.backgroundColor = UIColor.white
        self.title = contractInfo?.nproject ?? ""
        
        webview.scrollView.contentOffset = CGPoint.zero
        
        
       reloadPDF(nil)
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        webview.stopLoading()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK : UIWebView delegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.startAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        spinner.stopAnimating()
        errorLbl.isHidden = false
        reloadBtn.isHidden = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinner.stopAnimating()
//          print(view.frame, webview.frame, webview.scrollView.frame)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case constants.segueToEmail:
                if let controller = segue.destination as? SaveAndEmailViewController{
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
                        emailList.append("phalycak@kirbytitle.com")
                        emailList.append("heatherb@kirbytitle.com")
                        
                        controller.xemailList = emailList
                        let userInfo = UserDefaults.standard
                        let email = userInfo.value(forKey: CConstants.UserInfoEmail) as? String
                        
                        controller.xemailcc = email ?? ""
                        controller.xdes = "This is the contract of your new house."
                    }
                }
            case "GoToFile2":
                if let controller = segue.destination as? GoToFileViewController {
                    controller.delegate = self
                    if let a = sender as? [String] {
                    controller.printList = a
                    }
                    
                }
                break
            default:
                break
            }
        }
        
    }
    
    var hud : MBProgressHUD?
    func GoToEmailSubmit(_ email: String, emailcc: String, msg: String) {
        let str = "bacontract_SendEmail2.json"
        
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
        
        var param = ["idcontract": contractInfo?.idnumber ?? "", "EmailTo":email1,"EmailCc":emailcc1,"Subject":"\(contractInfo!.nproject!)'s Contract","Body":msg,"idcia":contractInfo?.idcia ?? "","idproject":contractInfo?.idproject ?? "", "salesemail": userInfo.string(forKey: CConstants.UserInfoEmail) ?? "", "salesname": userInfo.string(forKey: CConstants.UserInfoName) ?? ""]
        
        if contractInfo?.idcia == "9999" {
            param = ["idcontract":contractInfo?.idnumber ?? ""
                , "EmailTo": "april@buildersaccess.com"
                , "EmailCc": "xiujun_85@163.com"
                , "Subject":"\(contractInfo!.nproject!)'s Contract"
                , "Body":msg
                , "idcia":contractInfo?.idcia ?? ""
                , "idproject":contractInfo?.idproject ?? ""
                , "salesemail": userInfo.string(forKey: CConstants.UserInfoEmail) ?? ""
                , "salesname": userInfo.string(forKey: CConstants.UserInfoName) ?? ""]
        }
        
        print(param)
         hud = MBProgressHUD.showAdded(to: webview, animated: true)
        //                hud.mode = .AnnularDeterminate
        hud?.labelText = "Sending Email..."
        hud?.show(true)
        
        Alamofire.request(CConstants.ServerURL + str,
                          method: .post,
            parameters: param).responseJSON{ (response) -> Void in
                
                //                print(param, serviceUrl, response.result.value)
                if response.result.isSuccess {
                    print(response.result.value)
                    if let rtnValue = response.result.value as? Bool{
                        if rtnValue {
                            self.hud?.mode = .customView
                            let image = UIImage(named: CConstants.SuccessImageNm)
                            self.hud?.customView = UIImageView(image: image)
                            
                            self.hud?.labelText = "Email sent successfully."
                            self.perform(#selector(EmailAfterApprovedViewController.dismissProgress as (EmailAfterApprovedViewController) -> () -> ()), with: nil, afterDelay: 0.5)
                        }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                            self.perform(#selector(EmailAfterApprovedViewController.dismissProgress as (EmailAfterApprovedViewController) -> () -> ()), with: nil, afterDelay: 0.5)
                        }
                        
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                        self.perform(#selector(EmailAfterApprovedViewController.dismissProgress as (EmailAfterApprovedViewController) -> () -> ()), with: nil, afterDelay: 0.5)
                    }
                }else{
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                    self.perform(#selector(EmailAfterApprovedViewController.dismissProgress as (EmailAfterApprovedViewController) -> () -> ()), with: nil, afterDelay: 0.5)
                }
        }
        
    }
    
    func dismissProgress(){
        self.hud?.hide(true)
    }
    
    func ClearEmailData() {
        
    }
    
    @IBAction func SkipToFile(_ sender: UIBarButtonItem) {
        if self.webview.isLoading {
            return
        }
        self.GetPrintedFileList()
    }
    func GetPrintedFileList(){
        if let c = self.contractInfo {
            let param = ["idcontract1" : c.idnumber ?? ""]
            //            print(param,  CConstants.ServerURL + "bacontract_GetPrintedFileList.json")
            
            Alamofire.request(CConstants.ServerURL + "bacontract_GetPrintedFileList2.json"
                , method: .post
                , parameters: param).responseJSON{ (response) -> Void in
//                                print(response.result.value)
                if response.result.isSuccess {
                    c.printList = response.result.value as? [Int]
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
                    var array = [String]()
                    var arrayCnt = [Int]()
                    if let list = response.result.value as? [Int] {
                        for l in list{
                            switch l{
                            case 0:
                                array.append("Photo Check")
                                arrayCnt.append(1)
                            case 1:
                                array.append("Print Contract")
                                arrayCnt.append(9)
                            case 2:
                            array.append("Third Party Financing Addendum")
                                arrayCnt.append(2)
                            case 3:
                                array.append("Information about Brokerage Services")
                                arrayCnt.append(2)
                            case 4:
                                array.append("Addendum A")
                                arrayCnt.append(6)
                            case 5:
                                array.append("Exhibit A")
                                arrayCnt.append(1)
                            case 6:
                                array.append("Exhibit B")
                                 arrayCnt.append(1)
                            case 7:
                                array.append("Exhibit C General")
                                 arrayCnt.append(3)
                            case 8:
                                array.append("Buyers Expect")
                                 arrayCnt.append(5)
                            case 9:
                                array.append("Addendum C")
                                 arrayCnt.append(0)
                            case 10:
                                array.append("Addendum D")
                                 arrayCnt.append(2)
                            case 11:
                                array.append("Addendum E")
                                arrayCnt.append(2)
                            case 12:
                                array.append("Floodaplain Acknowledgement")
                                arrayCnt.append(1)
                            case 14:
                                array.append("Warranty Acknowledgement")
                                arrayCnt.append(2)
                            case 15:
                                array.append("Design Center")
                                arrayCnt.append(1)
                                
                            case 17:
                                array.append("Addendum for Property Subject to HOA")
                                arrayCnt.append(1)
                            case 13:
                                array.append("HOA Checklist")
                                arrayCnt.append(3)
                            default:
                                break
                            }
                        }
                    }
                    var cnt = 0
                    var index = 0;
                    for i in arrayCnt {
                        if i != 0 {
                            index += 1
                        }
                        
                        cnt += i
                    }
                    let cnt0 = (self.webview.scrollView.contentSize.height / self.webview.scrollView.frame.size.height)
                    print( Int(cnt0) - cnt, self.webview.pageLength, self.webview.gapBetweenPages)
                    arrayCnt[index] = self.webview.pageCount - cnt
                    
                    
                    self.performSegue(withIdentifier: "GoToFile2", sender: array)
                    //                    print(response.result.value)
                }else{
                    c.printList = nil
                    self.performSegue(withIdentifier: "GoToFile2", sender: nil)
                }
            }
        }
    }
    
   
    func skipToFile(_ filenm: String) {
        print(filenm)
    }
}
