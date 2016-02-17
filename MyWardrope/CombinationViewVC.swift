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
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combinationInfo.images.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath)
        let imgView = cell.viewWithTag(100) as! UIImageView
        imgView.image = combinationInfo.images[indexPath.row]
        return cell
    }
}
