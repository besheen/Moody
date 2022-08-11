//
//  Mood.swift
//  Moody
//
//  Created by Carl on 2022/8/11.
//

import CoreData
import UIKit

final class Mood: NSManagedObject {
    /// @NSManaged 表示属性将由 core data 来实现
    /// fileprivate(set) 表示属性公开制度
    @NSManaged fileprivate(set) var date: Date
    @NSManaged fileprivate(set) var colors: [UIColor]
}

extension Mood: Managed {
    static var defaultSortDescription: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: false)]
    }
}
