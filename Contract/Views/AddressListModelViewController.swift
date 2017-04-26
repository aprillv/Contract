//
//  AddressListModelViewController.swift
//  Contract
//
//  Created by April on 2/20/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

protocol ToSwitchAddressDelegate
{
    func GoToAddress(_ item : ContractsItem)
}
class AddressListModelViewController: BaseViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

//    var lastSelectedIndexPath : NSIndexPath?
    @IBOutlet var tableviewHeight: NSLayoutConstraint!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
     var delegate : ToSwitchAddressDelegate?
    var AddressListOrigin : [ContractsItem]?{
        didSet{
            AddressList = AddressListOrigin
        }
    }
    
    fileprivate var AddressList : [ContractsItem]? {
        didSet{
            AddressList?.sort(){$0.idcia < $1.idcia}
            //            AddressList?
            
            if AddressList != nil{
                CiaNmArray = [String : [ContractsItem]]()
                var citems = [ContractsItem]()
                CiaNm = [String]()
                if let first = AddressList?.first{
                    var thetmp = first
                    for item in AddressList!{
                        
                        if thetmp.idcia != item.idcia {
                            CiaNmArray![thetmp.idcia!] = citems
                            CiaNm?.append(thetmp.idcia!)
                            thetmp = item
                            citems = [ContractsItem]()
                        }
                        citems.append(item)
                    }
                    
                    if citems.count > 0 {
                        CiaNmArray![thetmp.idcia!] = citems
                        CiaNm?.append(thetmp.idcia!)
                    }
                }
            }
            
            self.tableView?.reloadData()
        }
    }
    
    fileprivate var CiaNm : [String]?
    fileprivate var CiaNmArray : [String : [ContractsItem]]?
    // MARK: - Constanse
    fileprivate struct constants{
        static let CellIdentifier : String = "AddressModelUITableViewCell"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CiaNm?.count ?? 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CiaNmArray?[CiaNm?[section] ?? ""]!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let info = CiaNmArray?[CiaNm?[section] ?? ""]![0] {
            return info.cianame
        }
        return ""
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.CellIdentifier, for: indexPath)
        
        
        let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
        let info = ddd![indexPath.row]
        cell.textLabel?.text = info.nproject
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        
        self.dismiss(animated: true, completion: nil)
        if let delegate1 = self.delegate {
            let ddd = self.CiaNmArray?[self.CiaNm?[indexPath.section] ?? ""]
            let item: ContractsItem = ddd![indexPath.row]
            delegate1.GoToAddress(item)
        }
        
    }
    
    
    
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.separatorInset = UIEdgeInsetsZero
//        cell.layoutMargins = UIEdgeInsetsZero
//        cell.preservesSuperviewLayoutMargins = false
//    }
    
     func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
    override var preferredContentSize: CGSize {
        
        get {
            let x = searchBar.frame.height + CGFloat(CiaNm!.count*25) + CGFloat(AddressList!.count * 44)
            
            if  x < tableView.frame.height {
                tableviewHeight.constant = x
                tableView.updateConstraintsIfNeeded()
                return CGSize(width: tableView.frame.width, height: x)
            }
            return CGSize(width: tableView.frame.width, height: tableView.frame.height)
        }
        set { super.preferredContentSize = newValue }
    }
    
    // MARK: - Search Bar Deleagte
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let txt = searchBar.text?.lowercased(){
            if txt.isEmpty{
                AddressList = AddressListOrigin
            }else{
                AddressList = AddressListOrigin?.filter(){
//                    return $0.cianame!.lowercaseString.containsString(txt)
//                        || $0.assignsales1name!.lowercaseString.containsString(txt)
//                        || $0.nproject!.lowercaseString.containsString(txt)
//                        || $0.client!.lowercaseString.containsString(txt)
                    return $0.cianame!.lowercased().contains(txt)
                        || $0.nproject!.lowercased().contains(txt)
                }
            }
        }else{
            AddressList = AddressListOrigin
        }
        
    }
    
}
