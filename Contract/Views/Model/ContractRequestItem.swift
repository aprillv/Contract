//
//  ContractRequestItem.swift
//  Contract
//
//  Created by April on 11/20/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import Foundation

class ContractRequestItem: NSObject {
    var cInfo : ContractsItem?
    
    required init(contractInfo : ContractsItem){
        super.init()
        cInfo = contractInfo
    }
    
    func DictionaryFromObject() -> [String: String]{
        let a = ["idnumber" : cInfo?.idnumber ?? ""
            , "idcity" : cInfo?.idcity ?? ""
            , "idcia": cInfo?.idcia ?? ""
            , "code": cInfo?.code ?? ""
            , "ispdf": "0"]
        return a
    }
}