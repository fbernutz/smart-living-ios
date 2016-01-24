//
//  DetailViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, HomeKitControllerDelegate, UITableViewDataSource, UITableViewDelegate, ContextHandlerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var contextHandler : ContextHandler?
    var controller : HomeKitController?
    
    var major: Int?
    var minor: Int?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    @IBOutlet weak var homeName: UILabel?
    @IBOutlet weak var roomName: UILabel?
    @IBOutlet weak var accessoriesTableView: UITableView?
    
    @IBAction func addAccessory(sender: UIButton) {
        performSegueWithIdentifier("showAllAccessoriesSegue", sender: self)
    }
    
    @IBAction func updateAccessories(sender: UIButton) {
        spinner?.startAnimating()
        
        controller!.reloadAccessories { _ in
            self.spinner?.stopAnimating()
        }
    }
    
    @IBAction func changeHome(sender: UIButton) {
        let sheet = self.createActionSheet()
        self.presentViewController(sheet, animated: true, completion: nil)
        
        spinner?.startAnimating()
    }
    
    @IBAction func addBeacon(sender: UIButton) {
        let alert = UIAlertController(title: "Beacon hinzufügen", message: "Verbinde das näheste Beacon mit \(room!).", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction (title: "Hinzufügen", style: .Default) { action in
            
            self.minor = self.contextHandler!.minorBeacon
            self.major = self.contextHandler!.majorBeacon
            
            let beaconRoom = BeaconRoomConnector(major: self.major!, minor: self.minor!, home: self.home!, room: self.room!)
            
            self.contextHandler!.saveData(beaconRoom)
            
            print("AccessoryVC: beacon \(self.major!), \(self.minor!) connected to \(self.room!)")
            
            self.alertBeaconAdded()
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    var localHomes : [Home]?
    var localRooms : [Room]?
    
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
    
    var viewControllerArray : [UIViewController] = [] {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.accessoriesTableView?.reloadData()
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
        controller!.delegate = self
        
        contextHandler!.contextDelegate = self
        
        spinner?.startAnimating()
        
        
        //    listen for notification
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
    
    
    // MARK: - HomeKitController Delegates
    
    func hasLoadedData(status: Bool) {
        if status == true {
            spinner?.stopAnimating()
        } else {
            print("loading failed")
        }
    }
    
    func loadData() {
        home = contextHandler!.retrieveHome()
        room = contextHandler!.retrieveRoom()
        contextHandler!.retrieveAccessories()
    }
    
    func hasCreatedDefaultHomes(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - TableView Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewControllerArray.count != 0 {
            return viewControllerArray.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if viewControllerArray.count != 0 {
            let vcInRow = viewControllerArray[indexPath.row]
            let view = vcInRow.view
            let size = view?.frame.height
            return size!
        }
        
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if viewControllerArray.count == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("emptyCell")!
            cell.textLabel!.text = "No accessories connected"
            return cell
            
        } else {
            let vcInRow = viewControllerArray[indexPath.row]
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
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAllAccessoriesSegue" {
            let vc = segue.destinationViewController as! DiscoveryViewController
            vc.contextHandler = contextHandler
        }
    }
    
    // MARK: - ActionSheet
    
    func createActionSheet() -> UIAlertController {
        let sheet = UIAlertController(title: "home > room", message: "Wähle einen anderen Raum aus, um dessen Accessories zu steuern.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for home in localHomes! {
            let roomsInHome = localRooms!.filter{ $0.homeID == home.id }.map{ room in
                sheet.addAction(UIAlertAction(title: "\(home.name!) > \(room.name!)", style: UIAlertActionStyle.Default)
                    { action in
                        self.controller!.currentHomeID = home.id
                        self.controller!.currentRoomID = room.id
                        
                        self.spinner?.stopAnimating()
                    }
                )
            }
        }
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action in
                self.spinner?.stopAnimating()
            })
        
        return sheet
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
                        self.alertShowBeaconRoom(homeID!, roomID: roomID!, message: "Bist du im >\(plistRoom)< in >\(plistHome)<? Willst du die dafür relevanten Accessories sehen?")
                    } else {
                        //TODO: 
                        //Beacon wurde aus aktuellem Raum gefunden
                        //hier: evtl. Beacon-Button farbig anzeigen
                    }
                }
            }
        } else {
            print ("no home and room found for this beacon")
        }
    }
    
    func alertShowBeaconRoom (homeID: NSUUID, roomID: NSUUID, message : String) {
        let alert = UIAlertController(title: "Beacon gefunden", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertActionStyle.Default)
            { action in
                self.controller!.currentHomeID = homeID
                self.controller!.currentRoomID = roomID
            }
        )
        alert.addAction(UIAlertAction(title: "Nein", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertBeaconAdded() {
        let alert = UIAlertController(title: "Beacon hinzugefügt", message: "Das Beacon \(major!), \(minor!) wurde erfolgreich zu \(home!), \(room!) hinzugefügt.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel)
            { action in
                // TODO: Beacon Button ausblenden oder anzeigen, dass verbunden
            }
        )
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

}