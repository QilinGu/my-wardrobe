//
//  PhotoViewVC.swift
//  MyWardrope
//
//  Created by Minh on 17.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit
import CoreData

typealias PhotoInfo = (category: String, subcategory: String, imageIndex: Int, image: UIImage)

public class PhotoViewVC : UIViewController {
    var photo: Photo!
    var combination: Combination?
    var deletable = true
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func btnDelete(sender: AnyObject) {
        Database.sharedInstance.deletePhoto(photo)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    public override func viewDidLoad() {
        if let _ = combination {
            navigationItem.rightBarButtonItems!.removeFirst()
        } else {
            navigationItem.rightBarButtonItems!.removeLast()
            if (!deletable) {
                navigationItem.rightBarButtonItems!.removeFirst()
            }
        }
        
        imageView.image = photo.photoImage()
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AddToCombinaton") {
            combination = Database.sharedInstance.addPhotoToCombination(photo, combination: combination!)
            let nextVC = segue.destinationViewController as! CombinationViewVC
            nextVC.combination = combination!
        }
    }
}
