//
//  SubCategoryTableVC.swift
//  MyWardrope
//
//  Created by Minh on 15.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

public class SubCategoryTableVC : UITableViewController {
    var subcategories: [Category]?
    var category: String!
    var combinationIndex = -1
    
    public override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        if (combinationIndex >= 0) {
            navigationItem.rightBarButtonItem = nil
        }

        self.title = category
    }
    
    public override func viewWillAppear(animated: Bool) {
        updateTable()
    }
    
    private func updateTable() {
        subcategories = Database.sharedInstance.getSubCategoriesList(category)
        tableView.reloadData()
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cats = subcategories {
            return cats.count
        }
        return 0
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellSubCaterogy", forIndexPath: indexPath)
        if let cats = subcategories {
            cell.imageView?.image = cats[indexPath.row].image
            let itemSize = CGSizeMake(32, 32);
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.mainScreen().scale);
            let imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            cell.imageView!.image?.drawInRect(imageRect);
            cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            cell.textLabel?.text = cats[indexPath.row].name
            cell.detailTextLabel?.text = "0"
        }
        return cell
    }
    
    public override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            Database.sharedInstance.deleteSubCategory(category, indexOfSubcategory: indexPath.row)
            updateTable()
        }
    }

    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowPhotoCollection") {
            let nextvc = segue.destinationViewController as! PhotoCollectionVC
            nextvc.subcatgoryInfo = (category, subcategories![(tableView.indexPathForSelectedRow?.row)!].name)
            nextvc.combinationIndex = combinationIndex
            
        } else if (segue.identifier == "AddNewSubCategory") {
            let nextvc = segue.destinationViewController as! NewSubCategoryVC
            nextvc.category = category
        }

    }
}

