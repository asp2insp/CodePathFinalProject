//
//  AddUsersToEventViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

let AddedUserCellReuseIdentifier = "AddedUserCell"

class AddUsersToEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventDictionary: NSDictionary!
    var startDate: NSDate!
    var endDate: NSDate!
    var eventTitle: String!
    var eventPhoto: UIImage?
    var friends: [Friend]?
    var selectedFriends: [Friend]?
    
    @IBOutlet var searchUserTextField: UITextField!
    @IBOutlet var topView: UIView!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func onCreate(sender: UIBarButtonItem) {
        var newEvent = Event(className: Event.parseClassName())
        newEvent.name = self.eventTitle
        newEvent.owner = PFUser.currentUser()!
        newEvent.pincode = "1111"
        newEvent.startDateTime = self.startDate
        newEvent.endDateTime = self.endDate
        newEvent.latitude = 37.770789
        newEvent.longitude = -122.403918
        newEvent.locationName = "Zynga"
        newEvent.admins = [PFUser.currentUser()!]
        newEvent.guests = [PFUser.currentUser()!]
        newEvent.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
                println("Event Created!")
            } else {
                println("Error creating event: \(error)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        searchUserTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        
        Friend.getAllFriendsFromFacebook("10153067889372737", onComplete: { (friends:[Friend]?) -> Void in
            if friends != nil {
                self.friends = friends
                println(friends![0].friendName)
                self.tableView.reloadData()
            } else {
                println("No friends found")
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        startDate = eventDictionary["start_date"] as! NSDate
        endDate = eventDictionary["end_date"] as! NSDate
        eventTitle = eventDictionary["event_title"] as! String
        eventPhoto = eventDictionary["eventPhoto"] as? UIImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    

}

//MARK: UITableViewDelegate

extension AddUsersToEventViewController: UITableViewDelegate {
    
}

//MARK: UITableViewDataSource

extension AddUsersToEventViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AddedUserCellReuseIdentifier, forIndexPath: indexPath) as! AddUsersAddedUserCell
        cell.userName = "Paco Smith"
        return cell
    }
}
