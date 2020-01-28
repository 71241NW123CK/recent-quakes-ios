//
//  UsgsEarthquakeAnnotationView.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import MapKit

class UsgsEarthquakeAnnotationView: MKMarkerAnnotationView {
    static let reuseIdentifier = "UsgsEarthquake"
    static let clusteringIdentifier = "UsgsEarthquake"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = UsgsEarthquakeAnnotationView.clusteringIdentifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let usgsEarthquake = annotation as? UsgsEarthquake else {
            return
        }
        markerTintColor = usgsEarthquake.displayColor
        if usgsEarthquake.magnitude < 4 {
            displayPriority = .defaultLow
        } else if usgsEarthquake.magnitude < 5 {
            displayPriority = .defaultHigh
        } else {
            displayPriority = .required
        }
    }
}
