//
//  Multimedia+CoreDataProperties.swift
//  SaveRetrieveImageCoreData
//
//  Created by Ryan Moniz on 2016-08-10.
//  Copyright © 2016 Ryan Moniz. All rights reserved.
//
//  we have 2 ways to do so, in imageData we store the ImageData as NData (Binary Data) and using external storage to store the image data not as a BLOB
//  

import Foundation
import CoreData

extension Multimedia {

    @NSManaged var name: String?
    @NSManaged var imageData: NSData?
    @NSManaged var imageTransformable: NSObject?

}
