
//
//  AddressListModelCell.swift
//  Contract
//
//  Created by April on 2/29/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit

class AddressListModelCell: UITableViewCell {
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        self.setCellBackColor(highlighted)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setCellBackColor(selected)
    }
    
    private func setCellBackColor(sels: Bool){
        if sels {
            self.contentView.backgroundColor = CConstants.SearchBarBackColor
            self.backgroundColor = CConstants.SearchBarBackColor
        }else{
            self.contentView.backgroundColor = UIColor.whiteColor()
            self.backgroundColor = UIColor.whiteColor()
        }
    
    }
}
