//
//  CombinationViewVC.swift
//  MyWardrope
//
//  Created by Minh on 17.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

public class CombinationViewVC : UITableViewController {
    var combination : Combination!
    
//    public override func viewDidLoad() {
//        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
//    }
    
    private func updateScreen() {
        tableView.reloadData()
        if (combination.photos == nil) || (combination.photos != nil && combination.photos!.count == 0) {
            navigationItem.rightBarButtonItems!.removeLast()
        }
    }
    
    @IBAction func btnAllCombination(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func btnAction(sender: AnyObject) {
        var photos = [UIImage]()
        for dbPhoto in combination.photos! {
            if let photo = dbPhoto.photoImage() {
                photos.append(photo)
            }
        }
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: photos, applicationActivities: nil)
        navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let photos = combination.photos {
            return photos.count
        }
        return 0
    }
    
    public override func viewWillAppear(animated: Bool) {
        if (combination.photos == nil) || (combination.photos != nil && combination.photos!.count == 0) {
            navigationItem.rightBarButtonItems!.removeLast()
        }
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
            updateScreen()
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AddToCollection") {
            let nextvc = segue.destinationViewController as! CategoriesTableVC
            nextvc.combination = combination
        } else if (segue.identifier == "ShowPhoto") {
            let nextvc = segue.destinationViewController as! PhotoViewVC
//            nextvc.photo = combination.photos![(tableView.indexPathForSelectedRow?.row)!]
            nextvc.photosToBrowse = combination.photos!
            nextvc.photoId = tableView.indexPathForSelectedRow!.row
            nextvc.deletable = false
        }
    }
}
