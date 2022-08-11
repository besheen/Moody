//
//  Managed.swift
//  Moody
//
//  Created by Carl on 2022/8/11.
//

import Foundation
import CoreData

protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescription: [NSSortDescriptor] { get }
}

extension Managed {
    static var defaultSortDescription: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescription
        return request
    }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String {
        return entity().name!
    }
}
