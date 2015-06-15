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
    
    var startDate: NSDate!
    var endDate: NSDate!
    var eventTitle: String!
    var eventPhoto: UIImage!
    var users: [String]?
    
    @IBOutlet var searchUserTextField: UITextField!
    @IBOutlet var topView: UIView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        searchUserTextField.autocapitalizationType = UITextAutocapitalizationType.Words
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
        return users?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AddedUserCellReuseIdentifier, forIndexPath: indexPath) as! AddUsersAddedUserCell
        cell.userName = "Paco Smith"
        return cell
    }
}
