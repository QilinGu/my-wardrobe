//
//  DBAPI.swift
//  MyWardrope
//
//  Created by Minh on 13.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit

public typealias Category = (name: String, image: UIImage?)

public protocol DBAPI {
    func getCategoriesList() -> [Category]?
    func getSubCategoriesList(category: String) -> [Category]?
    func getPhotosFromCategory(category: String, subcategory: String) -> [UIImage]?
    func getCombinations() -> [[UIImage]]?
    func getNbCombinations() -> Int
    
    func addNewCategory(name: String, image: UIImage?)
    func addNewSubCategory(category: String, name: String, image: UIImage?)
    func addImageToCombination(image: UIImage, combinationIndex: Int)
    func addPhotoToCategory(category: String, subcategory: String, image: UIImage)
    
    func deleteCategory(index: Int)
    func deleteSubCategory(category: String, indexOfSubcategory: Int)
    func deletePhotoFromCategory(category: String, subcategory: String, imageIndex: Int)
}

public class Database {
    static let sharedInstance = MockedDB()
}

public class MockedDB : DBAPI {
    var cats = [Category]()
    var subcats = [String: [Category]]()
    var images = [UIImage]()
    var combinations = [[UIImage]]()

    public init() {
        cats.append(("Clothes", UIImage(named: "Clothes")))
        cats.append(("Shoes", UIImage(named: "Shoes")))
        cats.append(("Accessories", UIImage(named: "Accessories")))
        cats.append(("Jewelry", UIImage(named: "Jewelry")))
        
        subcats["Clothes"] = [("Dress", UIImage(named: "Dress")),
            ("Skirt", UIImage(named: "Skirt")),
            ("Jeans", UIImage(named: "Jeans")),
            ("T-shirt", UIImage(named: "Tshirt")),
            ("Blouse", UIImage(named: "Blouse")),
            ("Cardigan", UIImage(named: "Cardigan")),
            ("Jacket", UIImage(named: "Jacket"))]
        subcats["Shoes"] = [("High heels", UIImage(named: "HighHeels")),
            ("Boots", UIImage(named: "Boots"))]
        subcats["Jewelry"] = [("Earring", UIImage(named: "Earrings")),
            ("Necklace", UIImage(named: "Necklace")),
            ("Bracelet", UIImage(named: "Bracelet"))]
        
        combinations.append([UIImage(named: "Skirt")!, UIImage(named: "Jeans")!, UIImage(named: "Tshirt")!])
        combinations.append([UIImage(named: "Blouse")!, UIImage(named: "Cardigan")!, UIImage(named: "Jacket")!, UIImage(named: "HighHeels")!, UIImage(named: "Earrings")!, UIImage(named: "Necklace")!, UIImage(named: "Bracelet")!])
        
    }
    
    public func getCategoriesList() -> [Category]? {
        return cats
    }
    
    public func getSubCategoriesList(category: String) -> [Category]? {
        return subcats[category]
    }

    
    public func addNewCategory(name: String, image: UIImage?) -> () {
        cats.append((name, image))
    }
    
    public func addNewSubCategory(category: String, name: String, image: UIImage?) {
        var subcategory = subcats[category]
        if (subcategory == nil) {
            subcategory = [Category]()
        }
        subcategory!.append((name, image))
        subcats[category] = subcategory
    }
    
    public func addPhotoToCategory(category: String, subcategory: String, image: UIImage) {
        images.append(image)
    }
    
    public func getPhotosFromCategory(category: String, subcategory: String) -> [UIImage]? {
        return images
    }
    
    public func deletePhotoFromCategory(category: String, subcategory: String, imageIndex: Int) {
        images.removeAtIndex(imageIndex)
    }
    
    public func deleteCategory(index: Int) {
        cats.removeAtIndex(index)
    }
    
    public func deleteSubCategory(category: String, indexOfSubcategory: Int) {
        var subcategory = subcats[category]
        if (subcategory != nil) {
            subcategory!.removeAtIndex(indexOfSubcategory)
            subcats[category] = subcategory
        }

    }
    
    public func getCombinations() -> [[UIImage]]? {
        return combinations
    }
    
    public func addImageToCombination(image: UIImage, combinationIndex: Int) {
        if (combinations.count == combinationIndex) {
            combinations.append([image])
        } else {
            var images = combinations[combinationIndex]
            images.append(image)            
        }
    }
    
    public func getNbCombinations() -> Int {
        return combinations.count
    }
}
