//
//  ViewController+Enumerations.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import Foundation

enum DataState {
    case initial
    case loading
    case loadingError(errorMessage: String)
    case ready(usgsEarthquakeList: [UsgsEarthquake])
    case refreshing(currentUsgsEarthquakeList: [UsgsEarthquake])
    case refreshingError(errorMessage: String, currentUsgsEarthquakeList: [UsgsEarthquake])
}

enum UiState {
    case map
    case list
}

enum SortOrder: Int {
    case magnitude = 0
    case time = 1

    var name: String {
        get {
            switch self {
            case .magnitude:
                return "Magnitude"
            case .time:
                return "Time"
            }
        }
    }
}
