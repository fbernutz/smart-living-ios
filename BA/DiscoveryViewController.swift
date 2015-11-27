//
//  AccessoryViewController.swift
//  HomeKit01
//
//  Created by Felizia Bernutz on 22.05.15.
//  Copyright (c) 2015 Felizia Bernutz. All rights reserved.
//

import UIKit
import HomeKit

class DiscoveryViewController: UITableViewController, HMAccessoryBrowserDelegate {
    
    let homeManager = HMHomeManager()
    let browser = HMAccessoryBrowser()
    
    var accessories = [HMAccessory]()
    var activeRoom: HMRoom?
    var activeHome: HMHome?
    var lastSelectedIndexRow = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = "Searching"
        
        browser.delegate = self
        
        browser.startSearchingForNewAccessories()
        NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "stopSearching", userInfo: nil, repeats: false)
    }
    
    func stopSearching() {
        title = "Discovered"
        browser.stopSearchingForNewAccessories()
    }
    
    // MARK: - Table Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("discoveryCell") as! DiscoverAccessoryCell
        let accessory = accessories[indexPath.row] as HMAccessory
        
        cell.headingLabel?.text = accessory.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let accessory = accessories[indexPath.row] as HMAccessory
        //lastSelectedIndexRow = indexPath.row
        
        if let activeRoom = self.activeRoom {
            if let activeHome = self.activeHome {
                activeHome.addAccessory(accessory, completionHandler: { (error) -> Void in
                    if error != nil {
                        print("Something went wrong when attempting to add an accessory to \(activeHome.name). \(error!.localizedDescription)")
                    } else {
                        self.activeHome!.assignAccessory(accessory, toRoom: self.activeRoom!, completionHandler: { (error) -> Void in
                            if error != nil {
                                print("Something went wrong when attempting to add an accessory to \(activeRoom.name). \(error!.localizedDescription)")
                            } else {
                                self.navigationController?.popViewControllerAnimated(true)
                                
                                
                                tableView.reloadData()
                            }
                        })
                        
                    }
                })
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

// MARK: - Cell

class DiscoverAccessoryCell: UITableViewCell {
    
    @IBOutlet weak var headingLabel: UILabel!
    //@IBOutlet weak var descriptionLabel: UILabel!
    
}
