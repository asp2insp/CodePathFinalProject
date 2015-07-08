//
//  CreateEventAddUsersViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI
import Social

let AddedUserCellReuseIdentifier = "AddedUserCell"

class CreateEventAddUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    var location : CLLocationCoordinate2D?
    var locationString: String?
    
    var startDate: NSDate!
    var endDate: NSDate!
    var eventTitle: String!
    var eventPhoto: UIImage?
    var friends: [Friend]?
    var friendsNames: [String]?
    var selectedFriends: [Friend]?
    var selectedIndexes: [Int]?
    var autocompleteArray : [String]?
    
    private var autocompleteTableView: UITableView!

    @IBOutlet var searchUserTextField: UITextField!
    @IBOutlet var topView: UIView!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func onCreate(sender: UIBarButtonItem) {
        searchUserTextField.resignFirstResponder()
        
        if selectedIndexes != nil {
            selectedFriends = [Friend]()
            for var i = 0; i < selectedIndexes!.count; i++ {
                selectedFriends!.append(friends![selectedIndexes![i]])
            }
        }
        
        var newEvent = Event()

        // Generate ChannelId
        dateFormatter.dateFormat = "MMyMhmMdyMyymhy" // just to mix things up a little ;)
        let channelId = "pretto_" + "\(PFUser.currentUser()!.objectId!)" + "\(dateFormatter.stringFromDate(NSDate()))"
        
        PFPush.subscribeToChannelInBackground(channelId)
        
        newEvent.channel = channelId
        newEvent.title = self.eventTitle
        newEvent.owner = PFUser.currentUser()!
        newEvent.pincode = "1111"
        newEvent.startDate = self.startDate
        newEvent.endDate = self.endDate
        newEvent.latitude = self.location?.latitude ?? 37.770789
        newEvent.longitude = self.location?.longitude ?? -122.403918
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
                return friend.friendFacebookId
            }) ?? []
            let query = PFUser.query()
            query?.whereKey("facebookId", containedIn: facebookIds)
            for invitedUser in query?.findObjects() ?? [] {
                newEvent.makeInvitationForUser(invitedUser as! PFUser).save()
            }
            
        }
        if eventPhoto != nil {
            var imageData = UIImageJPEGRepresentation(eventPhoto, 0.5)
            var imageFile = PFFile(name: channelId + ".jpg", data: imageData)
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
        
        presentEventSummary()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shareOnFacebook", name: kShareOnFacebookNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shareOnTwitter", name: kShareOnTwitterNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shareByEmail", name: kShareByEmailNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "okButton", name: kAcceptEventAndDismissVCNotification, object: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tag = 1
        
        topView.layer.borderWidth = 0
        topView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        searchUserTextField.autocapitalizationType = UITextAutocapitalizationType.Words
//        searchUserTextField.delegate = self
        
//        autocompleteTableView = UITableView(frame: tableView.frame, style: UITableViewStyle.Plain)
//        autocompleteTableView.delegate = self
//        autocompleteTableView.dataSource = self
//        autocompleteTableView.scrollEnabled = true
//        autocompleteTableView.hidden = true
//        autocompleteTableView.tag = 2
//        self.view.addSubview(autocompleteTableView)
        
        
        var me = User(innerUser: PFUser.currentUser())
        Friend.getAllFriendsFromFacebook(me.facebookId!, onComplete: { (friends:[Friend]?) -> Void in
            if friends != nil {
                self.friends = friends
                // TODO: delete below line later
                // self.friends?.append(self.getMeAsTestFriend(me))
                self.friendsNames = [String]()
                for friend in self.friends! {
                    self.friendsNames?.append(friend.friendName)
                }
                self.tableView.reloadData()
            } else {
                println("No friends found")
            }
        })
    }
    
    deinit {
        println("CreateEventAddUsersViewController : deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kShareOnFacebookNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kShareOnTwitterNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kShareByEmailNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kAcceptEventAndDismissVCNotification, object: nil)
    }
    
    func getMeAsTestFriend(me:User) -> Friend {
        var selfie = Friend()
        selfie.facebookId = me.facebookId!
        selfie.friendFacebookId = me.facebookId!
        selfie.friendName = me.name!
        return selfie
    }
    
    override func viewDidAppear(animated: Bool) {
        cameraView.hidden = true
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

extension CreateEventAddUsersViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 1 {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddUsersAddedUserCell
            if cell.accessoryType == .None {
                cell.accessoryView = UIImageView(image: UIImage(named: "checkmark"))
                cell.accessoryType = .Checkmark
                addFriendToSelectedList(indexPath)
            } else {
                cell.accessoryView = nil
                cell.accessoryType = .None
                removeFriendToSelectedList(indexPath)
            }
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
    
    func addFriendToSelectedList(indexPath: NSIndexPath) {
        if selectedIndexes == nil {
            selectedIndexes = [Int]()
        }
        if find(selectedIndexes!, indexPath.row) == nil {
            selectedIndexes!.append(indexPath.row)
        }
    }
    
    func removeFriendToSelectedList(indexPath: NSIndexPath) {
        if selectedIndexes != nil && selectedIndexes!.count > 0 {
            if let index = find(selectedIndexes!, indexPath.row) {
                selectedIndexes!.removeAtIndex(index)
            }
        }
    }
    
}

//MARK: UITableViewDataSource

extension CreateEventAddUsersViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return friends?.count ?? 0
        } else {
            return autocompleteArray?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(AddedUserCellReuseIdentifier, forIndexPath: indexPath) as! AddUsersAddedUserCell
            cell.userName = friends![indexPath.row].friendName
            cell.facebookId = friends![indexPath.row].friendFacebookId
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

extension CreateEventAddUsersViewController : UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        autocompleteTableView.hidden = false
        var substring: NSString = searchUserTextField.text
        substring = substring.stringByReplacingCharactersInRange(range, withString: string)
        self.searchAutocompleteEntriesWithSubstring(substring as String)
        return true
    }
}


