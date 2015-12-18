//
//  AccessoryViewController.swift
//  HomeKit01
//
//  Created by Felizia Bernutz on 22.05.15.
//  Copyright (c) 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DiscoveryViewController: UITableViewController, HomeKitControllerNewAccessoriesDelegate {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    
    var contextHandler: ContextHandler?
    var controller : HomeKitController?
    
    var tempArray: [String] = []
    
    var accessoryList : [String]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = contextHandler!.homeKitController
        controller!.accessoryDelegate = self
        
        title = "Searching..."
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        controller?.startSearchingForAccessories()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        controller?.stopSearching()
    }
    
    // MARK: - Table Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if accessoryList != nil {
            return accessoryList!.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newAccessoryCell")
        cell?.textLabel?.text = accessoryList![indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let accessory = accessoryList![indexPath.row]
        
        self.contextHandler!.addAccessory(accessory, completionHandler: { _ in
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.accessoryList?.removeAtIndex((self.accessoryList?.indexOf(accessory)!)!)
            self.performSegueWithIdentifier("addedAccessorySegue", sender: self)
        })
    }
    
    // MARK: - HomeKitController Delegates
    
    func hasLoadedNewAccessoriesList(accessoryNames: [String], stillLoading: Bool) {
        if stillLoading {
            tempArray += accessoryNames
            accessoryList = tempArray
        } else {
            title = "Discovered"
            accessoryList = accessoryNames
        }
    }
    
    func refresh(sender: AnyObject) {
        if title == "Discovered" {
            title = "Searching..."
            controller?.startSearchingForAccessories()
            
            refreshControl?.endRefreshing()
            tableView?.reloadData()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addedAccessorySegue" {
            let vc = segue.destinationViewController as! DetailViewController
            vc.accessories = contextHandler?.retrieveAccessories()
        }
    }
    
}

