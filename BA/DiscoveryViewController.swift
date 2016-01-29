//
//  AccessoryViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 22.05.15.
//  Copyright (c) 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DiscoveryViewController: UITableViewController, HomeKitControllerNewAccessoriesDelegate {
    
    var contextHandler: ContextHandler?
    var controller : HomeKitController?
    
    let searchingTitle = "Auf der Suche..."
    let discoveredTitle = "Tada!"
    
    var isAddingAccessory : Bool = false
    
    var accessoryList : [String]? = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = contextHandler!.homeKitController
        controller!.accessoryDelegate = self
        
        title = searchingTitle
        accessoryList = controller!.discoveredAccessories()
        
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        controller?.startSearchingForAccessories()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !isAddingAccessory {
            controller?.stopSearching()
        }
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
        
        isAddingAccessory = true
        
        self.contextHandler!.addNewAccessory(accessory, completionHandler: { success, error in
            if success {
                self.isAddingAccessory = false
                self.accessoryList?.removeAtIndex((self.accessoryList?.indexOf(accessory)!)!)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                self.isAddingAccessory = false
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        })
    }
    
    func refresh(sender: AnyObject) {
        if title == discoveredTitle {
            controller!.startSearchingForAccessories()
            title = searchingTitle
            if self.refreshControl!.refreshing {
                self.refreshControl!.endRefreshing()
            }
            tableView?.reloadData()
        } else {
            if self.refreshControl!.refreshing {
            self.refreshControl!.endRefreshing()
            }
        }
    }
    
    // MARK: - HomeKitController Delegates
    
    func hasLoadedNewAccessory(name: String, stillLoading: Bool) {
        if stillLoading {
            if !accessoryList!.contains(name) {
                accessoryList!.append(name)
            }
            title = searchingTitle
        } else {
            title = discoveredTitle
        }
    }
    
}

