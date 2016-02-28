//
//  NewSubCategoryVC.swift
//  MyWardrope
//
//  Created by Minh on 15.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

public class NewSubCategoryVC : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var categoryNameTxtField: UITextField!
    @IBOutlet weak var iconBtn: UIButton!

    var imagePicker = UIImagePickerController()
    var category: Category!
    
    public override func viewDidLoad() {
        iconBtn.layer.cornerRadius = 2;
        iconBtn.layer.borderWidth = 1;
        iconBtn.layer.borderColor = UIColor(red: 0, green: 128/255, blue: 64/255, alpha: 1).CGColor
    }
    
    @IBAction func submitNewSubCategory(sender: AnyObject) {
        Database.sharedInstance.addNewSubCategory(category, name:  categoryNameTxtField.text!, icon: iconBtn.imageForState(.Normal))
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func editSubCatName(sender: AnyObject) {
        if let textEntered = categoryNameTxtField.text where !textEntered.isEmpty {
            submitBtn.enabled = true
        } else {
            submitBtn.enabled = false
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
            self.iconBtn.setImage(image, forState: .Normal)
        })
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)

    }
}
