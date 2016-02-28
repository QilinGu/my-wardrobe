//
//  MyCoreData.swift
//  MyWardrope
//
//  Created by Minh on 20.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import CoreData
import UIKit

class MyCoreData : DBAPI {
    
    func addNewCategory (name: String, icon: UIImage?) -> Category? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Category",
            inManagedObjectContext:managedContext)
        let object = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        object.setValue(name, forKey: "name")
        if let _icon = icon {
            let storedImage = UIImageHelper.resizeImage(_icon, newWidth: 64, newHeight: 64)
            object.setValue(UIImageJPEGRepresentation(storedImage, 1), forKey: "icon")
        }
        
        do {
            try managedContext.save()
            return object as? Category
        } catch let error as NSError  {
            print("Could not add new category to DB: \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func getCategoriesList() -> [Category]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            if let _results = results as? [Category] {
//                var categories = [CategoryObject]()
//                for result in _results {
//                    categories.append(CategoryObject(managedObject: result))
//                }
                return _results
            }

        } catch let error as NSError {
            print("Could not get categories \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func deleteCategory(category: Category) {
        deleteObject(category)
    }
    
    func addNewSubCategory (category: Category, name: String, icon: UIImage?) -> SubCategory? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("SubCategory",
            inManagedObjectContext:managedContext)
        let object = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        object.setValue(category, forKey: "category")
        object.setValue(name, forKey: "name")
        if let _icon = icon {
            let storedImage = UIImageHelper.resizeImage(_icon, newWidth: 64, newHeight: 64)
            object.setValue(UIImageJPEGRepresentation(storedImage, 1), forKey: "icon")
        }
        
        do {
            try managedContext.save()
            return object as? SubCategory
        } catch let error as NSError  {
            print("Could not add new sub category to DB: \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func getSubCategoriesList(category: Category) -> [SubCategory]? {
        return category.subcategories
        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        
//        let fetchRequest = NSFetchRequest(entityName: "SubCategory")
//        let predicate = NSPredicate(format: "category == %@", category.name)
//        fetchRequest.predicate = predicate
//        
//        do {
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            if let _results = results as? [NSManagedObject] {
//                var subcategories = [SubCategoryObject]()
//                for result in _results {
//                    subcategories.append(SubCategoryObject(managedObject: result))
//                }
//                return subcategories
//            }
//        } catch let error as NSError {
//            print("Could not get subcategories \(error), \(error.userInfo)")
//        }
//        
//        return nil

    }
    
    func deleteSubCategory(subcategory: SubCategory) {
        deleteObject(subcategory)
    }
    
    func getPhotosFromSubCategory(subcategory: SubCategory) -> [Photo]? {
        
        return subcategory.photos
        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        
//        let fetchRequest = NSFetchRequest(entityName: "Photo")
//        let predicate1 = NSPredicate(format: "category == %@", subcategory.category)
//        let predicate2 = NSPredicate(format: "subcategory == %@", subcategory.name)
//        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [predicate1, predicate2])
//        fetchRequest.predicate = predicate
//        
//        do {
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            if let _results = results as? [NSManagedObject] {
//                var photos = [PhotoObject]()
//                for result in _results {
//                    photos.append(PhotoObject(managedObject: result))
//                }
//                return photos
//            }
//        } catch let error as NSError {
//            print("Could not get photos for subcategory \(error), \(error.userInfo)")
//        }
//        
//        return nil
    }
    
    func addPhotoToSubCategory(subcategory: SubCategory, photo: UIImage) -> Photo? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Photo",
            inManagedObjectContext:managedContext)
        let object = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        let storedImage = UIImageHelper.resizeImage(photo, newWidth: 600)
        
//        object.setValue(subcategory.category, forKey: "category")
        object.setValue(subcategory, forKey: "subcategory")
        object.setValue(UIImageJPEGRepresentation(storedImage, 1), forKey: "photo")
        
        do {
            try managedContext.save()
            return object as? Photo
        } catch let error as NSError  {
            print("Could not add new photo to DB: \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func deletePhoto(photo: Photo) {
        deleteObject(photo)
    }
    
    func getCombinations() -> [Combination]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Combination")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results as? [Combination]
            
        } catch let error as NSError {
            print("Could not get combinations \(error), \(error.userInfo)")
        }
        
        return nil

    }
    
    func addNewCombination(id: Int) -> Combination? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Combination",
            inManagedObjectContext:managedContext)
        let object = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        object.setValue(id, forKey: "id")
        
        do {
            try managedContext.save()
            return object as? Combination
        } catch let error as NSError  {
            print("Could not add new combination to DB: \(error), \(error.userInfo)")
        }
        return nil

    }
    
    func addPhotoToCombination(photo: Photo, combination: Combination) -> Combination {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        combination.mutableOrderedSetValueForKey("photos").addObject(photo)
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not add photo to combination : \(error), \(error.userInfo)")
        }
        return combination
    }
    
    func deleteCombination(combination: Combination) {
        deleteObject(combination)
    }
    
    func deletePhotoFromCombination(photo: Photo, combination: Combination) -> Combination {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        combination.mutableOrderedSetValueForKey("photos").removeObject(photo)
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not add photo to combination : \(error), \(error.userInfo)")
        }
        
        return combination
    }

    func removeEmptyCombinations() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Combination")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            
            if let _results = results as? [Combination] {
                for result in _results {
                    if (result.photos == nil || result.photos!.count == 0) {
                        deleteCombination(result)
                    }
                }
            }
            
        } catch let error as NSError {
            print("Could not get combinations \(error), \(error.userInfo)")
        }

    }
    
    func updatePhotoWithNote(photo: Photo, note: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        photo.note = note
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not update photo's note : \(error), \(error.userInfo)")
        }

    }
    
    private func deleteObject(object: NSManagedObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        managedContext.deleteObject(object)
        appDelegate.saveContext()
    }

}
