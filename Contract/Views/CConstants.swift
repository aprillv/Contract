//
//  File.swift
//  Contract
//
//  Created by April on 11/23/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import Foundation

struct CConstants{
   
    
    static let BorderColor : UIColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
    static let BackColor : UIColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
    
    static let ShowFilter : String = "ShowFilter"
    
    static let MsgTitle : String = "BA Contract"
    static let MsgOKTitle : String = "OK"
    static let MsgValidationTitle : String = "Validation Failed"
    static let MsgServerError : String = "Server Error, please try again later"
    static let MsgNetworkError : String = "Network Error, please check your network"
    
    static let UserInfoRememberMe :  String = "Login Remember Me"
    static let UserInfoEmail :  String = "Login Email"
    static let UserInfoName :  String = "Logined User Name"
    static let UserInfoPwd :  String = "Login Password"
    static let UserInfoIsContract :  String = "is contract"
    static let UserInfoPrintModel : String = "last print files"
    
    static let LoginingMsg = "   Logining...   "
    static let RequestMsg = "Requesting from server..."
     static let SubmitMsg = "Submitting to server..."
    static let SavedMsg = "Saving to the BA Server..."
    static let SavedSuccessMsg = "Saved successfully."
    static let SavedFailMsg = "Saved fail."
    static let SendEmailSuccessfullMsg = "Sent email successfully."
    static let PrintSuccessfullMsg = "Print successfully."
    
    static let CheckedImgNm = "checked"
    static let CheckImgNm = "check"
    static let SuccessImageNm = "checkmark"
    
    static let SegueToAddressList :  String = "adressList"
    static let SegueToPrintPdf : String = "tofile"
//    static let SegueToSignaturePdf : String = "pdfSignature"
//    static let SegueToThridPartyFinacingAddendumPdf : String = "pdfThridPartyFinacingAddendum"
//    static let SegueToClosingMemo : String = "closingmemo"
//    static let SegueToDesignCenter : String = "designcenter"
//    static let SegueToAddendumA : String = "addenduma"
//    static let SegueToAddendumC : String = "addendumc"
//    
//    static let SegueToInformationAboutBrokerageServices : String = "InformationAboutBrokerageServices"
//    static let SegueToExhibitA : String = "exhibita"
//    static let SegueToExhibitB : String = "exhibitb"
//    static let SegueToExhibitC : String = "exhibitc"
    static let SegueToPrintModel : String = "printModel"
    static let SegueToPrintModel2 : String = "printModel2"
    static let SegueToPrintModelPopover : String = "Print switch"
    static let SegueToAddressModelPopover : String = "Address switch"
    static let SegueToOperationsPopover : String = "Show Operations"
    
    static let Administrator = "roberto@buildersaccess.com"
    
    static let LoggedUserNameKey : String = "LoggedUserNameInDefaults"
    static let InstallAppLink : String = "itms-services://?action=download-manifest&url=https://www.buildersaccess.com/iphone/contract.plist"
    static let ServerURL : String = "https://contractssl.buildersaccess.com/"
    //validate login and get address list
    static let LoginServiceURL: String = "bacontract_login.json"
    //check app version
    static let CheckUpdateServiceURL: String = "bacontract_version.json"
    //get contract signature
    static let ContractServiceURL = "bacontract_signature.json"
    //get contract Addendum A
    static let AddendumAServiceURL = "bacontract_addendumA.json"
    //get contract Addendum c
    static let AddendumCServiceURL = "bacontract_addendumc.json"
    //get contract ClosingMemo
    static let ClosingMemoServiceURL = "bacontract_closingMemo.json"
    //get contract Design Center
    static let DesignCenterServiceURL = "bacontract_designCenter.json"
    // get Third Party Financing Addendum
//    static let ThirdPartyFinancingAddendumServiceURL = "bacontract_thirdPartyFinancingAddendum.json"
    //upload pdf
    static let ContractUploadPdfURL = "bacontract_upload.json"
    
    static let UploadCheckedPhotoURL = "bacontract_UploadCheckedPhoto.json"
   
    
    static let PdfFileNameContract = "BaseContract"
    static let PdfFielNameContract_Austin = "BaseContract_Austin"
    static let PdfFileNameThirdPartyFinancingAddendum = "Third_Party_Financing_Addendum_TREC"
    static let PdfFileNameClosingMemo = "ClosingMemo"
    static let PdfFileNameDesignCenter = "DesignCenter"
    static let PdfFileNameEXHIBIT_A = "EXHIBIT_A"
    static let PdfFileNameEXHIBIT_B = "EXHIBIT_B"
    static let PdfFileNameEXHIBIT_B_austin = "EXHIBIT_B_Austin"
    static let PdfFileNameEXHIBIT_C = "EXHIBIT_C_General"
    static let PdfFileNameEXHIBIT_C_austin = "EXHIBIT_C_General_Austin"
    static let PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES = "INFORMATION_ABOUT_BROKERAGE_SERVICES"
    static let PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES2 = "INFORMATION_ABOUT_BROKERAGE_SERVICES2"
    static let PdfFileNameAddendumA = "AddendumA"
    static let PdfFileNameAddendumA_austin = "AddendumA_Austin"
    static let PdfFileNameAddendumC = "AddendumC"
    static let PdfFileNameAddendumC2 = "AddendumC2"
    static let PdfFileNameAddendumD = "AddendumD"
    static let PdfFileNameAddendumE = "AddendumE"
    static let PdfFileNameBuyersExpect = "BuyersExpect"
    static let PdfFileNameFloodPlainAck = "FloodaplainAcknowledement"
    static let PdfFileNameHoaChecklist = "Hoa_Checklist"
    static let PdfFileNameHoaChecklist2 = "Hoa_Checklist2"
    static let PdfFileNameWarrantyAcknowledgement = "Warranty_Builder_s"
    static let PdfFileNameAddendumHOA = "trec_36-8"
    
