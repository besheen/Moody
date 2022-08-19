//
//  GeoLocationHelper.swift
//  Moody
//
//  Created by Carl on 2022/8/19.
//

import Foundation
import CoreLocation

@objc protocol GeoLocationDelegate {
    func geoLocationDidChangeAuthorizationStatus(authorized: Bool)
}

class GeoLocationHelper: NSObject {
    var isAuthorized: Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    required init(delegate: GeoLocationDelegate) {
        super.init()
    }
}
