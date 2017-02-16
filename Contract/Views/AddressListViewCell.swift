//
//  AdressListViewCell.swift
//  Contract
//
//  Created by April on 11/20/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

class AddressListViewCell: UITableViewCell {
    private var ProjectNmLbl: UILabel!
    private var ConsultantLbl: UILabel!
    private var ClientLbl: UILabel!
    private var StatusLbl: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let v = UIView()
        self.contentView.addSubview(v)
        v.backgroundColor = CConstants.BorderColor
        let leadingConstraint = NSLayoutConstraint(item:v,
            attribute: .LeadingMargin,
            relatedBy: .Equal,
            toItem: self.contentView,
            attribute: .LeadingMargin,
            multiplier: 1.0,
            constant: 0);
        let trailingConstraint = NSLayoutConstraint(item:v,
            attribute: .TrailingMargin,
            relatedBy: .Equal,
            toItem: self.contentView,
            attribute: .TrailingMargin,
            multiplier: 1.0,
            constant: 0);
        
        let bottomConstraint = NSLayoutConstraint(item: v,
            attribute: .BottomMargin,
            relatedBy: .Equal,
            toItem: self.contentView,
            attribute: .BottomMargin,
            multiplier: 1.0,
            constant: 0);
        
        let heightContraint = NSLayoutConstraint(item: v,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: 1.0 / (UIScreen.mainScreen().scale));
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([leadingConstraint, trailingConstraint, bottomConstraint, heightContraint])
    }
    
    @IBOutlet weak var cview: UIView!{
        didSet{
            
            ProjectNmLbl = UILabel()
            cview.addSubview(ProjectNmLbl)
            
            ConsultantLbl = UILabel()
            ConsultantLbl.textAlignment = NSTextAlignment.Left
            cview.addSubview(ConsultantLbl)
            
            ClientLbl = UILabel()
            cview.addSubview(ClientLbl)
            
            StatusLbl = UILabel()
            cview.addSubview(StatusLbl)

            setDisplaySubViews()
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        setDisplaySubViews()
    }
    
    func setDisplaySubViews(){
        
        let space : CGFloat = 10.0
        
        let xheight = frame.height
        let xwidth = frame.width - space * 3 - 16
        ProjectNmLbl.frame  = CGRect(x: 8, y: 0, width: xwidth * 0.36, height: xheight)
        
        
        
        ClientLbl.frame  = CGRect(x: ProjectNmLbl.frame.origin.x + ProjectNmLbl.frame.width + space, y: 0, width: xwidth * 0.33, height: xheight)
        
        ConsultantLbl.frame  = CGRect(x: ClientLbl.frame.origin.x + ClientLbl.frame.width + space, y: 0, width: xwidth * 0.17, height: xheight)
        
        StatusLbl.frame  = CGRect(x: ConsultantLbl.frame.origin.x + ConsultantLbl.frame.width + space, y: 0, width: xwidth * 0.14, height: xheight)
        
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        self.setCellBackColor(highlighted)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setCellBackColor(selected)
    }
    
    private func setCellBackColor(sels: Bool){
        if sels {
            self.backgroundColor = CConstants.SearchBarBackColor
            self.contentView.backgroundColor = CConstants.SearchBarBackColor
        }else{
            self.backgroundColor = UIColor.whiteColor()
            self.contentView.backgroundColor = UIColor.whiteColor()
        }
    }
    
   
    
    var contractInfo: ContractsItem? {
        didSet{
            if let item = contractInfo{
                ProjectNmLbl.text = item.nproject
                ConsultantLbl.text = item.assignsales1name
                if item.client2 != "" {
                ClientLbl.text = (item.client ?? "") + " / " + (item.client2 ?? "")
                }else{
                ClientLbl.text = (item.client ?? "")
                }
                
                StatusLbl.text = item.status
            }
        }
    }
}
