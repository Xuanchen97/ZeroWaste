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
    
    //function to update location and allow for location access
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
    
    //function to update location
    public func beginLocationUpdates(locationManager: CLLocationManager) {
        mapview.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    //function to zoom to user location
    public func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D)
    {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapview.setRegion(region, animated: true)
    }
    
    //function for adding annotated locations on map
    private func addAnnotations(){
        
        // Peel Region
        let HeartlakeAnnotation = MKPointAnnotation()
        HeartlakeAnnotation.title = "Heart Lake Community Recycling Centre"
        HeartlakeAnnotation.coordinate = CLLocationCoordinate2D(latitude: 43.710606, longitude: -79.801796)
        
        let BattlefordAnnotation = MKPointAnnotation()
        BattlefordAnnotation.title = "Battleford Community Recycling Centre"
        BattlefordAnnotation.coordinate = CLLocationCoordinate2D(latitude: 43.583734, longitude: 79.739060)
        
        let PeelScrapAnnotation = MKPointAnnotation()
        PeelScrapAnnotation.title = "Peel Scrap Metal Recycling Centre"
        PeelScrapAnnotation.coordinate = CLLocationCoordinate2D(latitude: 43.693585, longitude: 79.662407)
        
        let simsRecycleAnnotation = MKPointAnnotation()
        simsRecycleAnnotation.title = "Sims Recycling Solutions"
        simsRecycleAnnotation.coordinate = CLLocationCoordinate2D(latitude: 43.688228, longitude: -79.705006)
        
        // Halton Region
        let HaltonWasteAnnotation = MKPointAnnotation()
        HaltonWasteAnnotation.title = "Halton Waste Management Site"
        HaltonWasteAnnotation.coordinate = CLLocationCoordinate2D(latitude: 43.476987, longitude: -79.823558)
        
        
        
        desinations.append(HeartlakeAnnotation)
        desinations.append(simsRecycleAnnotation)
        desinations.append(BattlefordAnnotation)
        desinations.append(PeelScrapAnnotation)
        desinations.append(HaltonWasteAnnotation)

        
        mapview.addAnnotation(HeartlakeAnnotation)
        mapview.addAnnotation(simsRecycleAnnotation)
        mapview.addAnnotation(BattlefordAnnotation)
        mapview.addAnnotation(PeelScrapAnnotation)
        mapview.addAnnotation(HaltonWasteAnnotation)

    }
    
    /* //function to create route between location and annotated location
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
 */
    
    
    //function to make route between locations
    func mapview(mapview: MKMapView!, viewForAnnotation annotation: MKPointAnnotation!) -> MKAnnotationView?{
        guard annotation is MKPointAnnotation else { return nil }

        let reuseId = "pin"

        var pinView = mapview.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if pinView == nil {
                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView.canShowCallout = true
                pinView.pinTintColor = UIColor.green

                //next line sets a button for the right side of the callout...
                pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as! UIButton
            }
            else {
                pinView!.annotation = annotation
            }

            return pinView
        
    }
    // function to give directions when selecting annotation
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
        calloutAccessoryControlTapped control: UIControl!) {

            let selectedLoc = view.annotation

        print("Annotation '\(selectedLoc?.title!)' has been selected")

        let currentLocMapItem = MKMapItem.forCurrentLocation()

        let selectedPlacemark = MKPlacemark(coordinate: selectedLoc!.coordinate, addressDictionary: nil)
            let selectedMapItem = MKMapItem(placemark: selectedPlacemark)

            let mapItems = [selectedMapItem, currentLocMapItem]

            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]

        MKMapItem.openMaps(with: mapItems, launchOptions:launchOptions)
    }
    
    //checking for location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        addAnnotations()
        
        guard let latestLocation = locations.first else {return}
        
        //constructRoute(userLocation: latestLocation.coordinate)
        //zoomToLatestLocation(with: latestLocation.coordinate)
        currentLocation = latestLocation.coordinate
        //if(currentLocation == nil) {}
    }
    
    //checking if location services have been authorized
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
