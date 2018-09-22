//
//  SetDotValue.swift
//  Contract
//
//  Created by April on 2/23/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import Foundation
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


class SetDotValue : NSObject {
    
    // MARK: Sign Contract
    fileprivate struct SignContractPDFFields{
        
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
        static let pdf2213 = "2213"
        
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
        
        //04/23/2016
//        static let OtherBrokerFirm = "Other Broker Firm"
        static let OtherBrokerFirmNo = "License No"
        static let LicensedSupervisor = "Name of Associates Licensed Supervisor"
        static let AssociateNameNo = "Telephone"
        static let LicensedSupervisorNo = "Telephone_2"
        static let OtherBrokerAddress = "Other Brokers Address"
        static let OtherBrokerAddressFax = "Facsimile"
        static let CityState = "CityState"
        static let CityStateZip = "Zip"
        
        //05032016
        static let escrow_agent = "escrowagent"
        static let agent_address = "address2"
        static let insurance_company = "titlecompany"
        static let seller_name = "toseller1"
        static let seller_address = "toseller2"
        static let seller_tel1 = "toseller3"
        static let seller_tel2 = "toseller4"
        static let seller_fax1 = "toseller5"
        static let seller_fax2 = "toseller6"

        
    }
    
    fileprivate func getFileName(_ pdfInfo: ContractSignature?) -> String{
        return "contract1pdf_" + pdfInfo!.idcity! + "_" + pdfInfo!.idcia!
    }
    
