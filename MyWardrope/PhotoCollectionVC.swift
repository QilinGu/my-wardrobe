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
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPhotos = [Photo]()
    var addedSearchBar = false
    
    public override func viewDidLoad() {
        if let _ = combination {
            navigationItem.rightBarButtonItem = nil
        }
        
        self.title = subcategory.translatedName()
//        collectionView?.backgroundView = UIImageView(image: UIImage(named: "Background"))
        
//        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.placeholder = NSLocalizedString("Search by tag", comment: "")
        definesPresentationContext = true
    }
    
    public override func viewWillAppear(animated: Bool) {
        updateCollection()
    }
    
    private func updateCollection() {
        collectionView?.reloadSections(NSIndexSet(index: 1))
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if let allphotos = subcategory.photos {
            filteredPhotos = allphotos.filter { photo in
                if let tag = photo.tags {
                    return tag.lowercaseString.containsString(searchText.lowercaseString)
                }
                return false
            }
            
            updateCollection()
        }
        
    }
    
    public override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (section == 0) {
            return CGSizeMake(self.view.frame.width, 60)
        }
        return CGSizeMake(self.view.frame.width, 0)
    }
    
    override public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
            if (indexPath.section == 0) {
                if (!addedSearchBar) {
                    headerView.addSubview(searchController.searchBar)
                    searchController.searchBar.sizeToFit()
                    addedSearchBar = true
                }
                
            }
            
            return headerView
        }
        
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
    
    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 1) {
            if searchController.active && searchController.searchBar.text != "" {
                return filteredPhotos.count
            }
            if let allImages = subcategory.photos {
                return allImages.count
            }
        }
        
        return 0
    }
    
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        
        if let allphotos = subcategory.photos {
            let photo: Photo
            if searchController.active && searchController.searchBar.text != "" {
                photo = filteredPhotos[indexPath.row]
            } else {
                photo = allphotos[indexPath.row]
            }
            let imageView = cell.viewWithTag(100) as! UIImageView
            imageView.image = photo.photoImage()
        }
        return cell
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowPhoto") {
            let nextvc = segue.destinationViewController as! PhotoViewVC
            let index = (collectionView?.indexPathsForSelectedItems()?.first?.row)!
            if searchController.active && searchController.searchBar.text != "" {
                nextvc.photosToBrowse = filteredPhotos
            } else {
                nextvc.photosToBrowse = subcategory.photos!
            }
            nextvc.photoId = index
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

extension PhotoCollectionVC: UISearchResultsUpdating {
    public func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

//extension PhotoCollectionVC: UISearchControllerDelegate {
//    public func didPresentSearchController(searchController: UISearchController) {
//        searchController.searchBar.showsCancelButton = false
//    }
//}
