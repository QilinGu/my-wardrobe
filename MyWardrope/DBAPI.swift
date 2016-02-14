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
}

public class Database {
    public static func sharedInstance() -> DBAPI {
        return MockedDB()
    }
}

public class MockedDB : DBAPI {
    public func getCategoriesList() -> [Category] {
        var cats = [Category]()
        cats.append(("Dress", UIImage(named: "Dress")))
        cats.append(("Skirt", UIImage(named: "Skirt")))
        cats.append(("Jean", nil))
        cats.append(("T-shirt", nil))
        cats.append(("Blouse", nil))
        cats.append(("Cardigan", nil))
        cats.append(("Jacket", nil))
        cats.append(("Shoes", nil))
        cats.append(("Boots", nil))
        cats.append(("Earring", nil))
        cats.append(("Necklace", nil))
        cats.append(("Bracelet", nil))
        
        return cats
    }
}
