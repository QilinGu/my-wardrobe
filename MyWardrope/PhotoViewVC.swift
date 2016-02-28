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

public class PhotoViewVC : UIViewController, UITextViewDelegate {
    var photo: Photo!
    var combination: Combination?
    var deletable = true
    
    @IBOutlet weak var addNoteBtn: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func btnDelete(sender: AnyObject) {
        Database.sharedInstance.deletePhoto(photo)
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addNote(sender: AnyObject) {
        addNoteBtn.hidden = true
        noteTextView.becomeFirstResponder()
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
        if let note = photo.note {
            noteTextView.text = note
            addNoteBtn.hidden = true
        } else {
            addNoteBtn.hidden = false
        }
        
        noteTextView.delegate = self
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
        animateTextView(textView, up: true)
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        animateTextView(textView, up: false)
        if (textView.text != photo.note) {
            Database.sharedInstance.updatePhotoWithNote(photo, note: textView.text)
        }
        if (textView.text.isEmpty) {
            addNoteBtn.hidden = false
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
            combination = Database.sharedInstance.addPhotoToCombination(photo, combination: combination!)
            let nextVC = segue.destinationViewController as! CombinationViewVC
            nextVC.combination = combination!
        }
    }
}
