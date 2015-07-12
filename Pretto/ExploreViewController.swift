//
//  ExploreViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/22/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ExploreViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    private var searchBar: UISearchBar!
    var location : CLLocationCoordinate2D? {
        didSet {
            if let location = location {
                let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
                let region = MKCoordinateRegion(center: location, span: span)
                mapView?.setRegion(region, animated: true)
                updateNearbyEvents()
            }
        }
    }
    var locationManager = CLLocationManager()

    var mapEvents : [String:MKAnnotation] = [:]
    private let latitude: Double = 37.771052
    private let longitude: Double = -122.403891
    private let latDelta: Double = 0.01
    private let longDelta: Double = 0.01
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchBar.barTintColor = UIColor.prettoBlue()
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        self.navigationItem.titleView = searchBar
        
        for firstLevelSubView in searchBar.subviews {
            for secondLevelSubView in firstLevelSubView.subviews! {
                if secondLevelSubView.isKindOfClass(UITextField) {
                    var searchText: UITextField = secondLevelSubView as! UITextField
                    searchText.textColor = UIColor.whiteColor()
                }
            }
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "didTapOnView")
        self.view.addGestureRecognizer(tapRecognizer)
        
        
        mapView.delegate = self
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    func didTapOnView() {
        self.searchBar.resignFirstResponder()
    }
    
    func updateNearbyEvents() {
        Event.getNearbyEvents(self.location!, callback: { (events) -> Void in
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapEvents.removeAll(keepCapacity: true)
            for event : Event in events {
                let annotation = MKPointAnnotation()
                let locationCoordinate = CLLocationCoordinate2DMake(event.latitude, event.longitude)
                annotation.coordinate = locationCoordinate
                annotation.title = event.title
                self.mapView.addAnnotation(annotation)
                self.mapEvents[event.title] = annotation
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

 // MARK: - UISearchBarDelegate
extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println(searchBar.text)
        
        var request = MKLocalSearchRequest()
        
        request.naturalLanguageQuery = searchBar.text
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.787988, longitude: -122.407455)
        var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        request.region = MKCoordinateRegion(center: center, span: span)
        
        var search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { (response:MKLocalSearchResponse!, error:NSError!) -> Void in
            if error == nil {
                if response.mapItems.count == 0 {
                    println("No Matches")
                } else {
                    for item in response.mapItems {
                        println(item.name)
                        println(item.phoneNumber)
                    }
                }
            } else {
                println("Error with MapKit: \(error)")
            }
        }
    }
}

// MARK: CLLocationManagerDelegate
extension ExploreViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let newLocation = locations.last as! CLLocation
        println("Got location \(newLocation)")
        self.location = newLocation.coordinate
        locationManager.stopUpdatingLocation()
    }
}

// MARK: MapViewDelegate
extension ExploreViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView.canShowCallout = true
            //annotationView.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            let detailButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            
            annotationView.rightCalloutAccessoryView = detailButton
        }
//        let imageView = annotationView.leftCalloutAccessoryView as! UIImageView
//        imageView.image = images[annotation.title!]
        return annotationView
    }
}
