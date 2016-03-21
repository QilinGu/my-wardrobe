//
//  NewCategoryVC.swift
//  MyWardrope
//
//  Created by Nguyen Anh Thu on 15/02/16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

public class NewCategoryVC : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var categoryNameTxtField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!

    var imagePicker = UIImagePickerController()
    var caterogy: Category?
    var selectedIcon: UIImage? = nil
    
    public override func viewDidLoad() {
        if let cat = caterogy {
            title = NSLocalizedString("Edit category", comment:"")
            categoryNameTxtField.text = cat.translatedName()
            if let icon = cat.iconImage() {
                iconBtn.setImage(icon, forState: .Normal)
            }
            saveBarButton.enabled = true
        } else {
            title = NSLocalizedString("New category", comment:"")
            saveBarButton.enabled = false
        }
        categoryNameTxtField.delegate = MyTextFieldDelegate.sharedInstance
    }
    
    @IBAction func editCategoryName(sender: UITextField) {
        if let textEntered = categoryNameTxtField.text where !textEntered.isEmpty {
            saveBarButton.enabled = true
        } else {
            saveBarButton.enabled = false
        }
    }
    
    @IBAction func onSave(sender: AnyObject) {
        if let cat = caterogy {
            Database.sharedInstance.updateCategory(cat, name: categoryNameTxtField.text!, icon: self.selectedIcon)
        } else {
            Database.sharedInstance.addNewCategory(categoryNameTxtField.text!, icon: self.selectedIcon)
        }
        
        navigationController?.popViewControllerAnimated(true)

    }
    
    @IBAction func addImage(sender: AnyObject) {
        let optionMenu = UIAlertController(title: NSLocalizedString("Add icon to category", comment: ""), message: nil, preferredStyle: .ActionSheet)
        
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
    
}
