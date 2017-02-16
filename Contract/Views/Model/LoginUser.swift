//
//  LoginUser.swift
//  Contract
//
//  Created by April on 11/20/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import Foundation

class LoginUser: NSObject {
    var email: String?
    var password: String?
    var isContract : String?
    
    required init(email: String, password: String, iscontract: String){
        super.init()
        self.email = email
        self.password = password
        self.isContract = iscontract
    }
    
    func DictionaryFromObject() -> [String: String]{
        return ["email" : email ?? "", "password" : password ?? "", "isContract" : isContract ?? "1"]
    }
    
}