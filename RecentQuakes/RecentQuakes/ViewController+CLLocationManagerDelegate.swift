//
//  ViewController+CLLocationManagerDelegate.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import MapKit

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if !hasGottenFirstLocation {
                let locationMapPoint = MKMapPoint(location.coordinate)
                let origin = MKMapPoint(
                    x: locationMapPoint.x - 0.5 * ViewController.startingMapSize.width,
                    y: locationMapPoint.y - 0.5 * ViewController.startingMapSize.height
                )
                let mapRect = MKMapRect(origin: origin, size: ViewController.startingMapSize)
                mapView.setVisibleMapRect(mapRect, animated: true)
                hasGottenFirstLocation = true
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // no-op
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            fallthrough
        case .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
}
