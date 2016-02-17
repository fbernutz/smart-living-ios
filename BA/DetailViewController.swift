//
//  DetailViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, HomeKitControllerDelegate, ContextHandlerDelegate {
    
    @IBOutlet var headerView: HeaderView?
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var contextHandler : ContextHandler?
    var controller : HomeKitController?
    
    var major: Int?
    var minor: Int?
    
    var beaconConnected : Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    var localHomes : [Home]? {
        didSet {
            headerView?.localHomes = localHomes
        }
    }
    
    var localRooms : [Room]? {
        didSet {
            headerView?.localRooms = localRooms
        }
    }
    
    var home : String? {
        didSet {
            headerView?.home = home
        }
    }
    
    var room : String? {
        didSet {
            headerView?.room = room
        }
    }
    
    var viewControllerArray : [UIViewController] = [] {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contextHandler == nil {
            contextHandler = appDelegate.contextHandler
        }
        
        if controller == nil {
            controller = contextHandler!.homeKitController
        }
        
        contextHandler!.contextDelegate = self
        controller!.delegate = self
        
        title = "Smart Living"
        
        //Setting HeaderView
        tableView.setAndLayoutTableHeaderView(headerView!)
        headerView!.parentTableView = self
        
        // Pull to Refresh
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.refreshControl!.beginRefreshing()
        
        // listen for notification
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        
        center.addObserverForName("vcArray", object: contextHandler, queue: queue) { notification in
            if let vcArray = notification.userInfo!["VCArray"] as? [UIViewController] {
                self.viewControllerArray = vcArray
            }
        }
        
        center.addObserverForName("localHomes", object: contextHandler, queue: queue) { notification in
            if let localHomes = notification.userInfo!["localHomes"] as? [Home]? {
                self.localHomes = localHomes
            }
        }
        
        center.addObserverForName("localRooms", object: contextHandler, queue: queue) { notification in
            if let localRooms = notification.userInfo!["localRooms"] as? [Room]? {
                self.localRooms = localRooms
            }
        }
        
        center.addObserverForName("roomID", object: contextHandler, queue: queue) { notification in
            self.loadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func refresh(sender: AnyObject) {
        controller!.reloadAccessories { _ in
            if self.refreshControl!.refreshing {
                self.refreshControl!.endRefreshing()
            }
        }
    }
    
    func loadData() {
        home = contextHandler!.retrieveHome()
        room = contextHandler!.retrieveRoom()
        contextHandler!.retrieveAccessories() {_ in
            if self.refreshControl!.refreshing {
                self.refreshControl!.endRefreshing()
            }
        }
        
        let beacon = contextHandler!.isBeaconConnected(home!, room: room!)
        if let major = beacon.major, let minor =  beacon.minor {
            beaconConnected = true
            self.major = major
            self.minor = minor
        }
    }
    
    // MARK: - HomeKitController Delegates
    
    func hasCreatedDefaultHomes(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - TableView Delegates
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if !viewControllerArray.isEmpty {
                return viewControllerArray.count + 1
            } else {
                return 1 + 1
            }
        }
        
        return 1
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            if !viewControllerArray.isEmpty {
                if row < viewControllerArray.count {
                    let vcInRow = viewControllerArray[row]
                    
                    switch vcInRow {
                    case is LightViewController:
                        let vc = vcInRow as! LightViewController
                        if let size = vc.size { return size } else { 100 }
                    case is WeatherViewController:
                        let vc = vcInRow as! WeatherViewController
                        if let size = vc.size { return size } else { 100 }
                    case is EnergyViewController:
                        let vc = vcInRow as! EnergyViewController
                        if let size = vc.size { return size } else { 100 }
                    case is DoorWindowViewController:
                        let vc = vcInRow as! DoorWindowViewController
                        if let size = vc.size { return size } else { 100 }
                    case is DiverseViewController:
                        let vc = vcInRow as! DiverseViewController
                        if let size = vc.size { return size } else { 100 }
                    default:
                        break
                    }
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("addAccessoryCell")!
                    let size = cell.contentView.frame.size.height
                    return size
                }
            } else {
                if row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("emptyCell")!
                    let size = cell.contentView.frame.size.height
                    return size
                } else if row == 1 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("addAccessoryCell")!
                    let size = cell.contentView.frame.size.height
                    return size
                }
            }
        } else if section == 1 {
            if beaconConnected {
                let cell = tableView.dequeueReusableCellWithIdentifier("beaconCell")! as! BeaconCell
                let size = cell.contentView.frame.size.height
                return size
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("addBeaconCell")! as! BeaconCell
                let size = cell.contentView.frame.size.height
                return size
            }
        }
    
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            if viewControllerArray.isEmpty {
                if row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("emptyCell")!
                    cell.textLabel!.text = "Keine Geräte verfügbar."
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("addAccessoryCell")!
                    return cell
                }
            } else {
                if row < viewControllerArray.count {
                    let vcInRow = viewControllerArray[row]
                    let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell")!
                    var view: UIView?
                    
                    switch vcInRow {
                    case is LightViewController:
                        view = vcInRow.view as! LightView
                        break
                    case is WeatherViewController:
                        view = vcInRow.view as! WeatherView
                        break
                    case is EnergyViewController:
                        view = vcInRow.view as! EnergyView
                        break
                    case is DoorWindowViewController:
                        view = vcInRow.view as! DoorWindowView
                        break
                    case is DiverseViewController:
                        view = vcInRow.view as! DiverseView
                        break
                    default:
                        break
                    }
                    
                    view!.frame = cell.contentView.frame
                    
                    if !cell.contentView.subviews.isEmpty {
                        for subview in cell.contentView.subviews {
                            subview.removeFromSuperview()
                        }
                    }
                    
                    cell.contentView.addSubview(view!)
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("addAccessoryCell")!
                    return cell
                }
            }
        } else {
            if beaconConnected {
                let cell = tableView.dequeueReusableCellWithIdentifier("beaconCell")! as! BeaconCell
                cell.parentTableView = self
                cell.major = major
                cell.minor = minor
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("addBeaconCell")! as! BeaconCell
                return cell
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        
        if section == 0 {
            if indexPath.row >= viewControllerArray.count {
                performSegueWithIdentifier("showAllAccessoriesSegue", sender: self)
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        } else {
            if beaconConnected {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("beaconCell")! as! BeaconCell
                cell.parentTableView = self
                cell.major = major
                cell.minor = minor
                cell.addBeacon()
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
    
    //TableView Section Header
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Verbundene Geräte"
        } else {
            return "Verknüpftes iBeacon"
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAllAccessoriesSegue" {
            let vc = segue.destinationViewController as! DiscoveryViewController
            vc.contextHandler = contextHandler
        }
    }
    
    //MARK: - Beacon Functions
    
    func roomForBeacon(manager: ContextHandler, connectorArray: [BeaconRoomConnector], major: Int, minor: Int) {
        let plistResult = connectorArray.filter{ $0.major == major && $0.minor == minor }.first
        
        self.major = major
        self.minor = minor
        
        if let plistHome = plistResult?.home, let plistRoom = plistResult?.room {
            controller!.findHMRoomForBeacon(plistHome, room: plistRoom) { success, homeID, roomID in
                if success {
                    if self.room != plistRoom {
                        self.alertShowBeaconRoom(homeID!, roomID: roomID!, message: "Bist du im >\(plistRoom)< in >\(plistHome)<? Willst du die dafür relevanten Geräte sehen?")
                    }
                }
            }
        } else {
            beaconConnected = false
            
            print ("no home and room found for this beacon")
        }
    }
    
    func alertShowBeaconRoom (homeID: NSUUID, roomID: NSUUID, message : String) {
        let alert = UIAlertController(title: "Beacon gefunden", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertActionStyle.Default)
            { action in
                self.refreshControl!.beginRefreshing()
                self.contextHandler!.homeID = homeID
                self.contextHandler!.roomID = roomID
            }
        )
        alert.addAction(UIAlertAction(title: "Nein", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

extension UITableView {
    
    func setAndLayoutTableHeaderView(header: UIView) {
        let headerView = header as! HeaderView
        self.tableHeaderView = headerView
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        self.tableHeaderView = headerView
    }
    
}