//
//  CreateEventAddLocationViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 7/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit
import MapKit


class CreateEventAddLocationViewController: UIViewController, CLLocationManagerDelegate {
    private let latDelta: Double = 0.01
    private let longDelta: Double = 0.01
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var location : CLLocation? {
        didSet {
            if let location = location {
                let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    
    var parent : CreateEventViewController?
    
    var locationString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    @IBAction func didTapSetLocation() {
        parent?.location = mapView.centerCoordinate
    }
}

// MARK: CLLocationManagerDelegate
extension CreateEventAddLocationViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let newLocation = locations.last as! CLLocation
        println("Got location \(newLocation)")
        self.location = newLocation
        locationManager.stopUpdatingLocation()
    }
}
