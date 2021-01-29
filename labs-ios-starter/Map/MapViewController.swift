//
//  MapViewController.swift
//  labs-ios-starter
//
//  Created by Claudia Maciel on 1/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    let annotation = MKPointAnnotation()
    let slideVC = OverlayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        checkLocationServices()
        
        // For the searchController (will set in the navigation bar)
        let locationSearchTable = storyboard!.instantiateViewController(identifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for location"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        //Passes the mapView to the SearchTable
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self

    }
    
    @objc func showOverlay() {
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            let alert = UIAlertController(title: "Location Permissions Denied", message: "Go to your settings and allow this app to use your location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true )
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
        case .denied:
            let alert = UIAlertController(title: "Location Permissions Denied", message: "Go to your settings and allow this app to use your location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            let alert = UIAlertController(title: "Location Permissions Restricted", message: "Your location permissions is currently set to Restricted, talk to your administrator", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }

}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        // remove  pins
        mapView.removeAnnotations(mapView.annotations)
        
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true )
    }
}

extension MapViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MapViewController: MKMapViewDelegate {
    // When user selects the searched city annotation, it calls the showOverlay method
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        showOverlay()
        slideVC.updateView(city: annotation.title)
        mapView.deselectAnnotation(annotation, animated: true)
    }
}
