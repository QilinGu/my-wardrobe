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
    var combination : Combination!
    
    private func updateTable() {
        tableView.reloadData()
    }
    
    @IBAction func btnAllCombination(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func btnAdd(sender: AnyObject) {
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let photos = combination.photos {
            return photos.count
        }
        return 0
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath)
        let imgView = cell.viewWithTag(100) as! UIImageView
        imgView.image = combination.photos![indexPath.row].photoImage()
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
            Database.sharedInstance.deletePhotoFromCombination(combination.photos![indexPath.row], combination: combination)
//            combination.photos!.removeAtIndex(indexPath.row)
            updateTable()
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AddToCollection") {
            let nextvc = segue.destinationViewController as! CategoriesTableVC
            nextvc.combination = combination
        } else if (segue.identifier == "ShowPhoto") {
            let nextvc = segue.destinationViewController as! PhotoViewVC
            nextvc.photo = combination.photos![(tableView.indexPathForSelectedRow?.row)!]
            nextvc.deletable = false
        }
    }
}
