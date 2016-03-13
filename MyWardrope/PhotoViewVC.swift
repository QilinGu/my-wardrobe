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

public class PhotoViewVC : UIViewController, UITextViewDelegate, UITextFieldDelegate {
    var photosToBrowse: [Photo]!
    var photoId: Int = 0
    var combination: Combination?
    var deletable = true
    
    @IBOutlet weak var addNoteBtn: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tagsTextField: UITextField!
    
    @IBAction func btnDelete(sender: AnyObject) {
        Database.sharedInstance.deletePhoto(photosToBrowse[photoId])
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnAction(sender: AnyObject) {
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [photosToBrowse[photoId].photoImage()!], applicationActivities: nil)
        navigationController?.presentViewController(activityViewController, animated: true, completion: nil)

    }
    
    @IBAction func addNote(sender: AnyObject) {
        addNoteBtn.hidden = true
        noteTextView.becomeFirstResponder()
    }
    
    public override func viewDidLoad() {
        if let _ = combination {
            navigationItem.rightBarButtonItems!.removeFirst(2)
        } else {
            navigationItem.rightBarButtonItems!.removeLast()
            if (!deletable) {
                navigationItem.rightBarButtonItems!.removeFirst()
            }
        }
        
        displayContent()
        noteTextView.delegate = self
        tagsTextField.delegate = self
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func displayContent() {
        imageView.image = photosToBrowse[photoId].photoImage()
        tagsTextField.text = photosToBrowse[photoId].tags
        if let note = photosToBrowse[photoId].note where !note.isEmpty {
            noteTextView.text = note
            addNoteBtn.hidden = true
        } else {
            noteTextView.text = nil
            addNoteBtn.hidden = false
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                if (photoId > 0) {
                    photoId--
                    displayContent()
                }
                break
            case UISwipeGestureRecognizerDirection.Left:
                if (photoId < photosToBrowse.count - 1) {
                    photoId++
                    displayContent()
                }
                break
            default:
                break
            }
        }
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        if (textField.text!.characters.count - range.length + string.characters.count > 125) {
            return false
        }
        return true
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        if (textField.text != photosToBrowse[photoId].tags) {
            Database.sharedInstance.updatePhoto(photosToBrowse[photoId], note: photosToBrowse[photoId].note, tags: textField.text)
        }
    }
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        if (textView.text.characters.count - range.length + text.characters.count > 125) {
            return false
        }
        return true
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        addNoteBtn.hidden = true
        animateTextView(textView, up: true)
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        animateTextView(textView, up: false)
        if (textView.text != photosToBrowse[photoId].note) {
            Database.sharedInstance.updatePhoto(photosToBrowse[photoId], note: textView.text, tags: photosToBrowse[photoId].tags)
        }
        if (textView.text.isEmpty) {
            addNoteBtn.hidden = false
        } else {
            addNoteBtn.hidden = true
        }
    }
    
    private func animateTextView(textView: UITextView, up: Bool)
    {
        let movementDistance = 160 // tweak as needed
        let movementDuration = 0.3 // tweak as needed
        
        let movement = (up ? -movementDistance : movementDistance);
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, CGFloat(movement));
        UIView.commitAnimations()
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AddToCombinaton") {
            combination = Database.sharedInstance.addPhotoToCombination(photosToBrowse[photoId], combination: combination!)
            let nextVC = segue.destinationViewController as! CombinationViewVC
            nextVC.combination = combination!
        }
    }
}
