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

    var imageUrl: URL? {
        didSet{
            self.loadImage()
        }
    }
    
    var contractPdfInfo : ContractSignature?{
        didSet{
            lbl?.isHidden = ((contractPdfInfo?.hasCheckedPhoto ?? "0") == "1")
        }
    }
    @IBOutlet var lbl: UILabel?{
        didSet{
            lbl?.isHidden = ((contractPdfInfo?.hasCheckedPhoto ?? "0") == "1")
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
    
    fileprivate func loadImage(){
        if let url = imageUrl {
            if image != nil {
//                print(url)
                
                let hud = MBProgressHUD.showAdded(to: image, animated: true)
                //                hud.mode = .AnnularDeterminate
                hud?.labelText = "Loading Picutre"
                hud?.show(true)
                
                image.sd_setImage(with: url, completed: { (_, _, _, _) -> Void in
                    hud?.hide(true)
                })
//                image.sd_setImageWithURL(url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ds = self.contractPdfInfo?.signfinishdate, let ss = self.contractPdfInfo?.status {
            if  ds != "01/01/1980" && ss == CConstants.ApprovedStatus {
                saveBtn.isHidden = true
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
    
    fileprivate func setCornerRadius(_ btn : UIButton) {
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
    @IBAction func doSave(_ sender: UIButton) {
//        if let img = image.image {
//            UIImageWriteToSavedPhotosAlbum(img, self, #selector(BigPictureViewController.image(_:didFinishSavingWithError:contextInfo:)), nil);
//        }
        
        let alert: UIAlertController = UIAlertController(title: "Attach Photo Check", message: nil, preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
            //Do some stuff
            self.imagePicker =  UIImagePickerController()
            self.imagePicker?.delegate = self
            //            self.imagePicker?.allowsEditing = true
            self.imagePicker?.sourceType = .photoLibrary
            self.present(self.imagePicker!, animated: true, completion: nil)
        }
        alert.addAction(oKAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .cancel) { action -> Void in
            //Do some stuff
            self.imagePicker =  UIImagePickerController()
            self.imagePicker?.delegate = self
            //            self.imagePicker?.allowsEditing = true
            self.imagePicker?.sourceType = .camera
            self.present(self.imagePicker!, animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            
            
            var hud : MBProgressHUD?
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .customView
            let image = UIImage(named: CConstants.SuccessImageNm)
            hud?.customView = UIImageView(image: image)
            hud?.labelText = CConstants.SavedSuccessMsg
            hud?.show(true)
            
            hud?.hide(true, afterDelay: 0.5)
            
        } else {
            var hud : MBProgressHUD?
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .customView
            let image = UIImage(named: CConstants.SuccessImageNm)
            hud?.customView = UIImageView(image: image)
            hud?.labelText = CConstants.SavedFailMsg
            hud?.show(true)
            
            hud?.hide(true, afterDelay: 0.5)
        }
    }
    
    fileprivate struct constants{
        static let operationMsg = "Are you sure you want to take photo of the check again?"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker?.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
           
            if (contractPdfInfo?.hasCheckedPhoto ?? "0") == "1" {
                let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: constants.operationMsg, preferredStyle: .alert)
                
                //Create and add the OK action
                let oKAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
                    self.image.image = image
                    self.uploadAttachedPhoto(image)
                }
                alert.addAction(oKAction)
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                //Present the AlertController
                self.present(alert, animated: true, completion: nil)
            }else{
                self.lbl?.isHidden = true
                self.image.image = image
                
                self.uploadAttachedPhoto(image)
            }
        }
        
        
        
        
        
    }
    
    var hud : MBProgressHUD?
    fileprivate func uploadAttachedPhoto(_ image : UIImage){
        let imageData = UIImageJPEGRepresentation(image, 0.65)
        let string = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        self.hud?.labelText = "Uploading photo to BA Server..."
        let param = ["idcontract1" : contractPdfInfo?.idnumber ?? "0" , "checked_photo" : string]
//        print(param)
        Alamofire.request(
            (CConstants.ServerURL + CConstants.UploadCheckedPhotoURL)
            , method: .post
            , parameters: param).responseJSON{ (response) -> Void in
                //                hud.hide(true)
                //                print(param, serviceUrl, response.result.value)
                SDImageCache.shared().clearMemory()
                 SDImageCache.shared().cleanDisk()
                SDImageCache.shared().removeImage(forKey: (CConstants.ServerURL + "bacontract_photoCheck.json?ContractID=" + (self.contractPdfInfo?.idnumber ?? "")))
                if response.result.isSuccess {
                   
                    
                    if let rtnValue = response.result.value as? Bool{
                        
                        if rtnValue{
                            if let _ = self.imageUrl {
                                SDImageCache.shared().store(image, recalculateFromImage: false, imageData: imageData, forKey: CConstants.ServerURL + "bacontract_photoCheck.json?ContractID=" + (self.contractPdfInfo?.idnumber ?? ""), toDisk: true)
                            }
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
                self.perform(#selector(BigPictureViewController.dismissProgress as (BigPictureViewController) -> () -> ()), with: nil,afterDelay: 0.5)
                self.perform(#selector(BigPictureViewController.dismissProgress2 as (BigPictureViewController) -> () -> ()), with: nil,afterDelay: 0.8)
        }
    }
    
    func dismissProgress(){
        self.hud?.hide(true)
    }
    func dismissProgress2(){
       self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func afterSave(_ sender : AnyObject) {
//        print(sender)
    }
    @IBAction func doClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
