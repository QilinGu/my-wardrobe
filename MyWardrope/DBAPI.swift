//
//  DBAPI.swift
//  MyWardrope
//
//  Created by Minh on 13.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import UIKit
import CoreData

//public typealias Category = (name: String, image: UIImage?)

protocol DBAPI {
    func getCategoriesList() -> [Category]?
    func getSubCategoriesList(category: Category) -> [SubCategory]?
    func getPhotosFromSubCategory(subcategory: SubCategory) -> [Photo]?
    func getCombinations() -> [Combination]?
    
    func addNewCategory(name: String, icon: UIImage?) -> Category?
    func addNewSubCategory(category: Category, name: String, icon: UIImage?) -> SubCategory?
    func addNewCombination(id: Int) -> Combination?
    func addPhotoToCombination(photo: Photo, combination: Combination) -> Combination
    func addPhotoToSubCategory(subcategory: SubCategory, photo: UIImage) -> Photo?
    
    func deleteCategory(category: Category)
    func deleteSubCategory(subcategory: SubCategory)
    func deletePhoto(photo: Photo)
    func deleteCombination(combination: Combination)
    func deletePhotoFromCombination(photo: Photo, combination: Combination) -> Combination
    
    func removeEmptyCombinations()
    func updatePhotoWithNote(photo: Photo, note: String)
}

public class Database {
    static let sharedInstance = MyCoreData() //MockedDB()
    
    static public func populateDB() {
        let clothes = sharedInstance.addNewCategory("Clothes", icon: UIImage(named: "Clothes"))!
        let shoes = sharedInstance.addNewCategory("Shoes", icon: UIImage(named: "Shoes"))!
        let accessories = sharedInstance.addNewCategory("Accessories", icon: UIImage(named: "Accessories"))!
        let jewelry = sharedInstance.addNewCategory("Jewelry", icon: UIImage(named: "Jewelry"))!

        // clothes
        sharedInstance.addNewSubCategory(clothes, name: "Dress", icon: UIImage(named: "Dress"))
        sharedInstance.addNewSubCategory(clothes, name: "Skirt", icon: UIImage(named: "Skirt"))
        sharedInstance.addNewSubCategory(clothes, name: "Pants", icon: UIImage(named: "Pants"))
        let jean = sharedInstance.addNewSubCategory(clothes, name: "Jeans", icon: UIImage(named: "Jeans"))
        sharedInstance.addNewSubCategory(clothes, name: "Leggings", icon: UIImage(named: "Leggings"))
        let tshirt = sharedInstance.addNewSubCategory(clothes, name: "Tshirt", icon: UIImage(named: "Tshirt"))
        sharedInstance.addNewSubCategory(clothes, name: "Blouse", icon: UIImage(named: "Blouse"))
        sharedInstance.addNewSubCategory(clothes, name: "Pullover", icon: UIImage(named: "Pullover"))
        sharedInstance.addNewSubCategory(clothes, name: "Cardigan", icon: UIImage(named: "Cardigan"))
        sharedInstance.addNewSubCategory(clothes, name: "Jacket", icon: UIImage(named: "Jacket"))
        
        // shoes
        let highheels = sharedInstance.addNewSubCategory(shoes, name: "High heels", icon: UIImage(named: "HighHeels"))
        sharedInstance.addNewSubCategory(shoes, name: "Flat shoes", icon: UIImage(named: "FlatShoes"))
        sharedInstance.addNewSubCategory(shoes, name: "Sneakers", icon: UIImage(named: "Sneakers"))
        sharedInstance.addNewSubCategory(shoes, name: "Boots", icon: UIImage(named: "Boots"))
        
        // jewelry
        sharedInstance.addNewSubCategory(jewelry, name: "Ring", icon: UIImage(named: "Ring"))
        sharedInstance.addNewSubCategory(jewelry, name: "Earrings", icon: UIImage(named: "Earrings"))
        sharedInstance.addNewSubCategory(jewelry, name: "Bracelet", icon: UIImage(named: "Bracelet"))
        sharedInstance.addNewSubCategory(jewelry, name: "Necklace", icon: UIImage(named: "Necklace"))
        sharedInstance.addNewSubCategory(jewelry, name: "Watch", icon: UIImage(named: "Watch"))
        
        // accessories
        sharedInstance.addNewSubCategory(accessories, name: "Belt", icon: UIImage(named: "Belt"))
        sharedInstance.addNewSubCategory(accessories, name: "Bag", icon: UIImage(named: "Bag"))
        sharedInstance.addNewSubCategory(accessories, name: "Purse", icon: UIImage(named: "Purse"))
        sharedInstance.addNewSubCategory(accessories, name: "Scarf", icon: UIImage(named: "Scarf"))
        sharedInstance.addNewSubCategory(accessories, name: "Gants", icon: UIImage(named: "Gants"))
        sharedInstance.addNewSubCategory(accessories, name: "Hat", icon: UIImage(named: "Hat"))
        
        
        let tshirtPhoto = sharedInstance.addPhotoToSubCategory(tshirt!, photo: UIImage(named: "tshirt1")!)
        let jeanPhoto = sharedInstance.addPhotoToSubCategory(jean!, photo: UIImage(named: "Jean1")!)
        let shoesPhoto = sharedInstance.addPhotoToSubCategory(highheels!, photo: UIImage(named: "shoes1")!)
        
        let combi0 = sharedInstance.addNewCombination(0)
        sharedInstance.addPhotoToCombination(tshirtPhoto!, combination: combi0!)
        sharedInstance.addPhotoToCombination(jeanPhoto!, combination: combi0!)
        sharedInstance.addPhotoToCombination(shoesPhoto!, combination: combi0!)

    }
}