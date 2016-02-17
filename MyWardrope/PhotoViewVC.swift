//
//  PhotoViewVC.swift
//  MyWardrope
//
//  Created by Minh on 17.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

typealias PhotoInfo = (category: String, subcategory: String, imageIndex: Int, image: UIImage)

public class PhotoViewVC : UIViewController {
    var imageInfo: PhotoInfo!
    var combinationIndex = -1
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func btnSelect(sender: AnyObject) {
        Database.sharedInstance.addImageToCombination(imageInfo.image, combinationIndex: combinationIndex)
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnDelete(sender: AnyObject) {
        Database.sharedInstance.deletePhotoFromCategory(imageInfo.category, subcategory: imageInfo.subcategory, imageIndex: imageInfo.imageIndex)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    public override func viewDidLoad() {
        if (combinationIndex >= 0) {
            navigationItem.rightBarButtonItems!.removeFirst()
        } else {
            navigationItem.rightBarButtonItems!.removeLast()
        }
        
        imageView.image = imageInfo.image
    }
}
