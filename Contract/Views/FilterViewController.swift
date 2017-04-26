//
//  FilterViewController.swift
//  Contract
//
//  Created by April on 5/4/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit

protocol FilterViewDelegate
{
    func showAll()
    func showHomeOwnerSign()
    func showSalesSign()
    func showReCreate()
    
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var delegate1 : FilterViewDelegate?
    var itemList : [String]?{
        didSet{
            if let _ = itemList{
                tableView.reloadData()
            }
        }
    }
    
    
    fileprivate struct constants{
        static let cellReuseIdentifier = "filterCell"
        static let rowHeight : CGFloat = 44
//        static let operationShowAll = "Show All"
         static let operationShowAll = "Sign Required"
        static let operationHomeownerSign = "Homeowner Sign"
        static let operationSalesSign = "Sales Sign"
        static let operationReCreate = "Re-Create PDF"
        static let operationFinished = "Finished"
    }
    
    var showIndex : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        let userinfo = UserDefaults.standard
        showIndex = userinfo.integer(forKey: CConstants.ShowFilter)
        if (userinfo.string(forKey: CConstants.UserInfoEmail) ?? "").lowercased() == CConstants.Administrator {
        itemList = [constants.operationShowAll, constants.operationHomeownerSign, constants.operationSalesSign, constants.operationReCreate]
        }else{
        itemList = [constants.operationShowAll, constants.operationHomeownerSign, constants.operationSalesSign, constants.operationFinished]
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return constants.rowHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.cellReuseIdentifier, for: indexPath)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        if let cell1 = cell as? filterCell {
            cell1.textlbl.text = itemList![indexPath.row]
            
            if indexPath.row == (showIndex ?? 1) {
                cell1.checkImg.image = UIImage(named: "checkmark2")
            }
        }
        
        
        
//        cell.textLabel?.textAlignment = .Center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userinfo = UserDefaults.standard
        let a = userinfo.integer(forKey: CConstants.ShowFilter)
        let lastIndex = IndexPath(row: a, section: 0 )
        if let cell1 = tableView.cellForRow(at: lastIndex) as? filterCell {
            cell1.checkImg.image = nil
        }
        if let cell1 = tableView.cellForRow(at: indexPath) as? filterCell {
            cell1.checkImg.image = UIImage(named: "checkmark2")
        }
        userinfo.set(indexPath.row, forKey: CConstants.ShowFilter)
        
        
        self.dismiss(animated: true){
            
            if let delegate0 = self.delegate1{
                switch self.itemList![indexPath.row]{
                case constants.operationShowAll:
                    delegate0.showAll()
                case constants.operationSalesSign:
                    delegate0.showSalesSign()
                case constants.operationReCreate, constants.operationFinished:
                    delegate0.showReCreate()
                default:
                    delegate0.showHomeOwnerSign()
                }
            }
        }
    }
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: tableView.frame.width, height: constants.rowHeight * CGFloat(itemList!.count))
        }
        set { super.preferredContentSize = newValue }
    }
    
}
