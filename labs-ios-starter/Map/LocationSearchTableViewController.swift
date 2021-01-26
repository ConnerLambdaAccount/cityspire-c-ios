//
//  LocationSearchTableViewController.swift
//  labs-ios-starter
//
//  Created by Claudia Maciel on 1/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit


class LocationSearchTableViewController: UITableViewController {

    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    var cities: [String] = []
    var citySearchResults: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cities = parseCities()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citySearchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let city: String = citySearchResults[indexPath.row]
        let cityName: String = String(city.dropLast(3))
        let state: String = String(city.dropFirst(city.count-2))
        cell.textLabel?.text = "\(cityName), \(state)"
        return cell 
    }
    
    // User taps cell, perform mapkit search for cell text, default to first result from api response
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Perform Search
        guard let mapView = mapView else { return }
        let request = MKLocalSearch.Request()
        let selectedCell = tableView.cellForRow(at: indexPath)
        request.naturalLanguageQuery = selectedCell?.textLabel?.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else { return }
            self.handleMapSearchDelegate?.dropPinZoomIn(placemark: response.mapItems[0].placemark)
        }
        
        dismiss(animated: true, completion: nil)
    }

}

extension LocationSearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        
        let filteredCities = cities.filter { (city) -> Bool in
            return city.lowercased().starts(with: searchBarText.lowercased())
        }
        self.citySearchResults = filteredCities
        self.tableView.reloadData()

    }
}

