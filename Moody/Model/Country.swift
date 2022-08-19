//
//  Country.swift
//  Moody
//
//  Created by Carl on 2022/8/18.
//

import UIKit
import CoreData

final class Country: NSManagedObject {
    @NSManaged var updatedAt: Date
    
    @NSManaged fileprivate(set) var moods: Set<Mood>
    @NSManaged fileprivate(set) var continent: Continent?
    
    fileprivate(set) var iso3166Code: ISO3166.Country {
        get {
            guard let c = ISO3166.Country(rawValue: numericISO3166Code) else {
                fatalError("Unknown country code")
            }
            return c
        }
        
        set {
            numericISO3166Code = newValue.rawValue
        }
    }
    
    static func findOrCreate(for isoCountry: ISO3166.Country, in context: NSManagedObjectContext) -> Country {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(numericISO3166Code), Int(isoCountry.rawValue))
        let country = findOrCreate(in: context, matching: predicate) {
            $0.iso3166Code = isoCountry
            $0.updatedAt = Date()
            $0.continent = Continent.findOrCreateContinent(for: isoCountry, in: context)
        }
        return country
    }
    
    @NSManaged fileprivate var numericISO3166Code: Int16
}

extension Country: Managed {
    static var defaultSortDescription: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(updatedAt), ascending: false)]
    }
}
