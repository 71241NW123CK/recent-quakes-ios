//
//  ViewController+MKMapViewDelegate.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import MapKit

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? UsgsEarthquake else {
            return nil
        }
        return UsgsEarthquakeAnnotationView(
            annotation: annotation,
            reuseIdentifier: UsgsEarthquakeAnnotationView.reuseIdentifier
        )
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let usgsEarthquakeAnnotationView = view as? UsgsEarthquakeAnnotationView {
            guard let usgsEarthquake = usgsEarthquakeAnnotationView.annotation as? UsgsEarthquake else {
                return
            }
            let visibleRect = mapView.visibleMapRect
            if ViewController.maximumSelectionMapSize.width < visibleRect.width
                || ViewController.maximumSelectionMapSize.height < visibleRect.height {
                let mapPoint = MKMapPoint(usgsEarthquake.coordinate)
                let newVisibleRectOrigin = MKMapPoint(
                    x: mapPoint.x - 0.5 * ViewController.maximumSelectionMapSize.width,
                    y: mapPoint.y - 0.5 * ViewController.maximumSelectionMapSize.height
                )
                let newVisibleRect = MKMapRect(origin: newVisibleRectOrigin, size: ViewController.maximumSelectionMapSize)
                mapView.setVisibleMapRect(newVisibleRect, animated: true)
            } else {
                mapView.setCenter(usgsEarthquake.coordinate, animated: true)
            }
            selectedEarthquakeStripeView.backgroundColor = usgsEarthquake.displayColor
            selectedEarthquakeMagnitudeLabel.text = "M\(usgsEarthquake.magnitude)"
            selectedEarthquakeLocationLabel.text = usgsEarthquake.location
            selectedEarthquakeTimeLabel.text = DateFormatter.localizedString(from: usgsEarthquake.time, dateStyle: .medium, timeStyle: .medium)
            UIView.animate(withDuration: ViewController.animationDuration) {
                self.selectedEarthquakeContainerView.alpha = 1
            }
        } else if let usgsEarthquakeClusterAnnotationView = view as? UsgsEarthquakeClusterAnnotationView {
            guard let annotation = usgsEarthquakeClusterAnnotationView.annotation else {
                return
            }
            let mapPoint = MKMapPoint(annotation.coordinate)
            let visibleRect = mapView.visibleMapRect
            let newVisibleRectOrigin = MKMapPoint(x: mapPoint.x - 0.25 * visibleRect.width, y: mapPoint.y - 0.25 * visibleRect.height)
            let newVisibleRectSize = MKMapSize(width: 0.5 * visibleRect.width, height: 0.5 * visibleRect.height)
            let newVisibleRect = MKMapRect(origin: newVisibleRectOrigin, size: newVisibleRectSize)
            mapView.deselectAnnotation(annotation, animated: false)
            mapView.setVisibleMapRect(newVisibleRect, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        UIView.animate(withDuration: ViewController.animationDuration) {
            self.selectedEarthquakeContainerView.alpha = 0
        }
    }
}