    func setSignContractDots(_ pdfInfo:ContractSignature?, additionViews: [PDFWidgetAnnotationView], pdfview: PDFView, item: ContractsItem?){
//        print("first")
//        if let filedsFromTxt = readContractFieldsFromTxt(getFileName(pdfInfo)) {
//            
//            
//            let na = filedsFromTxt.keys
//            for pv : PDFWidgetAnnotationView in additionViews{
//                if na.contains(pv.xname){
//                    pv.value = filedsFromTxt[pv.xname]
//                }
//            }
//
//        }
        
        var tobuyer3 : String
        var tobuyer4 : String
        if let b = pdfInfo!.bmobile1 == "" ? pdfInfo?.boffice1! : pdfInfo?.bmobile1! {
            if b.contains("-") {
                let a = b.components(separatedBy: "-")
                if a.count > 2 {
                    tobuyer3 = a[0]
                    if tobuyer3.characters.count != 3 {
                        tobuyer3 = ""
                        tobuyer4 = b
                    }else{
                        let index1 = b.characters.index(b.startIndex, offsetBy: 4)
                        tobuyer4 = b.substring(from: index1)
                    }
                }else{
                    tobuyer3 = ""
                    tobuyer4 = b
                }
            
            }else if strlen(b) >= 10 {
                let ss = b.characters.index(b.startIndex, offsetBy: 3)
                tobuyer3 = b.substring(to: ss)
                tobuyer4 = b.substring(from: ss)
            }else{
                tobuyer3 = ""
                tobuyer4 = b
            }
            
        }else{
            tobuyer3 = ""
            tobuyer4 = ""
        }
        
        if (pdfInfo?.client2 ?? "") != "" {
//            tobuyer4 = tobuyer4 + " / " +  (pdfInfo!.bmobile2 ?? "")
            tobuyer4 = tobuyer4  +  doPhoneNo(pdfInfo!.bmobile2 ?? "")
        }
        
        
        var tobuyer5 : String
        var tobuyer6 : String
        if let b = pdfInfo!.bfax1 {
            if b.contains("-") {
                let a = b.components(separatedBy: "-")
                if a.count > 2 {
                    tobuyer5 = a[0]
                    let index1 = b.characters.index(b.startIndex, offsetBy: 4)
                    tobuyer6 = b.substring(from: index1)
                }else{
                    tobuyer5 = ""
                    tobuyer6 = b
                }
            }else if strlen(b) >= 10 {
                let ss = b.characters.index(b.startIndex, offsetBy: 3)
                tobuyer5 = b.substring(to: ss)
                tobuyer6 = b.substring(from: ss)
            }else{
                tobuyer5 = ""
                tobuyer6 = b
            }
            
        }else{
            tobuyer5 = ""
            tobuyer6 = ""
        }
//        print(pdfInfo!.bfax2)
        if (pdfInfo?.client2 ?? "") != "" {
            //            tobuyer4 = tobuyer4 + " / " +  (pdfInfo!.bmobile2 ?? "")
            tobuyer6 = tobuyer6  +  doPhoneNo(pdfInfo!.bfax2 ?? "")
        }
//        print(tobuyer6)
        
        
        var overrideFields : [String: String]
        overrideFields = [SignContractPDFFields.CompanyName : SignContractPDFFields.CompanyName1
            , SignContractPDFFields.Buyer : SignContractPDFFields.Buyer1
            , SignContractPDFFields.Lot: SignContractPDFFields.Lot1
            , SignContractPDFFields.Block : SignContractPDFFields.Block1
            , SignContractPDFFields.Section : SignContractPDFFields.Section1
            , SignContractPDFFields.City : SignContractPDFFields.City1
            , SignContractPDFFields.County : SignContractPDFFields.County1
            , SignContractPDFFields.Address : SignContractPDFFields.Address1
            , SignContractPDFFields.Address_zip : SignContractPDFFields.Address1
            , SignContractPDFFields.SalePrice : SignContractPDFFields.SalePrice1]
        
        //        pdfInfo?.section = "MEADOWS AT TRINITY CROSSING PHASE 2-B-1 AMENDED PL"
        
        let na = overrideFields.keys
        for pv : PDFWidgetAnnotationView in additionViews{
//            if let x = pv as? SignatureView {
////                print(x.menubtn, x.menubtn.superview)
//                if x.menubtn != nil {
//                x.menubtn.superview?.bringSubviewToFront(x.menubtn)
//                }
//                
////                if let a = pv as? SignatureView {
////                    a.addSignautre()
////                }
////                continue
//            }
            if na.contains(pv.xname){
                if SignContractPDFFields.Address_zip == pv.xname{
                    
                    if pdfInfo!.zipcode! != "" {
                        pv.value = "\(pdfInfo!.nproject!) / \(pdfInfo!.zipcode!)"
                    }else{
                        pv.value = pdfInfo!.nproject!
                    }
                }else if SignContractPDFFields.Address == pv.xname{
                    pv.value = pdfInfo!.nproject
                }else if(SignContractPDFFields.Buyer == pv.xname){
                    if (pdfInfo!.client2 != ""){
                        pv.value = pdfInfo!.client! + " / " + pdfInfo!.client2!
                    }else{
                        pv.value = pdfInfo!.client!
                    }
                    
                }else{
                    if let a = overrideFields[pv.xname!]{
                        pv.value = pdfInfo!.value(forKey: a) as! String
                    }
                    
                }
            }else {
                
                switch pv.xname {
                case SignContractPDFFields.seller_name:
                    pv.value = pdfInfo!.cianame!
                case SignContractPDFFields.seller_address:
                    pv.value = pdfInfo!.seller_address!
                case SignContractPDFFields.seller_tel1:
                    if let tel = pdfInfo?.seller_tel {
                    let d = tel.components(separatedBy: ".")
                        if d.count > 1 {
                        pv.value = d[0]
                        }
                    }
                    
                case SignContractPDFFields.seller_tel2:
                    if let tel = pdfInfo?.seller_tel {
                        let d = tel.components(separatedBy: ".")
                        if d.count > 2 {
                            pv.value = "\(d[1])-\(d[2])"
                        }else{
                            pv.value = tel
                        }
                    }
                case SignContractPDFFields.seller_fax1:
                    if let tel = pdfInfo?.seller_fax {
                        let d = tel.components(separatedBy: ".")
                        if d.count > 1 {
                            pv.value = d[0]
                        }
                    }
                    
                case SignContractPDFFields.seller_fax2:
                    if let tel = pdfInfo?.seller_fax {
                        let d = tel.components(separatedBy: ".")
                        if d.count > 2 {
                            pv.value = "\(d[1])-\(d[2])"
                        }else{
                            pv.value = tel
                        }
                    }
                case SignContractPDFFields.tobuyer6:
                    pv.value = tobuyer6
                case SignContractPDFFields.cashportion:
                    //                    pv.value = pdfInfo!.cashportion! == "" ? "0.00" : pdfInfo!.cashportion!
                    pv.value = pdfInfo!.cashportion!
                case SignContractPDFFields.financing:
                    pv.value = pdfInfo!.financing!
                case SignContractPDFFields.escrow_agent:
                    pv.value = pdfInfo!.escrow_agent!
                case SignContractPDFFields.agent_address:
                    pv.value = pdfInfo!.agent_address!
                case SignContractPDFFields.insurance_company:
                    pv.value = pdfInfo!.insurance_company!
                case SignContractPDFFields.estimatedclosing_MMdd:
                    pv.value = pdfInfo!.estimatedclosing_MMdd!
                case SignContractPDFFields.estimatedclosing_yy:
                    pv.value = pdfInfo!.estimatedclosing_yy!
                case SignContractPDFFields.tobuyer1:
                    if (pdfInfo?.client2 ?? "") != "" {
                        pv.value = pdfInfo!.client! + " / " +  pdfInfo!.client2!
                    }else{
                        pv.value = pdfInfo!.client!
                    }
                    
                case SignContractPDFFields.tobuyer2:
                    pv.value = pdfInfo!.tobuyer2!
                case SignContractPDFFields.tobuyer3:
                    pv.value = tobuyer3
                case SignContractPDFFields.tobuyer4:
                    pv.value = tobuyer4
                case SignContractPDFFields.tobuyer5:
                    pv.value = tobuyer5
                case SignContractPDFFields.tobuyer6:
                    pv.value = tobuyer6
                case SignContractPDFFields.tobuyer7:
                    if (pdfInfo?.client2 ?? "") != ""
                        && pdfInfo?.bemail2 != ""
                        && (pdfInfo?.bemail1 ?? "") != (pdfInfo?.bemail2 ?? ""){
                        pv.value = pdfInfo!.bemail1
                    }
                case "toseller7":
                    let userInfo = UserDefaults.standard
                    pv.value = userInfo.string(forKey: CConstants.UserInfoEmail) ?? ""
//                     pv.value = "brandonr@intown-homes.com"
                case "tobuyer72":
                    if (pdfInfo?.client2 ?? "") != "" && pdfInfo?.bemail2 != "" && (pdfInfo?.bemail1 ?? "") != (pdfInfo?.bemail2 ?? ""){
                        pv.value = pdfInfo!.bemail2!
                    }else{
                        pv.value = pdfInfo!.bemail1!
                    }
//                    pv.value = pdfInfo!.bemail1!
                case SignContractPDFFields.executeddd:
                    if let item1 = item {
                        if item1.status == CConstants.ApprovedStatus {
                            pv.value = pdfInfo!.approveMonthdate!.components(separatedBy: " ")[0]
                        }else{
                            pv.value = ""
                        }
                    }else{
                        pv.value = ""
                    }
                    
                    
//                    if let dd = pdfInfo?.executeddd {
//                    pv.value = dd
//                    }
                case SignContractPDFFields.executedmm:
                    if let item1 = item {
                        if item1.status == CConstants.ApprovedStatus {
                            pv.value = pdfInfo!.approveMonthdate!.components(separatedBy: " ")[1]
                        }else{
                            pv.value = ""
                        }
                    }else{
                        pv.value = ""
                    }
//                    if let dd = pdfInfo?.executedmm {
//                        pv.value = dd
//                    }
                case SignContractPDFFields.executedyy:
                    if let item1 = item {
                        if item1.status == CConstants.ApprovedStatus {
                            pv.value = pdfInfo!.approveMonthdate!.components(separatedBy: " ")[2]
                            let a = pv.value.index(pv.value.startIndex,offsetBy: 2)
                            pv.value = pv.value.substring(from: a)
//                            let a = pv.value.startIndex
//                            pv.value = pv.value.substring(from: pv.value.characters.index(a, offsetBy: index))
//                            pv.value = pv.value.substring(from: String.CharacterView corresponding to `a`.index(a, offsetBy: 2))
                        }else{
                            pv.value = ""
                        }
                    }else{
                        pv.value = ""
                    }
//                    if let dd = pdfInfo?.executedyy {
//                        pv.value = dd
//                    }
                    
                    
                case SignContractPDFFields.buyer_2:
                    pv.value = pdfInfo!.client!
//                    pv.removeFromSuperview()
                case SignContractPDFFields.buyer_3:
                    pv.value = pdfInfo!.client2!
                case SignContractPDFFields.seller_2:
                    pv.value = pdfInfo!.cianame!
                case SignContractPDFFields.pdf2211:
//                    pv.value = "Add A,C,D,E, Warr. Ack.,Exhibits A,B"
                    pv.value = pdfInfo?.trec1 ?? ""
//                    if (pdfInfo?.idcia ?? "100") == "386" {
//                        pv.value = "Addendums A,C,D, Exhibits A-C, Buyer & Constr."
//                    }else{
//                        if let a = pdfInfo?.idcity {
//                            if a == "1" {
//                                pv.value = "Addendums A,D,E, Exhibits A-C, Buyer & Constr."
//                            }else if a == "2" {
//                                pv.value = "Addendums A,B,D,E Exhibits A-C,"
//                            }else if a == "3" {
//                                pv.value = "Addendums A,C,D, Exhibits A-C, Buyer & Constr."
//                            }
//                        }
//                    }
                    
                case SignContractPDFFields.pdf2212:
                     pv.value = pdfInfo?.trec2 ?? ""
//                    if let a = pdfInfo?.idcity {
//                        if a == "2" {
//                            pv.value = "Builder Express Ltd Warranty & Performance St"
//                        }else {
//                            pv.value = "Expectations, Builder Express Ltd Warranty & Performance St"
//                        }
//                    }
                case "2214":
                    pv.value = pdfInfo?.trec4 ?? ""
                case "2215":
                    pv.value = pdfInfo?.trec5 ?? ""
                case SignContractPDFFields.pdf2213:
                     pv.value = pdfInfo?.trec3 ?? ""
                case SignContractPDFFields.pdf22a1:
                    if let radio = pv as? PDFFormButtonField {
                        radio.setValue2(pdfInfo!.page7ThirdPartyFinacingAddendum!)
                    }
                case SignContractPDFFields.pdf22a15:
                    if let radio = pv as? PDFFormButtonField {
                        radio .setValue2(pdfInfo!.other!)
                    }
                case SignContractPDFFields.pdf22a3:
                    if let radio = pv as? PDFFormButtonField {
                        radio .setValue2(pdfInfo!.hoa!)
                    }
                case SignContractPDFFields.pdf22a10:
                    if let radio = pv as? PDFFormButtonField {
                        radio.setValue2(pdfInfo!.environment!)
                    }
                case SignContractPDFFields.page7e2:
                    pv.value = pdfInfo!.page7e2!
                    //                case "buyer_2", "buyer_3", "seller_2", "seller_3":
                    //                case "buyer_2":
                    
                case SignContractPDFFields.p9Broker:
                    pv.value = pdfInfo!.page9OtherBrokerFirm
                case "otherbroker":
                    if let p = pdfInfo?.broker_percent {
                        if !p.contains("0."){
                            pv.value = "\(p)%"
                        }
                        
                    }
                    if let c = pdfInfo?.page9btsa {
                        if let b = pv.value {
                            pv.value = b + c;
                        }else{
                            pv.value = "0.00%" + c;
                        }
                    }
                case SignContractPDFFields.p9represents:
                    if let radio = pv as? PDFFormButtonField {
                        radio .setValue2(pdfInfo!.page9BuyeronlyasBuyersagent!)
                    }
                case SignContractPDFFields.LicensedSupervisor:
                    pv.value = pdfInfo!.page9AssociatesName
                    
                case SignContractPDFFields.OtherBrokerFirmNo:
                    pv.value = pdfInfo!.page9OtherBrokerFirmNo
//                case "7g2c3":
//                    if (pdfInfo?.idcity ?? "1") == "2" {
//                        //dallas
//                        pv.value = "38"
//                    }else{
//                        pv.value = "30"
//                    }
                case SignContractPDFFields.AssociateNameNo:
                    pv.value = pdfInfo!.page9AssociateNameNo
                    
                case SignContractPDFFields.p9AssociatesName:
                    
                    if pdfInfo?.nproject == "4012 Woodshire Village Estates" {
                        pv.value = "Cheri Fama"
                    }else{
                        pv.value = pdfInfo!.page9LicensedSupervisor
                    }
//                    pv.value = pdfInfo!.page9AssociatesName
                case SignContractPDFFields.LicensedSupervisorNo:
                    if pdfInfo?.nproject == "4012 Woodshire Village Estates" {
                        pv.value = "360812"
                    }else{
                        pv.value = pdfInfo!.page9LicensedSupervisorNo
                    }
                case SignContractPDFFields.OtherBrokerAddress:
                    pv.value = pdfInfo!.page9OtherBrokerAddress
                case SignContractPDFFields.OtherBrokerAddressFax:
                    pv.value = pdfInfo!.page9OtherBrokerAddressFax
                case SignContractPDFFields.CityState:
                    pv.value = pdfInfo!.page9CityState
                case SignContractPDFFields.CityStateZip:
                    pv.value = pdfInfo!.page9CityZip
                case SignContractPDFFields.p9AssociatesEmailAddress:
                    if pdfInfo?.nproject == "4012 Woodshire Village Estates" {
                        pv.value = "ericp@johndaughery.com"
                    }else{
                        pv.value = pdfInfo!.page9AssociatesEmailAddress
                    }
                    
                    //                    static let chkfinancing = "financing"
                    //                    static let chk6c = "6c"
                    //                    static let chkcer2 = "cer2"
                    //                    static let chkcer1 = "cer1"
                    //                    static let chk23a = "23a"
                    //                    static let chk10a = "10a"
                    //                    static let chk7g = "7g"
                    //                    static let chk6e2 = "6e2"
                    //                    static let chk6a83 = "6a83"
                    //                    static let chk6a8 = "6a8"
                    //                    static let chk6a = "6a"
                case SignContractPDFFields.chkfinancing:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "4a" {
                            radio.setValue2("1")
                        }
                    }
                case "cer1":
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "On" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk6c:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "6c2" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk10a:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "10a1" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk7g:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "7g2" {
                            radio.setValue2("1")
                        }
                    }
                
                case SignContractPDFFields.chk6e2:
                    if let radio = pv as? PDFFormButtonField {
                        if pdfInfo!.hoa == "0" {
                            if radio.exportValue == "6e22" {
                                radio.setValue2("1")
                            }
                        }else{
                            if radio.exportValue == "6e21" {
                                radio.setValue2("1")
                            }
                        }
                        
                    }
                case SignContractPDFFields.chk6a83:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "6a831" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk6a8:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "6a82" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk6a:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "6a2" {
                            radio.setValue2("1")
                        }
                    }
                case "7e1":
                    if let p = pdfInfo?.estimatedclosing_MMdd {
                        pv.value = p
                        
                    }
                default:
                    break
                }
            }
            if let sign = pv as? SignatureView{
                sign.pdfViewsssss = pdfview
            }
        }
    }
    
    fileprivate func doPhoneNo( _ txtphone : String) -> String{
        let na = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        var s1 = ""
        var s2 = ""
        var s3 = ""
        var j = 0
        for i in txtphone.characters {
            if na.contains(String(i)){
                j = j + 1;
                if j < 4 {
                    s1 = s1 + String(i)
                }else if j < 7 {
                    s2 = s2 + String(i)
                }else{
                    s3 = s3 + String(i)
                }
            }
            
        }
        let h = s1.characters.count + s2.characters.count + s3.characters.count
        if h >= 10 {
            return " / (" + s1 + ")" + s2 + "-" + s3
        }else if h > 0 {
            return  " / " + s1 + s2 + s3
        }else{
            return ""
        }
    }
    
    fileprivate func readContractFieldsFromTxt(_ fileName: String) ->[String: String]? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            var fieldsDic = [String : String]()
            do {
                let fieldsStr = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
                let n = fieldsStr.components(separatedBy: "\n")
                
                for one in n{
                    let s = one.components(separatedBy: ":")
                    if s.count != 2 {
//                        print(one)
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
    // MARK: Closing Memo
    fileprivate struct ClosingMemoPDFFields{
        static let CiaNm = "txtCiaNm"
        static let Address = "txtAddress"
        static let CityStateZip = "txtCityStateZip"
        static let TelFax = "txtTelFax"
        static let IdNumber = "txtIdNumber"
        static let Date = "txtDate"
        static let ContractDate = "txtContractDate"
        static let EstimatedCompletion = "txtEstimatedCompletion"
        static let EstamatedClosing = "txtEstamatedClosing"
        static let StageContract = "txtStageContract"
        static let Buyer2 = "txtBuyer2"
        static let Address1 = "txtAddress1"
        static let Address2 = "txtAddress2"
        static let Buyer1 = "txtBuyer1"
        static let Email = "txtEmail"
        static let Office = "txtOffice"
        static let Fax = "txtFax"
        static let Mobile = "txtMobile"
        static let Email2 = "txtEmail2"
        static let Office2 = "txtOffice2"
        static let Fax2 = "txtFax2"
        static let Mobile2 = "txtMobile2"
        static let Broker = "txtBroker"
        static let Per = "txtPer"
        static let Agent = "txtAgent"
        static let BrokerOffice = "txtBrokerOffice"
        static let BrokerFax = "txtBrokerFax"
        static let BrokerMobile = "txtBrokerMobile"
        static let BrokerEmail = "txtBrokerEmail"
        static let ProjectManager = "txtProjectManager"
        static let Consultant = "txtConsultant"
        static let BuilderAddress = "txtBuilderAddress"
        static let BuilderAddress2 = "txtBuilderAddress2"
        static let BuilderSubdivision2 = "txtBuilderSubdivision2"
        static let LegalDescription = "txtLegalDescription"
        static let Floorplan = "txtFloorplan"
        static let BuilderSubdivision = "txtBuilderSubdivision"
        static let ListPrice = "txtListPrice"
        static let Incl = "txtIncl"
        static let Allowance = "txtAllowance"
        static let Title = "txtTitle"
        static let Mortgage = "txtMortgage"
        static let Bank = "txtBank1"
        static let SalesPrice = "txtSalesPrice"
        static let Check = "txtCheck1"
        static let XType = "txtType1"
        static let Amount = "txtAmount1"
    }
    
    func setCloingMemoDots(_ pdfInfo: ContractClosingMemo?, additionViews: [PDFWidgetAnnotationView], pdfview: PDFView){
//        var bankField : PDFFormTextField?
//        var checkField : PDFFormTextField?
//        var typeField : PDFFormTextField?
//        var amountField : PDFFormTextField?
        if pdfInfo?.memoItemlist!.count > 1 {
            var i = 1;
            
            for item in pdfInfo!.memoItemlist!{
                for pv : PDFWidgetAnnotationView in additionViews{
                    if (pv.xname == "txtBank\(i)") {
                        pv.value = item.bankName ?? ""
                    }else if (pv.xname == "txtCheck\(i)") {
                        pv.value = item.check ?? ""
                    }else if (pv.xname == "txtType\(i)") {
                        pv.value = item.type ?? ""
                    }else if (pv.xname == "txtAmount\(i)") {
                        pv.value = item.amount ?? ""
                    }
                }
                i = i + 1;
            }
        
        }
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname{
                //left top
            case ClosingMemoPDFFields.CiaNm:
                pv.value = pdfInfo?.cianame!
            case ClosingMemoPDFFields.Address:
                pv.value = pdfInfo?.ciaaddress!
            case ClosingMemoPDFFields.CityStateZip:
                pv.value = pdfInfo?.ciacityzip!
            case ClosingMemoPDFFields.TelFax:
                pv.value = pdfInfo?.ciatelfax!
                //right top
            case ClosingMemoPDFFields.IdNumber:
                pv.value = pdfInfo?.closingNo!
            case ClosingMemoPDFFields.Date:
                pv.value = pdfInfo?.closingDate!
                //pending sele
            case ClosingMemoPDFFields.ContractDate:
                pv.value = pdfInfo?.contractdate!
            case ClosingMemoPDFFields.EstimatedCompletion:
                pv.value = pdfInfo?.estimatedcompletion!
            case ClosingMemoPDFFields.EstamatedClosing:
                pv.value = pdfInfo?.estimatedclosing!
            case ClosingMemoPDFFields.StageContract:
                pv.value = pdfInfo?.stage!
                
                //buyer info
            case ClosingMemoPDFFields.Buyer1:
                pv.value = pdfInfo?.buyer1!
            case ClosingMemoPDFFields.Buyer2:
                pv.value = pdfInfo?.buyer2!
            case ClosingMemoPDFFields.Address1:
                pv.value = pdfInfo?.currentAddress1!
            case ClosingMemoPDFFields.Address2:
                pv.value = pdfInfo?.currentAddress2!
            case ClosingMemoPDFFields.Email:
                pv.value = pdfInfo?.email1!
            case ClosingMemoPDFFields.Email2:
                pv.value = pdfInfo?.email2!
            case ClosingMemoPDFFields.Office:
                pv.value = pdfInfo?.office1!
            case ClosingMemoPDFFields.Office2:
                pv.value = pdfInfo?.office2!
            case ClosingMemoPDFFields.Fax:
                pv.value = pdfInfo?.fax1!
            case ClosingMemoPDFFields.Fax2:
                pv.value = pdfInfo?.fax2!
            case ClosingMemoPDFFields.Mobile:
                pv.value = pdfInfo?.mobile1!
            case ClosingMemoPDFFields.Mobile2:
                pv.value = pdfInfo?.mobile2!
                
                //broker info
            case ClosingMemoPDFFields.Broker:
                pv.value = pdfInfo?.broker!
            case ClosingMemoPDFFields.Per:
                pv.value = pdfInfo?.brokerPercent!
            case ClosingMemoPDFFields.Agent:
                pv.value = pdfInfo?.brokerAgent!
            case ClosingMemoPDFFields.BrokerEmail:
                pv.value = pdfInfo?.brokerEmail!
            case ClosingMemoPDFFields.BrokerOffice:
                pv.value = pdfInfo?.brokerOffice!
            case ClosingMemoPDFFields.BrokerFax:
                pv.value = pdfInfo?.brokerFax!
            case ClosingMemoPDFFields.BrokerMobile:
                pv.value = pdfInfo?.brokerMobile!
                
                //builder info
            case ClosingMemoPDFFields.ProjectManager:
                pv.value = pdfInfo?.projectManager!
            case ClosingMemoPDFFields.Consultant:
                pv.value = pdfInfo?.salesConsultant!
            case ClosingMemoPDFFields.BuilderAddress:
                pv.value = pdfInfo?.nproject!
            case ClosingMemoPDFFields.BuilderSubdivision:
                pv.value = pdfInfo?.subdivision!
            case ClosingMemoPDFFields.LegalDescription:
                pv.value = pdfInfo?.cdescription!
            case ClosingMemoPDFFields.Floorplan:
                pv.value = pdfInfo?.floorplan!
                
                //financial information
            case ClosingMemoPDFFields.ListPrice:
                pv.value = pdfInfo?.listPrice!
            case ClosingMemoPDFFields.Incl:
                pv.value = pdfInfo?.UPG!
            case ClosingMemoPDFFields.SalesPrice:
                pv.value = pdfInfo?.salesPrice!
            case ClosingMemoPDFFields.Allowance:
                pv.value = pdfInfo?.allowance!
            case ClosingMemoPDFFields.Mortgage:
                pv.value = pdfInfo?.company!
            case ClosingMemoPDFFields.Title:
                pv.value = pdfInfo?.titleInsurance!
                
            default:
                break
            }
        }
    
    }
    // MARK: Addendum A
    fileprivate struct AddendumAPDFFields{
        static let Nonrefundable = "Nonrefundable"
        static let CompanyName = "CompanyName"
         static let CompanyName1 = "sellercompany"
        static let delayfees_word = "delayfees_word"
        static let delayfees_amount = "delayfees_amount"
        static let ExcutedDay = "ExcutedDay"
        static let GeneralPartner = "GeneralPartner"
        static let Signature = "SignatureSign"
        static let adate = "AddendumAExecutedDaySign1"
        
    }
    
    func setAddendumADots(_ pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case AddendumAPDFFields.adate:
                pv.value = pdfInfo?.approvedate ?? ""
            case AddendumAPDFFields.Nonrefundable:
                pv.value = pdfInfo?.Nonrefundable!
            case AddendumAPDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            case AddendumAPDFFields.CompanyName1:
                pv.value = pdfInfo?.CompanyName!
            case AddendumAPDFFields.delayfees_word:
                pv.value = pdfInfo?.delayfees_word!
            case AddendumAPDFFields.delayfees_amount:
                pv.value = pdfInfo?.delayfees_amount!
            case AddendumAPDFFields.GeneralPartner:
                if pdfInfo!.GeneralPartner! == "" {
                    pv.value = " "
                }else{
                    pv.value = "\(pdfInfo!.GeneralPartner!), General Partner"
                }
            case "GeneralPartner1":
                if pdfInfo!.GeneralPartner! == "" {
                    pv.value = " "
                }else{
                    pv.value = "\(pdfInfo!.GeneralPartner!), General Partner"
                }
                
            case AddendumAPDFFields.ExcutedDay:
                pv.value = pdfInfo?.ExcutedDay!
            case "cityname":
//                print(pdfInfo?.city!)
                pv.value = pdfInfo?.city!
                
//                if pdfInfo?.idcity! == "1" {
//                   pv.value = "Houston"
//                }else if pdfInfo?.idcity! == "2" {
//                    pv.value = "Dallas"
//                }else if pdfInfo?.idcity! == "3" {
//                    pv.value = "Austin"
//                }
                
                
            default:
                break
            }
        }
    }
    
