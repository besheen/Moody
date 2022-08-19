//
//  Continent.swift
//  Moody
//
//  Created by Carl on 2022/8/18.
//

import UIKit
import CoreData

final class Continent: NSManagedObject {
    @NSManaged var updatedAt: Date
    
    @NSManaged fileprivate(set) var countries: Set<Country>
    
    fileprivate(set) var iso3166Code: ISO3166.Continent {
        get {
            guard let c = ISO3166.Continent(rawValue: numericISO3166Code) else {
                fatalError("unknown continent code")
            }
            return c
        }
        set {
            numericISO3166Code = newValue.rawValue
        }
    }
    
    static func findOrCreateContinent(for isoCountry: ISO3166.Country, in context: NSManagedObjectContext) -> Continent? {
        guard let iso3166 = ISO3166.Continent(country: isoCountry) else {
            return nil
        }
        let predicate = NSPredicate(format: "%K == %d", #keyPath(numericISO3166Code), Int(iso3166.rawValue))
        let continent = findOrCreate(in: context, matching: predicate) {
            $0.iso3166Code = iso3166
            $0.updatedAt = Date()
        }
        return continent
    }
    
    @NSManaged fileprivate var numericISO3166Code: Int16
}

extension Continent: Managed {
    static var defaultSortDescription: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(updatedAt), ascending: false)]
    }
}
