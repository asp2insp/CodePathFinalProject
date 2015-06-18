//
//  FullsizePhoto.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "FullsizePhoto"

class FullsizePhoto : PFObject, PFSubclassing {
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

    override init() {
        super.init()
        self.ACL = PFACL(user: PFUser.currentUser()!)
    }
    
    @NSManaged var thumbnailPhoto : ThumbnailPhoto?
    @NSManaged var file : PFFile?
    @NSManaged var localPath : String
    @NSManaged var owner : PFUser
    
    func getThumbnail() -> ThumbnailPhoto {
        if thumbnailPhoto == nil {
            let photo = ThumbnailPhoto()
            photo.fullsizePhoto = self
            
            let fullSizeImage = UIImage(contentsOfFile: self.localPath)!
            
            let size = CGSizeApplyAffineTransform(fullSizeImage.size, CGAffineTransformMakeScale(0.5, 0.5))
            let hasAlpha = false
            let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
            
            UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
            fullSizeImage.drawInRect(CGRect(origin: CGPointZero, size: size))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let thumbnailFile = PFFile(data: UIImageJPEGRepresentation(scaledImage, 0.8))
            thumbnailFile.saveInBackgroundWithBlock(nil)
            
            photo.file = thumbnailFile
            photo.saveInBackgroundWithBlock(nil)
            self.thumbnailPhoto = photo
            self.saveInBackgroundWithBlock(nil)
        }
        return self.thumbnailPhoto!
    }
}