//
//  CreateEventViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

let dateFormatter = NSDateFormatter()
let AddEventPhotoCellReuseIdentifier = "AddEventPhotoCell"
let AddEventTitleCellReuseIdentifier = "AddEventTitleCell"
let AddEventDateCellReuseIdentifier = "AddEventDateCell"
let AddEventDatePickerCellReuseIdentifier = "AddEventDatePickerCell"

class CreateEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, addEventPhotoCellDelegate, AddEventTitleCellDelegate, AddEventDatePickerCellDelegate {

    @IBOutlet var nextButton: UIBarButtonItem!
    
    @IBOutlet var tableView: UITableView!
    
    private var isStartDate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        nextButton.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
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

// MARK: UITableViewDelegate

extension CreateEventViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 100
        case 3, 5:
            return 180
        default:
            return 44
        }
    }
    
}



// MARK: UITableViewDataSource

extension CreateEventViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(AddEventPhotoCellReuseIdentifier, forIndexPath: indexPath) as! AddEventPhotoCell
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(AddEventTitleCellReuseIdentifier, forIndexPath: indexPath) as! AddEventTitleCell
            cell.delegate = self
            return cell
        case 2, 4:
            let cell = tableView.dequeueReusableCellWithIdentifier(AddEventDateCellReuseIdentifier, forIndexPath: indexPath) as! AddEventDateCell
            cell.date = NSDate()
            return cell
        case 3, 5:
            let cell = tableView.dequeueReusableCellWithIdentifier(AddEventDatePickerCellReuseIdentifier, forIndexPath: indexPath) as! AddEventDatePickerCell
            cell.delegate = self
            cell.isStartDate = indexPath.row == 3 ? true : false
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
    }
}

// MARK: AddEventTitleCellDelegate

extension CreateEventViewController: AddEventTitleCellDelegate {
    func addEventTitleCell(addEventTitleCell: AddEventTitleCell, titleDidChange title: String) {
        nextButton.enabled = title == "" ? false : true
    }
}

// MARK: AddEventTitleCellDelegate

extension CreateEventViewController: AddEventDatePickerCellDelegate {
    func addEventDatePickerCell(addEventDatePickerCell: AddEventDatePickerCell, isStartDatePicker: Bool, valueDidChange date: NSDate) {
        dateFormatter.dateFormat = "MMM, d yyyy - hh:mm a"
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: (isStartDatePicker ? 2 : 4), inSection: 0)) as! AddEventDateCell
        cell.dateLabel.text = dateFormatter.stringFromDate(date)
    }
}

// MARK: AddEventTitleCellDelegate

extension CreateEventViewController: addEventPhotoCellDelegate {
    func addEventPhotoCell(addEventPhotoCell: AddEventPhotoCell, didTapOnEventPhoto photo: UIImageView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionTakePhoto = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default) { (alertAction: UIAlertAction!) -> Void in println("Take Photo") }
        let actionChoosePhoto = UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.Default) { (alertAction: UIAlertAction!) -> Void in println("Choose Photo") }
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alertAction:UIAlertAction!) -> Void in println("Cancel") }
        alertController.addAction(actionTakePhoto)
        alertController.addAction(actionChoosePhoto)
        alertController.addAction(actionCancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
}