    static let PdfPageHeight : CGFloat = 976.688235
//    static let PdfPageMarginUserDefault = "pageHMargin"
    static let PdfFileNameContractPageCount = 9
    static let PdfFileNameThirdPartyFinancingAddendumPageCount = 2
    static let PdfFileNameClosingMemoPageCount = 1
    static let PdfFileNameDesignCenterPageCount = 1
    static let PdfFileNameEXHIBIT_APageCount = 1
    static let PdfFileNameEXHIBIT_BPageCount = 1
    static let PdfFileNameEXHIBIT_CPageCount = 3
    static let PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICESPageCount = 2
    static let PdfFileNameAddendumAPageCount = 6
    static let PdfFileNameAddendumCPageCount = 1
    static let PdfFileNameAddendumC2PageCount = 2
    static let PdfFileNameAddendumDPageCount = 2
    static let PdfFileNameAddendumEPageCount = 2
    
    static let PdfFileNameBuyersExpectPageCount = 5
    static let PdfFileNameFloodPlainAckPageCount = 1
    static let PdfFileNameHoaChecklistPageCount = 3
    static let PdfFileNameWarrantyAcknowledgementPageCount = 2
    static let PdfFileNameAddendumHoaPageCount = 1
    
    static let ControllerNameContract = "SignContractViewController"
    static let ControllerNameExhibitA = "ExhibitAViewController"
    static let ControllerNameExhibitB = "ExhibitBViewController"
    static let ControllerNameExhibitC = "ExhibitCGeneralViewController"
    static let ControllerNameAddendumA = "AddendumAViewController"
    static let ControllerNameAddendumC = "AddendumCViewController"
    static let ControllerNameClosingMemo = "ClosingMemoViewController"
    static let ControllerNameDesignCenter = "DesignCenterViewController"
    static let ControllerNameThirdPartyFinancingAddendum = "ThirdPartyFinacingAddendumViewController"
    static let ControllerNameINFORMATION_ABOUT_BROKERAGE_SERVICES = "InformationAboutBrokerageServicesViewController"
    static let ControllerNamePrint = "PDFPrintViewController"
    
    
    static let StoryboardName = "Main"
    
    static let ActionTitleAddendumC : String = "Addendum C"
    static let ActionTitleAddendumD : String = "Addendum D"
    static let ActionTitleAddendumE : String = "Addendum E"
    static let ActionTitleAddendumA : String = "Addendum A"
    static let ActionTitleClosingMemo : String = "Closing Memo"
    static let ActionTitleDesignCenter : String = "Design Center"
    static let ActionTitleContract : String = "Sign Contract"
    static let ActionTitleDraftContract : String = "Contract"
    static let ActionTitleThirdPartyFinancingAddendum : String = "Third Party Financing Addendum"
    static let ActionTitleEXHIBIT_A : String = "Exhibit A"
    static let ActionTitleEXHIBIT_B : String = "Exhibit B"
    static let ActionTitleEXHIBIT_C : String = "Exhibit C General"
//    static let ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES = "Information about brokerage services"
    static let ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES = "Information about Brokerage Services"
    static let ActionTitleAddendumHOA : String = "Addendum for Property Subject to HOA"
    static let ActionTitleGoContract : String = "Print Contract"
    static let ActionTitleGoDraft : String = "Print Draft"
    static let ActionTitleBuyersExpect : String = "Buyers Expept"
    static let ActionTitleFloodPlainAck : String = "Floodplain Acknowledgement"
    static let ActionTitleHoaChecklist : String = "HOA Checklist"
    static let ActionTitleWarrantyAcknowledgement : String = "Warranty Acknowledgement"
    
    static let ApplicationColor  = UIColor(red: 0, green: 164/255.0, blue: 236/255.0, alpha: 1)
    static let SearchBarBackColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
    static let ApplicationBarFontName  =  "Futura"
    static let ApplicationBarFontSize : CGFloat = 25.0
    static let ApplicationBarItemFontSize : CGFloat = 17.0
    
    static let ApprovedStatus : String = "Approved"
    static let DisApprovedStatus : String = "Disapproved"
    static let EmailSignedStatus : String = "Email Sign"
    static let ForApproveStatus : String = "For Approve"
    static let DraftStatus : String = "iPad Sign"
    
    static let GoToBAMsg : String = "Go back to BA to modify and send to IPAD /Email  again."
    
}



