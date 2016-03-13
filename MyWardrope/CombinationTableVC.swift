//
//  CombinationTableVC.swift
//  MyWardrope
//
//  Created by Minh on 17.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

public class CombinationTableVC : UITableViewController {
    
    var combinations: [Combination]?
    
    private func updateTable() {
        combinations = Database.sharedInstance.getCombinations()
        tableView.reloadData()
    }
    
    public override func viewWillAppear(animated: Bool) {
        Database.sharedInstance.removeEmptyCombinations()
        updateTable()
    }
    
    public override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextId = combinations != nil ? combinations!.count : 0
        if (segue.identifier == "CreateCollection") {
            let nextvc = segue.destinationViewController as! CategoriesTableVC
            nextvc.combination = Database.sharedInstance.addNewCombination(nextId)
            
        } else if (segue.identifier == "ShowCollection") {
            let nextvc = segue.destinationViewController as! CombinationViewVC
            let index = (tableView.indexPathForSelectedRow?.row)!
            nextvc.combination = combinations![index]
        }
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _combinations = combinations {
            return _combinations.count
        }
        return 0
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CombinationCell", forIndexPath: indexPath)
        
        if let _combinations = combinations, let _photos = _combinations[indexPath.row].photos {
            let count = _photos.count <= 6 ? _photos.count : 6
            for (var i = 0; i < count; i++) {
                let imgView = cell.viewWithTag(100 + i) as! UIImageView
                imgView.image = _photos[i].photoImage()
            }
            if (count < 6) {
                for (var i = count; i < 6; i++) {
                    let imgView = cell.viewWithTag(100 + i) as! UIImageView
                    imgView.image = nil
                }
            }
        }
        
        return cell
    }
    
    public override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            Database.sharedInstance.deleteCombination(combinations![indexPath.row])
            updateTable()
        }
    }
}
