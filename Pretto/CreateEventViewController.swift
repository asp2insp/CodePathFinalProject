//
//  CreateEventViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

private let AddEventPhotoCellReuseIdentifier = "AddEventPhotoCell"
private let AddEventTitleCellReuseIdentifier = "AddEventTitleCell"
private let AddEventDateCellReuseIdentifier = "AddEventDateCell"
private let AddEventDatePickerCellReuseIdentifier = "AddEventDatePickerCell"

class CreateEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddEventPhotoCellDelegate, AddEventTitleCellDelegate, AddEventDatePickerCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var nextButton: UIBarButtonItem!
    
    @IBOutlet var tableView: UITableView!
    
    private var shouldDisplayPickerForStartDate = false
    private var shouldDisplayPickerForEndDate = false
    
    var startDate: NSDate!
    var endDate: NSDate!
    var minimunDate: NSDate?
    var eventTitle: String!
    var eventPhoto: UIImage?
    
    var titleTextField: UITextField?
    
    @IBAction func onCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindFromAddUsers(segue: UIStoryboardSegue) {

        var sourceVC = segue.sourceViewController as! AddUsersToEventViewController
        
        if sourceVC.startDate != nil {
            self.startDate = sourceVC.startDate
        }
        
        if sourceVC.endDate != nil {
            self.endDate = sourceVC.endDate
        }
        
        if sourceVC.eventTitle != nil {
            self.eventTitle = sourceVC.eventTitle
        }
        
        if sourceVC.eventPhoto != nil {
            self.eventPhoto = sourceVC.eventPhoto
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clearColor()
        
        nextButton.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        cameraView.hidden = true
        
        tableView.reloadData()
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddUsersSegue" {
            var destinationVC = segue.destinationViewController as! AddUsersToEventViewController
            destinationVC.startDate = self.startDate ?? NSDate()
            destinationVC.endDate = self.endDate ?? NSDate()
            destinationVC.eventTitle = self.eventTitle
            destinationVC.eventPhoto = self.eventPhoto
        }
    }


}

// MARK: UITableViewDelegate

extension CreateEventViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 100
        case (1, 1), (2, 1):
            return 180
        default:
            return 58
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row){
        case (1,0):
            self.titleTextField?.resignFirstResponder()
            if !self.shouldDisplayPickerForStartDate {
                self.shouldDisplayPickerForStartDate = true
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 1)], withRowAnimation: .Top)
                if self.shouldDisplayPickerForEndDate {
                    self.shouldDisplayPickerForEndDate = false
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 2)], withRowAnimation: .Top)
                }
                tableView.endUpdates()
            } else {
                self.shouldDisplayPickerForStartDate = false
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 1)], withRowAnimation: .Top)
            }
            
        case (2, 0):
            self.titleTextField?.resignFirstResponder()
            if !self.shouldDisplayPickerForEndDate {
                self.shouldDisplayPickerForEndDate = true
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 2)], withRowAnimation: .Top)
                if self.shouldDisplayPickerForStartDate {
                    self.shouldDisplayPickerForStartDate = false
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 1)], withRowAnimation: .Top)
                }
                tableView.endUpdates()
            } else {
                self.shouldDisplayPickerForEndDate = false
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 2)], withRowAnimation: .Top)
                
            }

        default:
            self.titleTextField?.resignFirstResponder()
            self.shouldDisplayPickerForStartDate = false
            self.shouldDisplayPickerForEndDate = false
            tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(1, 2)), withRowAnimation: .None)
        }
    }
}



// MARK: UITableViewDataSource

extension CreateEventViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return shouldDisplayPickerForStartDate ? 2 : 1
        case 2:
            return shouldDisplayPickerForEndDate ? 2 : 1
        default:
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier(AddEventPhotoCellReuseIdentifier, forIndexPath: indexPath) as! AddEventPhotoCell
            cell.delegate = self
            if self.eventPhoto != nil {
                cell.eventImage = self.eventPhoto!
            }
            return cell
            
        case (0, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier(AddEventTitleCellReuseIdentifier, forIndexPath: indexPath) as! AddEventTitleCell
            cell.delegate = self
            if self.eventTitle != nil {
                cell.title = self.eventTitle
            }
            self.titleTextField = cell.eventTitle
            return cell
            
        case (1, 0), (2,0):
            let cell = tableView.dequeueReusableCellWithIdentifier(AddEventDateCellReuseIdentifier, forIndexPath: indexPath) as! AddEventDateCell
            if indexPath.section == 1 {
                cell.isStartDate = true
                cell.date = self.startDate ?? NSDate()
            } else {
                cell.isStartDate = false
                cell.date = self.endDate ?? NSDate().dateByAddingTimeInterval(3600)
            }
            return cell
            
        case (1, 1), (2, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier(AddEventDatePickerCellReuseIdentifier, forIndexPath: indexPath) as! AddEventDatePickerCell
            cell.delegate = self
            cell.isStartDate = indexPath.section == 1 ? true : false
            cell.currentDate = indexPath.section == 1 ? (startDate ?? NSDate()) : (endDate ?? NSDate())
            cell.minimunDate = self.minimunDate
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
        nextButton.enabled = (title == "") || (title == "Event Title") ? false : true
        self.eventTitle = title
    }
}

// MARK: AddEventTitleCellDelegate

extension CreateEventViewController: AddEventDatePickerCellDelegate {
    func addEventDatePickerCell(addEventDatePickerCell: AddEventDatePickerCell, isStartDatePicker: Bool, valueDidChange date: NSDate) {
        dateFormatter.dateFormat = "MMM, d yyyy - hh:mm a"
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: isStartDatePicker ? 1 : 2)) as! AddEventDateCell
        cell.dateLabel.text = dateFormatter.stringFromDate(date)
        if isStartDatePicker {
            self.startDate = date
            self.minimunDate = date
            if self.endDate != nil {
                self.endDate = endDate.laterDate(date)
            } else {
                self.endDate = date
            }

        } else {
            self.endDate = date
        }
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)!,NSIndexPath(forRow: 0, inSection: 2)!], withRowAnimation: UITableViewRowAnimation.None)
    }
}

// MARK: AddEventTitleCellDelegate

extension CreateEventViewController: AddEventPhotoCellDelegate {
    func addEventPhotoCell(addEventPhotoCell: AddEventPhotoCell, didTapOnEventPhoto photo: UIImageView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let actionTakePhoto = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default) { (alertAction: UIAlertAction!) -> Void in
            println("Take Photo")
            var photoPicker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                photoPicker.delegate = self
                photoPicker.sourceType = UIImagePickerControllerSourceType.Camera
                photoPicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear) ? .Rear : .Front
                self.presentViewController(photoPicker, animated: true, completion: nil)
            }
        }
        
        let actionChoosePhoto = UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.Default) { (alertAction: UIAlertAction!) -> Void in
            println("Choose Photo")
            var photoPicker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                photoPicker.delegate = self
                photoPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(photoPicker, animated: true, completion: nil)
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alertAction:UIAlertAction!) -> Void in println("Cancel") }
        alertController.addAction(actionTakePhoto)
        alertController.addAction(actionChoosePhoto)
        alertController.addAction(actionCancel)
    
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
}

// MARK: UIImagePickerControllerDelegate
extension CreateEventViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Photo Taken or Picked")
        self.eventPhoto = image
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
