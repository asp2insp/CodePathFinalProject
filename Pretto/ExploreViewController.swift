//
//  ExploreViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/22/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mapView: MKMapView!
    
    let latitude: Double = 37.771052
    let longitude: Double = -122.403891
    let latDelta: Double = 0.01
    let longDelta: Double = 0.01
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.prettoBlue()
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        cameraView.hidden = false
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

