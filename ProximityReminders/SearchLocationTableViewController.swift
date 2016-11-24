//
//  SearchLocationTableViewController.swift
//  ProximityReminders
//
//  Created by Joey on 21/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol writeLocationBackDelegate: class {
    func writeLocationBack(toLocation: CLLocation)
}

class SearchLocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    //---------------------
    //MARK: Variables
    //---------------------
    var searchController: UISearchController!
    let locationManager = LocationManager()
    let coreDataManager = CoreDataManager()
    var reminder: Reminder?
    var locations: [MKMapItem] = []
    var locationToPassBack: CLLocation?
    weak var delegate: writeLocationBackDelegate?
    
    //---------------------
    //MARK: Outlets
    //---------------------
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "CurrentLocation"), style: .plain, target: self, action: #selector(zoomToCurrentLocation))
        
        configureSearchController()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let location = self.locationToPassBack {
            delegate?.writeLocationBack(toLocation: location)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView.removeFromSuperview()
        mapView = nil
    }
    
    deinit {
        
        searchController.view.removeFromSuperview()
        mapContainerView.removeFromSuperview()
        segmentedControl.removeFromSuperview()
        mapView = nil
    }

    //---------------------
    //MARK: Table View
    //---------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        
        let location = locations[indexPath.row].placemark
        cell.textLabel?.text = location.name
        cell.detailTextLabel?.text = locationManager.parseAddress(location: location)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mapContainerView.isHidden = false
        searchController.searchBar.endEditing(true)
        
        let selectedLocation = locations[indexPath.row].placemark
        locationManager.dropPinZoomIn(placemark: selectedLocation, mapView: self.mapView)
        print(selectedLocation.coordinate)
        
        locationToPassBack = CLLocation(latitude: selectedLocation.coordinate.latitude, longitude: selectedLocation.coordinate.longitude)
        
    }
    
    //---------------------
    //MARK: Search
    //---------------------
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        
        self.getLocations(forSearchString: text)
    }
    
    fileprivate func getLocations(forSearchString searchString: String) {
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchString
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            guard let response = response else { return }
            self.locations = response.mapItems
            self.tableView.reloadData()
        }
    }
    
    @objc func zoomToCurrentLocation() {
        
        mapContainerView.isHidden = false
        
        //Clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.userLocation.coordinate
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(mapView.userLocation.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        let location = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        mapView.add(MKCircle(center: location.coordinate, radius: 50))
        
        locationToPassBack = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
    }
    
    //---------------------
    //MARK: Functions
    //---------------------
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search or Enter Address"
        searchController.searchBar.showsCancelButton = false
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SearchLocationTableViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 2.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
}













