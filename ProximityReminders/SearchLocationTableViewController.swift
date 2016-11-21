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

class SearchLocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    //---------------------
    //MARK: Variables
    //---------------------
    var searchController: UISearchController!
    let locationManager = LocationManager()
    let coreDataManager = CoreDataManager()
    var reminder: Reminder?
    var placemarks: [CLPlacemark]?
    
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

        configureSearchController()
        
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
    }

    //---------------------
    //MARK: Table View
    //---------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placemarks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchLocationCell
        
        

        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        
        self.getAddress(forSearchString: text)
    }
    
    fileprivate func getAddress(forSearchString searchString: String) {
        
        self.placemarks = nil
        
        
        
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
