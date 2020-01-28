//
//  ViewController.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    var dataState: DataState = .initial
    var uiState: UiState = .map
    var sortOrder: SortOrder = .magnitude

    var mapView: MKMapView!
    var mapViewCoverView: UIView!
    var selectedEarthquakeContainerView: UIView!
    var selectedEarthquakeStripeView: UIView!
    var selectedEarthquakeMagnitudeLabel: UILabel!
    var selectedEarthquakeLocationLabel: UILabel!
    var selectedEarthquakeTimeLabel: UILabel!
    var selectedEarthquakeLinkButton: UIButton!
    var tableViewContainerView: UIView!
    var sortOrderSegmentedControl: UISegmentedControl!
    var tableView: UITableView!
    var changeUiStateButton: UIButton!
    var refreshButton: UIButton!
    var busyContainerView: UIView!
    var busyActivityIndicatorView: UIActivityIndicatorView!
    var busyLabel: UILabel!

    let locationManager = CLLocationManager()
    var hasGottenFirstLocation = false
    var tableViewData: [UsgsEarthquake] = []

    var maybeUsgsEarthquakeList: [UsgsEarthquake]? {
        get {
            switch dataState {
            case .ready(let usgsEarthquakeList):
                return usgsEarthquakeList
            case .refreshing(let currentUsgsEarthquakeList):
                return currentUsgsEarthquakeList
            case .refreshingError(_, let currentUsgsEarthquakeList):
                return currentUsgsEarthquakeList
            default:
                return nil
            }
        }
    }

    override func loadView() {
        super.loadView()
        loadCustomUi()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true
        mapView.register(UsgsEarthquakeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(UsgsEarthquakeClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        mapView.delegate = self
        selectedEarthquakeLinkButton.addTarget(self, action: #selector(selectedEarthquakeLinkButtonWasTapped), for: .touchUpInside)
        sortOrderSegmentedControl.addTarget(self, action: #selector(sortOrderSegmentedControlValueDidChange), for: .valueChanged)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        changeUiStateButton.addTarget(self, action: #selector(changeUiStateButtonWasTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshButtonWasTapped), for: .touchUpInside)
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = 5
        locationManager.delegate = self
        transition(toDataState: .loading)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (CLLocationManager.locationServicesEnabled()) {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways:
                fallthrough
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            default:
                break
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }

    func computeTableViewData() {
        guard let usgsEarthquakeList = maybeUsgsEarthquakeList else {
            return
        }
        switch sortOrder {
        case .magnitude:
            tableViewData = usgsEarthquakeList
        case .time:
            tableViewData = usgsEarthquakeList.sorted(by: { (lhs, rhs) -> Bool in
                lhs.time > rhs.time
            })
        }
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
