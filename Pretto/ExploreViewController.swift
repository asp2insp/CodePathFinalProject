//
//  ExploreViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/22/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
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

