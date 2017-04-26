//
//  HapObject.swift
//  HappApp
//
//  Created by April on 11/12/15.
//  Copyright © 2015 lovetthomes. All rights reserved.
//

import Foundation

class ContractObject : NSObject{
    required init(dicInfo : [String: AnyObject]?){
        super.init()
        if let info = dicInfo {
            self.setValuesForKeys(info)
        }
        
    }
    
    fileprivate struct constants  {
        static let projectName : String = "Contract."
//        NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
        static let lastName : String = "Item"
    
    }
    
//    func getPropertieNamesAsDictionary() -> [String: String]{
//        
//        var outCount:UInt32
//        outCount = 0
//        let peopers:UnsafeMutablePointer<objc_property_t>! =  class_copyPropertyList(self.classForCoder, &outCount)
//        let count:Int = Int(outCount);
//        var selfDicInfo : [String: String] = [String: String]()
//        for i in 0...(count-1) {
//            let aPro: objc_property_t = peopers[i]
//            let proName: String! = String(validatingUTF8: property_getName(aPro))
//            if let v = value(forKey: proName) as? String {
//                selfDicInfo[proName] = v
//            }else{
//                selfDicInfo[proName] = ""
//            }
//        }
//        
//        let peopers2:UnsafeMutablePointer<objc_property_t>! =  class_copyPropertyList(super.classForCoder, &outCount)
//        let count2:Int = Int(outCount);
////        var selfDicInfo2 : [String: String] = [String: String]()
//        for i in 0...(count2-1) {
//            let aPro: objc_property_t = peopers2[i]
//            let proName: String! = String(validatingUTF8: property_getName(aPro))
//            if let v = value(forKey: proName) as? String {
//                selfDicInfo[proName] = v
//            }else{
//                selfDicInfo[proName] = ""
//            }
//        }
//        
//        return selfDicInfo
//        
//    }
    
    override func setValue(_ value0: Any?, forKey key: String) {
        var skey : String
//        if key == "description" {
//            skey = "cdescription"
//        }else{
            skey = key
//        }
//        print("\(skey)")
//        let  dic = self.getPropertieNamesAsDictionary()
//        
//        if dic.keys.contains(key) {
            if let value = value0{
                if let dic = value as? [Dictionary<String, AnyObject>]{
                    var tmpArray : [ContractObject] = [ContractObject]()
                    for tmp0 in dic{
                        
                        let anyobjecType: AnyObject.Type = NSClassFromString(GetCapitalFirstWord(skey)!)!
                        if anyobjecType is ContractObject.Type {
                            let vc = (anyobjecType as! ContractObject.Type).init(dicInfo: tmp0)
                            tmpArray.append(vc)
                        }
                    }
                    super.setValue(tmpArray, forKey: skey)
                }else{
                    
                    super.setValue(value, forKey: skey as String)
                }
            }
//        }
        
        
        
    }
    
    fileprivate func GetCapitalFirstWord(_ str : String?) -> String?{
        if let str0 = str {
            let index = str0.characters.index(str0.startIndex, offsetBy: 1)
            let firstCapitalWord = str0.substring(to: index).capitalized
            return constants.projectName + firstCapitalWord + str0.substring(from: index) + constants.lastName
        }
        return nil
    }
}
