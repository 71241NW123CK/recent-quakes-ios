//
//  UsgsApiClient.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import Foundation

struct UsgsApiClient {
    enum GetUsgsEarthquakeListResult {
        case error(errorMessage: String)
        case success(usgsEarthquakeList: [UsgsEarthquake])
    }
    
    static let minimumMagnitude = 3.0
    static let url = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&orderby=magnitude&minmagnitude=\(minimumMagnitude)")!

    static func getUsgsEarthquakeList(completion: @escaping (GetUsgsEarthquakeListResult) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.error(errorMessage: error.localizedDescription))
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.error(errorMessage: "Invalid response"))
                }
                return
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.error(errorMessage: "Failed Request"))
                }
                return
            }
            guard let mimeType = httpResponse.mimeType else {
                DispatchQueue.main.async {
                    completion(.error(errorMessage: "Format Error"))
                }
                return
            }
            guard mimeType == "application/json" else {
                DispatchQueue.main.async {
                    completion(.error(errorMessage: "Invalid Format: \(mimeType)"))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.error(errorMessage: "Empty Response"))
                }
                return
            }
            guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any?] else {
                DispatchQueue.main.async {
                    completion(.error(errorMessage: "Invalid JSON"))
                }
                return
            }
            guard let features = json["features"] as? [[String: Any?]] else {
                DispatchQueue.main.async {
                    completion(.error(errorMessage: "JSON missing data"))
                }
                return
            }
            let usgsEarthquakeList = features.compactMap {
                UsgsEarthquake(fromJson: $0)
            }
            DispatchQueue.main.async {
                completion(.success(usgsEarthquakeList: usgsEarthquakeList))
            }
        }
        task.resume()
    }
}
