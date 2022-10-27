//
//  Todo+CoreDataProperties.swift
//  ios-core-data
//
//  Created by Erwindo Sianipar on 10/27/22.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: String?

}

extension Todo : Identifiable {

}
