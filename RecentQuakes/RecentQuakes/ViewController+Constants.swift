//
//  ViewController+Constants.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import MapKit

extension ViewController {
    static let startingMapSize = MKMapSize(
        width: MKMapSize.world.width / 64.0,
        height: MKMapSize.world.height / 64.0
    )

    static let maximumSelectionMapSize = MKMapSize(
        width: MKMapSize.world.width / 4096.0,
        height: MKMapSize.world.height / 4096.0
    )

    static let animationDuration = 0.375

    static let selectedEarthquakeContainerViewPadding: CGFloat = 8.0
    static let selectedEarthquakeContainerViewMargin: CGFloat = 8.0
    static let selectedEarthquakeMagnitudeLabelWidth: CGFloat = 100.0
    static let selectedEarthquakeMagnitudeLabelFontSize: CGFloat = 30.0
    static let selectedEarthquakeLocationLabelHeight: CGFloat = 50.0
    static let selectedEarthquakeLocationLabelFontSize: CGFloat = 20.0
    static let selectedEarthquakeBottomRowHeight: CGFloat = 30.0
    static let selectedEarthquakeTimeLabelFontSize: CGFloat = 12.0
    static let selectedEarthquakeLinkButtonWidth: CGFloat = 80.0

    static let busyActivityIndicatorSideLength: CGFloat = 100.0
    static let busyLabelHeight: CGFloat = 20.0
    static let busyContainerViewPadding: CGFloat = 20.0
}