//    func setAddendumCCDots(_ pdfInfo: ContractSignature?, additionViews: [PDFWidgetAnnotationView]){
//        for pv : PDFWidgetAnnotationView in additionViews{
//            switch pv.xname {
//            case "buyer1DateSign1"
//                , "seller1DateSign1":
//                pv.value = pdfInfo?.approvedate ?? ""
//            case "buyer2DateSign1":
//                if (pdfInfo?.client2 ?? "") != "" {
//                    pv.value = pdfInfo?.approvedate ?? ""
//                }
//            default:
//                break
//            }
//        }
//    }
    
    
    // MARK: ADDENDUM C
    fileprivate struct AddendumCPDFFields{
        
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
        
        static let SignArray : [String] = [
            "Homebuyer # 1 - Sign"
            , "Homebuyer # 2 - Sign"
            , "Consultant - Sign"
            , "Homebuyer # 1 - Date"
            , "Homebuyer # 2 - Date"
            , "Consultant - Date"]
        
    }
    
    func setAddendumCDots(_ pdfInfo: ContractAddendumC?, additionViews: [PDFWidgetAnnotationView], pdfview: PDFView, has2Pages0: Bool) -> [PDFWidgetAnnotationView]{
        var aPrice : PDFFormTextField?
        var aPrice2 : PDFFormTextField?
        var aPrice3 : PDFFormTextField?
        var aCiaName : PDFWidgetAnnotationView?
        var aStage : PDFWidgetAnnotationView?
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case AddendumCPDFFields.CompanyName:
                aCiaName = pv
                pv.value = pdfInfo?.cianame!
            case AddendumCPDFFields.Address:
                pv.value = pdfInfo?.ciaaddress!
            case AddendumCPDFFields.CityStateZip:
                pv.value = pdfInfo?.ciacityzip!
            case AddendumCPDFFields.TelFax:
                pv.value = pdfInfo?.ciatelfax!
            case AddendumCPDFFields.IdNo:
                pv.value = pdfInfo?.addendumNo!
            case AddendumCPDFFields.DateL:
                pv.value = pdfInfo?.approvedate!
            case AddendumCPDFFields.ContractDate:
                pv.value = pdfInfo?.contractdate!
            case AddendumCPDFFields.EstimatedCompletion:
                pv.value = pdfInfo?.estimatedcompletion!
            case AddendumCPDFFields.EstamatedClosing:
                pv.value = pdfInfo?.estimatedclosing!
            case AddendumCPDFFields.StageContract:
                pv.value = pdfInfo?.stage!
                aStage = pv
            case AddendumCPDFFields.JobAddress:
                pv.value = pdfInfo?.nproject!
            case AddendumCPDFFields.Buyer:
                pv.value = pdfInfo?.buyer!
            case AddendumCPDFFields.Consultant:
                pv.value = pdfInfo?.consultant!
            case AddendumCPDFFields.SubDivision:
                pv.value = pdfInfo?.subdivision!
            case AddendumCPDFFields.Price:
                if (aPrice3 == nil) {
                    aPrice3 = pv as? PDFFormTextField
                }else{
                    aPrice2 = pv as? PDFFormTextField
                }
                pv.value = pdfInfo?.price!
            default:
                break
            }
            
        }
        
        var has2Pages = has2Pages0
        if has2Pages {
            if aPrice3?.frame.origin.y > aPrice2?.frame.origin.y {
                aPrice = aPrice2
                aPrice2 = aPrice3
            }else{
                aPrice = aPrice3
            }
        }else{
            aPrice = aPrice3
        }
        
        var addedAnnotationViews : [PDFWidgetAnnotationView] = [PDFWidgetAnnotationView]()
