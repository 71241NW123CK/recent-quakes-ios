//
//  ViewController+UITableViewDataSource+UITableViewDelegate.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource {
    class TableViewCell: UITableViewCell {
        static let reuseIdentifier = "cell"
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usgsEarthquake = tableViewData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "M\(usgsEarthquake.magnitude) \(usgsEarthquake.location)"
        cell.detailTextLabel?.text = DateFormatter.localizedString(from: usgsEarthquake.time, dateStyle: .medium, timeStyle: .medium)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usgsEarthquake = tableViewData[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        switch uiState {
        case .list:
            mapView.selectAnnotation(usgsEarthquake, animated: true)
            transition(toUiState: .map)
        default:
            return
        }
    }
}
