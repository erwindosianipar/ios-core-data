//
//  Todo+CoreDataProperties.swift
//  ios-core-data
//
//  Created by Erwindo Sianipar on 10/26/22.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var name: String?

}

extension Todo : Identifiable {

}
