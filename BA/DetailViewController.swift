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
    var controller : HomeKitController?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    @IBOutlet weak var homeName: UILabel?
    @IBOutlet weak var roomName: UILabel?
    @IBOutlet weak var accessoriesTableView: UITableView?
    
    @IBAction func addAccessory(sender: UIButton) {
        performSegueWithIdentifier("showAllAccessoriesSegue", sender: self)
    }
    
    @IBAction func updateAccessories(sender: UIButton) {
//        contextHandler!.retrieveViewControllerList()
        accessoriesTableView?.reloadData()
    }
    
    @IBAction func changeHome(sender: UIButton) {
        let sheet = self.createActionSheet()
        self.presentViewController(sheet, animated: true, completion: nil)
        
        spinner?.startAnimating()
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
            accessoriesTableView?.reloadData()
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
    }
    
    
    // MARK: - HomeKitController Delegates
    
    func hasLoadedData(status: Bool) {
        if status == true {
            print("loading successful")
            
            loadData()
            
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
//        if viewControllerArray.count != 0 {
//            let vcInRow = viewControllerArray[indexPath.row]
//            let view = vcInRow.view
//            let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell")!
//            
//            view.frame = cell.frame
//            
//            if cell.contentView.subviews.isEmpty {
//                cell.contentView.addSubview(view)
//            }
//            
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCellWithIdentifier("emptyCell")!
//            cell.textLabel!.text = "No accessories connected"
//            return cell
//        }
        
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
            
            view!.frame = cell.frame
            
            if cell.contentView.subviews.isEmpty {
                cell.contentView.addSubview(view!)
            }
            
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
                        self.controller?.currentHomeID = home.id
                        self.controller?.currentRoomID = room.id
                        self.loadData()
                        
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
}