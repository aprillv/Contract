//
//  AddressDraftListViewCell.swift
//  Contract
//
//  Created by April on 2/25/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit


class AddressDraftListViewCell: UITableViewCell {
    fileprivate var ProjectNmLbl: UILabel!
//    private var ConsultantLbl: UILabel!
//    privates var ClientLbl: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let v = UIView()
        self.contentView.addSubview(v)
        v.backgroundColor = CConstants.BorderColor
        let leadingConstraint = NSLayoutConstraint(item:v,
            attribute: .leadingMargin,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .leadingMargin,
            multiplier: 1.0,
            constant: 0);
        let trailingConstraint = NSLayoutConstraint(item:v,
            attribute: .trailingMargin,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .trailingMargin,
            multiplier: 1.0,
            constant: 0);
        
        let bottomConstraint = NSLayoutConstraint(item: v,
            attribute: .bottomMargin,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .bottomMargin,
            multiplier: 1.0,
            constant: 0);
        
        let heightContraint = NSLayoutConstraint(item: v,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 1.0 / (UIScreen.main.scale));
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, bottomConstraint, heightContraint])
    }
    
    @IBOutlet weak var cview: UIView!{
        didSet{
            
            ProjectNmLbl = UILabel()
            cview.addSubview(ProjectNmLbl)
            
//            ConsultantLbl = UILabel()
//            ConsultantLbl.textAlignment = NSTextAlignment.Left
//            cview.addSubview(ConsultantLbl)
//            
//            ClientLbl = UILabel()
//            cview.addSubview(ClientLbl)
//            setDisplaySubViews()
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.contentView.backgroundColor = CConstants.SearchBarBackColor
        }else{
            self.contentView.backgroundColor = UIColor.white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.contentView.backgroundColor = CConstants.SearchBarBackColor
        }else{
            self.contentView.backgroundColor = UIColor.white
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setDisplaySubViews()
    }
    
    func setDisplaySubViews(){
        
        let space : CGFloat = 10.0
        
        let xheight = frame.height
        let xwidth = frame.width - space * 2 - 16
        ProjectNmLbl.frame  = CGRect(x: 8, y: 0, width: xwidth , height: xheight)
        
        
//        
//        ClientLbl.frame  = CGRect(x: ProjectNmLbl.frame.origin.x + ProjectNmLbl.frame.width + space, y: 0, width: xwidth * 0.33, height: xheight)
//        
//        ConsultantLbl.frame  = CGRect(x: ClientLbl.frame.origin.x + ClientLbl.frame.width + space, y: 0, width: xwidth * 0.23, height: xheight)
        
        
    }
    
    
    
    
    var contractInfo: ContractsItem? {
        didSet{
            if let item = contractInfo{
                ProjectNmLbl.text = item.nproject
//                ConsultantLbl.text = item.assignsales1name
//                ClientLbl.text = item.client
            }
        }
    }
}
