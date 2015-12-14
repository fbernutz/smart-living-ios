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
        contextHandler?.loadAccessoryBrowser()
        performSegueWithIdentifier("showAllAccessoriesSegue", sender: self)
    }
    
    @IBAction func changeHome(sender: UIButton) {
        //choose another home or room
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
    
    // MARK: - TableView Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let accessories = accessories {
            return accessories.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let accessoryInRow = accessories![indexPath.row]
        
        switch accessoryInRow {
        case is Lamp:
            tableView.registerNib(UINib(nibName: "LightCell", bundle: nil), forCellReuseIdentifier: "lightCell")
            
            let cell = tableView.dequeueReusableCellWithIdentifier("lightCell") as! LightCell
            
            cell.accessory = accessoryInRow
            cell.slider?.minimumValue = 0
            cell.slider?.maximumValue = 100
            
            return cell
            
        case is WeatherStation:
            let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell")
            cell!.textLabel?.text = "\(accessoryInRow.name!) Weather"
            return cell!
            
        case is EnergyController:
            let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell")
            cell!.textLabel?.text = "\(accessoryInRow.name!) Energy"
            return cell!
            
        case is DoorWindowSensor:
            let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell")
            cell!.textLabel?.text = "\(accessoryInRow.name!) Door & Window"
            return cell!
            
        case is Diverse:
            let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell")
            cell!.textLabel?.text = "\(accessoryInRow.name!) Sonstiges"
            return cell!
        
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell")
            cell!.textLabel?.text = "\(accessoryInRow.name!) Default"
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected row \(indexPath.row)")
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAllAccessoriesSegue" {
            let vc = segue.destinationViewController as! DiscoveryViewController
            vc.contextHandler = contextHandler
        }
    }
}
