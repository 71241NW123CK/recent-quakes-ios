//
//  UsgsEarthquake+MKAnnotation.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import MapKit

extension UsgsEarthquake: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitutde, longitude: longitude)
        }
    }
    
    var title: String? {
        get {
            return "M\(magnitude)"
        }
    }
    
    var subtitle: String? {
        get {
            return location
        }
    }
    
    var displayColor: UIColor {
        if magnitude < 4 {
            return UIColor.blue
        } else if magnitude < 5 {
            return UIColor.yellow
        } else if magnitude < 6 {
            return UIColor.orange
        } else {
            return UIColor.red
        }
    }
}