//        var addedAnnotationViews2 : [PDFWidgetAnnotationView] = [PDFWidgetAnnotationView]()
        var j : CGFloat = 1
//        if UIScreen.mainScreen().or
        var xxxx :CGFloat  = 130
         var k  = 0
        if let price = aPrice {
            var pf : PDFFormTextField?
            var line : PDFWidgetAnnotationView?
            var x : CGFloat = aCiaName!.frame.origin.x
            var y : CGFloat = price.frame.origin.y + price.frame.size.height + 20
            let w : CGFloat = (aStage!.frame.width + aStage!.frame.origin.x - aCiaName!.frame.origin.x)
            var h : CGFloat = price.frame.height
            var yo = y
           
            if has2Pages0 {
                while yo > aPrice2!.frame.origin.y - aPrice!.frame.origin.y {
                    yo -= aPrice2!.frame.origin.y - aPrice!.frame.origin.y
                    j += 1
                }
            }
            
           
            
            if let list = pdfInfo?.itemlistStr {
                var i: Int = 0
               
                for items in list {
                    i += 1
                    let font = floor(aPrice!.currentFontSize())
                    
                    pf = PDFFormTextField(frame: CGRect(x: x, y: y, width: 25, height: h), multiline: false, alignment: NSTextAlignment.left, secureEntry: false, readOnly: true, withFont: font)
                    pf?.xname = "april"
                    pf?.value = "\(i)"
                    pf?.pageno = has2Pages ? "0" : "1";
                    pf?.pagenomargin = (aPrice?.pagenomargin ?? 0.0)!
                    addedAnnotationViews.append(pf!)
                    
//                    print(pf?.xname)
                    //                    print( "number \(pf?.frame) \(y)")
                    for description in items {
                        k += 1
                        //                        print("----" + a.substringWithRange(glyphRange))
                        pf = PDFFormTextField(frame: CGRect(x: x+25, y: y, width: w-25, height: h), multiline: false, alignment: NSTextAlignment.left, secureEntry: false, readOnly: true, withFont: font)
                        pf?.xname = "april"
                        pf?.value = description
                        pf?.pageno = has2Pages ? "0" : "1";
                        pf?.pagenomargin = (aPrice?.pagenomargin ?? 0.0)!
                        addedAnnotationViews.append(pf!)
                        
//                        print(pf?.xname)
                        
                        //                            pf?.sizeToFit()
                        y = y + pf!.frame.height
                        //                            print( "text \(pf?.frame)")
                    }
                    
                    y = y + 2
                    line = PDFWidgetAnnotationView(frame: CGRect(x: x, y: y, width: w, height: 1))
                    line?.backgroundColor = UIColor.lightGray
                    line?.pageno = has2Pages ? "0" : "1";
                    line?.pagenomargin = (aPrice?.pagenomargin ?? 0.0)!
//                    print(line?.pagenomargin)
                    addedAnnotationViews.append(line!)
                    //                    print( "line \(line?.frame) \(y)")
                    y = y + 5.5
                    
//                    if has2Pages && y+xxxx  > (aPrice2!.frame.origin.y - aPrice!.frame.origin.y) * j {
//                        has2Pages = false
//                        y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
//                    }
                    
                    if has2Pages && k >= 31 {
                        has2Pages = false
                        y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
                    }
                    
                }
            }
            
            y = y + 22
//            if has2Pages && y+xxxx > (aPrice2!.frame.origin.y - aPrice!.frame.origin.y) {
//                has2Pages = false
//                y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
//            }
            if has2Pages && k >= 31 {
                has2Pages = false
                y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
            }
            pf = PDFFormTextField(frame: CGRect(x: x, y: y, width: w, height: h), multiline: false, alignment: NSTextAlignment.left, secureEntry: false, readOnly: true, withName: nil)
            pf?.xname = "april"
            y = y + price.frame.size.height + 2
            pf?.value = pdfInfo?.agree!
            pf?.pageno = has2Pages ? "0" : "1";
            pf?.pagenomargin = (aPrice?.pagenomargin ?? 0.0)!
            addedAnnotationViews.append(pf!)
            
            y = y + h
//            if has2Pages && y+xxxx > (aPrice2!.frame.origin.y - aPrice!.frame.origin.y) {
//                has2Pages = false
//                y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
//            }
            if has2Pages && k >= 31 {
                has2Pages = false
                y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
            }
            h = w * 0.0521
            var sign : SignatureView?
            for i: Int in 0...5 {
                
                if i < 3 {
                    sign = SignatureView(frame: CGRect(x: x, y: y, width: w * 0.28, height: h))
                    switch i{
                    case 0:
                        sign?.xname = "buyer1Sign"
                    case 1:
                        sign?.xname = "buyer2Sign"
                    default:
                        sign?.xname = "seller1Sign"
                    
                    }
                    sign?.pageno = has2Pages ? "0" : "1";
                    if has2Pages {
                        sign?.xname = "p2AC\(sign?.xname ?? "")"
                    }else{
                        sign?.xname = "p1AC\(sign?.xname ?? "")"
                    }
                    sign?.pagenomargin = (aPrice?.pagenomargin ?? 0.0)!
//                    print(sign?.pagenomargin)
                    addedAnnotationViews.append(sign!)
                }else{
                    
                    pf = PDFFormTextField(frame: CGRect(x: x, y: y+h/2 , width: w * 0.28, height: price.frame.height), multiline: false, alignment: NSTextAlignment.left, secureEntry: false, readOnly: true, withName: nil)
//                    pf?.xname = "april"
                    switch i{
                        
                    case 3:
                        pf?.xname = "buyer1DateSign1"
                        pf?.value = pdfInfo?.approvedate
                    case 4:
                        pf?.xname = "buyer2DateSign1"
                        if  (pdfInfo?.buyer ?? "").contains(" / ") {
                            pf?.value = pdfInfo?.approvedate
                        }
                    default:
                        pf?.xname = "seller1DateSign1"
                        pf?.value = pdfInfo?.approvedate
                    }
//                    pf?.value = AddendumCPDFFields.SignArray[i]
                    pf?.pageno = has2Pages ? "0" : "1";
                    pf?.pagenomargin = (aPrice?.pagenomargin ?? 0.0)!
                    addedAnnotationViews.append(pf!)
                }
               
                
                line = PDFWidgetAnnotationView(frame: CGRect(x: x, y: y + 2+h, width: w * 0.28, height: 1))
                line?.backgroundColor = UIColor.lightGray
                line?.pageno = has2Pages ? "0" : "1";
                line?.pagenomargin = (aPrice?.pagenomargin ?? 0.0)!
                addedAnnotationViews.append(line!)
                
                pf = PDFFormTextField(frame: CGRect(x: x, y: y + h + 3 , width: w * 0.28, height: price.frame.height), multiline: false, alignment: NSTextAlignment.left, secureEntry: false, readOnly: true, withName: nil)
                pf?.xname = "april"
                pf?.value = AddendumCPDFFields.SignArray[i]
                pf?.pageno = has2Pages ? "0" : "1";
                pf?.pagenomargin = (aPrice?.pagenomargin ?? 0.0)!
                addedAnnotationViews.append(pf!)
                x += w * 0.36
                
                if (i == 2) {
                    x = aCiaName!.frame.origin.x
                    y = y + w * 0.1
                    //                    if has2Pages && y+50 > (aPrice2!.frame.origin.y - aPrice!.frame.origin.y) {
                    //                        y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
                    //                    }
                    if has2Pages {
                        y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
                    }
                }
                
            }
        }
        
        if !has2Pages0{
            for a in addedAnnotationViews {
                a.pageno = "0"
            }
        }
        
        pdfview.addMoreDots(addedAnnotationViews)
