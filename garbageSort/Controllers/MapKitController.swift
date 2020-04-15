//
//  MapKitController.swift
//  garbageSort
//
//  Created by Saam Haghighat on 2020-04-13.
//  Copyright © 2020 Saam Haghighat. All rights reserved.
//

import UIKit
import MapKit

class MapKitController: UIViewController, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private var currentLocation = CLLocationCoordinate2D()
    private var desinations: [MKPointAnnotation] = []
    private var currentRoute: MKRoute!
    @IBOutlet weak var mapview : MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationServices()
        // Do any additional setup after loading the view.
    }
    
    private func configureLocationServices()
    {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }else if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            mapview.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    public func beginLocationUpdates(locationManager: CLLocationManager) {
        mapview.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    public func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D)
    {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapview.setRegion(region, animated: true)
    }
    
    private func addAnnotations(){
        let HeartlakeAnnotation = MKPointAnnotation()
        HeartlakeAnnotation.title = "Heart Lake Community Recycling Centre"
        HeartlakeAnnotation.coordinate = CLLocationCoordinate2D(latitude: 43.710606, longitude: -79.801796)
        
        let simsRecycleAnnotation = MKPointAnnotation()
        simsRecycleAnnotation.title = "Sims Recycling Solutions"
        simsRecycleAnnotation.coordinate = CLLocationCoordinate2D(latitude: 43.688228, longitude: -79.705006)
        
        desinations.append(HeartlakeAnnotation)
        desinations.append(simsRecycleAnnotation)
        
        mapview.addAnnotation(HeartlakeAnnotation)
        mapview.addAnnotation(simsRecycleAnnotation)
    }
    
    private func constructRoute(userLocation: CLLocationCoordinate2D){
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: desinations[0].coordinate))
        directionsRequest.requestsAlternateRoutes = true
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { [weak self] (directionsResponse, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let response = directionsResponse, response.routes.count > 0 {
                strongSelf.currentRoute = response.routes[0]
                strongSelf.mapview.addOverlay(response.routes[0].polyline)
                strongSelf.mapview.setVisibleMapRect(response.routes[0].polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapview(_ mapview: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        guard let currentRoute = currentRoute else {
            return MKOverlayRenderer()
        }
        
        let polyLineRenderer = MKPolylineRenderer(polyline: currentRoute.polyline)
        polyLineRenderer.strokeColor = UIColor.green
        polyLineRenderer.lineWidth = 5
        
        return polyLineRenderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        addAnnotations()
        
        guard let latestLocation = locations.first else {return}
        
        constructRoute(userLocation: latestLocation.coordinate)
        zoomToLatestLocation(with: latestLocation.coordinate)
        currentLocation = latestLocation.coordinate
        //if(currentLocation == nil) {}
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status has changed")
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            beginLocationUpdates(locationManager: manager)
        }
    }

}

/*
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        
        var currentLocation = CLLocationCoordinate2D()
        
        guard let latestLocation = locations.first else {return}
        if(currentLocation == nil) {
        
        }
        currentLocation = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status has changed")
    }
}
*/
