
//
//  MapKitController.swift
//  garbageSort
//
//  Created by Saam Haghighat on 2020-04-13.
//  Copyright © 2020 ZeroWaste. All rights reserved.
//
import UIKit
import MapKit
import Contacts

class MapKitController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private let locationManager = CLLocationManager()
    private var currentLocation = CLLocationCoordinate2D()
    private var desinations: [MKPointAnnotation] = []
    private var currentRoute: MKRoute!
    @IBOutlet weak var mapview : MKMapView!
    
    //function to zoom to user location
    public func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D)
    {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 30000, longitudinalMeters: 30000)
        mapview.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationServices()
        mapview.showsUserLocation = true
        mapview.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        // Do any additional s  etup after loading the view.
        
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
            zoomToLatestLocation(with: locationManager.location!.coordinate)
        }
    }
    
    //function to update location
    public func beginLocationUpdates(locationManager: CLLocationManager) {
        mapview.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    

    
    //function for adding annotated locations on map
    private func addAnnotations(){
        
        // Peel Region
        let HeartlakeAnnotation = MKPointAnnotation()
        HeartlakeAnnotation.title = "Heart Lake Community Recycling Centre"
        HeartlakeAnnotation.coordinate = CLLocationCoordinate2D(latitude: 43.710606, longitude: -79.801796)
        
        let HeartLakeCoordinate = CLLocationCoordinate2D(latitude: 43.710606, longitude: -79.801796)
        
        let HeartLakeAddress = [CNPostalAddressStreetKey: "420 Railside Dr", CNPostalAddressCityKey: "Brampton", CNPostalAddressPostalCodeKey: "L7A 0N8", CNPostalAddressISOCountryCodeKey: "CA"]
        let HeartLakeWaste = MKPlacemark(coordinate: HeartLakeCoordinate, addressDictionary: HeartLakeAddress)

        
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
        
        
        
        //desinations.append(HeartlakeAnnotation)
        desinations.append(simsRecycleAnnotation)
        desinations.append(BattlefordAnnotation)
        desinations.append(PeelScrapAnnotation)
        desinations.append(HaltonWasteAnnotation)

        
        //mapview.addAnnotation(HeartlakeAnnotation)
        mapview.addAnnotation(simsRecycleAnnotation)
        mapview.addAnnotation(BattlefordAnnotation)
        mapview.addAnnotation(PeelScrapAnnotation)
        mapview.addAnnotation(HaltonWasteAnnotation)
        
        mapview.addAnnotation(HeartLakeWaste)

    }
    //function to make route between locations
    func mapview(mapview: MKMapView!, viewForAnnotation annotation: MKPointAnnotation!) -> MKAnnotationView?{
        guard annotation is MKPointAnnotation else { return nil }

        let reuseId = "pin"

        var pinView = mapview.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if pinView == nil {
                let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pin.canShowCallout = false
                pin.pinTintColor = UIColor.green

                //next line sets a button for the right side of the callout...
                pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as! UIButton
            }
            else {
                pinView!.annotation = annotation
            }

            return pinView
        
    }
    // function to give directions when selecting annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

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
      //  print("Did get latest location")
        addAnnotations()
        
        guard let latestLocation = locations.first else {return}
        
        //constructRoute(userLocation: latestLocation.coordinate)

        currentLocation = latestLocation.coordinate
      // zoomToLatestLocation(with: latestLocation.coordinate)
        //if(currentLocation == nil) {}
    }
    
    //checking if location services have been authorized
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      //  print("The status has changed")
        addAnnotations()
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            beginLocationUpdates(locationManager: manager)
        }
    }

}
