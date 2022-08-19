//
//  Region.swift
//  Moody
//
//  Created by Carl on 2022/8/18.
//

import UIKit
import CoreData

final class Region: NSManagedObject {}

extension Region: Managed {
    static var defaultSortDescription: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "updatedAt", ascending: false)]
    }
}
