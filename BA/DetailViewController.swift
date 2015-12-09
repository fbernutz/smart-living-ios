//
//  DetailViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, HomeKitControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var contextHandler : ContextHandler?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    @IBOutlet weak var homeName: UILabel?
    @IBOutlet weak var roomName: UILabel?
    @IBOutlet weak var accessoryName: UILabel?
    @IBOutlet weak var accessoriesTableView: UITableView?
    
    @IBAction func addAccessory(sender: UIButton) {
        spinner?.startAnimating()
        contextHandler?.loadAccessoryBrowser()
    }
    
    @IBAction func changeHome(sender: UIButton) {
        
    }
    
    var home : String? {
        didSet {
            homeName?.text = home
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
            accessoriesTableView?.reloadData()
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
   
    
    // MARK: - HomeKitController Delegates
    
    func hasLoadedData(status: Bool) {
        if status == true {
            print("loading successful")
            
            home = contextHandler!.retrieveHome()
            room = contextHandler!.retrieveRoom()
            accessories = contextHandler!.retrieveAccessories()
            
        } else {
            print("loading failed")
        }
    }
    
    func hasLoadedNewAccessoriesList(accessoryNames: [String]) {
        accessoryList = accessoryNames
        
        let sheet = self.createActionSheet(accessoryList)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    // MARK: - TableView Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let accessories = accessories {
            return accessories.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell")
        
        cell?.textLabel?.text = accessories![indexPath.row].name
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected row \(indexPath.row)")
    }
    
    // MARK: - Create Action Sheet
    
    func createActionSheet(accessories : [String]) -> UIAlertController {
        spinner?.stopAnimating()
        let sheet = UIAlertController(title: "Found accessories", message: "By choosing you can add this accessory", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for accessory in accessories {
            sheet.addAction(UIAlertAction(title: accessory, style: UIAlertActionStyle.Default)
                { action in
                    // 1 add accessory
                    self.contextHandler!.addAccessory(accessory)
                    
                    // 2 show name of accessories
                    self.accessories = self.contextHandler!.retrieveAccessories()
                    
                    // 3 delete from list for next query
                    self.accessoryList.removeAtIndex(accessories.indexOf(accessory)!)
                }
            )
        }
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            { action in
                
            }
        )
        
        return sheet
    }
    
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAllAccessoriesSegue" {
            //            let vc = segue.destinationViewController as! DiscoveryViewController
            //            vc.activeRoom = room
            //            vc.activeHome = home
        }
    }
}
