
//
//  AddressListModelCell.swift
//  Contract
//
//  Created by April on 2/29/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit

class AddressListModelCell: UITableViewCell {
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.setCellBackColor(highlighted)
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var textlbl: UILabel!
    @IBOutlet weak var photo: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setCellBackColor(selected)
    }
    
    fileprivate func setCellBackColor(_ sels: Bool){
        if sels {
            self.contentView.backgroundColor = CConstants.SearchBarBackColor
            self.backgroundColor = CConstants.SearchBarBackColor
        }else{
            self.contentView.backgroundColor = UIColor.white
            self.backgroundColor = UIColor.white
        }
    
    }
}
