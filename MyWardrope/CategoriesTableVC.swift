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
    	    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (categories == nil) {
            categories = Database.sharedInstance().getCategoriesList()
        }
        if let cats = categories {
            return cats.count
        }
        return 0
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellCaterogy")
        if let cats = categories {
            cell!.imageView?.image = cats[indexPath.row].image
            cell!.textLabel?.text = cats[indexPath.row].name
            cell!.detailTextLabel?.text = "0"
        }
        return cell!
    }
}
