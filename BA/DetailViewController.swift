//
//  DetailViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, HomeKitControllerDelegate {
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    @IBOutlet weak var homeName: UILabel?
    @IBOutlet weak var roomName: UILabel?
    @IBOutlet weak var accessoryNameFirst: UILabel?
    
    @IBAction func addAccessory(sender: UIButton) {
        contextHandler?.loadAccessoryBrowser()
    }
    
    @IBAction func changeHome(sender: UIButton) {
        
    }
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var contextHandler : ContextHandler?
    
    var home : String? {
        didSet {
            homeName?.text = home
            //            spinner?.stopAnimating()
        }
    }
    
    var room : String? {
        didSet {
            roomName?.text = room
        }
    }
    
    var accessoryList : [String] = []
    
    var accessories : [IAccessory]? {
        didSet {
            accessory = accessories?.first
        }
    }
    
    var accessory : IAccessory? {
        didSet {
            accessoryNameFirst?.text = accessory?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contextHandler == nil {
            contextHandler = appDelegate.contextHandler
        }
        
        let controller = contextHandler!.homeKitController
        controller!.delegate = self
        
    }
    
    func hasLoadedData(status: Bool) {
        if status == true {
            print("loading successful")
            
            home = contextHandler!.retrieveHome()
            room = contextHandler!.retrieveRoom()
            
        } else {
            print("loading failed")
        }
    }
    
    func hasLoadedNewAccessory(status: String) {
        accessoryList.append(status)
        
        let sheet = self.createActionSheet(accessoryList)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAllAccessoriesSegue" {
            //            let vc = segue.destinationViewController as! DiscoveryViewController
            //            vc.activeRoom = room
            //            vc.activeHome = home
        }
    }
    
    func createActionSheet(accessories : [String]) -> UIAlertController {
        let sheet = UIAlertController(title: "Found accessories", message: "By choosing you can add this accessory", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var index = 0
        for accessory in accessories {
            sheet.addAction(UIAlertAction(title: accessory, style: UIAlertActionStyle.Default)
                { action in
                    self.accessoryList.removeAtIndex(index)
                    self.contextHandler!.addAccessory(accessory)
                    self.accessories = self.contextHandler!.retrieveAccessories()
                }
            )
            index++
        }
        
        sheet.addAction(UIAlertAction(title: "Cancel", style:UIAlertActionStyle.Cancel)
            { action in
                //
            }
        )
        
        return sheet
    }
    
}
