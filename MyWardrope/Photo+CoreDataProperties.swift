//
//  Photo+CoreDataProperties.swift
//  MyWardrope
//
//  Created by Minh on 21.02.16.
//  Copyright © 2016 NAT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import UIKit

extension Photo {

    @NSManaged var photo: NSData
    @NSManaged var combinations: [Combination]?
    @NSManaged var subcategory: SubCategory

    func photoImage() -> UIImage? {
        return UIImage(data: photo)
    }

}
