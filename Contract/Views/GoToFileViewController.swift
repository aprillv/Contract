//
//  GoToFileViewController.swift
//  Contract
//
//  Created by April on 5/10/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
protocol GoToFileDelegate {
    func skipToFile(_ filenm : String)
}
class GoToFileViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate{
    // MARK: - Constanse
    
    var projectInfo: ContractsItem?
    
    @IBOutlet var printBtn: UIButton!{
        didSet{
            printBtn.layer.cornerRadius = 5.0
            printBtn.isHidden = true
        }
    }
    var delegate : GoToFileDelegate?
    
    
    
    @IBAction func dismissSelf(_ sender: UITapGestureRecognizer) {
        //        print(sender)
        //        let point = sender.locationInView(view)
        //        if !CGRectContainsPoint(tableview.frame, point) {
        self.dismiss(animated: true){}
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
    
    fileprivate struct constants{
        
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return constants.cellHeight
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.cellFirstReuseIndentifier)
        cell!.textLabel!.text = "Skip to File"
        cell?.textLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
        cell?.textLabel?.textColor =  UIColor.white
        cell?.textLabel?.backgroundColor = CConstants.ApplicationColor
        cell!.textLabel!.textAlignment = NSTextAlignment.center
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return printList.count
    }
    
   
    //    var filesNames : [String]?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.cellReuseIdentifier, for: indexPath)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.text = printList[indexPath.row]
        cell.textLabel?.textAlignment = .left
        cell.selectionStyle = .default
        
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filenm = printList[indexPath.row]
        self.dismiss(animated: true) {
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
    
    fileprivate func getTableHight() -> CGFloat{
        //        print(constants.cellHeight * CGFloat(printList.count + 1), 680, (min(view.frame.height, view.frame.width) - 40))
        //        print(min(CGFloat(constants.cellHeight * CGFloat(printList.count + 1)), 680, (min(view.frame.height, view.frame.width) - 40)))
        return min(CGFloat(constants.cellHeight * CGFloat(printList.count + 1)), 680, (min(view.frame.height, view.frame.width) - 40))
    }
    
    
    
}
