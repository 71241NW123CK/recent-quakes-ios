//
//  UsgsEarthquakeClusterAnnotationView.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import MapKit

class UsgsEarthquakeClusterAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let clusterAnnotation = annotation as? MKClusterAnnotation else {
            return
        }
        let maybeBiggestEarthquake =
            clusterAnnotation.memberAnnotations
                .compactMap { $0 as? UsgsEarthquake }
                .max { $0.magnitude < $1.magnitude }
        guard let biggestEarthquake = maybeBiggestEarthquake else {
            return
        }
        let imageRenderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        image = imageRenderer.image { _ in
            biggestEarthquake.displayColor.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 4, y: 4, width: 32, height: 32)).fill()
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
            ]
            let text = "\(clusterAnnotation.memberAnnotations.count)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(
                x: 20 - 0.5 * size.width,
                y: 20 - 0.5 * size.height,
                width: size.width,
                height: size.height
            )
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