//        for a in addedAnnotationViews{
//            if let b = a.copy() as? PDFWidgetAnnotationView{
//            b.frame = CGRect(x: b.frame.origin.x, y: b.frame.origin.y - hss, width: b.frame.size.width, height: b.frame.size.height)
//                addedAnnotationViews2.append(b)
//            }
//            
//        }
        
        for element in addedAnnotationViews {
            element.alpha = 0
        }
        return addedAnnotationViews
    }
    
    // MARK: DesignCenter
    fileprivate struct DesignCenterPDFFields{
        static let txtCiaNm = "txtCiaNm"
        static let txtAddress = "txtAddress"
        static let txtCityStateZip = "txtCityStateZip"
        static let txtTelFax = "txtTelFax"
        
        static let txtDate = "txtDateSign1"
        static let buyer1Date = "buyer1DateSign1"
        static let buyer2Date = "buyer2DateSign1"
        
        static let txtIdNumber = "txtIdNumber"
        static let txtContractDate = "txtContractDate"
        static let txtEstimatedCompletion = "txtEstimatedCompletion"
        static let txtEstamatedClosing = "txtEstamatedClosing"
        static let txtStageContract = "txtStageContract"
        static let txtBuilderAddress = "txtBuilderAddress"
        static let txtBuyer1 = "txtBuyer1"
        static let txtBuyer2 = "txtBuyer2"
        static let txtBuilderSubdivision = "txtBuilderSubdivision"
        static let txtConsultant = "txtConsultant"
        static let txtDesignDate = "txtDesignDate"
        static let txtBuilderAddress2 = "txtBuilderAddress2"
        static let txtNotes1 = "txtNotes1"
        static let txtNotes2 = "txtNotes2"
        static let txtNotes3 = "txtNotes3"
        static let txtNotes4 = "txtNotes4"
        static let txtMaxHourEdit = "txtMaxHourEdit"
        static let homeBuyer1Sign = "homeBuyer1Sign"
        static let homeBuyer2Sign = "homeBuyer2Sign"
        static let dcChkMaster = "dcChkMaster"
        static let dcChkMasterCountertop = "dcChkMasterCountertop"
        static let dcChkSecond = "dcChkSecond"
        static let dcChkPowder = "dcChkPowder"
        static let dcChkWood = "dcChkWood"
        static let dcChkKitchenCountertop = "dcChkKitchenCountertop"
        static let dcChkMasterBath = "dcChkMasterBath"
        static let dcChk2ndBath = "dcChk2ndBath"
        static let dcChkEntryFloor = "dcChkEntryFloor"
        static let dcChkCarpet = "dcChkCarpet"
        static let dcChkKitchenBacksplash = "dcChkKitchenBacksplash"
        static let dcChkUtility = "dcChkUtility"
        static let dcChkInterior = "dcChkInterior"
        static let dcChkPlumbing = "dcChkPlumbing"
        static let dcChkHandware = "dcChkHandware"
    }
    
    func setDesignCenterDots(_ pdfInfo: ContractDesignCenter?, additionViews: [PDFWidgetAnnotationView]){
        var itemList1 = [String]()
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 657.941, height: 13.2353))
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "Verdana", size: 11.0)
        textView.text = pdfInfo!.notes!
        textView.sizeToFit()
        textView.layoutManager.enumerateLineFragments(forGlyphRange: NSMakeRange(0, pdfInfo!.notes!.characters.count), using: { (rect, usedRect, textContainer, glyphRange, _) -> Void in
            if  let a : NSString = pdfInfo!.notes! as NSString {
                itemList1.append(a.substring(with: glyphRange))
            }
        })
        
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname{
                //left top
            case DesignCenterPDFFields.txtCiaNm:
                pv.value = pdfInfo?.cianame!
            case DesignCenterPDFFields.txtAddress:
                pv.value = pdfInfo?.ciaaddress!
            case DesignCenterPDFFields.txtCityStateZip:
                pv.value = pdfInfo?.ciacityzip!
            case DesignCenterPDFFields.txtTelFax:
                pv.value = pdfInfo?.ciatelfax!
                //right top
            case DesignCenterPDFFields.txtIdNumber:
                pv.value = pdfInfo?.designNo!
            case DesignCenterPDFFields.txtDesignDate:
                pv.value = pdfInfo?.designDate!
            case DesignCenterPDFFields.txtDate:
                pv.value = pdfInfo?.txtDate!
            case DesignCenterPDFFields.buyer1Date:
                pv.value = pdfInfo?.txtDate!
            case DesignCenterPDFFields.buyer2Date:
                if let c = pdfInfo?.buyer2 {
                    if c != ""{
                    pv.value = pdfInfo?.txtDate!
                    }else{
                    pv.value = ""
                    }
                }else{
                    pv.value = ""
                }
                
                //pending sele
            case DesignCenterPDFFields.txtContractDate:
                pv.value = pdfInfo?.contractDate!
            case DesignCenterPDFFields.txtEstimatedCompletion:
                pv.value = pdfInfo?.estimatedcompletion!
            case DesignCenterPDFFields.txtEstamatedClosing:
                pv.value = pdfInfo?.estimatedclosing!
            case DesignCenterPDFFields.txtStageContract:
                pv.value = pdfInfo?.stage!
                
            case DesignCenterPDFFields.txtMaxHourEdit:
                if pdfInfo?.dcChkMaster! == 0
                && pdfInfo?.dcChkMasterCountertop! == 0
                && pdfInfo?.dcChkSecond! == 0
                && pdfInfo?.dcChkPowder! == 0
                && pdfInfo?.dcChkWood! == 0
                && pdfInfo?.dcChkKitchenCountertop! == 0
                && pdfInfo?.dcChkMasterBath! == 0
                && pdfInfo?.dcChk2ndBath! == 0
                && pdfInfo?.dcChkEntryFloor! == 0
                && pdfInfo?.dcChkCarpet! == 0
                && pdfInfo?.dcChkKitchenBacksplash! == 0
                && pdfInfo?.dcChkUtility! == 0
                && pdfInfo?.dcChkInterior! == 0
                && pdfInfo?.dcChkPlumbing! == 0
                && pdfInfo?.dcChkHandware! == 0
                {
                    pv.value = "n/a"
                }else{
                    pv.value = "2"
                }
                
                //Checkbox
            case DesignCenterPDFFields.txtBuyer1:
                pv.value = pdfInfo?.buyer1!
            case DesignCenterPDFFields.txtBuyer2:
                pv.value = pdfInfo?.buyer2!
            case DesignCenterPDFFields.txtConsultant:
                pv.value = pdfInfo?.consultant!
            case DesignCenterPDFFields.txtBuilderAddress:
                pv.value = pdfInfo?.nproject!
            case DesignCenterPDFFields.txtBuilderSubdivision:
                pv.value = pdfInfo?.subdivision!
            case DesignCenterPDFFields.txtNotes1:
                if (itemList1.count > 0){
                    pv.value = itemList1[0]
                }
            case DesignCenterPDFFields.txtNotes2:
                if (itemList1.count > 1){
                    pv.value = itemList1[1]
                }
            case DesignCenterPDFFields.txtNotes3:
                if (itemList1.count > 2){
                    pv.value = itemList1[2]
                }
            case DesignCenterPDFFields.txtNotes4:
                if (itemList1.count > 3){
                    pv.value = itemList1[3]
                }
            case DesignCenterPDFFields.dcChkMaster:
                pv.value = String(describing: pdfInfo!.dcChkMaster!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkMaster!))
                }
            case DesignCenterPDFFields.dcChkMasterCountertop:
                pv.value = String(describing: pdfInfo!.dcChkMasterCountertop!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkMasterCountertop!))
                }
            case DesignCenterPDFFields.dcChkSecond:
                pv.value = String(describing: pdfInfo!.dcChkSecond!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkSecond!))
                }
            case DesignCenterPDFFields.dcChkPowder:
                pv.value = String(describing: pdfInfo!.dcChkPowder!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkPowder!))
                }
            case DesignCenterPDFFields.dcChkWood:
                pv.value = String(describing: pdfInfo!.dcChkWood!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkWood!))
                }
            case DesignCenterPDFFields.dcChkKitchenCountertop:
                pv.value = String(describing: pdfInfo!.dcChkKitchenCountertop!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkKitchenCountertop!))
                }
            case DesignCenterPDFFields.dcChkMasterBath:
                pv.value = String(describing: pdfInfo!.dcChkMasterBath!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkMasterBath!))
                }
            case DesignCenterPDFFields.dcChk2ndBath:
                pv.value = String(describing: pdfInfo!.dcChk2ndBath!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChk2ndBath!))
                }
            case DesignCenterPDFFields.dcChkEntryFloor:
                pv.value = String(describing: pdfInfo!.dcChkEntryFloor!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkEntryFloor!))
                }
            case DesignCenterPDFFields.dcChkCarpet:
                pv.value = String(describing: pdfInfo!.dcChkCarpet!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkCarpet!))
                }
            case DesignCenterPDFFields.dcChkKitchenBacksplash:
                pv.value = String(describing: pdfInfo!.dcChkKitchenBacksplash!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkKitchenBacksplash!))
                }
            case DesignCenterPDFFields.dcChkUtility:
                pv.value = String(describing: pdfInfo!.dcChkUtility!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkUtility!))
                }
            case DesignCenterPDFFields.dcChkInterior:
                pv.value = String(describing: pdfInfo!.dcChkInterior!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkInterior!))
                }
            case DesignCenterPDFFields.dcChkPlumbing:
                pv.value = String(describing: pdfInfo!.dcChkPlumbing!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkPlumbing!))
                }
            case DesignCenterPDFFields.dcChkHandware:
                pv.value = String(describing: pdfInfo!.dcChkHandware!)
                if let radio = pv as? PDFFormButtonField {
                    radio.setValue2(String(describing: pdfInfo!.dcChkHandware!))
                }
            default:
                break
            }
            
        }
    }
    
    
    // MARK: Third Party Finacing Addendum
    fileprivate struct ThirdPartyFinacingAddendumPDFFields{
        static let AddressCity = "Street Address and City"
        static let PropertyAddress = "Address of Property"
        
        static let checkedField = "This contract is not subject to Buyer obtaining Buyer Approval"
        
    }
    
    func setThirdPartyFinacingAddendumDots(_ pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case ThirdPartyFinacingAddendumPDFFields.AddressCity,  ThirdPartyFinacingAddendumPDFFields.PropertyAddress:
                pv.value = pdfInfo!.nproject! + " / " + pdfInfo!.city!
            case ThirdPartyFinacingAddendumPDFFields.checkedField:
                if let radio = pv as? PDFFormButtonField {
                    radio .setValue2("1")
                }
            default:
                break
            }
        }
    }
    
    
    // MARK: Exhibit A
    fileprivate struct ExhibitAPDFFields{
        static let To = "1"
        static let Property = "PROPERTY 1"
        static let CompanyName = "CompanyName"
        static let adate = "PROPERTY 2Sign1"
    }
    
    func setExhibitADots(_ pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
//        print(additionViews)
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case ExhibitAPDFFields.To:
                pv.value = pdfInfo?.Client!
            case ExhibitAPDFFields.Property:
                pv.value = pdfInfo?.nproject!
            case ExhibitAPDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            case ExhibitAPDFFields.adate:
                pv.value = pdfInfo?.approvedate ?? ""
            default:
                break
            }
