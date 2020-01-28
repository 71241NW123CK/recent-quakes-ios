//
//  UsgsEarthquake.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import Foundation

class UsgsEarthquake: NSObject {
    let location: String
    let magnitude: Double
    let name: String
    let time: Date
    let url: String
    let latitutde: Double
    let longitude: Double

    init?(fromJson json: [String: Any?]) {
        guard
            let propertiesJson = json["properties"] as? [String: Any?],
            let location = propertiesJson["place"] as? String,
            let magnitude = propertiesJson["mag"] as? Double,
            let name = propertiesJson["title"] as? String,
            let timeMillis = propertiesJson["time"] as? Int,
            let url = propertiesJson["url"] as? String,
            let geometryJson = json["geometry"] as? [String: Any?],
            let coordinates = geometryJson["coordinates"] as? [Double]
        else {
            return nil
        }
        if coordinates.count < 2 {
            return nil
        }
        self.location = location
        self.magnitude = magnitude
        self.name = name
        self.time = Date(timeIntervalSince1970: Double(timeMillis) / 1000)
        self.url = url
        self.latitutde = coordinates[1]
        self.longitude = coordinates[0]
    }
}
