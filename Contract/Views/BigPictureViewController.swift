//
//  BigPictureViewController.swift
//  Selection
//
//  Created by April on 3/14/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import MessageUI
import MBProgressHUD

class BigPictureViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageUrl: NSURL? {
        didSet{
            self.loadImage()
        }
    }
    
    var contractPdfInfo : ContractSignature?{
        didSet{
            lbl?.hidden = ((contractPdfInfo?.hasCheckedPhoto ?? "0") == "1")
        }
    }
    @IBOutlet var lbl: UILabel?{
        didSet{
            lbl?.hidden = ((contractPdfInfo?.hasCheckedPhoto ?? "0") == "1")
        }
    }
    @IBOutlet var image: UIImageView!{
        didSet{
            if ((contractPdfInfo?.hasCheckedPhoto ?? "0") == "1") {
                self.loadImage()
            }
            
        }
    }
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    private func loadImage(){
        if let url = imageUrl {
            if image != nil {
//                print(url)
                
                let hud = MBProgressHUD.showHUDAddedTo(image, animated: true)
                //                hud.mode = .AnnularDeterminate
                hud.labelText = "Loading Picutre"
                hud.show(true)
                
                image.sd_setImageWithURL(url, completed: { (_, _, _, _) -> Void in
                    hud.hide(true)
                })
//                image.sd_setImageWithURL(url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ds = self.contractPdfInfo?.signfinishdate, ss = self.contractPdfInfo?.status {
            if  ds != "01/01/1980" && ss == CConstants.ApprovedStatus {
                saveBtn.hidden = true
//                justShowEmail = true
            }
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        self.title = "Print"
        view.superview?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        //        view.superview?.bounds = CGRect(x: 0, y: 0, width: tableview.frame.width, height: 44 * CGFloat(5))
    }
    
    override var preferredContentSize: CGSize {
        
        get {
            
            return CGSize(width: 800, height: 700)
        }
        set { super.preferredContentSize = newValue }
    }
    
    private func setCornerRadius(btn : UIButton) {
        btn.layer.cornerRadius = 5.0
    }
    @IBOutlet var closeBtn: UIButton!{
        didSet{
            setCornerRadius(closeBtn)
        }
    }
    
    @IBOutlet var saveBtn: UIButton!{
        didSet{
            setCornerRadius(saveBtn)
        }
    }
    
    var imagePicker : UIImagePickerController?
    @IBAction func doSave(sender: UIButton) {
//        if let img = image.image {
//            UIImageWriteToSavedPhotosAlbum(img, self, #selector(BigPictureViewController.image(_:didFinishSavingWithError:contextInfo:)), nil);
//        }
        
        let alert: UIAlertController = UIAlertController(title: "Attach Photo Check", message: nil, preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default) { action -> Void in
            //Do some stuff
            self.imagePicker =  UIImagePickerController()
            self.imagePicker?.delegate = self
            //            self.imagePicker?.allowsEditing = true
            self.imagePicker?.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker!, animated: true, completion: nil)
        }
        alert.addAction(oKAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Cancel) { action -> Void in
            //Do some stuff
            self.imagePicker =  UIImagePickerController()
            self.imagePicker?.delegate = self
            //            self.imagePicker?.allowsEditing = true
            self.imagePicker?.sourceType = .Camera
            self.presentViewController(self.imagePicker!, animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            
            
            var hud : MBProgressHUD?
            hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud?.mode = .CustomView
            let image = UIImage(named: CConstants.SuccessImageNm)
            hud?.customView = UIImageView(image: image)
            hud?.labelText = CConstants.SavedSuccessMsg
            hud?.show(true)
            
            hud?.hide(true, afterDelay: 0.5)
            
        } else {
            var hud : MBProgressHUD?
            hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud?.mode = .CustomView
            let image = UIImage(named: CConstants.SuccessImageNm)
            hud?.customView = UIImageView(image: image)
            hud?.labelText = CConstants.SavedFailMsg
            hud?.show(true)
            
            hud?.hide(true, afterDelay: 0.5)
        }
    }
    
    private struct constants{
        static let operationMsg = "Are you sure you want to take photo of the check again?"
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imagePicker?.dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
           
            if (contractPdfInfo?.hasCheckedPhoto ?? "0") == "1" {
                let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: constants.operationMsg, preferredStyle: .Alert)
                
                //Create and add the OK action
                let oKAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                    self.image.image = image
                    self.uploadAttachedPhoto(image)
                }
                alert.addAction(oKAction)
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alert.addAction(cancelAction)
                
                //Present the AlertController
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                self.lbl?.hidden = true
                self.image.image = image
                
                self.uploadAttachedPhoto(image)
            }
        }
        
        
        
        
        
    }
    
    var hud : MBProgressHUD?
    private func uploadAttachedPhoto(image : UIImage){
        let imageData = UIImageJPEGRepresentation(image, 0.65)
        let string = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        self.hud?.labelText = "Uploading photo to BA Server..."
        let param = ["idcontract1" : contractPdfInfo?.idnumber ?? "0" , "checked_photo" : string]
//        print(param)
        Alamofire.request(.POST,
            CConstants.ServerURL + CConstants.UploadCheckedPhotoURL,
            parameters: param).responseJSON{ (response) -> Void in
                //                hud.hide(true)
                //                print(param, serviceUrl, response.result.value)
                SDImageCache.sharedImageCache().clearMemory()
                 SDImageCache.sharedImageCache().cleanDisk()
                
                SDImageCache.sharedImageCache().removeImageForKey(CConstants.ServerURL + "bacontract_photoCheck.json?ContractID=" + (self.contractPdfInfo?.idnumber ?? ""))
                if response.result.isSuccess {
                   
                    
                    if let rtnValue = response.result.value as? Bool{
                        
                        if rtnValue{
                            if let _ = self.imageUrl {
                                
                                SDImageCache.sharedImageCache().storeImage(image, recalculateFromImage: false, imageData: imageData, forKey: CConstants.ServerURL + "bacontract_photoCheck.json?ContractID=" + (self.contractPdfInfo?.idnumber ?? ""), toDisk: true)
                            }
                            self.contractPdfInfo?.hasCheckedPhoto = "1"
                            self.hud?.mode = .CustomView
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
                self.performSelector(#selector(BigPictureViewController.dismissProgress as (BigPictureViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
                self.performSelector(#selector(BigPictureViewController.dismissProgress2 as (BigPictureViewController) -> () -> ()), withObject: nil, afterDelay: 0.8)
        }
    }
    
    func dismissProgress(){
        self.hud?.hide(true)
    }
    func dismissProgress2(){
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func afterSave(sender : AnyObject) {
//        print(sender)
    }
    @IBAction func doClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
