//
//  ViewController+UI.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import MapKit

extension ViewController {
    @objc
    func changeUiStateButtonWasTapped() {
        switch uiState {
        case .map:
            transition(toUiState: .list)
        case .list:
            transition(toUiState: .map)
        }
    }

    @objc
    func refreshButtonWasTapped() {
        switch dataState {
        case .ready(let usgsEarthquakeList):
            transition(toDataState: .refreshing(currentUsgsEarthquakeList: usgsEarthquakeList))
        default:
            return
        }
    }

    @objc
    func selectedEarthquakeLinkButtonWasTapped() {
        guard
            let selectedEarthquake = mapView.selectedAnnotations.first as? UsgsEarthquake,
            let url = URL(string: selectedEarthquake.url)
        else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc
    func sortOrderSegmentedControlValueDidChange() {
        guard let sortOrder = SortOrder(rawValue: sortOrderSegmentedControl.selectedSegmentIndex) else {
            return
        }
        self.sortOrder = sortOrder
        computeTableViewData()
    }

    func loadCustomUi() {
        loadMapView()
        loadSelectedEarthquakeContainerView()
        loadMapViewCover()
        loadTableViewContainer()
        loadButtons()
        loadBusyContainerView()
    }

    func loadMapView() {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.mapView = mapView
    }

    func loadSelectedEarthquakeContainerView() {
        let selectedEarthquakeContainerView = UIView(frame: .zero)
        selectedEarthquakeContainerView.translatesAutoresizingMaskIntoConstraints = false
        selectedEarthquakeContainerView.backgroundColor = UIColor.white
        selectedEarthquakeContainerView.layer.cornerRadius = ViewController.selectedEarthquakeContainerViewPadding
        selectedEarthquakeContainerView.clipsToBounds = true
        selectedEarthquakeContainerView.alpha = 0
        let selectedEarthquakeStripeView = UILabel(frame: .zero)
        selectedEarthquakeStripeView.translatesAutoresizingMaskIntoConstraints = false
        selectedEarthquakeContainerView.addSubview(selectedEarthquakeStripeView)
        let selectedEarthquakeMagnitudeLabel = UILabel(frame: .zero)
        selectedEarthquakeMagnitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedEarthquakeMagnitudeLabel.textAlignment = .center
        selectedEarthquakeMagnitudeLabel.font = UIFont.boldSystemFont(ofSize: ViewController.selectedEarthquakeMagnitudeLabelFontSize)
        selectedEarthquakeContainerView.addSubview(selectedEarthquakeMagnitudeLabel)
        let selectedEarthquakeLocationLabel = UILabel(frame: .zero)
        selectedEarthquakeLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedEarthquakeLocationLabel.font = UIFont.boldSystemFont(ofSize: ViewController.selectedEarthquakeLocationLabelFontSize)
        selectedEarthquakeLocationLabel.adjustsFontSizeToFitWidth = true
        selectedEarthquakeLocationLabel.numberOfLines = 2
        selectedEarthquakeLocationLabel.lineBreakMode = .byWordWrapping
        selectedEarthquakeContainerView.addSubview(selectedEarthquakeLocationLabel)
        let selectedEarthquakeTimeLabel = UILabel(frame: .zero)
        selectedEarthquakeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedEarthquakeTimeLabel.font = UIFont.systemFont(ofSize: ViewController.selectedEarthquakeTimeLabelFontSize)
        selectedEarthquakeContainerView.addSubview(selectedEarthquakeTimeLabel)
        let selectedEarthquakeLinkButton = UIButton(type: .system)
        selectedEarthquakeLinkButton.translatesAutoresizingMaskIntoConstraints = false
        selectedEarthquakeLinkButton.setTitle("USGS site", for: .normal)
        selectedEarthquakeLinkButton.setTitleColor(UIColor.systemBlue, for: .normal)
        selectedEarthquakeLinkButton.layer.cornerRadius = 2
        selectedEarthquakeLinkButton.layer.borderColor = UIColor.systemBlue.cgColor
        selectedEarthquakeLinkButton.layer.borderWidth = 2
        selectedEarthquakeContainerView.addSubview(selectedEarthquakeLinkButton)
        view.addSubview(selectedEarthquakeContainerView)
        NSLayoutConstraint.activate([
            selectedEarthquakeContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ViewController.selectedEarthquakeContainerViewMargin),
            selectedEarthquakeContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ViewController.selectedEarthquakeContainerViewMargin),
            selectedEarthquakeContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -ViewController.selectedEarthquakeContainerViewMargin),
            selectedEarthquakeStripeView.leadingAnchor.constraint(equalTo: selectedEarthquakeContainerView.leadingAnchor),
            selectedEarthquakeStripeView.topAnchor.constraint(equalTo: selectedEarthquakeContainerView.topAnchor),
            selectedEarthquakeStripeView.bottomAnchor.constraint(equalTo: selectedEarthquakeContainerView.bottomAnchor),
            selectedEarthquakeStripeView.widthAnchor.constraint(equalToConstant: ViewController.selectedEarthquakeContainerViewPadding),
            selectedEarthquakeMagnitudeLabel.leadingAnchor.constraint(equalTo: selectedEarthquakeContainerView.leadingAnchor, constant: ViewController.selectedEarthquakeContainerViewPadding),
            selectedEarthquakeMagnitudeLabel.topAnchor.constraint(equalTo: selectedEarthquakeContainerView.topAnchor, constant: ViewController.selectedEarthquakeContainerViewPadding),
            selectedEarthquakeMagnitudeLabel.bottomAnchor.constraint(equalTo: selectedEarthquakeContainerView.bottomAnchor, constant: -ViewController.selectedEarthquakeContainerViewPadding),
            selectedEarthquakeMagnitudeLabel.widthAnchor.constraint(equalToConstant: ViewController.selectedEarthquakeMagnitudeLabelWidth),
            selectedEarthquakeLocationLabel.leadingAnchor.constraint(equalTo: selectedEarthquakeMagnitudeLabel.trailingAnchor, constant: ViewController.selectedEarthquakeContainerViewPadding),
            selectedEarthquakeLocationLabel.topAnchor.constraint(equalTo: selectedEarthquakeContainerView.topAnchor, constant: ViewController.selectedEarthquakeContainerViewPadding),
            selectedEarthquakeLocationLabel.trailingAnchor.constraint(equalTo: selectedEarthquakeContainerView.trailingAnchor, constant: -ViewController.selectedEarthquakeContainerViewPadding),
            selectedEarthquakeLocationLabel.heightAnchor.constraint(equalToConstant: ViewController.selectedEarthquakeLocationLabelHeight),
            selectedEarthquakeTimeLabel.leadingAnchor.constraint(equalTo: selectedEarthquakeMagnitudeLabel.trailingAnchor, constant: ViewController.selectedEarthquakeContainerViewPadding),
            selectedEarthquakeTimeLabel.topAnchor.constraint(equalTo: selectedEarthquakeLocationLabel.bottomAnchor, constant: ViewController.selectedEarthquakeContainerViewPadding),
            selectedEarthquakeTimeLabel.lastBaselineAnchor.constraint(equalTo: selectedEarthquakeLinkButton.lastBaselineAnchor),
            selectedEarthquakeLinkButton.leadingAnchor.constraint(equalTo: selectedEarthquakeTimeLabel.trailingAnchor),
            selectedEarthquakeLinkButton.topAnchor.constraint(equalTo: selectedEarthquakeLocationLabel.bottomAnchor, constant: ViewController.selectedEarthquakeContainerViewPadding),
            selectedEarthquakeLinkButton.widthAnchor.constraint(equalToConstant: ViewController.selectedEarthquakeLinkButtonWidth),
            selectedEarthquakeLinkButton.heightAnchor.constraint(equalToConstant: ViewController.selectedEarthquakeBottomRowHeight),
            selectedEarthquakeLinkButton.bottomAnchor.constraint(equalTo: selectedEarthquakeContainerView.bottomAnchor, constant: -ViewController.selectedEarthquakeContainerViewPadding),
            selectedEarthquakeLinkButton.trailingAnchor.constraint(equalTo: selectedEarthquakeContainerView.trailingAnchor, constant: -ViewController.selectedEarthquakeContainerViewPadding),
        ])
        self.selectedEarthquakeStripeView = selectedEarthquakeStripeView
        self.selectedEarthquakeMagnitudeLabel = selectedEarthquakeMagnitudeLabel
        self.selectedEarthquakeLocationLabel = selectedEarthquakeLocationLabel
        self.selectedEarthquakeTimeLabel = selectedEarthquakeTimeLabel
        self.selectedEarthquakeContainerView = selectedEarthquakeContainerView
        self.selectedEarthquakeLinkButton = selectedEarthquakeLinkButton
    }

    func loadMapViewCover() {
        let mapViewCover = UIView(frame: .zero)
        mapViewCover.translatesAutoresizingMaskIntoConstraints = false
        mapViewCover.backgroundColor = UIColor.white
        mapViewCover.alpha = 0
        view.addSubview(mapViewCover)
        NSLayoutConstraint.activate([
            mapViewCover.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            mapViewCover.topAnchor.constraint(equalTo: mapView.topAnchor),
            mapViewCover.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
            mapViewCover.trailingAnchor.constraint(equalTo: mapView.trailingAnchor)
        ])
        self.mapViewCoverView = mapViewCover
    }

    func loadTableViewContainer() {
        let tableViewContainerView = UIView(frame: .zero)
        tableViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainerView.backgroundColor = UIColor.white
        tableViewContainerView.alpha = 0
        let sortOrderSegmentedControl = UISegmentedControl(items: [SortOrder(rawValue: 0)!.name, SortOrder(rawValue: 1)!.name])
        sortOrderSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        sortOrderSegmentedControl.selectedSegmentIndex = sortOrder.rawValue
        tableViewContainerView.addSubview(sortOrderSegmentedControl)
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainerView.addSubview(tableView)
        view.addSubview(tableViewContainerView)
        NSLayoutConstraint.activate([
            tableViewContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableViewContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableViewContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableViewContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            sortOrderSegmentedControl.leadingAnchor.constraint(equalTo: tableViewContainerView.leadingAnchor, constant: 160),
            sortOrderSegmentedControl.topAnchor.constraint(equalTo: tableViewContainerView.topAnchor, constant: 8),
            sortOrderSegmentedControl.trailingAnchor.constraint(equalTo: tableViewContainerView.trailingAnchor, constant: -8),
            sortOrderSegmentedControl.heightAnchor.constraint(equalToConstant: 48),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainerView.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: tableViewContainerView.topAnchor, constant: 64),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainerView.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainerView.trailingAnchor),
        ])
        self.sortOrderSegmentedControl = sortOrderSegmentedControl
        self.tableView = tableView
        self.tableViewContainerView = tableViewContainerView
    }

    func loadButtons() {
        let changeUiStateButton = UIButton(type: .roundedRect)
        changeUiStateButton.translatesAutoresizingMaskIntoConstraints = false
        changeUiStateButton.setTitle("List", for: .normal)
        changeUiStateButton.setTitleColor(UIColor.black, for: .normal)
        changeUiStateButton.backgroundColor = UIColor.white
        changeUiStateButton.layer.borderColor = UIColor.black.cgColor
        changeUiStateButton.layer.borderWidth = 2.0
        changeUiStateButton.layer.cornerRadius = 5.0
        changeUiStateButton.alpha = 0
        view.addSubview(changeUiStateButton)
        NSLayoutConstraint.activate([
            changeUiStateButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            changeUiStateButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            changeUiStateButton.widthAnchor.constraint(equalToConstant: 48),
            changeUiStateButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        self.changeUiStateButton = changeUiStateButton
        let refreshButton = UIButton(type: .roundedRect)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.setTitleColor(UIColor.black, for: .normal)
        refreshButton.backgroundColor = UIColor.white
        refreshButton.layer.borderColor = UIColor.black.cgColor
        refreshButton.layer.borderWidth = 2.0
        refreshButton.layer.cornerRadius = 5.0
        refreshButton.alpha = 0
        view.addSubview(refreshButton)
        NSLayoutConstraint.activate([
            refreshButton.leadingAnchor.constraint(equalTo: changeUiStateButton.safeAreaLayoutGuide.trailingAnchor, constant: 8),
            refreshButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            refreshButton.widthAnchor.constraint(equalToConstant: 80),
            refreshButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        self.refreshButton = refreshButton
    }

    func loadBusyContainerView() {
        let busyContainerView = UIView(frame: .zero)
        busyContainerView.translatesAutoresizingMaskIntoConstraints = false
        busyContainerView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        busyContainerView.layer.cornerRadius = ViewController.busyContainerViewPadding
        busyContainerView.alpha = 0
        var busyActivityIndicatorView: UIActivityIndicatorView!
//        if #available(iOS 13.0, *) {
//            busyActivityIndicatorView = UIActivityIndicatorView(style: .large)
//        } else {
            busyActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
//        }
        busyActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        busyContainerView.addSubview(busyActivityIndicatorView)
        let busyLabel = UILabel(frame: .zero)
        busyLabel.translatesAutoresizingMaskIntoConstraints = false
        busyLabel.textColor = UIColor.white
        busyLabel.textAlignment = .center
        busyContainerView.addSubview(busyLabel)
        view.addSubview(busyContainerView)
        NSLayoutConstraint.activate([
            busyContainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            busyContainerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            busyContainerView.widthAnchor.constraint(equalToConstant: ViewController.busyActivityIndicatorSideLength + 2.0 * ViewController.busyContainerViewPadding),
            busyContainerView.heightAnchor.constraint(equalToConstant: ViewController.busyActivityIndicatorSideLength + ViewController.busyLabelHeight + 2.0 * ViewController.busyContainerViewPadding),
            busyActivityIndicatorView.centerXAnchor.constraint(equalTo: busyContainerView.centerXAnchor),
            busyActivityIndicatorView.topAnchor.constraint(equalTo: busyContainerView.topAnchor, constant: ViewController.busyContainerViewPadding),
            busyActivityIndicatorView.widthAnchor.constraint(equalToConstant: ViewController.busyActivityIndicatorSideLength),
            busyLabel.centerXAnchor.constraint(equalTo: busyContainerView.centerXAnchor),
            busyLabel.topAnchor.constraint(equalTo: busyActivityIndicatorView.bottomAnchor),
            busyLabel.bottomAnchor.constraint(equalTo: busyContainerView.bottomAnchor, constant: -ViewController.busyContainerViewPadding),
            busyLabel.widthAnchor.constraint(equalTo: busyContainerView.widthAnchor),
            busyLabel.heightAnchor.constraint(equalToConstant: ViewController.busyLabelHeight)
        ])
        self.busyContainerView = busyContainerView
        self.busyActivityIndicatorView = busyActivityIndicatorView
        self.busyLabel = busyLabel
    }

    func showBusy(text busyText: String) {
        busyActivityIndicatorView.startAnimating()
        busyLabel.text = busyText
        busyContainerView.alpha = 1
    }

    func hideBusy() {
        busyActivityIndicatorView.stopAnimating()
        busyContainerView.alpha = 0
    }
}