// MARK: MFMailComposeViewControllerDelegate
extension CreateEventAddUsersViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
//MARK: Aux Funtions
extension CreateEventAddUsersViewController {
    
    func shareOnFacebook() {
        println("Notification received, sharing on Facebook")
        var content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
        content.contentDescription = " between " + dateFormatter.stringFromDate(startDate) + " and " + dateFormatter.stringFromDate(endDate)
        content.contentURL = NSURL(string: "http://www.pretto.co/")
        content.contentTitle = self.eventTitle + " - Where? " + (self.locationString ?? "Somewhere")
        content.peopleIDs = [String]()
        content.ref = ""
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
    }
    
    func shareOnTwitter() {
        println("Notification received, sharing on Twitter")

        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            var composeController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            composeController.setInitialText("I just created a new event on Pretto and would like you to join us. http://pretto.co")
            self.presentViewController(composeController, animated: true, completion: { () -> Void in
                println("Shared")
            })
        }
        
    }
    
    func shareByEmail() {
        println("Notification received, sharing by email ")
        if MFMailComposeViewController.canSendMail() {
            var emailController = MFMailComposeViewController()
            emailController.mailComposeDelegate = self
            let subject = "I'd like to invite you to join me for an event on Pretto"
            emailController.setSubject(subject)
            
            dateFormatter.dateFormat = "MM/dd/yy HH:mm"
            let messagePart1 = "<p>Hi,</p><p>I just created a new event on Pretto and would like you to join us. Pretto it's the simplest way to share our memories after the event.</p><p>---</br>"
            let messagePart2 = "Event: <span><strong>\(self.eventTitle)</strong></span></br>" + "Location: <span><strong>\(self.locationString!)</strong></span></br>"
            let messagePart3 =  "Between <span><strong>" + dateFormatter.stringFromDate(startDate) + "</strong></span> and <span><strong>" + dateFormatter.stringFromDate(endDate) + "</strong></span></br></p>"
            let message = messagePart1 + messagePart2 + messagePart3
            emailController.setMessageBody(message, isHTML: true)
            self.presentViewController(emailController, animated: true, completion: nil)
        }
    }
    
    func okButton() {

        self.navigationController?.topViewController.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func presentEventSummary() {

        let currentWindow = UIApplication.sharedApplication().keyWindow
        var completionView = EventCreatedView()
        
        currentWindow?.addSubview(completionView)
        currentWindow?.bringSubviewToFront(completionView)
        completionView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        completionView.center = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: UIScreen.mainScreen().bounds.height / 2)
        
        // Add Data to Summary Card
        if self.location != nil {
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: self.location!.latitude, longitude: self.location!.longitude), completionHandler: { (markers, error) -> Void in
                if markers.count > 0 {
                    let marker = markers[0] as! CLPlacemark
                    let locality = marker.locality ?? ""
                    if let sublocality = marker.subLocality {
                        self.locationString = locality + ", " + sublocality
                    } else {
                        self.locationString = locality
                    }
                    
                    completionView.eventLocation.text = self.locationString
                    
                } else {
                    completionView.eventLocation.text = "Location TBD"
                }
            })
        } else {
            completionView.eventLocation.text = "Location TBD"
        }
        completionView.eventTItle.text = self.eventTitle
        dateFormatter.dateFormat = "MMM dd, hh:mm a"
        completionView.eventStartDate.text = dateFormatter.stringFromDate(startDate)
        completionView.eventEndDate.text = dateFormatter.stringFromDate(endDate)
        
        
        
        let scale = CGAffineTransformMakeScale(0.3, 0.3)
        let translate = CGAffineTransformMakeTranslation(50, -50)
        completionView.transform = CGAffineTransformConcat(scale, translate)
        completionView.alpha = 0
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
            let scale = CGAffineTransformMakeScale(1.0, 1.0)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            completionView.transform = CGAffineTransformConcat(scale, translate)
            completionView.alpha = 1
            }, completion: nil)
    }
    
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
