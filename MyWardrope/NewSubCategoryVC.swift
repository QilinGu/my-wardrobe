//
//  NewSubCategoryVC.swift
//  MyWardrope
//
//  Created by Minh on 15.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

public class NewSubCategoryVC : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var categoryNameTxtField: UITextField!
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!

    var imagePicker = UIImagePickerController()
    var category: Category!
    var subCaterogy: SubCategory?
    var selectedIcon: UIImage? = nil
    
    public override func viewDidLoad() {
        if let subcat = subCaterogy {
            title = NSLocalizedString("Edit sub category", comment:"")
            categoryNameTxtField.text = subcat.name
            if let icon = subcat.iconImage() {
                iconBtn.setImage(icon, forState: .Normal)
            }
            saveBarButton.enabled = true
        } else {
            title = NSLocalizedString("New sub category", comment:"")
            saveBarButton.enabled = false
        }
        categoryNameTxtField.delegate = MyTextFieldDelegate.sharedInstance
    }
    
    @IBAction func editCategoryName(sender: AnyObject) {
        if let textEntered = categoryNameTxtField.text where !textEntered.isEmpty {
            saveBarButton.enabled = true
        } else {
            saveBarButton.enabled = false
        }

    }
    
    @IBAction func addImage(sender: AnyObject) {
        let optionMenu = UIAlertController(title: NSLocalizedString("Add icon to sub category", comment: ""), message: nil, preferredStyle: .ActionSheet)
        
        let takeAPhoto = UIAlertAction(title: NSLocalizedString("Take a photo", comment: ""), style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                self.imagePicker.allowsEditing = false
                
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
            
        })
        let chooseAPhoto = UIAlertAction(title: NSLocalizedString("Choose from photo library", comment: ""), style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
                self.imagePicker.allowsEditing = false
                
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
            
        })
        let dismissAction = UIAlertAction(title:NSLocalizedString("Dismiss", comment: ""), style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(takeAPhoto)
        optionMenu.addAction(chooseAPhoto)
        optionMenu.addAction(dismissAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(false, completion: { () -> Void in
            self.selectedIcon = image
            self.iconBtn.setImage(image, forState: .Normal)
        })
    }
    
    @IBAction func onSave(sender: AnyObject) {
        if let subcat = subCaterogy {
            Database.sharedInstance.updateSubCategory(subcat, name: categoryNameTxtField.text!, icon: selectedIcon)
        } else {
            Database.sharedInstance.addNewSubCategory(category, name:  categoryNameTxtField.text!, icon: selectedIcon)
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
}
