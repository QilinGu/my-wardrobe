//
//  PhotoCollectionVC.swift
//  MyWardrope
//
//  Created by Minh on 17.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

typealias SubCategoryInfo = (category: String, subcategory: String)

public class PhotoCollectionVC : UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var images : [UIImage]?
    var imagePicker = UIImagePickerController()
    var subcatgoryInfo: SubCategoryInfo!
    var combinationIndex = -1
    
    public override func viewDidLoad() {
        if (combinationIndex >= 0) {
            navigationItem.rightBarButtonItem = nil
        }
        
        self.title = subcatgoryInfo.subcategory
    }
    
    public override func viewWillAppear(animated: Bool) {
        updateCollection()
    }
    
    private func updateCollection() {
        images = Database.sharedInstance.getPhotosFromCategory(subcatgoryInfo.category, subcategory: subcatgoryInfo.subcategory)
        collectionView?.reloadData()
    }
    
    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let allImages = images {
            return allImages.count
        }
        
        return 0
    }
    
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        if let _images = images {
            let imageView = cell.viewWithTag(100) as! UIImageView
            imageView.image = _images[indexPath.row]
        }
        return cell
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowPhoto") {
            let nextvc = segue.destinationViewController as! PhotoViewVC
            let index = (collectionView?.indexPathsForSelectedItems()?.first?.row)!
            nextvc.imageInfo = (subcatgoryInfo.category, subcatgoryInfo.subcategory, index,  images![index])
            nextvc.combinationIndex = combinationIndex
        }
    }
    
    @IBAction func btnCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            self.imagePicker.allowsEditing = false
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        let img = UIImageHelper.resizeImage(image, newWidth: 300)
        Database.sharedInstance.addPhotoToCategory("", subcategory: "", image: img)
        updateCollection()
    }

    
}
