//
//  ViewController.swift
//  SaveRetrieveImageCoreData
//
//  Created by Ryan Moniz on 2016-08-10.
//  Copyright © 2016 Ryan Moniz. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var dataImageView: UIImageView!
    @IBOutlet weak var transformableImageView: UIImageView!
    
    @IBAction func getImageDataFromCoreData(sender: AnyObject) {
        let fetchRequest = NSFetchRequest(entityName: "Multimedia")
        do {
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                let fetchedEntities = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [Multimedia]
                let obj = fetchedEntities.first
                if let data = obj?.valueForKey("imageData") as? NSData {
                    dataImageView.image = UIImage(data: data)
                }
                
            }
            // Do something with fetchedEntities
        } catch {
            // Do something in response to error condition
        }
    }
   
    @IBAction func getImageTransformableFromCoreData(sender: AnyObject) {
        let fetchRequest = NSFetchRequest(entityName: "Multimedia")
        do {
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                let fetchedEntities = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [Multimedia]
                let obj = fetchedEntities.first
                if let image = obj?.valueForKey("imageTransformable") as? UIImage {
                    transformableImageView.image = image
                }
                
            }
            // Do something with fetchedEntities
        } catch {
            // Do something in response to error condition
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didReceiveImage(_:)), name: "ImageCompleted", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.coreDataDidSave(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
        
        resetCoreData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NetworkController.sharedInstance.getImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func coreDataDidSave(notification:NSNotification) {
        print("Core Data did finish saving, notification.object \(notification.object)")
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
                
                //save into both core data models and retrieve
                if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                    if let multimediaEntity = NSEntityDescription.entityForName("Multimedia", inManagedObjectContext: appDelegate.managedObjectContext) {
                        let managedObject = NSManagedObject(entity: multimediaEntity, insertIntoManagedObjectContext: appDelegate.managedObjectContext)
                        managedObject.setValue("us-flag", forKey: "name")
                        if (image != nil) {
                            let data = UIImageJPEGRepresentation(image!, 1.0)
                            managedObject.setValue(data, forKey: "imageData")
                            managedObject.setValue(image, forKey: "imageTransformable")
                            appDelegate.saveContext()
                        }
                    }
                    
                }
                
                

            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
    }
    
    func resetCoreData() {
        let fetchRequest = NSFetchRequest(entityName: "Multimedia")
        do {
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                let fetchedEntities = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [Multimedia]
                for entity in fetchedEntities {
                    appDelegate.managedObjectContext.deleteObject(entity)
                }
            }
            // Do something with fetchedEntities
        } catch {
            // Do something in response to error condition
        }
    }

}