//            print(pv.value)
        }
    }
    
    // MARK: Exhibit B
    fileprivate struct ExhibitBPDFFields{
        static let To = "1"
        //        static let From = "CompanyName"
        static let Property = "PROPERTY 1"
        static let CompanyName = "CompanyName"
          static let adate = "PROPERTY 2Sign1"
    }
    
    func setExhibitBDots(_ pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
//        for pv : PDFWidgetAnnotationView in additionViews{
//            switch pv.xname {
//            case ExhibitBPDFFields.To:
//                pv.value = pdfInfo?.Client!
//            case ExhibitBPDFFields.Property:
//                pv.value = pdfInfo?.nproject!
//            case ExhibitBPDFFields.CompanyName:
//                pv.value = pdfInfo?.CompanyName!
//            case ExhibitBPDFFields.adate:
//                pv.value = pdfInfo?.approvedate ?? ""
//            default:
//                break
//            }
//        }
    }
    
    // MARK: Exhibit B General
    fileprivate struct ExhibitCPDFFields{
        static let GeneralPartner = "GeneralPartner"
        static let CompanyName = "CompanyName"
        static let CompanyName1 = "sellercompany"
         static let adate = "SignatureDate"
    }
    
    func setExhibitCDots(_ pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case ExhibitCPDFFields.GeneralPartner:
                pv.value = "\(pdfInfo!.GeneralPartner!),"
            case ExhibitCPDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            case ExhibitCPDFFields.CompanyName1:
                pv.value = pdfInfo?.CompanyName!
            case "sellercompanyCapital":
                pv.value = pdfInfo?.CompanyName!.uppercased()
            case ExhibitCPDFFields.adate:
                pv.value = pdfInfo?.approvedate ?? ""
            default:
                break
            }
        }
    }
    // MARK: Buyers Expect
    fileprivate struct BuyersExpectPDFFields{
        static let CompanyName = "CompanyName"
        static let Version = "version"
    }
    
    func setBuyersExpectDots(_ pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView], pdfview: PDFView){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case BuyersExpectPDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            default:
                break
            }
            if let sign = pv as? SignatureView{
                sign.pdfViewsssss = pdfview
            }
        }
    }
    
    // MARK: Warranty Acknowledege
    fileprivate struct WarrantyAcknowledegePDFFields{
        static let CompanyName = "CompanyName"
        static let GeneralPartner = "GeneralPartner"
        static let property1 = "Address for Notice Purposes 1_2"
        static let propertyline2 = "Address for Notice Purposes 2_2"
        static let printedName1 = "WPrintedName1"
        static let printedName2 = "WPrintedName2"
        static let homeOwnerNoticeAddress = "Address for Notice Purposes 1"
        static let homeOwnerNoticeAddressline2 = "Address for Notice Purposes 2"
        
        
    }
    
    func setWarrantyAcknowledegeDots(_ pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case WarrantyAcknowledegePDFFields.GeneralPartner:
                pv.value = "\(pdfInfo!.GeneralPartner!),"
            case WarrantyAcknowledegePDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            case WarrantyAcknowledegePDFFields.property1:
                pv.value = "1520 Oliver St."
            case WarrantyAcknowledegePDFFields.propertyline2:
                pv.value = "Houston, TX 77007"
            case WarrantyAcknowledegePDFFields.printedName1:
                if let c = pdfInfo?.Client {
                    if c.contains(" / ") {
                        pv.value = c.components(separatedBy: " / ")[0]
                    }else{
                        pv.value = c
                    }
                }else{
                    pv.value = ""
                }
            case WarrantyAcknowledegePDFFields.printedName2:
                if let c = pdfInfo?.Client {
                    if c.contains(" / ") {
                        pv.value = c.components(separatedBy: " / ")[1]
                    }else{
                        pv.value = ""
                    }
                }else{
                    pv.value = ""
                }
            case WarrantyAcknowledegePDFFields.homeOwnerNoticeAddress:
                pv.value = pdfInfo!.noticeAddress1!
            case WarrantyAcknowledegePDFFields.homeOwnerNoticeAddressline2:
                pv.value = pdfInfo!.noticeAddressLine2!
            default:
                break
            }
        }
    }
    // MARK: HOA Checklist
    fileprivate struct HoaChecklistPDFFields{
        static let PropertyName = "Address of Property"
        static let PropertyName2 = "Address of Property_2"
    }
    
    func setHoaChecklistDots(_ pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case HoaChecklistPDFFields.PropertyName,HoaChecklistPDFFields.PropertyName2:
                pv.value = pdfInfo?.nproject!
            default:
                break
            }
        }
    }
    
    // MARK: Addendum 1Hoa
    fileprivate struct AddendumHoaPDFFields{
        static let AddressName = "Street Address and City"
        static let PropertyName = "Name of Property Owners Association Association and Phone Number"
        static let fee = "D DEPOSITS FOR RESERVES Buyer shall pay any deposits for reserves required at closing by the Association"
        
        static let A4 = "4Buyer does not require delivery of the Subdivision Information"
        static let E = "Buyer"
    }
    
    func setAddendumHoaDots(_ pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case AddendumHoaPDFFields.AddressName:
                pv.value = "\(pdfInfo!.nproject!) / \(pdfInfo!.city!)"
            case AddendumHoaPDFFields.PropertyName:
                pv.value = "\(pdfInfo!.hoaname!) \(pdfInfo!.hoaphone!)"
            case AddendumHoaPDFFields.fee:
                pv.value = pdfInfo!.hoafee!
            case AddendumHoaPDFFields.A4, AddendumHoaPDFFields.E:
                if let radio = pv as? PDFFormButtonField {
                    radio .setValue2("1")
                }
            default:
                break
            }
        }
    }
    // MARK: Acknowledgment Of Environmental
    fileprivate struct AcknowledgmentEnvironmentalPDFFields{
        static let lot = "lot"
        static let block = "block1"
        static let buyer = "buyer"
        static let day = "day"
        static let month = "month"
        static let year = "year"
    }
    
    func setAcknowledgmentOfEnvironmental(_ pdfInfo: ContractSignature?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case AcknowledgmentEnvironmentalPDFFields.lot:
                pv.value = pdfInfo?.lot ?? ""
            case AcknowledgmentEnvironmentalPDFFields.block:
                pv.value = pdfInfo?.block ?? ""
            case AcknowledgmentEnvironmentalPDFFields.buyer:
                pv.value = pdfInfo?.client ?? ""
                if let buyer2 = pdfInfo?.client2 {
                    if buyer2 != "" {
                        pv.value = (pdfInfo?.client ?? "") + " / " + buyer2
                    }
                    
                }
            
            case AcknowledgmentEnvironmentalPDFFields.day:
                if pdfInfo?.status == CConstants.ApprovedStatus {
                pv.value = pdfInfo?.executeddd ?? ""
                }
                
            case AcknowledgmentEnvironmentalPDFFields.month:
                if pdfInfo?.status == CConstants.ApprovedStatus {
                    pv.value = pdfInfo?.executedmm ?? ""
                }
            case AcknowledgmentEnvironmentalPDFFields.year:
                if pdfInfo?.status == CConstants.ApprovedStatus {
                    pv.value = pdfInfo?.executedyy ?? ""
                }
            default:
                break
            }
        }
    }
    
    // MARK: FloodPlain Acknowledgement
    fileprivate struct FloodPlainAcknowledgementPDFFields{
        static let PropertyName = "Property Address 1"
        static let PropertyName2 = "Property Address 2"
    }
    
    func setFloodPlainAcknowledgementDots(_ pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        var h : String?
        var h2 : String?
        if let c = pdfInfo?.nproject {
            if c.contains("(") {
                let d = c.components(separatedBy: "(")
                h = d[0]
                h2 = "(\(d[1])"
            }else{
                h = c
//                h2 = ""
            }
        }else{
            h = ""
//            h2 = ""
        }
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case FloodPlainAcknowledgementPDFFields.PropertyName:
                pv.value = h
            case FloodPlainAcknowledgementPDFFields.PropertyName2:
                pv.value = h2 ?? ""
            default:
                break
            }
        }
    }
    
    fileprivate func getCurrentYear() -> Int{
        
        let format = (Calendar.current as NSCalendar).components(.year, from: Date()) 
        return format.year!
    }
    
    
}
