//
//  CategoriesTableVC.swift
//  MyWardrope
//
//  Created by Minh on 13.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

public class CategoriesTableVC : UITableViewController {
    var categories: [Category]?
    var combination: Combination?
    
    public override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        if let _ = combination {
            navigationItem.rightBarButtonItem = nil
        }
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
    }
    
    public override func viewWillAppear(animated: Bool) {
        categories = Database.sharedInstance.getCategoriesList()
        updateTable()
    }
    
    private func updateTable() {
        tableView.reloadData()
    }
    	    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cats = categories {
            return cats.count
        }
        return 0
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellCaterogy", forIndexPath: indexPath)
        if let cats = categories {
            cell.imageView?.image = cats[indexPath.row].iconImage()
            let itemSize = CGSizeMake(32, 32);
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.mainScreen().scale);
            let imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            cell.imageView!.image?.drawInRect(imageRect);
            cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            cell.textLabel?.text = cats[indexPath.row].name
            if let subcats = cats[indexPath.row].subcategories {
                var sum = 0
                for subcat in subcats {
                    if let photos = subcat.photos {
                        sum += photos.count
                    }
                }
                cell.detailTextLabel?.text = String(sum)
            } else {
                cell.detailTextLabel?.text = "0"
            }
            
        }
        return cell
    }
    
    public override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .Normal, title: NSLocalizedString("Edit", comment: "")) { action, index in
            self.performSegueWithIdentifier("AddNewCategory", sender: indexPath)
        }
        edit.backgroundColor = AppGreenColor
        
        let delete = UITableViewRowAction(style: .Normal, title: NSLocalizedString("Delete", comment: "")) { action, index in
            Database.sharedInstance.deleteCategory(self.categories![indexPath.row])
            self.categories!.removeAtIndex(indexPath.row)
            self.updateTable()
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, edit]
    }
    
    public override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowSubCategory") {
            let nextvc = segue.destinationViewController as! SubCategoryTableVC
            nextvc.category = categories![(tableView.indexPathForSelectedRow?.row)!]
            nextvc.combination = combination
            
        } else if (segue.identifier == "AddNewCategory" && sender is NSIndexPath) {
            if let row = sender?.row {
                let nextvc = segue.destinationViewController as! NewCategoryVC
                nextvc.caterogy = categories![row]
            }
        }
    }
}
