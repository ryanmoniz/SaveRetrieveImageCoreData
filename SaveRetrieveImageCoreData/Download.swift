//
//  Download.swift
//  SaveRetrieveImageCoreData
//
//  Created by Ryan Moniz on 2016-08-11.
//  Copyright © 2016 Ryan Moniz. All rights reserved.
//

import Foundation

class Download: NSObject {
    
    var url: String
    var isDownloading = false
    var progress: Float = 0.0
    
    var downloadTask: NSURLSessionDownloadTask?
    var resumeData: NSData?
    
    init(url: String) {
        self.url = url
    }
}