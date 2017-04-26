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
    
    required init(contractInfo : ContractsItem?){
        super.init()
        if contractInfo != nil {
            cInfo = contractInfo
        }
        
    }
    
    func DictionaryFromObject() -> [String: String]{
        let userinfo = UserDefaults.standard
        
        if userinfo.bool(forKey: CConstants.UserInfoIsContract){
            let a = ["idnumber" : cInfo?.idnumber ?? ""
                , "idcity" : cInfo?.idcity ?? ""
                , "idcia": cInfo?.idcia ?? ""
                , "code": cInfo?.code ?? ""
                , "isContract" : "1"
                , "ispdf": "0"]
            return a
        }else{
            let a = ["idnumber" : cInfo?.idproject ?? ""
                , "idcity" : cInfo?.idcity ?? ""
                , "idcia": cInfo?.idcia ?? ""
                , "code": cInfo?.code ?? ""
                , "isContract" : "0"
                , "ispdf": "0"]
            return a
        }
    }
    
    func DictionaryFromBasePdf(_ model :ContractPDFBaseModel) -> [String: String]{
        let userinfo = UserDefaults.standard
        if userinfo.bool(forKey: CConstants.UserInfoIsContract){
            let a = ["idnumber" : model.idnumber!
                , "idcity" : model.idcity!
                , "idcia": model.idcia!
                , "code": model.code!
                , "isContract" : "1"
                , "ispdf": "0"]
            //        print(a)
            return a
        }else{
            let a = ["idnumber" : model.idproject!
                , "idcity" : model.idcity!
                , "idcia": model.idcia!
                , "code": model.code!
                , "isContract" : "0"
                , "ispdf": "0"]
            //        print(a)
            return a
        }
        
    }
}
