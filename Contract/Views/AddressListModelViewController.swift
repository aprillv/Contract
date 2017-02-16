//
//  AddressListModelViewController.swift
//  Contract
//
//  Created by April on 2/20/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
protocol ToSwitchAddressDelegate
{
    func GoToAddress(item : ContractsItem)
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
    
    private var AddressList : [ContractsItem]? {
        didSet{
            AddressList?.sortInPlace(){$0.idcia < $1.idcia}
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
    
    private var CiaNm : [String]?
    private var CiaNmArray : [String : [ContractsItem]]?
    // MARK: - Constanse
    private struct constants{
        static let CellIdentifier : String = "AddressModelUITableViewCell"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CiaNm?.count ?? 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CiaNmArray?[CiaNm?[section] ?? ""]!.count ?? 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let info = CiaNmArray?[CiaNm?[section] ?? ""]![0] {
            return info.cianame
        }
        return ""
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.CellIdentifier, forIndexPath: indexPath)
        
        
        let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
        let info = ddd![indexPath.row]
        cell.textLabel?.text = info.nproject
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
     func scrollViewWillBeginDragging(scrollView: UIScrollView) {
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
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let txt = searchBar.text?.lowercaseString{
            if txt.isEmpty{
                AddressList = AddressListOrigin
            }else{
                AddressList = AddressListOrigin?.filter(){
//                    return $0.cianame!.lowercaseString.containsString(txt)
//                        || $0.assignsales1name!.lowercaseString.containsString(txt)
//                        || $0.nproject!.lowercaseString.containsString(txt)
//                        || $0.client!.lowercaseString.containsString(txt)
                    return $0.cianame!.lowercaseString.containsString(txt)
                        || $0.nproject!.lowercaseString.containsString(txt)
                }
            }
        }else{
            AddressList = AddressListOrigin
        }
        
    }
    
}
