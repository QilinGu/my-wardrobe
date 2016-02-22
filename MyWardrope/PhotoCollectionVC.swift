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
    var imagePicker = UIImagePickerController()
    var subcategory: SubCategory!
    var combination: Combination?
    
    public override func viewDidLoad() {
        if let _ = combination {
            navigationItem.rightBarButtonItem = nil
        }
        
        self.title = subcategory.name
    }
    
    public override func viewWillAppear(animated: Bool) {
        updateCollection()
    }
    
    private func updateCollection() {
        collectionView?.reloadData()
    }
    
    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let allImages = subcategory.photos {
            return allImages.count
        }
        
        return 0
    }
    
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        if let _images = subcategory.photos {
            let imageView = cell.viewWithTag(100) as! UIImageView
            imageView.image = _images[indexPath.row].photoImage()
        }
        return cell
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowPhoto") {
            let nextvc = segue.destinationViewController as! PhotoViewVC
            let index = (collectionView?.indexPathsForSelectedItems()?.first?.row)!
            nextvc.photo = subcategory.photos![index]
            nextvc.combination = combination
        }
    }
    
    @IBAction func btnPhotoLibrary(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            self.imagePicker.allowsEditing = false
        
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
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
        
        Database.sharedInstance.addPhotoToSubCategory(subcategory, photo: image)
        updateCollection()
    }

    
}
