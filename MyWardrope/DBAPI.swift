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
    func getCategoriesList() -> [Category]
    func getSubCategoriesList() -> [Category]
    func addNewCategory(name: String, image: UIImage?)
    func addNewSubCategory(category: String, name: String, image: UIImage?)
}

public class Database {
    static let mockedDB = MockedDB()
    public static func sharedInstance() -> DBAPI {
        return mockedDB
    }
}

public class MockedDB : DBAPI {
    var cats = [Category]()
    var subcats = [Category]()

    public init() {
        cats.append(("Dress", UIImage(named: "Dress")))
        cats.append(("Skirt", UIImage(named: "Skirt")))
        cats.append(("Jean", nil))
        cats.append(("T-shirt", nil))
        cats.append(("Blouse", nil))
        cats.append(("Cardigan", nil))
        cats.append(("Jacket", nil))
        cats.append(("Shoes", nil))
        cats.append(("Boots", nil))
        cats.append(("Jewelry", nil))
        subcats.append(("Earring", nil))
        subcats.append(("Necklace", nil))
        subcats.append(("Bracelet", nil))
    }
    
    public func getCategoriesList() -> [Category] {
        return cats
    }
    
    public func getSubCategoriesList() -> [Category] {
        return subcats
    }

    
    public func addNewCategory(name: String, image: UIImage?) -> () {
        cats.append((name, image))
    }
    
    public func addNewSubCategory(category: String, name: String, image: UIImage?) {
        subcats.append((name, image))
    }
}
