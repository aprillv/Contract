//
//  GoToFileViewController.swift
//  Contract
//
//  Created by April on 5/10/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
protocol GoToFileDelegate {
    func skipToFile(filenm : String)
}
class GoToFileViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate{
    // MARK: - Constanse
    
    var projectInfo: ContractsItem?
    
    @IBOutlet var printBtn: UIButton!{
        didSet{
            printBtn.layer.cornerRadius = 5.0
            printBtn.hidden = true
        }
    }
    var delegate : GoToFileDelegate?
    
    
    
    @IBAction func dismissSelf(sender: UITapGestureRecognizer) {
        //        print(sender)
        //        let point = sender.locationInView(view)
        //        if !CGRectContainsPoint(tableview.frame, point) {
        self.dismissViewControllerAnimated(true){}
        //        }
        
    }
    @IBOutlet var tableHeight: NSLayoutConstraint!
    
    @IBOutlet var tablex: NSLayoutConstraint!
    @IBOutlet var tabley: NSLayoutConstraint!
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        let point = touch.locationInView(view)
//        return !CGRectContainsPoint(tableview.frame, point)
//    }
    @IBOutlet var tableview: UITableView!{
        didSet{
            tableview.layer.cornerRadius = 8.0
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.superview?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)    }
    
    private struct constants{
        
        static let cellReuseIdentifier = "cellIdentifier"
        static let cellFirstReuseIndentifier = "firstCell"
        static let cellHeight: CGFloat = 44.0
    }
    var printList: [String] = [String]()
    
    var selected : [Bool]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableHeight.constant = getTableHight()
        tableview.updateConstraintsIfNeeded()
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return constants.cellHeight
//    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return constants.cellHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellFirstReuseIndentifier)
        cell!.textLabel!.text = "Skip to File"
        cell?.textLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
        cell?.textLabel?.textColor =  UIColor.whiteColor()
        cell?.textLabel?.backgroundColor = CConstants.ApplicationColor
        cell!.textLabel!.textAlignment = NSTextAlignment.Center
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return printList.count
    }
    
   
    //    var filesNames : [String]?
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellReuseIdentifier, forIndexPath: indexPath)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.text = printList[indexPath.row]
        cell.textLabel?.textAlignment = .Left
        cell.selectionStyle = .Default
        
        
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filenm = printList[indexPath.row]
        self.dismissViewControllerAnimated(true) {
            if let del = self.delegate {
                del.skipToFile(filenm)
            }
        }
    }
    
    override var preferredContentSize: CGSize {
        
        get {
            return CGSize(width: 380, height:getTableHight())
        }
        set { super.preferredContentSize = newValue }
    }
    
    private func getTableHight() -> CGFloat{
        //        print(constants.cellHeight * CGFloat(printList.count + 1), 680, (min(view.frame.height, view.frame.width) - 40))
        //        print(min(CGFloat(constants.cellHeight * CGFloat(printList.count + 1)), 680, (min(view.frame.height, view.frame.width) - 40)))
        return min(CGFloat(constants.cellHeight * CGFloat(printList.count + 1)), 680, (min(view.frame.height, view.frame.width) - 40))
    }
    
    
    
}
