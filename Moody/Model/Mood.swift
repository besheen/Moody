//
//  Mood.swift
//  Moody
//
//  Created by Carl on 2022/8/11.
//

import CoreData
import UIKit
import CoreLocation

final class Mood: NSManagedObject {
    /// @NSManaged 表示属性将由 core data 来实现
    /// fileprivate(set) 表示属性公开制度
    @NSManaged fileprivate(set) var date: Date
    @NSManaged fileprivate(set) var imageData: Data
    
    @NSManaged fileprivate var latitude: NSNumber?
    @NSManaged fileprivate var longitude: NSNumber?
    
    @NSManaged public fileprivate(set) var country: Country

    public var location: CLLocation? {
        guard let lat = latitude, let lon = longitude else {
            return nil
        }
        return CLLocation(latitude: lat.doubleValue, longitude: lon.doubleValue)
    }
    
    static func inset(into context: NSManagedObjectContext, image: UIImage, location: CLLocation?, placemark: CLPlacemark?) -> Mood {
        let mood: Mood = context.insertObject()
        mood.date = Date()
        mood.imageData = image.jpegData(compressionQuality: 1)!
        if let coord = location?.coordinate {
            mood.latitude = NSNumber(value: coord.latitude)
            mood.longitude = NSNumber(value: coord.longitude)
        }
        let isoCode = placemark?.isoCountryCode ?? ""
        let isoCountry = ISO3166.Country.fromISO3166(isoCode)
        mood.country = Country.findOrCreate(for: isoCountry, in: context)
        return mood
    }
}

extension Mood: Managed {
    static var defaultSortDescription: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: false)]
    }
}
