//
//  ContractAddendumC.swift
//  Contract
//
//  Created by April on 12/11/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import Foundation

class ContractAddendumC : ContractPDFBaseModel {
    var cianame: String?
    var ciaaddress: String?
    var ciacityzip: String?
    var ciatelfax: String?
    var addendumNo: String?
    var contractdate: String?
    var estimatedcompletion: String?
    var estimatedclosing: String?
    var stage: String?
    var buyer: String?
    var consultant: String?
    var subdivision: String?
    var price: String?
    var agree: String?
    var itemlist:[ItemlistItem]?
    var itemlistStr:[[String]]?
    var found: String?
    var message: String?
    var approvedate : String?
    var approveMonthdate : String?
//    var buyer2: String?
}
