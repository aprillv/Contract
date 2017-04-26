//
//  AddressListViewHeadView.swift
//  Contract
//
//  Created by April on 11/23/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

class AddressListViewHeadView: UIView {
    
    var CiaNmLbl: UILabel!
    
    fileprivate var ProjectNmLbl: UILabel!
    fileprivate var ConsultantLbl: UILabel!
    fileprivate var ClientLbl: UILabel!
    fileprivate var StatusLbl: UILabel!
    
    fileprivate struct constants{
        static let ProjectNM = "Project"
        static let Consultant = "Consultant"
        static let Client = "Client"
        static let Status = "Status"
        static let HeadBackGroudColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = CConstants.BackColor
        
        CiaNmLbl = UILabel()
        self.addSubview(CiaNmLbl)
        CiaNmLbl.font = UIFont.boldSystemFont(ofSize: 17)
        CiaNmLbl.textAlignment = NSTextAlignment.left
        
        ProjectNmLbl = UILabel()
        addSubview(ProjectNmLbl)
        ProjectNmLbl.textAlignment = .left
        ProjectNmLbl.text = constants.ProjectNM
        ProjectNmLbl.font = UIFont.boldSystemFont(ofSize: 16)
        
        ConsultantLbl = UILabel()
        addSubview(ConsultantLbl)
        ConsultantLbl.text = constants.Consultant
        ConsultantLbl.textAlignment = .left
        ConsultantLbl.font = UIFont.boldSystemFont(ofSize: 16)
        
        ClientLbl = UILabel()
        addSubview(ClientLbl)
        ClientLbl.textAlignment = .left
        ClientLbl.text = constants.Client
        ClientLbl.font = UIFont.boldSystemFont(ofSize: 16)
        
        StatusLbl = UILabel()
        addSubview(StatusLbl)
        StatusLbl.textAlignment = .left
        StatusLbl.text = constants.Status
        StatusLbl.font = UIFont.boldSystemFont(ofSize: 16)
        
        setDisplaySubViews()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setDisplaySubViews()
    }
    
   
    
     
    
    func setDisplaySubViews(){
        
          CiaNmLbl.frame = CGRect(x: 8, y: 0, width: frame.width-16, height: frame.height * 0.5)
        
        
        let space : CGFloat = 10.0
        
        let xheight = frame.height * 0.5
        let xy = CiaNmLbl.frame.height
        
        let xwidth = frame.width - space * 3 - 16
        ProjectNmLbl.frame  = CGRect(x: 8, y: xy, width: xwidth * 0.36, height: xheight)
        
        
        
        ClientLbl.frame  = CGRect(x: ProjectNmLbl.frame.origin.x + ProjectNmLbl.frame.width + space, y: xy, width: xwidth * 0.33, height: xheight)
        
        ConsultantLbl.frame  = CGRect(x: ClientLbl.frame.origin.x + ClientLbl.frame.width + space, y: xy, width: xwidth * 0.17, height: xheight)
        StatusLbl.frame  = CGRect(x: ConsultantLbl.frame.origin.x + ConsultantLbl.frame.width + space, y: xy, width: xwidth * 0.14, height: xheight)
    }
    
}
