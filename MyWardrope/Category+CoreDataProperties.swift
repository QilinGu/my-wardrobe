//
//  Category+CoreDataProperties.swift
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

extension Category {

    @NSManaged var icon: NSData?
    @NSManaged var name: String
    @NSManaged var subcategories: [SubCategory]?

    func iconImage() -> UIImage? {
        if let icondata = icon {
            return UIImage(data: icondata)
        }
        return nil
    }
    
    func translatedName() -> String {
        return NSLocalizedString(self.name, comment: "")
    }
}
