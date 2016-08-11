//
//  NetworkController.swift
//  SaveRetrieveImageCoreData
//
//  Created by Ryan Moniz on 2016-08-11.
//  Copyright © 2016 Ryan Moniz. All rights reserved.
//

import UIKit

final class NetworkController: NSObject, NSURLSessionDownloadDelegate {
    
    static let sharedInstance = NetworkController()
    
    lazy var downloadsSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    var activeDownloads = [String: Download]()
    
    private override init() {
        
    }
    
    
    func getImage() {
        let urlString = "http://images.apple.com/ac/flags/1/images/us/32.png"
        
        if let url =  NSURL(string: urlString) {
        let download = Download(url: urlString)
            download.downloadTask = downloadsSession.downloadTaskWithURL(url)
            download.downloadTask!.resume()
            download.isDownloading = true
            activeDownloads[download.url] = download
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        // 1
        if let originalURL = downloadTask.originalRequest?.URL?.absoluteString {
            print(originalURL)
            print(location)
            
            NSNotificationCenter.defaultCenter().postNotificationName("ImageCompleted", object: location)
        }
        
        // 3
        if let url = downloadTask.originalRequest?.URL?.absoluteString {
            activeDownloads[url] = nil
        }
    }
}