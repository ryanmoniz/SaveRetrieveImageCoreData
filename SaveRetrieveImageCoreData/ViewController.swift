//
//  ViewController.swift
//  SaveRetrieveImageCoreData
//
//  Created by Ryan Moniz on 2016-08-10.
//  Copyright © 2016 Ryan Moniz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var dataImageView: UIImageView!
    @IBOutlet weak var transformableImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didReceiveImage(_:)), name: "ImageCompleted", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NetworkController.sharedInstance.getImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didReceiveImage(notification:NSNotification) {
        print("notification.object \(notification.object)")
        
        if let location = notification.object as? NSURL {
            print("\nLocation: \(location)")
            let tempURL = NSURL(fileURLWithPath: "\(NSTemporaryDirectory())image.png")
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtURL(tempURL)
            } catch {
                // Non-fatal: file probably doesn't exist
            }
            do {
                try fileManager.copyItemAtURL(location, toURL: tempURL)
                let image = UIImage(contentsOfFile: "\(NSTemporaryDirectory())image.png")
                print("image:\(image)")
                originalImageView.image = image

            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
    }

}

