//
//  FullsizePhoto.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "FullsizePhoto"

class Photo : PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return kClassName
    }

    @NSManaged var fullsizeFile : PFFile?
    @NSManaged var localPath : String
    @NSManaged var owner : PFUser
    @NSManaged var accessList : [PFUser]
    @NSManaged var thumbnailFile : PFFile?
    @NSManaged var events : [Event]
    
    func getThumbnail() -> PFFile {
        if thumbnailFile == nil {
            let fullSizeImage = UIImage(contentsOfFile: self.localPath)!
            
            let size = CGSizeApplyAffineTransform(fullSizeImage.size, CGAffineTransformMakeScale(0.5, 0.5))
            let hasAlpha = false
            let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
            
            UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
            fullSizeImage.drawInRect(CGRect(origin: CGPointZero, size: size))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.thumbnailFile = PFFile(data: UIImageJPEGRepresentation(scaledImage, 0.8))
            self.thumbnailFile!.saveInBackgroundWithBlock(nil)
        }
        return self.thumbnailFile!
    }
    
    func userCanSeeFullsizePhoto(user: PFUser) -> Bool {
        for candidate in self.accessList {
            if user == candidate {
                return true
            }
        }
        return false
    }
}