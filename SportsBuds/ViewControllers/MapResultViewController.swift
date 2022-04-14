//
//  MapResultViewController.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-30.
//

import UIKit
import MapKit
import CoreLocation

class MapResultViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Variables
    var selectedPostId: Int?
    var postList = [Post]()
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showPostAnnotations()
    }
    
    // MARK: - Instance Methods

    func showPostAnnotations() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()

        if CLLocationManager.locationServicesEnabled() {
            if let currentLocation = locationManager.location {
                self.currentLocation = currentLocation
                PostAPI.get(url: PostAPI.postURL,
                            parameters: ["latitude": String(currentLocation.coordinate.latitude),
                                         "longtitude": String(currentLocation.coordinate.longitude)])
                { [self] response in
                    switch response {
                    case .success(let data):
                        postList = data
                        DispatchQueue.main.async { [weak self] in
                            self?.addAnnotations()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func addAnnotations() {
        var annotations = [MKAnnotation]()
        for post in postList {
            let postAnnotation = PostMapAnnotation(id: post.id, title: post.title, coordinate: CLLocationCoordinate2D(latitude: post.latitude!, longitude: post.longitude!), info: post.location!)
            annotations.append(postAnnotation)
        }
        mapView.showAnnotations(annotations, animated: .random())
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is PostMapAnnotation else { return nil }
        
        let identifier = "PostMapAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        selectedPostId = nil
        guard let annotation = view.annotation as? PostMapAnnotation else {return}
        selectedPostId = annotation.id
        performSegue(withIdentifier: "showPostDetail", sender: self)
        
//        guard let annotation = view.annotation as? PostMapAnnotation else {return}
//        let placeName = annotation.title
//        let placeInfo = annotation.info
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
        
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(mRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PostDetailViewController {
            destination.emailAddress = ""
            if segue.identifier == "showPostDetail" {
                destination.post = postList.first(where: { $0.id == selectedPostId })
            }
        }
    }
    

}
