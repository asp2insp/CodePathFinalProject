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
    private var invitationToSelectedEvent : Invitation?
    private var searchBar: UISearchBar!
    var location : CLLocationCoordinate2D? {
        didSet {
            if let location = location {
                let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
                let region = MKCoordinateRegion(center: location, span: span)
                mapView?.setRegion(region, animated: true)
                refreshEvents()
            }
        }
    }
    var locationManager = CLLocationManager()

    var mapEvents : [String:Event] = [:]
    var attendingEvents : [String] = []
    var invites :[String:Invitation] = [:]
    private let latitude: Double = 37.771052
    private let longitude: Double = -122.403891
    private let latDelta: Double = 0.01
    private let longDelta: Double = 0.01
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func refreshEvents() {
        Invitation.getAllLiveEvents { invitations in
            self.attendingEvents.removeAll(keepCapacity: true)
            self.invites.removeAll(keepCapacity: true)
            for invite in invitations {
                self.attendingEvents.append(invite.event.objectId!)
                self.invites[invite.event.objectId!] = invite
            }
            self.displayNearbyEvents()
        }
    }
    
    func displayNearbyEvents() {
        Event.getNearbyEvents(self.mapView.centerCoordinate, callback: { (events) -> Void in
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapEvents.removeAll(keepCapacity: true)
            for event : Event in events {
                let annotation = MKPointAnnotation()
                let locationCoordinate = CLLocationCoordinate2DMake(event.latitude, event.longitude)
                annotation.coordinate = locationCoordinate
                annotation.title = event.title
                self.mapView.addAnnotation(annotation)
                self.mapEvents[event.title] = event
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController = segue.destinationViewController as! EventDetailViewController
        destinationController.invitation = self.invitationToSelectedEvent
    }

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
        let event = mapEvents[view.annotation.title!]!
        if !contains(self.attendingEvents, event.objectId!) {
            event.acceptFromMapView().saveInBackgroundWithBlock({ (success, err) -> Void in
                self.refreshEvents()
            })
        } else {
            self.invitationToSelectedEvent = invites[event.objectId!]
            self.performSegueWithIdentifier("ShowEventDetail", sender: self)
        }
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        self.refreshEvents()
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView.canShowCallout = true
            var button = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            annotationView.rightCalloutAccessoryView = button
        }
        let annView = annotationView as! MKPinAnnotationView
        let callToActionView = annView.rightCalloutAccessoryView as! UIButton
        let event = mapEvents[annotation.title!]!
        if contains(self.attendingEvents, event.objectId!) {
            annView.pinColor = MKPinAnnotationColor.Green
            callToActionView.setImage(nil, forState: UIControlState.Normal)
        } else {
            annView.pinColor = MKPinAnnotationColor.Red
            callToActionView.setImage(UIImage(named: "plus"), forState: UIControlState.Normal)
        }
        return annView
    }
}
