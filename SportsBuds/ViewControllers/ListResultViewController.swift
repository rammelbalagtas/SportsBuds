//
//  ListResultViewController.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-30.
//

import UIKit
import CoreLocation

class ListResultViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate {
    
    var emailAddress: String?
    var postList = [Post]()
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
    }
    
    // MARK: - Instance Methods
    func registerNib() {
        //Register nib for table view
        let nibTable = UINib(nibName: Constants.NibName.nibSearchResultTable, bundle: nil)
        tableView.register(nibTable, forCellReuseIdentifier: Constants.ReuseIdentifier.searchResultViewCell)
    }

    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()

        if CLLocationManager.locationServicesEnabled() {
            if let currentLocation = locationManager.location {
                self.currentLocation = currentLocation
                PostAPI.get(url: PostAPI.postURL,
                            parameters: ["latitude": String(currentLocation.coordinate.latitude),
                                         "longitude": String(currentLocation.coordinate.longitude)])
                { [self] response in
                    switch response {
                    case .success(let data):
                        postList = data
                        DispatchQueue.main.async { [self] in
                            tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation: CLLocation = locations[0] as CLLocation
//        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        mapView.setRegion(mRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PostDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.post = postList[indexPath.row]
                destination.emailAddress = emailAddress
            }
        }
    }

}

extension ListResultViewController: UITableViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewMyPost", sender: self)
    }
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    // data per table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier.searchResultViewCell, for: indexPath) as? SearchResultTableViewCell
        else{preconditionFailure("unable to dequeue reusable cell")}
        let post = postList[indexPath.row]
        cell.configureCell(using: post, emailAddress: emailAddress!)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPostSegue", sender: self)
    }
    
}

extension ListResultViewController: SearchResultTableCell {
    func addToFavorites() {
        
    }
}
