//
//  SubCategoryTableVC.swift
//  MyWardrope
//
//  Created by Minh on 15.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

public class SubCategoryTableVC : UITableViewController {
    var category: Category!
    var combination: Combination?
    
    public override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        if let _ = combination {
            navigationItem.rightBarButtonItem = nil
        }

        self.title = category.name
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
    }
    
    public override func viewWillAppear(animated: Bool) {
        updateTable()
    }
    
    private func updateTable() {
        tableView.reloadData()
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cats = category.subcategories {
            return cats.count
        }
        return 0
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellSubCaterogy", forIndexPath: indexPath)
        if let cats = category.subcategories {
            cell.imageView?.image = cats[indexPath.row].iconImage()
            let itemSize = CGSizeMake(32, 32);
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.mainScreen().scale);
            let imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            cell.imageView!.image?.drawInRect(imageRect);
            cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            cell.textLabel?.text = cats[indexPath.row].name
            
            if let photos = cats[indexPath.row].photos {
                cell.detailTextLabel?.text = String(photos.count)
            } else {
                cell.detailTextLabel?.text = "0"
            }
        }
        return cell
    }
    
    public override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .Normal, title: NSLocalizedString("Edit", comment: "")) { action, index in
            self.performSegueWithIdentifier("AddNewSubCategory", sender: indexPath)
        }
        edit.backgroundColor = AppGreenColor
        
        let delete = UITableViewRowAction(style: .Normal, title: NSLocalizedString("Delete", comment: "")) { action, index in
            Database.sharedInstance.deleteSubCategory(self.category.subcategories![indexPath.row])
//            self.categories!.removeAtIndex(indexPath.row)
            self.updateTable()
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, edit]
    }
    
    public override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            Database.sharedInstance.deleteSubCategory(category.subcategories![indexPath.row])
            updateTable()
        }
    }

    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowPhotoCollection") {
            let nextvc = segue.destinationViewController as! PhotoCollectionVC
            nextvc.subcategory = category.subcategories![(tableView.indexPathForSelectedRow?.row)!]
            nextvc.combination = combination
            
        } else if (segue.identifier == "AddNewSubCategory") {
            let nextvc = segue.destinationViewController as! NewSubCategoryVC
            nextvc.category = category
            if let row = (sender as? NSIndexPath)?.row {
                nextvc.subCaterogy = category.subcategories![row]
            }
        }

    }
}

