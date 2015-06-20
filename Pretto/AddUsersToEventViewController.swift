//
//  AddUsersToEventViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit
import CoreLocation

let AddedUserCellReuseIdentifier = "AddedUserCell"

class AddUsersToEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var location : CLLocation?
    
    var startDate: NSDate!
    var endDate: NSDate!
    var eventTitle: String!
    var eventPhoto: UIImage?
    var friends: [Friend]?
    var friendsNames: [String]?
    var selectedFriends: [Friend]?
    var autocompleteArray : [String]?
    
    private var autocompleteTableView: UITableView!
    
    @IBOutlet var searchUserTextField: UITextField!
    @IBOutlet var topView: UIView!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func onCreate(sender: UIBarButtonItem) {
        var newEvent = Event()

        PushManager.createChannel { (success, channelId) -> () in
            if success {
                newEvent.channel = channelId
            } else {
                println("Channel NOT CREATED!!!")
            }
        }

        newEvent.title = self.eventTitle
        newEvent.owner = PFUser.currentUser()!
        newEvent.pincode = "1111"
        newEvent.startDate = self.startDate
        newEvent.endDate = self.endDate
        newEvent.latitude = self.location?.coordinate.latitude ?? 37.770789
        newEvent.longitude = self.location?.coordinate.longitude ?? -122.403918
        newEvent.locationName = "TODO"
        newEvent.admins = [PFUser.currentUser()!]
        newEvent.guests = [PFUser.currentUser()!]
        let album = Album()
        album.saveInBackground()
        newEvent.albums = [album]
        
        // Send invitations
        let invitation = newEvent.makeInvitationForUser(PFUser.currentUser()!)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let facebookIds : [String] = self.selectedFriends?.map({ (friend) -> String in
                return friend.facebookId
            }) ?? []
            let query = PFUser.query()
            query?.whereKey("facebookId", containedIn: facebookIds)
            for invitedUser in query?.findObjects() ?? [] {
                newEvent.makeInvitationForUser(invitedUser as! PFUser).save()
            }
        }
        if eventPhoto != nil {
            var imageData = UIImageJPEGRepresentation(eventPhoto, 0.5)
            var imageFile = PFFile(name: "test.jpg", data: imageData)
            imageFile.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if success {
                    newEvent.coverPhoto = imageFile
                } else {
                    println(error)
                }
                newEvent.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
                    if success {
                        println("Event Created!")
                    } else {
                        println("Error creating event: \(error)")
                    }
                }
            })
        } else {
            newEvent.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
                if success {
                    println("Event Created!")
                } else {
                    println("Error creating event: \(error)")
                }
            }
        }
        invitation.accepted = true
        invitation.saveInBackground()

        self.navigationController?.topViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tag = 1
        
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        searchUserTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        searchUserTextField.delegate = self
        
        autocompleteTableView = UITableView(frame: tableView.frame, style: UITableViewStyle.Plain)
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
        autocompleteTableView.tag = 2
        self.view.addSubview(autocompleteTableView)
        
        
        Friend.getAllFriendsFromFacebook("10153067889372737", onComplete: { (friends:[Friend]?) -> Void in
            if friends != nil {
                self.friends = friends
                println(friends![0].friendName)
                self.friendsNames = [String]()
                for friend in friends! {
                    self.friendsNames?.append(friend.friendName)
                }
                self.tableView.reloadData()
            } else {
                println("No friends found")
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
}

//MARK: UITableViewDelegate

extension AddUsersToEventViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 1 {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddUsersAddedUserCell
            cell.accessoryView = (cell.accessoryType == .None) ? UIImageView(image: UIImage(named: "checkmark")) : nil
            cell.accessoryType = (cell.accessoryType == .None) ? .Checkmark : .None
        } else if tableView.tag == 2 {
            println("selected 2")
            autocompleteTableView.hidden = true
            searchUserTextField.resignFirstResponder()
            var cell = tableView.cellForRowAtIndexPath(indexPath)
            var name = cell?.textLabel?.text
            var index = find(friendsNames!, name!)
            if index != nil {
                selectedFriends = selectedFriends ?? [Friend]()
                selectedFriends?.append(friends![index!])
            }
            self.tableView.reloadData()
        }
        
    }
    
}

//MARK: UITableViewDataSource

extension AddUsersToEventViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return selectedFriends?.count ?? 0
        } else {
            return autocompleteArray?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(AddedUserCellReuseIdentifier, forIndexPath: indexPath) as! AddUsersAddedUserCell
            cell.userName = selectedFriends![indexPath.row].friendName
            cell.facebookId = selectedFriends![indexPath.row].friendFacebookId
            return cell
        } else {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.text = autocompleteArray![indexPath.row]
            cell.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
            return cell
        }
    }
}

// MARK: UITextFieldDelegate

extension AddUsersToEventViewController : UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        autocompleteTableView.hidden = false
        var substring: NSString = searchUserTextField.text
        substring = substring.stringByReplacingCharactersInRange(range, withString: string)
        self.searchAutocompleteEntriesWithSubstring(substring as String)
        return true
    }
}

// MARK: CLLocationManagerDelegate
extension AddUsersToEventViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let newLocation = locations.last as! CLLocation
        println("Got location \(newLocation)")
        self.location = newLocation
        locationManager.stopUpdatingLocation()
    }
}

extension AddUsersToEventViewController {
    func searchAutocompleteEntriesWithSubstring(substring: String) {
        autocompleteArray?.removeAll(keepCapacity: false)
        for friend in self.friendsNames! {
            var substringRange = NSString(string: friend).rangeOfString(substring)
            if substringRange.location == 0 {
                if autocompleteArray == nil {
                    autocompleteArray = [String]()
                }
                autocompleteArray?.append(friend)
            }
        }
        autocompleteTableView.reloadData()
    }
}
