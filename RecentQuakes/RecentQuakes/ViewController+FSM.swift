//
//  ViewController+FSM.swift
//  RecentQuakes
//
//  Created by Ryan Hiroaki Tsukamoto on 1/27/20.
//  Copyright © 2020 Ryan Hiroaki Tsukamoto. All rights reserved.
//

import UIKit

extension ViewController {
    func transition(toDataState newDataState: DataState) {
        let onInvalidStateTransition = {
            fatalError("invalid data state transition \(self.dataState) -> \(newDataState)")
        }
        switch newDataState {
        case .initial:
            onInvalidStateTransition()
        case .loading:
            switch dataState {
            case .loadingError(_):
                fallthrough
            case .initial:
                showBusy(text: "Loading")
                dataState = newDataState
                UsgsApiClient.getUsgsEarthquakeList {
                    switch $0 {
                    case .error(let errorMessage):
                        self.transition(toDataState: .loadingError(errorMessage: errorMessage))
                    case .success(let usgsEarthquakeList):
                        self.transition(toDataState: .ready(usgsEarthquakeList: usgsEarthquakeList))
                    }
                }
            default:
                onInvalidStateTransition()
            }
        case .loadingError(let errorMessage):
            switch dataState {
            case .loading:
                hideBusy()
                let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self.transition(toDataState: .loading)
                }))
                present(alertController, animated: true, completion: nil)
                dataState = newDataState
            default:
                onInvalidStateTransition()
            }
        case .ready(let usgsEarthquakeList):
            switch dataState {
            case .loading:
                hideBusy()
                UIView.animate(withDuration: ViewController.animationDuration) {
                    self.changeUiStateButton.alpha = 1
                    self.refreshButton.alpha = 1
                }
                self.mapView.addAnnotations(usgsEarthquakeList)
            case .refreshing(let currentUsgsEarthquakeList):
                hideBusy()
                self.refreshButton.isEnabled = true
                self.refreshButton.setTitle("Refresh", for: .normal)
                self.mapView.removeAnnotations(currentUsgsEarthquakeList)
                self.mapView.addAnnotations(usgsEarthquakeList)
            case .refreshingError(_, _):
                self.refreshButton.isEnabled = true
                self.refreshButton.setTitle("Refresh", for: .normal)
                break
            default:
                onInvalidStateTransition()
            }
            dataState = newDataState
            computeTableViewData()
        case .refreshing(_):
            let possiblyRefresh: ([UsgsEarthquake]) -> () = { currentUsgsEarthquakeList in
                UsgsApiClient.getUsgsEarthquakeList {
                    switch $0 {
                    case .error(let errorMessage):
                        self.transition(toDataState:
                            .refreshingError(errorMessage: errorMessage, currentUsgsEarthquakeList: currentUsgsEarthquakeList)
                        )
                    case .success(let usgsEarthquakeList):
                        self.transition(toDataState: .ready(usgsEarthquakeList: usgsEarthquakeList))
                    }
                }
            }
            switch dataState {
            case .ready(let usgsEarthquakeList):
                showBusy(text: "Refreshing")
                refreshButton.setTitle("Refreshing", for: .normal)
                refreshButton.isEnabled = false
                dataState = newDataState
                possiblyRefresh(usgsEarthquakeList)
            case .refreshingError(_, let currentUsgsEarthquakeList):
                showBusy(text: "Refreshing")
                dataState = newDataState
                possiblyRefresh(currentUsgsEarthquakeList)
            default:
                onInvalidStateTransition()
            }
        case .refreshingError(let errorMessage, _):
            switch dataState {
            case .refreshing(let currentUsgsEarthquakeList):
                hideBusy()
                dataState = newDataState
                let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
                    self.transition(toDataState: .ready(usgsEarthquakeList: currentUsgsEarthquakeList))
                }))
                alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self.transition(toDataState: .refreshing(currentUsgsEarthquakeList: currentUsgsEarthquakeList))
                }))
                present(alertController, animated: true, completion: nil)
            default:
                onInvalidStateTransition()
            }
        }
    }

    func transition(toUiState newUiState: UiState) {
        let onInvalidStateTransition = {
            fatalError("invalid UI state transition \(self.uiState) -> \(newUiState)")
        }
        switch newUiState {
        case .map:
            switch uiState {
            case .list:
                changeUiStateButton.isEnabled = false
                changeUiStateButton.setTitle("", for: .normal)
                UIView.animate(withDuration: ViewController.animationDuration, animations: {
                    self.mapViewCoverView.alpha = 0
                    self.tableViewContainerView.alpha = 0
                }) { _ in
                    self.changeUiStateButton.setTitle("List", for: .normal)
                    self.changeUiStateButton.isEnabled = true
                }
                uiState = newUiState
            default:
                onInvalidStateTransition()
            }
        case .list:
            switch uiState {
            case .map:
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                changeUiStateButton.isEnabled = false
                changeUiStateButton.setTitle("", for: .normal)
                UIView.animate(withDuration: ViewController.animationDuration, animations: {
                    self.mapViewCoverView.alpha = 1
                    self.tableViewContainerView.alpha = 1
                }) { _ in
                    self.changeUiStateButton.setTitle("Map", for: .normal)
                    self.changeUiStateButton.isEnabled = true
                }
                uiState = newUiState
            default:
                onInvalidStateTransition()
            }
        }
    }
}
