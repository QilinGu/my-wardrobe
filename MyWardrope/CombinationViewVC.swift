//
//  CombinationViewVC.swift
//  MyWardrope
//
//  Created by Minh on 17.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

typealias CombinationInfo = (index: Int, images: [UIImage])

public class CombinationViewVC : UITableViewController {
    var combinationInfo : CombinationInfo!
    
    private func updateTable() {
        tableView.reloadData()
    }
    
    @IBAction func btnAdd(sender: AnyObject) {
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combinationInfo.images.count
    }
    
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath)
        let imgView = cell.viewWithTag(100) as! UIImageView
        imgView.image = combinationInfo.images[indexPath.row]
        return cell
    }
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320.0
    }
    
    public override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            Database.sharedInstance.deleteImageFromCombination(indexPath.row, combinationIndex: combinationInfo.index)
            combinationInfo.images.removeAtIndex(indexPath.row)
            updateTable()
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AddToCollection") {
            let nextvc = segue.destinationViewController as! CategoriesTableVC
            nextvc.combinationIndex = combinationInfo.index
        }
    }
}
